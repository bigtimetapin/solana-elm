module Msg.User.Msg exposing (Msg(..), toString)


type Msg
    = Init


toString : Msg -> String
toString msg =
    case msg of
        Init ->
            "user-init"
