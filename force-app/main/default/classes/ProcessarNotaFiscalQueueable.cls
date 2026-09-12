public without sharing class ProcessarNotaFiscalQueueable implements Queueable, Database.AllowsCallouts {

    private Id notaFiscalId;

    public ProcessarNotaFiscalQueueable(Id notaFiscalId) {
        this.notaFiscalId = notaFiscalId;
    }

    public void execute(QueueableContext context) {
        NotaFiscal__c nota = [SELECT Id, Texto_Bruto__c FROM NotaFiscal__c WHERE Id = :notaFiscalId LIMIT 1];

        try {
            NotaFiscalProcessingService.DadosExtraidos dados = NotaFiscalIAGateway.extrairDados(nota.Texto_Bruto__c);
            NotaFiscalProcessingService.processarComDadosExtraidos(notaFiscalId, dados);
        } catch (Exception e) {
            NotaFiscalProcessingService.marcarComoErro(notaFiscalId);
        }
    }
}
