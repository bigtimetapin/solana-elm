module View.User.View exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model.User.State exposing (State(..))
import Msg.Msg exposing (Msg(..))
import Msg.User.Msg as UserMsg


view : State -> Html Msg
view state =
    case state of
        Top ->
            Html.div
                []
                [ Html.button
                    [ class "is-button-1"
                    , onClick <|
                        FromUser <|
                            UserMsg.Increment
                    ]
                    [ Html.text
                        """increment
                        """
                    ]
                ]

        Fetched user ->
            Html.div
                []
                [ Html.div
                    []
                    [ Html.button
                        [ class "is-button-1"
                        , onClick <|
                            FromUser <|
                                UserMsg.Increment
                        ]
                        [ Html.text
                            """increment
                            """
                        ]
                    ]
                , Html.div
                    []
                    [ Html.text <|
                        String.concat
                            [ "increment"
                            , ":"
                            , " "
                            , String.fromInt user.increment
                            ]
                    ]
                ]
