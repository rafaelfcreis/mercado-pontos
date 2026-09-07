@IsTest
private class MercadoPontosControllerTest {

    @TestSetup
    static void setup() {
        Profile perfilPortal = [SELECT Id FROM Profile WHERE UserLicense.Name = 'Customer Community Login' LIMIT 1];

        // Conta de um usuario de portal precisa que o dono tenha um Role -
        // atribui um Role ao usuario que esta rodando o setup do teste.
        UserRole role = new UserRole(Name = 'Role Teste Mercado Pontos');
        insert role;
        User usuarioAtual = new User(Id = UserInfo.getUserId(), UserRoleId = role.Id);
        update usuarioAtual;

        Account conta = new Account(Name = 'Conta Teste Mercado Pontos');
        insert conta;

        Contact contato = new Contact(
            FirstName = 'Cliente',
            LastName = 'Teste',
            AccountId = conta.Id,
            Email = 'cliente.teste@mercadopontos.invalid',
            Saldo_Pontos__c = 50
        );
        insert contato;

        User usuarioPortal = new User(
            FirstName = 'Cliente',
            LastName = 'Teste',
            Email = 'cliente.teste@mercadopontos.invalid',
            Username = 'cliente.teste.mercadopontos@example.com.testorg',
            Alias = 'clitest',
            TimeZoneSidKey = 'America/Sao_Paulo',
            LocaleSidKey = 'pt_BR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'pt_BR',
            ProfileId = perfilPortal.Id,
            ContactId = contato.Id
        );
        insert usuarioPortal;

        insert new ProdutoResgate__c(Name = 'Produto Teste', Custo_Pontos__c = 20, Ativo__c = true, Estoque__c = 3);
    }

    @IsTest
    static void usuarioPortalEnviaNotaEConsultaSaldoECatalogo() {
        User usuarioPortal = [SELECT Id FROM User WHERE Username = 'cliente.teste.mercadopontos@example.com.testorg' LIMIT 1];

        Test.startTest();
        System.runAs(usuarioPortal) {
            Id notaId = MercadoPontosController.enviarNota('MERCADO TESTE\nARROZ 25,90', '11111111111111111111111111111111111111111111');
            System.assertNotEquals(null, notaId);

            Decimal saldo = MercadoPontosController.saldoDePontos();
            System.assertEquals(50, saldo);

            List<ProdutoResgate__c> catalogo = MercadoPontosController.catalogoDisponivel();
            System.assertEquals(1, catalogo.size());
        }
        Test.stopTest();
    }

    @IsTest
    static void usuarioPortalNaoEnviaNotaDuplicada() {
        User usuarioPortal = [SELECT Id FROM User WHERE Username = 'cliente.teste.mercadopontos@example.com.testorg' LIMIT 1];
        String chave = '22222222222222222222222222222222222222222222';

        System.runAs(usuarioPortal) {
            MercadoPontosController.enviarNota('texto original', chave);
        }

        Test.startTest();
        Boolean lancouExcecao = false;
        System.runAs(usuarioPortal) {
            try {
                MercadoPontosController.enviarNota('texto repetido', chave);
            } catch (AuraHandledException e) {
                lancouExcecao = true;
            }
        }
        Test.stopTest();

        System.assertEquals(true, lancouExcecao);
    }

    @IsTest
    static void usuarioPortalResgataProduto() {
        User usuarioPortal = [SELECT Id FROM User WHERE Username = 'cliente.teste.mercadopontos@example.com.testorg' LIMIT 1];
        ProdutoResgate__c produto = [SELECT Id FROM ProdutoResgate__c LIMIT 1];

        Test.startTest();
        System.runAs(usuarioPortal) {
            Id resgateId = MercadoPontosController.resgatar(produto.Id);
            System.assertNotEquals(null, resgateId);
        }
        Test.stopTest();

        Contact contatoAtualizado = [SELECT Saldo_Pontos__c FROM Contact WHERE Email = 'cliente.teste@mercadopontos.invalid'];
        System.assertEquals(30, contatoAtualizado.Saldo_Pontos__c);
    }
}
