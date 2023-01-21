module Model.User.User exposing (User, decode)

import Json.Decode as Decode
import Util.Decode as Util


type alias User =
    { increment : Int
    }


decode : String -> Result String User
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder User
decoder =
    Decode.map User
        (Decode.field "increment" Decode.int)
