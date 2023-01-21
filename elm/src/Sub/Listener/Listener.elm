module Sub.Listener.Listener exposing (Listener(..), decode, decode0, decode2)

import Json.Decode as Decode
import Model.Model exposing (Model)
import Model.State.Local.Local as Local
import Msg.Msg exposing (Msg)
import Sub.Listener.Global.Global as GlobalListener exposing (ToGlobal)
import Sub.Listener.Local.Local as LocalListener exposing (ToLocal)
import Util.Decode as Util


type Listener
    = Local ToLocal
    | Global ToGlobal


decode0 : String -> Result String (Maybe Listener)
decode0 string =
    let
        decoder : Decode.Decoder (Maybe Listener)
        decoder =
            Decode.field "listener" <| Decode.map fromString Decode.string
    in
    Util.decode string decoder identity


decode : Model -> Json -> (String -> Result String a) -> (a -> Model) -> ( Model, Cmd Msg )
decode model json moreDecoder update =
    decode2 model json moreDecoder (\a -> ( update a, Cmd.none ))


decode2 : Model -> Json -> (String -> Result String a) -> (a -> ( Model, Cmd Msg )) -> ( Model, Cmd Msg )
decode2 model json moreDecoder update =
    case decodeMore json of
        -- more found
        Ok moreJson ->
            -- decode
            case moreDecoder moreJson of
                Ok decoded ->
                    update decoded

                -- error from decoder
                Err string ->
                    ( { model
                        | state =
                            { local = Local.Error string
                            , global = model.state.global
                            , exception = model.state.exception
                            }
                      }
                    , Cmd.none
                    )

        -- error from decoder
        Err string ->
            ( { model
                | state =
                    { local = Local.Error string
                    , global = model.state.global
                    , exception = model.state.exception
                    }
              }
            , Cmd.none
            )


decodeMore : String -> Result String Json
decodeMore string =
    let
        decoder =
            Decode.field "more" Decode.string
    in
    Util.decode string decoder identity


fromString : String -> Maybe Listener
fromString string =
    case GlobalListener.fromString string of
        Just toGlobal ->
            Just <| Global toGlobal

        Nothing ->
            case LocalListener.fromString string of
                Just toLocal ->
                    Just <| Local toLocal

                Nothing ->
                    Nothing


type alias Json =
    String
