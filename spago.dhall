{ name = "mdast-util-from-markdown"
, dependencies =
  [ "argonaut"
  , "effect"
  , "either"
  , "exceptions"
  , "maybe"
  , "prelude"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT-0"
, repository =
    "https://github.com/sigma-andex/purescript-mdast-util-from-markdown.git"
}
