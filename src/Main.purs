module Main where

import Prelude

import Debug (spy)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log)
import MdAst.MdAst as MD

main = launchAff_ do
  md <- MD.fromMarkdown "# Hello world\n ## Subparagraph"
  let
    _ = spy "md" $ md
  log ""
