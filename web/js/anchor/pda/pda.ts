import {PublicKey} from "@solana/web3.js";

export interface Pda {
    address: PublicKey,
    bump: number
}
