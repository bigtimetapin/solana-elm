import {Pda} from "./pda";
import {AnchorProvider, Program} from "@project-serum/anchor";
import {PublicKey} from "@solana/web3.js";
import {SolanaElm} from "../idl/idl";

export interface UserPda extends Pda {
}

export interface User {
    wallet: PublicKey
    increment: number
}

export async function getUserPda(provider: AnchorProvider, program: Program<SolanaElm>, pda: UserPda): Promise<User> {
    const fetched = await program.account.user.fetch(pda.address);
    return {
        wallet: provider.wallet.publicKey,
        increment: fetched.increment
    }
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
