let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "examples/decode/**/*.purs" ],
  dependencies = conf.dependencies # [ "web-html" ]                
}
