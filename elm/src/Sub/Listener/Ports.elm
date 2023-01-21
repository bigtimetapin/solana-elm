port module Sub.Listener.Ports exposing (exception, success)


port success : (Json -> msg) -> Sub msg


port exception : (String -> msg) -> Sub msg


type alias Json =
    String
