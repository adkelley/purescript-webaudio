let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "test/props/**/*.purs" ],
  dependencies = conf.dependencies # [ "assert" ]
}
