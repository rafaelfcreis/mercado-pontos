public without sharing class NotaFiscalProcessingService {

    public class NotaDuplicadaException extends Exception {}

    public class ItemExtraido {
        public String descricao;
        public Decimal quantidade;
        public Decimal valorTotalItem;
        public String categoria;
    }

    public class DadosExtraidos {
        public String estabelecimento;
        public String dataCompra;
        public Decimal valorTotal;
        public List<ItemExtraido> itens;
    }

    public static Id registrarNotaPendente(Id contatoId, String textoBruto, String chaveAcesso) {
        chaveAcesso = String.isBlank(chaveAcesso) ? null : chaveAcesso.trim();
        if (chaveAcesso != null) {
            List<NotaFiscal__c> existentes = [
                SELECT Id FROM NotaFiscal__c WHERE Chave_Acesso__c = :chaveAcesso LIMIT 1
            ];
            if (!existentes.isEmpty()) {
                throw new NotaDuplicadaException('Esta nota fiscal ja foi enviada anteriormente.');
            }
        }

        NotaFiscal__c nota = new NotaFiscal__c(
            Contato__c = contatoId,
            Texto_Bruto__c = textoBruto,
            Chave_Acesso__c = chaveAcesso,
            Status__c = 'Pendente'
        );
        insert nota;
        return nota.Id;
    }

    public static void processarComDadosExtraidos(Id notaFiscalId, DadosExtraidos dados) {
        NotaFiscal__c nota = [
            SELECT Id, Contato__c, Status__c FROM NotaFiscal__c WHERE Id = :notaFiscalId LIMIT 1
        ];
        if (nota.Status__c == 'Processada') {
            return;
        }

        List<ItemNotaFiscal__c> itensParaInserir = new List<ItemNotaFiscal__c>();
        if (dados.itens != null) {
            for (ItemExtraido item : dados.itens) {
                itensParaInserir.add(new ItemNotaFiscal__c(
                    NotaFiscal__c = notaFiscalId,
                    Descricao__c = item.descricao,
                    Quantidade__c = item.quantidade,
                    Valor_Total_Item__c = item.valorTotalItem,
                    Categoria__c = String.isBlank(item.categoria) ? 'Outros' : item.categoria
                ));
            }
        }
        if (!itensParaInserir.isEmpty()) {
            insert itensParaInserir;
        }

        Integer pontosGerados = dados.valorTotal == null ? 0 : dados.valorTotal.intValue();

        nota.Status__c = 'Processada';
        nota.Estabelecimento__c = dados.estabelecimento;
        nota.Valor_Total__c = dados.valorTotal;
        nota.Pontos_Gerados__c = pontosGerados;
        if (String.isNotBlank(dados.dataCompra)) {
            try {
                nota.Data_Compra__c = Date.valueOf(dados.dataCompra);
            } catch (Exception e) {
                // formato de data inesperado vindo da IA - segue sem bloquear a pontuacao
            }
        }
        update nota;

        if (pontosGerados > 0) {
            Contact cliente = [SELECT Id, Saldo_Pontos__c FROM Contact WHERE Id = :nota.Contato__c LIMIT 1];
            cliente.Saldo_Pontos__c = (cliente.Saldo_Pontos__c == null ? 0 : cliente.Saldo_Pontos__c) + pontosGerados;
            update cliente;
        }
    }

    public static void marcarComoErro(Id notaFiscalId) {
        update new NotaFiscal__c(Id = notaFiscalId, Status__c = 'Erro_Processamento');
    }
}
