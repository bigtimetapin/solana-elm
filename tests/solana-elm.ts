import * as anchor from "@project-serum/anchor";
import {Program} from "@project-serum/anchor";
import {SolanaElm} from "../target/types/solana_elm";
import {PublicKey, SystemProgram} from "@solana/web3.js";
import {assert} from "chai";

describe("solana-elm", () => {
    // Configure the client to use the local cluster.
    anchor.setProvider(anchor.AnchorProvider.env());
    const program = anchor.workspace.SolanaElm as Program<SolanaElm>;
    it("should run top level", async () => {
        let pda, _;
        [pda, _] = PublicKey.findProgramAddressSync(
            [
                Buffer.from("user")
            ],
            program.programId
        );
        await program
            .methods
            .increment()
            .accounts(
                {
                    user: pda,
                    payer: program.provider.publicKey,
                    systemProgram: SystemProgram.programId,
                }
            ).rpc()
        const fetched = await program.account.user.fetch(pda);
        assert(fetched.increment === 1);
    });
});
