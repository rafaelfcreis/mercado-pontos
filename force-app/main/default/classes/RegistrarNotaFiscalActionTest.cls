@IsTest
private class RegistrarNotaFiscalActionTest {

    @TestSetup
    static void setup() {
        Profile perfilPortal = [SELECT Id FROM Profile WHERE UserLicense.Name = 'Customer Community Login' LIMIT 1];

        // UserRole e User sao objetos de setup: o DML deles precisa ficar
        // isolado em System.runAs, senao misturar com Account/Contact na mesma
        // transacao dispara MIXED_DML_OPERATION.
        User usuarioSetup = new User(Id = UserInfo.getUserId());

        System.runAs(usuarioSetup) {
            UserRole role = new UserRole(Name = 'Role Teste Agentforce Mercado Pontos');
            insert role;
            update new User(Id = UserInfo.getUserId(), UserRoleId = role.Id);
        }

        Account conta = new Account(Name = 'Conta Teste Agentforce');
        insert conta;

        Contact contato = new Contact(
            FirstName = 'Cliente',
            LastName = 'Agentforce',
            AccountId = conta.Id,
            Email = 'cliente.agentforce@mercadopontos.invalid',
            Saldo_Pontos__c = 0
        );
        insert contato;

        User usuarioPortal = new User(
            FirstName = 'Cliente',
            LastName = 'Agentforce',
            Email = 'cliente.agentforce@mercadopontos.invalid',
            Username = 'cliente.agentforce.mercadopontos@example.com.testorg',
            Alias = 'clagent',
            TimeZoneSidKey = 'America/Sao_Paulo',
            LocaleSidKey = 'pt_BR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'pt_BR',
            ProfileId = perfilPortal.Id,
            ContactId = contato.Id
        );
        System.runAs(usuarioSetup) {
            insert usuarioPortal;
        }
    }

    @IsTest
    static void registraNotaViaAcaoEDevolvePontosESaldo() {
        User usuarioPortal = [SELECT Id FROM User WHERE Username = 'cliente.agentforce.mercadopontos@example.com.testorg' LIMIT 1];

        RegistrarNotaFiscalAction.Entrada entrada = new RegistrarNotaFiscalAction.Entrada();
        entrada.textoOriginal = 'MERCADO BOM PRECO\nARROZ 5KG 25,90\nFEIJAO 1KG 8,50\nTOTAL 34,90';
        entrada.estabelecimento = 'Mercado Bom Preco';
        entrada.dataCompra = '2026-09-12';
        entrada.valorTotal = 34.90;
        entrada.itensJson = '[{"descricao":"Arroz 5kg","quantidade":1,"valorTotalItem":25.90,"categoria":"Alimentos"},' +
            '{"descricao":"Feijao 1kg","quantidade":1,"valorTotalItem":8.50,"categoria":"Alimentos"}]';
        entrada.recomendacao = 'Troque pontos por um oleo de soja.';

        Test.startTest();
        List<RegistrarNotaFiscalAction.Saida> resultados;
        System.runAs(usuarioPortal) {
            resultados = RegistrarNotaFiscalAction.registrar(new List<RegistrarNotaFiscalAction.Entrada>{ entrada });
        }
        Test.stopTest();

        System.assertEquals(1, resultados.size());
        System.assertEquals(34, resultados[0].pontosGerados);
        System.assertEquals(34, resultados[0].saldoAtual);
        System.assert(resultados[0].mensagem.contains('sucesso'));

        Contact contatoAtualizado = [SELECT Saldo_Pontos__c FROM Contact WHERE Email = 'cliente.agentforce@mercadopontos.invalid'];
        System.assertEquals(34, contatoAtualizado.Saldo_Pontos__c);

        List<ItemNotaFiscal__c> itens = [SELECT Id FROM ItemNotaFiscal__c];
        System.assertEquals(2, itens.size());
    }

    @IsTest
    static void devolveMensagemDeErroQuandoJsonDeItensEInvalido() {
        User usuarioPortal = [SELECT Id FROM User WHERE Username = 'cliente.agentforce.mercadopontos@example.com.testorg' LIMIT 1];

        RegistrarNotaFiscalAction.Entrada entrada = new RegistrarNotaFiscalAction.Entrada();
        entrada.textoOriginal = 'texto qualquer';
        entrada.valorTotal = 10;
        entrada.itensJson = 'isso nao e um json valido';

        Test.startTest();
        List<RegistrarNotaFiscalAction.Saida> resultados;
        System.runAs(usuarioPortal) {
            resultados = RegistrarNotaFiscalAction.registrar(new List<RegistrarNotaFiscalAction.Entrada>{ entrada });
        }
        Test.stopTest();

        System.assertEquals(1, resultados.size());
        System.assertEquals(0, resultados[0].pontosGerados);
        System.assert(resultados[0].mensagem.contains('Nao foi possivel'));
    }
}
