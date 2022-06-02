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
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT-0"
, repository =
    "https://github.com/sigma-andex/purescript-mdast-util-from-markdown.git"
}
