port module Sub.Sender.Ports exposing (sender)


port sender : Json -> Cmd msg


type alias Json =
    String
