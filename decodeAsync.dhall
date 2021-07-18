let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "examples/decodeAsync/**/*.purs" ],
  dependencies = conf.dependencies 
    # [ "affjax"
      , "arraybuffer"
      , "arrays"
      , "either"
      , "foldable-traversable"
      , "http-methods"
      , "parallel"
      ]
}
