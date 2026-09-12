public without sharing class RegistrarNotaFiscalAction {

    public class Entrada {
        @InvocableVariable(label='Texto Original da Nota' description='O texto exato que o cliente colou, antes da interpretacao' required=true)
        public String textoOriginal;

        @InvocableVariable(label='Nome do Estabelecimento' description='Nome do mercado ou loja identificado no texto da nota' required=false)
        public String estabelecimento;

        @InvocableVariable(label='Data da Compra' description='Data da compra no formato AAAA-MM-DD, ou vazio se nao identificada' required=false)
        public String dataCompra;

        @InvocableVariable(label='Valor Total' description='Valor total da compra identificado no texto' required=true)
        public Decimal valorTotal;

        @InvocableVariable(label='Itens em JSON' description='Lista de itens identificados na nota, em formato JSON: [{"descricao":"...","quantidade":1,"valorTotalItem":10.5,"categoria":"Alimentos"}]. Categoria deve ser uma de: Alimentos, Bebidas, Limpeza, Higiene, Outros.' required=true)
        public String itensJson;

        @InvocableVariable(label='Recomendacao' description='Sugestao curta de produto para resgate de pontos baseado no perfil desta compra' required=false)
        public String recomendacao;
    }

    public class Saida {
        @InvocableVariable(label='Pontos Gerados')
        public Integer pontosGerados;

        @InvocableVariable(label='Saldo Atual de Pontos')
        public Decimal saldoAtual;

        @InvocableVariable(label='Mensagem')
        public String mensagem;
    }

    @InvocableMethod(
        label='Registrar Nota Fiscal e Calcular Pontos'
        description='Recebe os dados ja extraidos de uma nota fiscal (estabelecimento, data, valor total, itens em JSON) e credita pontos ao cliente logado no programa Mercado Pontos.'
    )
    public static List<Saida> registrar(List<Entrada> entradas) {
        List<Saida> resultados = new List<Saida>();
        for (Entrada entrada : entradas) {
            Saida saida = new Saida();
            try {
                Id contatoId = contatoDoUsuarioAtual();
                Id notaId = NotaFiscalProcessingService.registrarNotaPendente(contatoId, entrada.textoOriginal, null);

                NotaFiscalProcessingService.DadosExtraidos dados = new NotaFiscalProcessingService.DadosExtraidos();
                dados.estabelecimento = entrada.estabelecimento;
                dados.dataCompra = entrada.dataCompra;
                dados.valorTotal = entrada.valorTotal;
                dados.recomendacao = entrada.recomendacao;
                dados.itens = String.isBlank(entrada.itensJson)
                    ? new List<NotaFiscalProcessingService.ItemExtraido>()
                    : (List<NotaFiscalProcessingService.ItemExtraido>) JSON.deserialize(
                        entrada.itensJson, List<NotaFiscalProcessingService.ItemExtraido>.class
                    );

                NotaFiscalProcessingService.processarComDadosExtraidos(notaId, dados);

                Contact cliente = [SELECT Saldo_Pontos__c FROM Contact WHERE Id = :contatoId LIMIT 1];
                saida.pontosGerados = entrada.valorTotal == null ? 0 : entrada.valorTotal.intValue();
                saida.saldoAtual = cliente.Saldo_Pontos__c;
                saida.mensagem = 'Nota registrada com sucesso. Pontos creditados.';
            } catch (Exception e) {
                saida.pontosGerados = 0;
                saida.mensagem = 'Nao foi possivel registrar a nota: ' + e.getMessage();
            }
            resultados.add(saida);
        }
        return resultados;
    }

    private static Id contatoDoUsuarioAtual() {
        User usuario = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return usuario.ContactId;
    }
}
