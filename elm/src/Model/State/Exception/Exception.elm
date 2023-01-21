module Model.State.Exception.Exception exposing (Exception(..), decode)

import Json.Decode as Decode
import Util.Decode as Util


type Exception
    = Open String (Maybe Href)
    | Waiting
    | Closed


type alias Href =
    String


decode : String -> Result String { message : String, href : Maybe Href }
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder { message : String, href : Maybe Href }
decoder =
    Decode.map2
        (\m h ->
            { message = m, href = h }
        )
        (Decode.field "message" Decode.string)
        (Decode.maybe <|
            Decode.field "href" Decode.string
        )
