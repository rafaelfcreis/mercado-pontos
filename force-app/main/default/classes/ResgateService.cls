public without sharing class ResgateService {

    public class ResgateException extends Exception {}

    public static Id resgatarProduto(Id contatoId, Id produtoId) {
        Contact cliente = [SELECT Id, Saldo_Pontos__c FROM Contact WHERE Id = :contatoId LIMIT 1];
        ProdutoResgate__c produto = [
            SELECT Id, Custo_Pontos__c, Ativo__c, Estoque__c
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
            Status__c = 'Solicitado'
        );
        insert resgate;

        cliente.Saldo_Pontos__c = saldoAtual - produto.Custo_Pontos__c;
        update cliente;

        if (produto.Estoque__c != null) {
            produto.Estoque__c -= 1;
            update produto;
        }

        return resgate.Id;
    }
}
