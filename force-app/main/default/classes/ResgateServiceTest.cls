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

    private static ResgateService.EnderecoEntrega enderecoValido() {
        ResgateService.EnderecoEntrega endereco = new ResgateService.EnderecoEntrega();
        endereco.endereco = 'Rua das Flores';
        endereco.numero = '123';
        endereco.complemento = 'Apto 45';
        endereco.bairro = 'Centro';
        endereco.cidade = 'Sao Paulo';
        endereco.estado = 'SP';
        endereco.cep = '01000-000';
        return endereco;
    }

    @IsTest
    static void resgataProdutoComSucessoEDebitaPontos() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        ProdutoResgate__c produto = [SELECT Id FROM ProdutoResgate__c WHERE Name = 'Oleo de Soja 900ml' LIMIT 1];

        Test.startTest();
        Id resgateId = ResgateService.resgatarProduto(cliente.Id, produto.Id, enderecoValido());
        Test.stopTest();

        Resgate__c resgate = [
            SELECT Status__c, Pontos_Utilizados__c, Endereco__c, Cidade__c, Estado__c, CEP__c
            FROM Resgate__c
            WHERE Id = :resgateId
        ];
        System.assertEquals('Solicitado', resgate.Status__c);
        System.assertEquals(40, resgate.Pontos_Utilizados__c);
        System.assertEquals('Rua das Flores, 123', resgate.Endereco__c);
        System.assertEquals('Sao Paulo', resgate.Cidade__c);
        System.assertEquals('SP', resgate.Estado__c);
        System.assertEquals('01000-000', resgate.CEP__c);

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
            ResgateService.resgatarProduto(cliente.Id, produto.Id, enderecoValido());
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
            ResgateService.resgatarProduto(cliente.Id, produto.Id, enderecoValido());
        } catch (ResgateService.ResgateException e) {
            lancouExcecao = true;
            System.assert(e.getMessage().contains('disponivel'));
        }
        Test.stopTest();

        System.assertEquals(true, lancouExcecao);
    }

    @IsTest
    static void bloqueiaResgateSemEnderecoCompleto() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        ProdutoResgate__c produto = [SELECT Id FROM ProdutoResgate__c WHERE Name = 'Oleo de Soja 900ml' LIMIT 1];

        ResgateService.EnderecoEntrega enderecoIncompleto = new ResgateService.EnderecoEntrega();
        enderecoIncompleto.endereco = 'Rua das Flores';

        Test.startTest();
        Boolean lancouExcecao = false;
        try {
            ResgateService.resgatarProduto(cliente.Id, produto.Id, enderecoIncompleto);
        } catch (ResgateService.ResgateException e) {
            lancouExcecao = true;
            System.assert(e.getMessage().contains('endereco'));
        }
        Test.stopTest();

        System.assertEquals(true, lancouExcecao);
    }
}
