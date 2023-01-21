import {AnchorProvider, Program} from "@project-serum/anchor";
import {SolanaElm} from "../idl/idl";
import {deriveUserPda, getUserPda} from "../pda/user-pda";
import {SystemProgram} from "@solana/web3.js";

export async function ix(app, provider: AnchorProvider, program: Program<SolanaElm>): Promise<void> {
    const userPda = deriveUserPda(
        provider,
        program
    );
    await program
        .methods
        .increment()
        .accounts(
            {
                user: userPda.address,
                payer: provider.wallet.publicKey,
                systemProgram: SystemProgram.programId
            }
        ).rpc();
    const user = await getUserPda(
        provider,
        program,
        userPda
    );
    app.ports.success.send(
        JSON.stringify(
            {
                listener: "user-fetched",
                more: JSON.stringify(
                    user
                )
            }
        )
    );
}
