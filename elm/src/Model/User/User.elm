module Model.User.User exposing (User, decode)

import Json.Decode as Decode
import Model.Wallet exposing (Wallet)
import Util.Decode as Util


type alias User =
    { wallet : Wallet
    , increment : Int
    }


decode : String -> Result String User
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder User
decoder =
    Decode.map2 User
        (Decode.field "wallet" Decode.string)
        (Decode.field "increment" Decode.int)
