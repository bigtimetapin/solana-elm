module Model.Sol exposing (Sol, fromLamports, toLamports)


type alias Sol =
    Float


type alias Lamports =
    Int


fromLamports : Lamports -> Sol
fromLamports lamports =
    toFloat lamports / lamportsPerSol


toLamports : Sol -> Lamports
toLamports sol =
    floor <| sol * lamportsPerSol



{- 1 billion -}


lamportsPerSol : Float
lamportsPerSol =
    1000000000.0
