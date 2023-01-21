module Msg.Msg exposing (Msg(..), resetViewport)

import Browser
import Browser.Dom as Dom
import Msg.Global as FromGlobal
import Msg.Js exposing (FromJs)
import Msg.User.Msg as User
import Task
import Url


type
    Msg
    -- system
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
      -- global
    | Global FromGlobal.Global
      -- user
    | FromUser User.Msg
      -- exception
    | CloseExceptionModal
      -- js ports
    | FromJs FromJs


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)
