module Sub.Listener.Local.Local exposing (ToLocal(..), fromString)

import Sub.Listener.Local.User.Listener as User


type ToLocal
    = User User.Listener


fromString : String -> Maybe ToLocal
fromString string =
    case User.fromString string of
        Just listener ->
            Just <| User listener

        Nothing ->
            Nothing
