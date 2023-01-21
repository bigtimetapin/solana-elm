module Model.State.Global.Global exposing (Global(..), default)

import Model.Wallet exposing (Wallet)


type Global
    = NoWalletYet
    | WalletMissing -- no browser extension found
    | HasWallet Wallet


default : Global
default =
    NoWalletYet
