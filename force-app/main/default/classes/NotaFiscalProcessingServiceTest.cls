@IsTest
private class NotaFiscalProcessingServiceTest {

    @TestSetup
    static void setup() {
        insert new Contact(LastName = 'Cliente Teste', Saldo_Pontos__c = 0);
    }

    @IsTest
    static void registraNotaPendenteComSucesso() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];

        Test.startTest();
        Id notaId = NotaFiscalProcessingService.registrarNotaPendente(
            cliente.Id, 'MERCADO BOM PRECO\nARROZ 5KG 25,90\nFEIJAO 1KG 8,50', '12345678901234567890123456789012345678901234'
        );
        Test.stopTest();

        NotaFiscal__c nota = [SELECT Status__c, Chave_Acesso__c FROM NotaFiscal__c WHERE Id = :notaId];
        System.assertEquals('Pendente', nota.Status__c);
        System.assertEquals('12345678901234567890123456789012345678901234', nota.Chave_Acesso__c);
    }

    @IsTest
    static void bloqueiaNotaComChaveDeAcessoDuplicada() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        String chave = '99999999999999999999999999999999999999999999';
        NotaFiscalProcessingService.registrarNotaPendente(cliente.Id, 'texto original', chave);

        Test.startTest();
        Boolean lancouExcecao = false;
        try {
            NotaFiscalProcessingService.registrarNotaPendente(cliente.Id, 'texto repetido', chave);
        } catch (NotaFiscalProcessingService.NotaDuplicadaException e) {
            lancouExcecao = true;
        }
        Test.stopTest();

        System.assertEquals(true, lancouExcecao, 'Deveria ter bloqueado a nota com chave de acesso repetida');
        List<NotaFiscal__c> notas = [SELECT Id FROM NotaFiscal__c WHERE Chave_Acesso__c = :chave];
        System.assertEquals(1, notas.size(), 'Nao deveria ter criado uma segunda nota com a mesma chave');
    }

    @IsTest
    static void processaItensExtraidosEAcumulaPontos() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        Id notaId = NotaFiscalProcessingService.registrarNotaPendente(cliente.Id, 'texto qualquer', null);

        NotaFiscalProcessingService.DadosExtraidos dados = new NotaFiscalProcessingService.DadosExtraidos();
        dados.estabelecimento = 'Mercado Bom Preco';
        dados.dataCompra = '2026-09-06';
        dados.valorTotal = 34.90;

        NotaFiscalProcessingService.ItemExtraido item1 = new NotaFiscalProcessingService.ItemExtraido();
        item1.descricao = 'Arroz 5kg';
        item1.quantidade = 1;
        item1.valorTotalItem = 25.90;
        item1.categoria = 'Alimentos';

        NotaFiscalProcessingService.ItemExtraido item2 = new NotaFiscalProcessingService.ItemExtraido();
        item2.descricao = 'Feijao 1kg';
        item2.quantidade = 1;
        item2.valorTotalItem = 8.50;
        item2.categoria = null;

        dados.itens = new List<NotaFiscalProcessingService.ItemExtraido>{ item1, item2 };

        Test.startTest();
        NotaFiscalProcessingService.processarComDadosExtraidos(notaId, dados);
        Test.stopTest();

        NotaFiscal__c nota = [SELECT Status__c, Pontos_Gerados__c, Data_Compra__c FROM NotaFiscal__c WHERE Id = :notaId];
        System.assertEquals('Processada', nota.Status__c);
        System.assertEquals(34, nota.Pontos_Gerados__c);
        System.assertEquals(Date.newInstance(2026, 9, 6), nota.Data_Compra__c);

        List<ItemNotaFiscal__c> itens = [SELECT Categoria__c FROM ItemNotaFiscal__c WHERE NotaFiscal__c = :notaId ORDER BY Descricao__c];
        System.assertEquals(2, itens.size());
        System.assertEquals('Outros', itens[1].Categoria__c);

        Contact clienteAtualizado = [SELECT Saldo_Pontos__c FROM Contact WHERE Id = :cliente.Id];
        System.assertEquals(34, clienteAtualizado.Saldo_Pontos__c);
    }

    @IsTest
    static void ignoraDataEmFormatoInesperadoSemBloquearPontuacao() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        Id notaId = NotaFiscalProcessingService.registrarNotaPendente(cliente.Id, 'texto qualquer', null);

        NotaFiscalProcessingService.DadosExtraidos dados = new NotaFiscalProcessingService.DadosExtraidos();
        dados.valorTotal = 10;
        dados.dataCompra = 'data ilegivel';
        dados.itens = new List<NotaFiscalProcessingService.ItemExtraido>();

        Test.startTest();
        NotaFiscalProcessingService.processarComDadosExtraidos(notaId, dados);
        Test.stopTest();

        NotaFiscal__c nota = [SELECT Status__c, Data_Compra__c, Pontos_Gerados__c FROM NotaFiscal__c WHERE Id = :notaId];
        System.assertEquals('Processada', nota.Status__c);
        System.assertEquals(null, nota.Data_Compra__c);
        System.assertEquals(10, nota.Pontos_Gerados__c);
    }

    @IsTest
    static void marcaNotaComoErro() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        Id notaId = NotaFiscalProcessingService.registrarNotaPendente(cliente.Id, 'texto ilegivel', null);

        Test.startTest();
        NotaFiscalProcessingService.marcarComoErro(notaId);
        Test.stopTest();

        NotaFiscal__c nota = [SELECT Status__c FROM NotaFiscal__c WHERE Id = :notaId];
        System.assertEquals('Erro_Processamento', nota.Status__c);
    }
}
