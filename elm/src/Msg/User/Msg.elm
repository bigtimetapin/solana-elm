module Msg.User.Msg exposing (Msg(..), toString)


type Msg
    = Increment


toString : Msg -> String
toString msg =
    case msg of
        Increment ->
            "user-increment"
