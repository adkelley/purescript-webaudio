let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "examples/square-wave/**/*.purs" ],
  dependencies = conf.dependencies 
    # [ "exceptions"
      , "js-timers"
      , "newtype"
      , "refs"
      , "unsafe-coerce"
      , "web-dom"
      , "web-html" 
      ]
}
