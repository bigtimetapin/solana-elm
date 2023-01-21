module Model.User.State exposing (State(..))

import Model.User.User exposing (User)


type State
    = Top
    | Fetched User
