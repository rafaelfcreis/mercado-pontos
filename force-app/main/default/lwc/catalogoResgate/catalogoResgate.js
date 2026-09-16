import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import catalogoDisponivel from '@salesforce/apex/MercadoPontosController.catalogoDisponivel';
import saldoDePontos from '@salesforce/apex/MercadoPontosController.saldoDePontos';
import resgatar from '@salesforce/apex/MercadoPontosController.resgatar';

export default class CatalogoResgate extends LightningElement {
    wiredCatalogoResultado;
    wiredSaldoResultado;
    mensagem = '';
    erro = false;
    resgatando = false;
    produtoSelecionadoId;
    confirmacao;
    documento = '';

    @wire(catalogoDisponivel)
    wiredCatalogo(result) {
        this.wiredCatalogoResultado = result;
    }

    @wire(saldoDePontos)
    wiredSaldo(result) {
        this.wiredSaldoResultado = result;
    }

    get produtos() {
        return this.wiredCatalogoResultado && this.wiredCatalogoResultado.data
            ? this.wiredCatalogoResultado.data
            : [];
    }

    get saldoAtual() {
        return this.wiredSaldoResultado && this.wiredSaldoResultado.data !== undefined
            ? this.wiredSaldoResultado.data
            : 0;
    }

    get mensagemClass() {
        return this.erro ? 'slds-text-color_error' : 'slds-text-color_success';
    }

    get emConfirmacao() {
        return !!this.confirmacao;
    }

    get emCheckout() {
        return !this.confirmacao && !!this.produtoSelecionadoId;
    }

    get emGrade() {
        return !this.confirmacao && !this.produtoSelecionadoId;
    }

    get produtoSelecionado() {
        return this.produtos.find((produto) => produto.Id === this.produtoSelecionadoId);
    }

    get saldoAposResgate() {
        const produto = this.produtoSelecionado;
        return produto ? this.saldoAtual - produto.Custo_Pontos__c : this.saldoAtual;
    }

    get saldoInsuficiente() {
        const produto = this.produtoSelecionado;
        return produto ? this.saldoAtual < produto.Custo_Pontos__c : false;
    }

    get confirmarDesabilitado() {
        return this.saldoInsuficiente || this.resgatando || !this.documento;
    }

    get urlQrCode() {
        if (!this.confirmacao) {
            return '';
        }
        const dados = encodeURIComponent(this.confirmacao.codigoRetirada);
        return `https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=${dados}`;
    }

    handleAbrirCheckout(event) {
        this.produtoSelecionadoId = event.target.dataset.id;
        this.mensagem = '';
        this.erro = false;
        this.documento = '';
    }

    handleDocumentoChange(event) {
        this.documento = event.target.value;
    }

    handleCancelarCheckout() {
        this.produtoSelecionadoId = null;
    }

    handleFecharConfirmacao() {
        this.confirmacao = null;
    }

    async handleConfirmarResgate() {
        const produto = this.produtoSelecionado;
        if (!produto) {
            return;
        }
        this.resgatando = true;
        this.mensagem = '';
        this.erro = false;
        try {
            const resultado = await resgatar({ produtoId: produto.Id, documento: this.documento });
            this.confirmacao = {
                produtoNome: produto.Name,
                codigoRetirada: resultado.codigoRetirada
            };
            this.produtoSelecionadoId = null;
            await Promise.all([
                refreshApex(this.wiredCatalogoResultado),
                refreshApex(this.wiredSaldoResultado)
            ]);
        } catch (error) {
            this.erro = true;
            this.mensagem = error.body && error.body.message ? error.body.message : 'Nao foi possivel resgatar este produto.';
        } finally {
            this.resgatando = false;
        }
    }
}
