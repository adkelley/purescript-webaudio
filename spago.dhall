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
    , "effect"
    , "maybe"
    , "prelude"
    , "psci-support"
    , "web-events"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs" ]
}
