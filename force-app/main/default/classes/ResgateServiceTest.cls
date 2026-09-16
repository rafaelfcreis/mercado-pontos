@IsTest
private class ResgateServiceTest {

    private static final String CPF_VALIDO_TESTE = '111.444.777-35';

    @TestSetup
    static void setup() {
        insert new Contact(LastName = 'Cliente Teste', Email = 'cliente.teste@resgate.invalid', Saldo_Pontos__c = 100);
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
        Id resgateId = ResgateService.resgatarProduto(cliente.Id, produto.Id, CPF_VALIDO_TESTE);
        Test.stopTest();

        Resgate__c resgate = [
            SELECT Status__c, Pontos_Utilizados__c, Codigo_Retirada__c, Documento__c
            FROM Resgate__c
            WHERE Id = :resgateId
        ];
        System.assertEquals('Solicitado', resgate.Status__c);
        System.assertEquals(40, resgate.Pontos_Utilizados__c);
        System.assertEquals(CPF_VALIDO_TESTE, resgate.Documento__c);
        System.assertNotEquals(null, resgate.Codigo_Retirada__c);
        System.assertEquals(8, resgate.Codigo_Retirada__c.length());
        System.assert(Pattern.matches('^[A-Z0-9]{8}$', resgate.Codigo_Retirada__c));

        Contact clienteAtualizado = [SELECT Saldo_Pontos__c FROM Contact WHERE Id = :cliente.Id];
        System.assertEquals(60, clienteAtualizado.Saldo_Pontos__c);

        ProdutoResgate__c produtoAtualizado = [SELECT Estoque__c FROM ProdutoResgate__c WHERE Id = :produto.Id];
        System.assertEquals(1, produtoAtualizado.Estoque__c);
    }

    @IsTest
    static void codigosDeRetiradaGeradosSaoUnicos() {
        Set<String> codigos = new Set<String>();
        Test.startTest();
        for (Integer i = 0; i < 20; i++) {
            codigos.add(ResgateService.gerarCodigoRetirada());
        }
        Test.stopTest();

        System.assertEquals(20, codigos.size(), 'Os codigos gerados deveriam ser unicos');
    }

    @IsTest
    static void validaDocumentos() {
        Test.startTest();
        System.assertEquals(true, ResgateService.documentoValido(CPF_VALIDO_TESTE), 'CPF valido deveria passar');
        System.assertEquals(false, ResgateService.documentoValido('111.111.111-11'), 'CPF com digitos repetidos deveria falhar');
        System.assertEquals(false, ResgateService.documentoValido('123.456.789-00'), 'CPF com digito verificador errado deveria falhar');
        System.assertEquals(true, ResgateService.documentoValido('12.345.678-9'), 'RG plausivel deveria passar');
        System.assertEquals(false, ResgateService.documentoValido('123'), 'Documento curto demais deveria falhar');
        System.assertEquals(false, ResgateService.documentoValido(null), 'Documento vazio deveria falhar');
        System.assertEquals(false, ResgateService.documentoValido(''), 'Documento em branco deveria falhar');
        Test.stopTest();
    }

    @IsTest
    static void bloqueiaResgateSemDocumentoValido() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        ProdutoResgate__c produto = [SELECT Id FROM ProdutoResgate__c WHERE Name = 'Oleo de Soja 900ml' LIMIT 1];

        Test.startTest();
        Boolean lancouExcecao = false;
        try {
            ResgateService.resgatarProduto(cliente.Id, produto.Id, '123.456.789-00');
        } catch (ResgateService.ResgateException e) {
            lancouExcecao = true;
            System.assert(e.getMessage().contains('documento'));
        }
        Test.stopTest();

        System.assertEquals(true, lancouExcecao);
    }

    @IsTest
    static void bloqueiaResgateComSaldoInsuficiente() {
        Contact cliente = [SELECT Id FROM Contact LIMIT 1];
        ProdutoResgate__c produto = [SELECT Id FROM ProdutoResgate__c WHERE Name = 'Produto Caro Demais' LIMIT 1];

        Test.startTest();
        Boolean lancouExcecao = false;
        try {
            ResgateService.resgatarProduto(cliente.Id, produto.Id, CPF_VALIDO_TESTE);
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
            ResgateService.resgatarProduto(cliente.Id, produto.Id, CPF_VALIDO_TESTE);
        } catch (ResgateService.ResgateException e) {
            lancouExcecao = true;
            System.assert(e.getMessage().contains('disponivel'));
        }
        Test.stopTest();

        System.assertEquals(true, lancouExcecao);
    }
}
