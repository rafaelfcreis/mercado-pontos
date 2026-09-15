import { LightningElement, api, wire } from 'lwc';
import saldoDePontos from '@salesforce/apex/MercadoPontosController.saldoDePontos';

export default class CabecalhoMercadoPontos extends LightningElement {
    @api linkCatalogo = '/mercadopontos/catalogo';
    @api linkHome = '/mercadopontos/';
    @api tituloSite = 'Mercado Pontos';

    saldo = 0;
    saldoDisponivel = false;

    @wire(saldoDePontos)
    wiredSaldo({ data, error }) {
        if (data !== undefined && data !== null) {
            this.saldo = data;
            this.saldoDisponivel = true;
        } else if (error) {
            this.saldoDisponivel = false;
        }
    }
}
