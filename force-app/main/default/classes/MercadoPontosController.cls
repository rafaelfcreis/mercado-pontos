public without sharing class MercadoPontosController {

    @AuraEnabled
    public static Id enviarNota(String textoBruto, String chaveAcesso, Decimal valorTotal) {
        try {
            Id contatoId = contatoDoUsuarioAtual();
            Id notaFiscalId = NotaFiscalProcessingService.registrarNotaPendente(contatoId, textoBruto, chaveAcesso);

            NotaFiscalProcessingService.DadosExtraidos dados = new NotaFiscalProcessingService.DadosExtraidos();
            dados.valorTotal = valorTotal;
            dados.itens = new List<NotaFiscalProcessingService.ItemExtraido>();
            NotaFiscalProcessingService.processarComDadosExtraidos(notaFiscalId, dados);

            return notaFiscalId;
        } catch (NotaFiscalProcessingService.NotaDuplicadaException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Decimal saldoDePontos() {
        Id contatoId = contatoDoUsuarioAtual();
        if (contatoId == null) {
            return 0;
        }
        Contact cliente = [SELECT Saldo_Pontos__c FROM Contact WHERE Id = :contatoId LIMIT 1];
        return cliente.Saldo_Pontos__c == null ? 0 : cliente.Saldo_Pontos__c;
    }

    @AuraEnabled(cacheable=true)
    public static List<ProdutoResgate__c> catalogoDisponivel() {
        return [
            SELECT Id, Name, Descricao__c, Custo_Pontos__c, Categoria__c, Estoque__c, Imagem_URL__c
            FROM ProdutoResgate__c
            WHERE Ativo__c = true
            ORDER BY Custo_Pontos__c ASC
        ];
    }

    public class ResultadoResgate {
        @AuraEnabled
        public Id resgateId;
        @AuraEnabled
        public String codigoRetirada;
    }

    @AuraEnabled
    public static ResultadoResgate resgatar(Id produtoId, String documento) {
        try {
            Id contatoId = contatoDoUsuarioAtual();
            Id resgateId = ResgateService.resgatarProduto(contatoId, produtoId, documento);

            Resgate__c resgate = [SELECT Codigo_Retirada__c FROM Resgate__c WHERE Id = :resgateId LIMIT 1];

            ResultadoResgate resultado = new ResultadoResgate();
            resultado.resgateId = resgateId;
            resultado.codigoRetirada = resgate.Codigo_Retirada__c;
            return resultado;
        } catch (ResgateService.ResgateException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static Id contatoDoUsuarioAtual() {
        User usuario = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return usuario.ContactId;
    }
}
