module Sub.Listener.Global.Global exposing (ToGlobal(..), fromString)


type ToGlobal
    = FoundWalletDisconnected
    | FoundMissingWalletPlugin -- no browser plugin installed
    | FoundWallet


fromString : String -> Maybe ToGlobal
fromString string =
    case string of
        "global-found-wallet-disconnected" ->
            Just FoundWalletDisconnected

        "global-found-missing-wallet-plugin" ->
            Just FoundMissingWalletPlugin

        "global-found-wallet" ->
            Just FoundWallet

        _ ->
            Nothing
