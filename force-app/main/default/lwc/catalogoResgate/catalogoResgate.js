import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import catalogoDisponivel from '@salesforce/apex/MercadoPontosController.catalogoDisponivel';
import resgatar from '@salesforce/apex/MercadoPontosController.resgatar';

export default class CatalogoResgate extends LightningElement {
    wiredResultado;
    mensagem = '';
    erro = false;

    @wire(catalogoDisponivel)
    wiredCatalogo(result) {
        this.wiredResultado = result;
    }

    get produtos() {
        return this.wiredResultado && this.wiredResultado.data ? this.wiredResultado.data : [];
    }

    get mensagemClass() {
        return this.erro ? 'slds-text-color_error' : 'slds-text-color_success';
    }

    async handleResgatar(event) {
        const produtoId = event.target.dataset.id;
        this.mensagem = '';
        this.erro = false;
        try {
            await resgatar({ produtoId });
            this.mensagem = 'Resgate solicitado com sucesso!';
            await refreshApex(this.wiredResultado);
        } catch (error) {
            this.erro = true;
            this.mensagem = error.body && error.body.message ? error.body.message : 'Nao foi possivel resgatar este produto.';
        }
    }
}
