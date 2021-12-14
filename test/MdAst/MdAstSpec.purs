module Data.Lens.Barlow.BarlowSpec where

import Prelude

import MdAst.MdAst as MD
import Prelude (Unit, bind)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec =
  describe "MdAst" do
    describe "fromMarkdown" do
      it "should parse a markdown string" do
        actual <- MD.fromMarkdown "# Hello world\n ## Subparagraph"
        let
          expected = MD.Root
            { children:
                [ MD.Heading
                    { depth: 1
                    , children: [ MD.Text { value: "Hello world" } ]
                    }
                , MD.Heading
                    { depth: 2
                    , children: [ MD.Text { value: "Subparagraph" } ]
                    }
                ]
            }
        actual `shouldEqual` expected
