module Model.State.State exposing (State)

import Model.State.Exception.Exception exposing (Exception)
import Model.State.Global.Global exposing (Global)
import Model.State.Local.Local exposing (Local)


type alias State =
    { local : Local
    , global : Global
    , exception : Exception
    }
