@IsTest
private class ProcessarNotaFiscalQueueableTest {

    @TestSetup
    static void setup() {
        insert new Contact(LastName = 'Cliente Teste', Saldo_Pontos__c = 0);
    }

    @IsTest
    static void processaNotaDeFormaAssincronaSemDeixarPendente() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        Id notaId = NotaFiscalProcessingService.registrarNotaPendente(
            cliente.Id, 'MERCADO TESTE\nARROZ 5KG 25,90', null
        );

        Test.startTest();
        System.enqueueJob(new ProcessarNotaFiscalQueueable(notaId));
        Test.stopTest();

        NotaFiscal__c nota = [SELECT Status__c FROM NotaFiscal__c WHERE Id = :notaId];
        System.assertNotEquals('Pendente', nota.Status__c,
            'A nota deveria ter saido de Pendente apos o processamento assincrono (Processada ou Erro_Processamento)');
    }

    @IsTest
    static void limpaJsonComCercaDeCodigoMarkdown() {
        String comCerca = '```json\n{"valorTotal": 10}\n```';
        String limpo = NotaFiscalIAGateway.limparJson(comCerca);
        System.assertEquals('{"valorTotal": 10}', limpo);
    }

    @IsTest
    static void limpaJsonSemCercaMantemIgual() {
        String semCerca = '{"valorTotal": 10}';
        String limpo = NotaFiscalIAGateway.limparJson(semCerca);
        System.assertEquals('{"valorTotal": 10}', limpo);
    }

    @IsTest
    static void limpaJsonNuloVirouObjetoVazio() {
        System.assertEquals('{}', NotaFiscalIAGateway.limparJson(null));
    }
}
