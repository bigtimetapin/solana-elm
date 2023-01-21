module Sub.Listener.Local.User.Listener exposing (Listener(..), fromString)


type Listener
    = Fetched


fromString : String -> Maybe Listener
fromString string =
    case string of
        "user-fetched" ->
            Just Fetched

        _ ->
            Nothing
