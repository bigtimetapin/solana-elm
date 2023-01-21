module Main exposing (main)

-- MAIN

import Browser
import Browser.Navigation as Nav
import Model.Model as Model exposing (Model)
import Model.State.Exception.Exception as Exception
import Model.State.Global.Global as Global
import Model.State.Local.Local as Local exposing (Local)
import Model.User.State as UserState
import Model.User.User as User
import Model.Wallet as Wallet
import Msg.Js as JsMsg
import Msg.Msg exposing (Msg(..), resetViewport)
import Msg.User.Msg as UserMsg
import Sub.Listener.Global.Global as ToGlobal
import Sub.Listener.Listener as Listener
import Sub.Listener.Local.Local as ToLocal
import Sub.Listener.Local.User.Listener as UserListener
import Sub.Sender.Ports exposing (sender)
import Sub.Sender.Sender as Sender
import Sub.Sub as Sub
import Url
import View.Error.Error
import View.Hero
import View.User.View


main : Program () Model Msg
main =
    Browser.application
        { init = Model.init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.subs
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlChanged url ->
            let
                local : Local
                local =
                    Local.parse url

                bump : Model
                bump =
                    { model
                        | state =
                            { local = local
                            , global = model.state.global
                            , exception = model.state.exception
                            }
                        , url = url
                    }
            in
            ( bump
            , resetViewport
            )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        FromUser fromUserMsg ->
            case fromUserMsg of
                UserMsg.Increment ->
                    ( { model
                        | state =
                            { local = model.state.local
                            , global = model.state.global
                            , exception = Exception.Waiting
                            }
                      }
                    , sender <|
                        Sender.encode0 <|
                            Sender.User fromUserMsg
                    )

        FromJs fromJsMsg ->
            case fromJsMsg of
                -- JS sending success for decoding
                JsMsg.Success json ->
                    -- decode
                    case Listener.decode0 json of
                        -- decode success
                        Ok maybeListener ->
                            -- look for role
                            case maybeListener of
                                -- found role
                                Just listener ->
                                    -- which role?
                                    case listener of
                                        -- found msg for local update
                                        Listener.Local toLocal ->
                                            case toLocal of
                                                ToLocal.User userListener ->
                                                    case userListener of
                                                        UserListener.Fetched ->
                                                            let
                                                                f user =
                                                                    { model
                                                                        | state =
                                                                            { local =
                                                                                Local.User <|
                                                                                    UserState.Fetched user
                                                                            , global = model.state.global
                                                                            , exception = Exception.Closed
                                                                            }
                                                                    }
                                                            in
                                                            Listener.decode model json User.decode f

                                        -- found msg for global
                                        Listener.Global toGlobal ->
                                            case toGlobal of
                                                ToGlobal.FoundWalletDisconnected ->
                                                    ( { model
                                                        | state =
                                                            { local = model.state.local
                                                            , global = Global.NoWalletYet
                                                            , exception = Exception.Closed
                                                            }
                                                      }
                                                    , Cmd.none
                                                    )

                                                ToGlobal.FoundMissingWalletPlugin ->
                                                    ( { model
                                                        | state =
                                                            { local = model.state.local
                                                            , global = Global.WalletMissing
                                                            , exception = Exception.Closed
                                                            }
                                                      }
                                                    , Cmd.none
                                                    )

                                                ToGlobal.FoundWallet ->
                                                    let
                                                        f wallet =
                                                            { model
                                                                | state =
                                                                    { local = model.state.local
                                                                    , global = Global.HasWallet wallet
                                                                    , exception = Exception.Closed
                                                                    }
                                                            }
                                                    in
                                                    Listener.decode model json Wallet.decode f

                                -- undefined role
                                Nothing ->
                                    let
                                        message =
                                            String.join
                                                " "
                                                [ "Invalid role sent from client:"
                                                , json
                                                ]
                                    in
                                    ( { model
                                        | state =
                                            { local = Local.Error message
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

                -- JS sending exception to catch
                JsMsg.Exception string ->
                    case Exception.decode string of
                        Ok exception ->
                            ( { model
                                | state =
                                    { local = model.state.local
                                    , global = model.state.global
                                    , exception = Exception.Open exception.message exception.href
                                    }
                              }
                            , Cmd.none
                            )

                        Err jsonError ->
                            ( { model
                                | state =
                                    { local = Local.Error jsonError
                                    , global = model.state.global
                                    , exception = model.state.exception
                                    }
                              }
                            , Cmd.none
                            )

        Global fromGlobal ->
            ( { model
                | state =
                    { local = model.state.local
                    , global = model.state.global
                    , exception = Exception.Waiting
                    }
              }
            , sender <| Sender.encode0 <| Sender.Global fromGlobal
            )

        CloseExceptionModal ->
            ( { model
                | state =
                    { local = model.state.local
                    , global = model.state.global
                    , exception = Exception.Closed
                    }
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        hero =
            View.Hero.view model.state.exception model.state.global

        html =
            case model.state.local of
                Local.User user ->
                    hero <| View.User.View.view user

                Local.Error error ->
                    hero <| View.Error.Error.body error
    in
    { title = "solana-elm"
    , body =
        [ html
        ]
    }
