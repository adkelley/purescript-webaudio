let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "examples/decode/**/*.purs" ],
  dependencies = conf.dependencies 
    # [ "console"
      , "exceptions"
      , "functions"
      , "newtype"
      , "partial"
      , "unsafe-coerce"
      , "web-dom"
      , "web-html" 
      ]                
}
