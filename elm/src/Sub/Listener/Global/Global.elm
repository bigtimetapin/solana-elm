module Sub.Listener.Global.Global exposing (ToGlobal(..), fromString)


type ToGlobal
    = FoundWalletDisconnected
    | FoundMissingWalletPlugin -- no browser plugin installed
    | FoundWallet
    | FoundUser


fromString : String -> Maybe ToGlobal
fromString string =
    case string of
        "global-found-wallet-disconnected" ->
            Just FoundWalletDisconnected

        "global-found-missing-wallet-plugin" ->
            Just FoundMissingWalletPlugin

        "global-found-wallet" ->
            Just FoundWallet

        "global-found-user" ->
            Just FoundUser

        _ ->
            Nothing
