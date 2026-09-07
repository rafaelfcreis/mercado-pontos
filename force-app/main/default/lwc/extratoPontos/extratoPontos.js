import { LightningElement, wire } from 'lwc';
import saldoDePontos from '@salesforce/apex/MercadoPontosController.saldoDePontos';

export default class ExtratoPontos extends LightningElement {
    @wire(saldoDePontos)
    saldo;

    get valorSaldo() {
        return this.saldo && this.saldo.data !== undefined ? this.saldo.data : 0;
    }
}
