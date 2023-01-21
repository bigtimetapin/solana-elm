module Model.State.Global.Global exposing (Global(..), default)

import Model.User.User exposing (User)
import Model.Wallet exposing (Wallet)


type Global
    = NoWalletYet
    | WalletMissing -- no browser extension found
    | HasWallet Wallet
    | HasUser User


default : Global
default =
    NoWalletYet
