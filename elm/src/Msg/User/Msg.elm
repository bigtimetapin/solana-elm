module Msg.User.Msg exposing (Msg(..), toString)

import Model.User.User exposing (User)


type Msg
    = ToFetched User
    | Increment


toString : Msg -> String
toString msg =
    case msg of
        Increment ->
            "user-increment"

        _ ->
            "no-op"
