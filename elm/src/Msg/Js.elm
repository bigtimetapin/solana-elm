module Msg.Js exposing (FromJs(..))


type FromJs
    = Success Json
    | Exception String


type alias Json =
    String
