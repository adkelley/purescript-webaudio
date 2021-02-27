{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "purescript-webaudio"
, dependencies =
    [ "aff"
    , "arraybuffer"
    , "arraybuffer-types"
    , "arrays"
    , "effect"
    , "foldable-traversable"
    , "lists"
    , "math"
    , "maybe"
    , "strings"
    , "tuples"
    , "web-events"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs" ]
}
