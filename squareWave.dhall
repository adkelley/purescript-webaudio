let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "examples/square-wav/**/*.purs" ],
  dependencies = conf.dependencies # [ "web-html" ]
}
