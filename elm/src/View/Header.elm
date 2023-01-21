module View.Header exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model.State.Global.Global exposing (Global(..))
import Model.State.Local.Local as Local
import Model.User.State as UserState
import Model.Wallet as Wallet
import Msg.Global as FromGlobal
import Msg.Msg as Msg exposing (Msg(..))
import Msg.User.Msg as UserMsg


view : Global -> Html Msg
view global =
    Html.nav
        [ class "level is-size-4"
        ]
        [ Html.div
            [ class "level-left mx-5 my-3"
            ]
            [ Html.div
                [ class "level-item"
                ]
                [ Html.h1
                    []
                    [ Html.a
                        [ Local.href <|
                            Local.User <|
                                UserState.Top
                        ]
                        [ Html.div
                            [ class "is-text-container-4"
                            ]
                            [ Html.text "Solana-Elm"
                            , Html.text "🔥"
                            ]
                        ]
                    ]
                ]
            ]
        , Html.div
            [ class "level-right mx-5 my-3"
            ]
            [ Html.div
                [ class "level-item"
                ]
                [ Html.span
                    [ class "icon-text"
                    ]
                    [ Html.span
                        []
                        [ connect global
                        ]
                    , Html.span
                        [ class "icon"
                        ]
                        [ Html.i
                            [ class "fas fa-user"
                            ]
                            []
                        ]
                    ]
                ]
            , Html.div
                [ class "level-item"
                ]
                [ viewGlobal global
                ]
            ]
        ]


connect : Global -> Html Msg
connect global =
    case global of
        NoWalletYet ->
            Html.button
                [ class "is-light-text-container-4"
                , onClick <| Msg.Global FromGlobal.Connect
                ]
                [ Html.text "Connect Wallet"
                ]

        WalletMissing ->
            Html.div
                []
                []

        _ ->
            Html.button
                [ class "is-light-text-container-4"
                , onClick <| Msg.Global FromGlobal.Disconnect
                ]
                [ Html.text "Disconnect Wallet"
                ]


viewGlobal : Global -> Html Msg
viewGlobal global =
    case global of
        NoWalletYet ->
            Html.div
                []
                []

        WalletMissing ->
            Html.div
                [ class "is-light-text-container-4"
                ]
                [ Html.text "no-wallet-installed"
                ]

        HasWallet wallet ->
            Html.div
                [ class "is-text-container-5 is-family-secondary"
                ]
                [ Html.text <|
                    Wallet.slice wallet
                ]

        HasUser user ->
            Html.div
                [ class "is-text-container-5 is-family-secondary"
                ]
                [ Html.div
                    []
                    [ Html.text <|
                        Wallet.slice user.wallet
                    ]
                , Html.div
                    [ class "is-light-text-container-4"
                    ]
                    [ Html.button
                        [ onClick <|
                            FromUser <|
                                UserMsg.ToFetched
                                    user
                        ]
                        [ Html.text <|
                            "view increment"
                        ]
                    ]
                ]
