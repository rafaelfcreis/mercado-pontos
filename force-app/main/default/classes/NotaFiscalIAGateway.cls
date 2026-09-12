public without sharing class NotaFiscalIAGateway {

    @TestVisible
    private static final String TEMPLATE_API_NAME = 'Extrair_Dados_Nota_Fiscal';

    public class ExtracaoException extends Exception {}

    public static NotaFiscalProcessingService.DadosExtraidos extrairDados(String textoNota) {
        String jsonBruto = chamarPromptTemplate(textoNota);
        String jsonLimpo = limparJson(jsonBruto);
        try {
            return (NotaFiscalProcessingService.DadosExtraidos) JSON.deserialize(
                jsonLimpo, NotaFiscalProcessingService.DadosExtraidos.class
            );
        } catch (Exception e) {
            throw new ExtracaoException('A IA nao devolveu um JSON valido: ' + e.getMessage());
        }
    }

    private static String chamarPromptTemplate(String textoNota) {
        ConnectApi.WrappedValue valorEnvolvido = new ConnectApi.WrappedValue();
        valorEnvolvido.value = textoNota;

        Map<String, ConnectApi.WrappedValue> inputParamsMap = new Map<String, ConnectApi.WrappedValue>();
        inputParamsMap.put('Input:textoNota', valorEnvolvido);

        ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput =
            new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        executeTemplateInput.additionalConfig.applicationName = 'PromptBuilderPreview';
        executeTemplateInput.isPreview = false;
        executeTemplateInput.inputParams = inputParamsMap;

        try {
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation resultado =
                ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(TEMPLATE_API_NAME, executeTemplateInput);
            return resultado.generations[0].text;
        } catch (Exception e) {
            throw new ExtracaoException('Nao foi possivel processar a nota com a IA: ' + e.getMessage());
        }
    }

    @TestVisible
    private static String limparJson(String texto) {
        if (String.isBlank(texto)) {
            return '{}';
        }
        texto = texto.trim();
        texto = texto.replaceAll('(?s)^```json', '');
        texto = texto.replaceAll('(?s)^```', '');
        texto = texto.replaceAll('(?s)```$', '');
        return texto.trim();
    }
}
