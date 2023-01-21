module Sub.Sub exposing (subs)

import Msg.Js exposing (FromJs(..))
import Msg.Msg exposing (Msg(..))
import Sub.Listener.Ports exposing (exception, success)


subs : Sub Msg
subs =
    Sub.batch
        [ success
            (\json ->
                FromJs <| Success json
            )
        , exception
            (\string ->
                FromJs <| Exception string
            )
        ]
