import {Keypair, PublicKey, Transaction} from "@solana/web3.js";
import {Wallet} from "@project-serum/anchor";

export class PhantomWallet implements Wallet {

    constructor(readonly phantom: any) {
    }

    async signTransaction(tx: Transaction): Promise<Transaction> {
        return this.phantom.windowSolana.signTransaction(tx);
    }

    async signAllTransactions(txs: Transaction[]): Promise<Transaction[]> {
        return txs.map((t) => {
            this.phantom.windowSolana.signTransaction(t);
            return t;
        });
    }

    async signMessage(message) {
        return (await this.phantom.windowSolana.signMessage(message, "utf8")).signature;
    }

    readonly payer: Keypair;

    get publicKey(): PublicKey {
        return this.phantom.connection.publicKey;
    }

}

export class EphemeralWallet implements Wallet {

    constructor(readonly payer: Keypair) {
    }

    get publicKey(): PublicKey {
        return this.payer.publicKey;
    }

    async signAllTransactions(txs: Transaction[]): Promise<Transaction[]> {
        return txs.map((t) => {
            t.partialSign(this.payer);
            return t;
        });
    }

    async signTransaction(tx: Transaction): Promise<Transaction> {
        tx.partialSign(this.payer);
        return tx;
    }

}
