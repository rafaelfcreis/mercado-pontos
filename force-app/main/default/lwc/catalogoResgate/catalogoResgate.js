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

    get emCheckout() {
        return !!this.produtoSelecionadoId;
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
        return this.saldoInsuficiente || this.resgatando;
    }

    handleAbrirCheckout(event) {
        this.produtoSelecionadoId = event.target.dataset.id;
        this.mensagem = '';
        this.erro = false;
    }

    handleCancelarCheckout() {
        this.produtoSelecionadoId = null;
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
            await resgatar({ produtoId: produto.Id });
            this.mensagem = `Resgate de "${produto.Name}" confirmado com sucesso!`;
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
