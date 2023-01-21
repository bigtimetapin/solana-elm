module Model.Wallet exposing (Wallet, decode, decoder, encoder, slice)

import Json.Decode as Decode
import Json.Encode as Encode
import Util.Decode as Util


type alias Wallet =
    String


slice : Wallet -> String
slice publicKey =
    String.join
        "..."
        [ String.slice 0 4 publicKey
        , String.slice -5 -1 publicKey
        ]


encoder : Wallet -> Encode.Value
encoder wallet =
    Encode.object
        [ ( "wallet", Encode.string wallet )
        ]


type alias WalletObject =
    { wallet : String }


decode : String -> Result String Wallet
decode string =
    Util.decode string decoder (\a -> a.wallet)


decoder : Decode.Decoder WalletObject
decoder =
    Decode.map WalletObject
        (Decode.field "wallet" Decode.string)
