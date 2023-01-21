module Model.Model exposing (Model, init)

import Browser.Navigation as Nav
import Model.State.Exception.Exception as Exception
import Model.State.Global.Global as Global
import Model.State.Local.Local as Local exposing (Local)
import Model.State.State exposing (State)
import Msg.Msg exposing (Msg(..))
import Url


type alias Model =
    { state : State
    , url : Url.Url
    , key : Nav.Key
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        local : Local
        local =
            Local.parse url

        model : Model
        model =
            { state =
                { local = local
                , global = Global.default
                , exception = Exception.Closed
                }
            , url = url
            , key = key
            }
    in
    ( model
    , Cmd.none
    )
