import {getPhantom, getPhantomProvider} from "./phantom";
import {getEphemeralPP, getPP} from "./anchor/util/context";

// init phantom
let phantom = null;

export async function main(app, json) {
    console.log(json);
    try {
        // parse json as object
        const parsed = JSON.parse(json);
        // match on sender role
        const sender = parsed.sender;
        // listen for connect
        if (sender === "connect") {
            // get phantom
            phantom = await getPhantom(app);
            if (phantom) {
                // get provider & program
                const pp = getPP(phantom);
                // send wallet to elm
                app.ports.success.send(
                    JSON.stringify(
                        {
                            listener: "global-found-wallet",
                            more: JSON.stringify(
                                {
                                    wallet: pp.provider.wallet.publicKey.toString()
                                }
                            )
                        }
                    )
                );
            }
            // or listen for disconnect
        } else if (sender === "disconnect") {
            phantom.windowSolana.disconnect();
            phantom = null;
            app.ports.success.send(
                JSON.stringify(
                    {
                        listener: "global-found-wallet-disconnected"
                    }
                )
            );
            // or throw error
        } else {
            const msg = "invalid role sent to js: " + sender;
            app.ports.exception.send(
                msg
            );
        }
    } catch (error) {
        console.log(error);
        app.ports.exception.send(
            error.toString()
        );
    }
}

// export async function onWalletChange(app) {
//     const phantomProvider = getPhantomProvider();
//     if (phantomProvider) {
//         phantomProvider.on("accountChanged", async () => {
//             console.log("wallet changed");
//             // fetch state if previously connected
//             if (phantom) {
//                 phantom = await getPhantom(app);
//                 const pp = getPP(phantom);
//                 await getGlobal(
//                     app,
//                     pp.provider,
//                     pp.programs
//                 );
//             }
//         });
//     }
// }
//