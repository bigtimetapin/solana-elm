module Model.PublicKey exposing (PublicKey, encode)

import Json.Encode as Encode


type alias PublicKey =
    String


encode : PublicKey -> String
encode publicKey =
    let
        encoder =
            Encode.object
                [ ( "publicKey", Encode.string publicKey )
                ]
    in
    Encode.encode 0 encoder
