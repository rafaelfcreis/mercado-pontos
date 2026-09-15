import { LightningElement } from 'lwc';
import enviarNota from '@salesforce/apex/MercadoPontosController.enviarNota';

export default class EnviarNotaFiscal extends LightningElement {
    textoBruto = '';
    chaveAcesso = '';
    valorTotal;
    enviando = false;
    mensagem = '';
    erro = false;

    handleTextoChange(event) {
        this.textoBruto = event.target.value;
    }

    handleChaveChange(event) {
        this.chaveAcesso = event.target.value;
    }

    handleValorChange(event) {
        this.valorTotal = event.target.value;
    }

    get mensagemClass() {
        return this.erro ? 'slds-text-color_error' : 'slds-text-color_success';
    }

    async handleEnviar() {
        if (!this.textoBruto) {
            this.mensagem = 'Cole o texto da sua nota fiscal antes de enviar.';
            this.erro = true;
            return;
        }
        if (!this.valorTotal || this.valorTotal <= 0) {
            this.mensagem = 'Informe o valor total da compra.';
            this.erro = true;
            return;
        }
        this.enviando = true;
        this.erro = false;
        this.mensagem = '';
        try {
            await enviarNota({
                textoBruto: this.textoBruto,
                chaveAcesso: this.chaveAcesso,
                valorTotal: this.valorTotal
            });
            this.mensagem = 'Nota registrada! Seus pontos ja foram creditados no saldo.';
            this.textoBruto = '';
            this.chaveAcesso = '';
            this.valorTotal = null;
        } catch (error) {
            this.erro = true;
            this.mensagem = error.body && error.body.message ? error.body.message : 'Nao foi possivel enviar a nota.';
        } finally {
            this.enviando = false;
        }
    }
}
