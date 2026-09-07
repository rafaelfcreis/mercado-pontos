@IsTest
private class ResgateServiceTest {

    @TestSetup
    static void setup() {
        insert new Contact(LastName = 'Cliente Teste', Saldo_Pontos__c = 100);
        insert new List<ProdutoResgate__c>{
            new ProdutoResgate__c(Name = 'Oleo de Soja 900ml', Custo_Pontos__c = 40, Ativo__c = true, Estoque__c = 2),
            new ProdutoResgate__c(Name = 'Produto Esgotado', Custo_Pontos__c = 10, Ativo__c = true, Estoque__c = 0),
            new ProdutoResgate__c(Name = 'Produto Caro Demais', Custo_Pontos__c = 999, Ativo__c = true, Estoque__c = 5)
        };
    }

    @IsTest
    static void resgataProdutoComSucessoEDebitaPontos() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        ProdutoResgate__c produto = [SELECT Id FROM ProdutoResgate__c WHERE Name = 'Oleo de Soja 900ml' LIMIT 1];

        Test.startTest();
        Id resgateId = ResgateService.resgatarProduto(cliente.Id, produto.Id);
        Test.stopTest();

        Resgate__c resgate = [SELECT Status__c, Pontos_Utilizados__c FROM Resgate__c WHERE Id = :resgateId];
        System.assertEquals('Solicitado', resgate.Status__c);
        System.assertEquals(40, resgate.Pontos_Utilizados__c);

        Contact clienteAtualizado = [SELECT Saldo_Pontos__c FROM Contact WHERE Id = :cliente.Id];
        System.assertEquals(60, clienteAtualizado.Saldo_Pontos__c);

        ProdutoResgate__c produtoAtualizado = [SELECT Estoque__c FROM ProdutoResgate__c WHERE Id = :produto.Id];
        System.assertEquals(1, produtoAtualizado.Estoque__c);
    }

    @IsTest
    static void bloqueiaResgateComSaldoInsuficiente() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        ProdutoResgate__c produto = [SELECT Id FROM ProdutoResgate__c WHERE Name = 'Produto Caro Demais' LIMIT 1];

        Test.startTest();
        Boolean lancouExcecao = false;
        try {
            ResgateService.resgatarProduto(cliente.Id, produto.Id);
        } catch (ResgateService.ResgateException e) {
            lancouExcecao = true;
            System.assert(e.getMessage().contains('Saldo'));
        }
        Test.stopTest();

        System.assertEquals(true, lancouExcecao);
    }

    @IsTest
    static void bloqueiaResgateDeProdutoSemEstoque() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        ProdutoResgate__c produto = [SELECT Id FROM ProdutoResgate__c WHERE Name = 'Produto Esgotado' LIMIT 1];

        Test.startTest();
        Boolean lancouExcecao = false;
        try {
            ResgateService.resgatarProduto(cliente.Id, produto.Id);
        } catch (ResgateService.ResgateException e) {
            lancouExcecao = true;
            System.assert(e.getMessage().contains('disponivel'));
        }
        Test.stopTest();

        System.assertEquals(true, lancouExcecao);
    }
}
