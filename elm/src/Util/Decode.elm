module Util.Decode exposing (decode)

import Json.Decode as Decode


decode : String -> Decode.Decoder a -> (a -> b) -> Result String b
decode string decoder f =
    case Decode.decodeString decoder string of
        Ok obj ->
            Ok <| f obj

        Err error ->
            Err (Decode.errorToString error)
