let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "examples/gain/**/*.purs" ],
  dependencies = conf.dependencies # [ "console", "exceptions", "web-dom", "web-html" ]
}
