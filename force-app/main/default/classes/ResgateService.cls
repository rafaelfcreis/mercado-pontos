public without sharing class ResgateService {

    public class ResgateException extends Exception {}

    public static Id resgatarProduto(Id contatoId, Id produtoId, String documento) {
        if (!documentoValido(documento)) {
            throw new ResgateException('Informe um documento valido (CPF ou RG) para retirada do produto na loja.');
        }

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
            Codigo_Retirada__c = gerarCodigoRetirada(),
            Documento__c = documento
        );
        insert resgate;

        // Name e auto-numero: o Apex nao devolve o valor gerado no sObject em
        // memoria depois do insert, entao precisa reconsultar - senao o numero
        // do resgate sai como null no e-mail de confirmacao.
        resgate = [
            SELECT Id, Name, Codigo_Retirada__c, Documento__c, Pontos_Utilizados__c
            FROM Resgate__c
            WHERE Id = :resgate.Id
            LIMIT 1
        ];

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
    private static Boolean documentoValido(String documento) {
        if (String.isBlank(documento)) {
            return false;
        }
        String apenasDigitos = documento.replaceAll('[^0-9]', '');

        if (apenasDigitos.length() == 11) {
            return cpfValido(apenasDigitos);
        }

        // RG nao tem um digito verificador padrao unico no Brasil (varia por estado) -
        // aqui so validamos um tamanho plausivel e que nao seja uma sequencia repetida.
        return apenasDigitos.length() >= 5 && apenasDigitos.length() <= 12 && !todosDigitosIguais(apenasDigitos);
    }

    private static Boolean cpfValido(String cpf) {
        if (todosDigitosIguais(cpf)) {
            return false;
        }

        Integer soma = 0;
        for (Integer i = 0; i < 9; i++) {
            soma += Integer.valueOf(cpf.substring(i, i + 1)) * (10 - i);
        }
        Integer primeiroDigito = Math.mod(soma * 10, 11);
        if (primeiroDigito == 10) {
            primeiroDigito = 0;
        }
        if (primeiroDigito != Integer.valueOf(cpf.substring(9, 10))) {
            return false;
        }

        soma = 0;
        for (Integer i = 0; i < 10; i++) {
            soma += Integer.valueOf(cpf.substring(i, i + 1)) * (11 - i);
        }
        Integer segundoDigito = Math.mod(soma * 10, 11);
        if (segundoDigito == 10) {
            segundoDigito = 0;
        }
        return segundoDigito == Integer.valueOf(cpf.substring(10, 11));
    }

    private static Boolean todosDigitosIguais(String digitos) {
        for (Integer i = 1; i < digitos.length(); i++) {
            if (digitos.substring(i, i + 1) != digitos.substring(0, 1)) {
                return false;
            }
        }
        return true;
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

            // Sem remetente explicito, o Salesforce usa o e-mail do usuario logado -
            // num site de comunidade isso faz a mensagem sair com From igual ao To,
            // que o Gmail trata como spam. Usa um endereco verificado do org quando
            // houver algum disponivel.
            List<OrgWideEmailAddress> remetente = [
                SELECT Id FROM OrgWideEmailAddress WHERE IsAllowAllProfiles = true LIMIT 1
            ];
            if (!remetente.isEmpty()) {
                email.setOrgWideEmailAddressId(remetente[0].Id);
            }
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
                'Apresente este codigo e um documento com foto (' + resgate.Documento__c + ') no caixa para retirar seu produto:\n\n' +
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
            // Falha no envio do e-mail nao deve desfazer um resgate ja confirmado,
            // mas precisa deixar rastro: engolir a excecao em silencio ja escondeu
            // um problema de envio antes.
            System.debug(LoggingLevel.ERROR, 'Falha ao enviar e-mail do resgate ' +
                resgate.Id + ': ' + e.getTypeName() + ' - ' + e.getMessage());
        }
    }
}
