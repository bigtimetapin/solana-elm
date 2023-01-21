module Model.State.Local.Local exposing (..)

import Html
import Html.Attributes
import Model.User.State as User
import Url
import Url.Parser as UrlParser exposing ((</>))


type Local
    = Error String
    | User User.State


urlParser : UrlParser.Parser (Local -> c) c
urlParser =
    UrlParser.oneOf
        [ -- user
          UrlParser.map
            (User <| User.Top)
            (UrlParser.s "user")
        ]


parse : Url.Url -> Local
parse url =
    let
        target =
            -- The RealWorld spec treats the fragment like a path.
            -- This makes it *literally* the path, so we can proceed
            -- with parsing as if it had been a normal path all along.
            { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    in
    case UrlParser.parse urlParser target of
        Just state ->
            state

        Nothing ->
            Error "404; Invalid Path"


path : Local -> String
path local =
    case local of
        User User.Top ->
            "#/user"

        _ ->
            -- routes to error
            "#/invalid"


href : Local -> Html.Attribute msg
href local =
    Html.Attributes.href (path local)
