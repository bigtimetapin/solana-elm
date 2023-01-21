module Msg.Global exposing (Global(..), toString)


type
    Global
    -- wallet
    = Connect
    | Disconnect


toString : Global -> String
toString global =
    case global of
        Connect ->
            "connect"

        Disconnect ->
            "disconnect"
