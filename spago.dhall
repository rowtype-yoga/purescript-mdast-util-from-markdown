{ name = "mdast-util-from-markdown"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "argonaut"
  , "console"
  , "debug"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "spec"
  , "spec-discovery"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, license = "MIT-0"
, repository = "https://github.com/sigma-andex/purescript-mdast.git"
}
