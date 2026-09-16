public without sharing class ResgateService {

    public class ResgateException extends Exception {}

    public static Id resgatarProduto(Id contatoId, Id produtoId) {
        Contact cliente = [SELECT Id, Name, Email, Saldo_Pontos__c FROM Contact WHERE Id = :contatoId LIMIT 1];
        ProdutoResgate__c produto = [
            SELECT Id, Name, Descricao__c, Custo_Pontos__c, Ativo__c, Estoque__c
            FROM ProdutoResgate__c
            WHERE Id = :produtoId
            LIMIT 1
        ];

        if (produto.Ativo__c != true || (produto.Estoque__c != null && produto.Estoque__c <= 0)) {
            throw new ResgateException('Este produto nao esta disponivel para resgate no momento.');
        }

        Decimal saldoAtual = cliente.Saldo_Pontos__c == null ? 0 : cliente.Saldo_Pontos__c;
        if (saldoAtual < produto.Custo_Pontos__c) {
            throw new ResgateException('Saldo de pontos insuficiente para este resgate.');
        }

        Resgate__c resgate = new Resgate__c(
            Contato__c = contatoId,
            ProdutoResgate__c = produtoId,
            Pontos_Utilizados__c = produto.Custo_Pontos__c,
            Status__c = 'Solicitado',
            Codigo_Retirada__c = gerarCodigoRetirada()
        );
        insert resgate;

        Decimal saldoAposResgate = saldoAtual - produto.Custo_Pontos__c;
        cliente.Saldo_Pontos__c = saldoAposResgate;
        update cliente;

        if (produto.Estoque__c != null) {
            produto.Estoque__c -= 1;
            update produto;
        }

        enviarEmailConfirmacao(cliente, produto, resgate, saldoAposResgate);

        return resgate.Id;
    }

    @TestVisible
    private static String gerarCodigoRetirada() {
        // Sem O/0/I/1 para evitar confusao na leitura manual do codigo no caixa.
        final String caracteres = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
        String codigo = '';
        for (Integer i = 0; i < 8; i++) {
            Integer indice = Math.mod(Math.abs(Crypto.getRandomInteger()), caracteres.length());
            codigo += caracteres.substring(indice, indice + 1);
        }
        return codigo;
    }

    private static void enviarEmailConfirmacao(
        Contact cliente,
        ProdutoResgate__c produto,
        Resgate__c resgate,
        Decimal saldoAposResgate
    ) {
        if (String.isBlank(cliente.Email)) {
            return;
        }
        try {
            String urlQrCode = 'https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=' +
                EncodingUtil.urlEncode(resgate.Codigo_Retirada__c, 'UTF-8');

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{ cliente.Email });
            email.setSubject('Resgate ' + resgate.Name + ' confirmado - Mercado Pontos');
            email.setPlainTextBody(
                'Ola' + (String.isBlank(cliente.Name) ? '' : ', ' + cliente.Name) + '!\n\n' +
                'Seu resgate foi confirmado com sucesso. Aqui estao os detalhes:\n\n' +
                '-------------------------------------------\n' +
                'Numero do resgate: ' + resgate.Name + '\n' +
                'Produto: ' + produto.Name + '\n' +
                (String.isBlank(produto.Descricao__c) ? '' : 'Descricao: ' + produto.Descricao__c + '\n') +
                'Pontos utilizados neste resgate: ' + resgate.Pontos_Utilizados__c + '\n' +
                'Saldo de pontos restante: ' + saldoAposResgate + '\n' +
                '-------------------------------------------\n\n' +
                'RETIRADA NA LOJA\n' +
                'Apresente este codigo no caixa para retirar seu produto:\n\n' +
                resgate.Codigo_Retirada__c + '\n\n' +
                '(o codigo tambem aparece como QR code na versao HTML deste e-mail e na tela de confirmacao do site)\n\n' +
                'Obrigado por participar do Mercado Pontos!'
            );
            email.setHtmlBody(
                '<p>Ola' + (String.isBlank(cliente.Name) ? '' : ', ' + cliente.Name) + '!</p>' +
                '<p>Seu resgate foi confirmado com sucesso. Aqui estao os detalhes:</p>' +
                '<table style="border-collapse:collapse">' +
                '<tr><td style="padding:4px 8px"><strong>Numero do resgate</strong></td><td style="padding:4px 8px">' + resgate.Name + '</td></tr>' +
                '<tr><td style="padding:4px 8px"><strong>Produto</strong></td><td style="padding:4px 8px">' + produto.Name + '</td></tr>' +
                '<tr><td style="padding:4px 8px"><strong>Pontos utilizados</strong></td><td style="padding:4px 8px">' + resgate.Pontos_Utilizados__c + '</td></tr>' +
                '<tr><td style="padding:4px 8px"><strong>Saldo restante</strong></td><td style="padding:4px 8px">' + saldoAposResgate + '</td></tr>' +
                '</table>' +
                '<h3>Retirada na loja</h3>' +
                '<p>Apresente este QR code (ou o codigo escrito abaixo dele) no caixa para retirar seu produto:</p>' +
                '<p><img src="' + urlQrCode + '" alt="QR code de retirada" width="220" height="220" /></p>' +
                '<p style="font-size:20px;font-weight:bold;letter-spacing:2px">' + resgate.Codigo_Retirada__c + '</p>' +
                '<p><em>Obrigado por participar do Mercado Pontos!</em></p>'
            );
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
        } catch (Exception e) {
            // Falha no envio do e-mail nao deve desfazer um resgate ja confirmado.
        }
    }
}
