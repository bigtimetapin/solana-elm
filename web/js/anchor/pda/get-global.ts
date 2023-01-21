import {AnchorProvider, Program, SplToken} from "@project-serum/anchor";
import {SolanaElm} from "../idl/idl";
import {deriveUserPda, getUserPda} from "./user-pda";

export async function getGlobal(
    app,
    provider: AnchorProvider,
    programs: {
        elm: Program<SolanaElm>,
        token: Program<SplToken>
    },
): Promise<void> {
    // derive user pda
    const userPda = deriveUserPda(
        provider,
        programs.elm
    );
    // try getting user if existing already
    try {
        const user = await getUserPda(
            provider,
            programs.elm,
            userPda
        );
        app.ports.success.send(
            JSON.stringify(
                {
                    listener: "global-found-user",
                    more: JSON.stringify(
                        user
                    )
                }
            )
        );
    } catch (error) {
        console.log(error);
        console.log("could not find user on-chain");
        // send success to elm
        app.ports.success.send(
            JSON.stringify(
                {
                    listener: "global-found-wallet",
                    more: JSON.stringify({
                            wallet: provider.wallet.publicKey.toString()
                        }
                    )
                }
            )
        );
    }
}
