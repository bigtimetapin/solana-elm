import {Pda} from "./pda";
import {AnchorProvider, Program} from "@project-serum/anchor";
import {PublicKey} from "@solana/web3.js";
import {SolanaElm} from "../idl/idl";

export interface UserPda extends Pda {
}

export interface User {
    increment: number
}

export async function getUserPda(program: Program<SolanaElm>, pda: UserPda): Promise<User> {
    return await program.account.user.fetch(pda.address)
}

export function deriveUserPda(provider: AnchorProvider, program: Program<SolanaElm>): UserPda {
    let pda, bump;
    [pda, bump] = PublicKey.findProgramAddressSync(
        [
            Buffer.from(SEED),
            provider.wallet.publicKey.toBuffer()
        ],
        program.programId
    );
    return {
        address: pda,
        bump
    }
}

const SEED = "user";
