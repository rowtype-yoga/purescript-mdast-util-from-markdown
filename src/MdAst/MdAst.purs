module MdAst.MdAst
  ( Markdown(..)
  , MarkdownNode(..)
  , fromMarkdown
  ) where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Argonaut (class DecodeJson, class EncodeJson, Json, JsonDecodeError(..), decodeJson, encodeJson, printJsonDecodeError, stringify, (.:), (.:?))
import Data.Either (Either(..), either)
import Data.Maybe (Maybe)
import Data.Traversable (for, sequence, traverse)
import Debug (spy)
import Effect (Effect)
import Effect.Aff (Aff, error, throwError)

foreign import fromMarkdownImpl :: String -> Effect (Promise Json)

fromMarkdown :: String -> Aff Markdown
fromMarkdown doc = fromMarkdownImpl doc # Promise.toAffE >>= tryDecode
  where
  tryDecode :: Json -> Aff Markdown
  tryDecode = decodeJson >>> either (printJsonDecodeError >>> error >>> throwError) pure

data Markdown = Root { children :: Array MarkdownNode }
data MarkdownNode
  = Heading { depth :: Int, children :: Array MarkdownNode }
  | Text { value :: String }
  | Html { value :: String }
  | InlineCode { value :: String }
  | Code { lang :: Maybe String, meta :: Maybe String, value :: String }
  | Link { title :: Maybe String, url :: String, children :: Array MarkdownNode }
  | Image { title :: Maybe String, url :: String, alt :: Maybe String }
  | Paragraph { children :: Array MarkdownNode }
  | List { ordered :: Maybe Boolean, start :: Maybe Int, spread :: Maybe Boolean, children :: Array MarkdownNode }
  | ListItem { spread :: Maybe Boolean, checked :: Maybe Boolean, children :: Array MarkdownNode }
  | Strong { children :: Array MarkdownNode }
  | Break
  | ThematicBreak
  | Emphasis { children :: Array MarkdownNode }
  | Blockquote { children :: Array MarkdownNode }
  | Definition { identifier :: String, label :: Maybe String, url :: String, title :: Maybe String }
  | LinkReference { identifier :: String, label :: Maybe String, referenceType :: String, children :: Array MarkdownNode }
  | ImageReference { identifier :: String, label :: Maybe String, referenceType :: String, alt :: Maybe String, children :: Array MarkdownNode }

instance DecodeJson Markdown where
  decodeJson json = do
    obj <- decodeJson json
    tpe <- obj .: "type"
    case tpe of
      "root" -> do
        childrenJson <- obj .: "children"
        children <- decodeJson childrenJson
        pure $ Root { children }
      other -> Left $ TypeMismatch $ "Got type " <> other

instance EncodeJson Markdown where
  encodeJson (Root { children }) = encodeJson { "type": "root", children: encodeJson children }

instance DecodeJson MarkdownNode where
  decodeJson json = do
    obj <- decodeJson json
    tpe <- obj .: "type"
    case tpe of
      "heading" -> decodeHeading obj
      "text" -> decodeText obj
      "html" -> decodeHtml obj
      "inlineCode" -> decodeInlineCode obj
      "code" -> decodeCode obj
      "link" -> decodeLink obj
      "image" -> decodeImage obj
      "paragraph" -> decodeParagraph obj
      "list" -> decodeList obj
      "listItem" -> decodeListItem obj
      "strong" -> decodeStrong obj
      "break" -> decodeBreak obj
      "thematicBreak" -> decodeThematicBreak obj
      "emphasis" -> decodeEmphasis obj
      "blockquote" -> decodeBlockquote obj
      "definition" -> decodeDefinition obj
      "linkReference" -> decodeLinkReference obj
      "imageReference" -> decodeImageReference obj
      other -> Left $ TypeMismatch $ "Unknown type '" <> other <> "'"

    where
    decodeHeading heading = do
      depth <- heading .: "depth"
      childrenJson <- heading .: "children"
      children <- decodeJson childrenJson
      pure $ Heading { depth, children }

    decodeText text = do
      value <- text .: "value"
      pure $ Text { value }

    decodeHtml html = do
      value <- html .: "value"
      pure $ Html { value }

    decodeInlineCode inlineCode = do
      value <- inlineCode .: "value"
      pure $ InlineCode { value }

    decodeCode code = do
      lang <- code .:? "lang"
      meta <- code .:? "meta"
      value <- code .: "value"
      pure $ Code { lang, meta, value }

    decodeLink link = do
      title <- link .:? "title"
      url <- link .: "url"
      childrenJson <- link .: "children"
      children <- decodeJson childrenJson
      pure $ Link { title, url, children }

    decodeImage image = do
      title <- image .:? "title"
      url <- image .: "url"
      alt <- image .:? "alt"
      pure $ Image { title, url, alt }

    decodeParagraph paragraph = do
      childrenJson <- paragraph .: "children"
      children <- decodeJson childrenJson
      pure $ Paragraph { children }

    decodeList list = do
      ordered <- list .:? "ordered"
      start <- list .:? "start"
      spread <- list .:? "spread"
      childrenJson <- list .: "children"
      children <- decodeJson childrenJson
      pure $ List { ordered, start, spread, children }

    decodeListItem listItem = do
      spread <- listItem .:? "spread"
      checked <- listItem .:? "checked"
      childrenJson <- listItem .: "children"
      children <- decodeJson childrenJson
      pure $ ListItem { spread, checked, children }

    decodeStrong strong = do
      childrenJson <- strong .: "children"
      children <- decodeJson childrenJson
      pure $ Strong { children }

    decodeEmphasis emphasis = do
      childrenJson <- emphasis .: "children"
      children <- decodeJson childrenJson
      pure $ Emphasis { children }

    decodeBlockquote blockquote = do
      childrenJson <- blockquote .: "children"
      children <- decodeJson childrenJson
      pure $ Blockquote { children }

    decodeDefinition definition = do
      identifier <- definition .: "identifier"
      label <- definition .:? "label"
      url <- definition .: "url"
      title <- definition .:? "title"
      pure $ Definition { identifier, label, url, title }

    decodeLinkReference linkReference = do
      identifier <- linkReference .: "identifier"
      label <- linkReference .:? "label"
      referenceType <- linkReference .: "referenceType"
      childrenJson <- linkReference .: "children"
      children <- decodeJson childrenJson
      pure $ LinkReference { identifier, label, referenceType, children }

    decodeImageReference imageReference = do
      identifier <- imageReference .: "identifier"
      label <- imageReference .:? "label"
      referenceType <- imageReference .: "referenceType"
      alt <- imageReference .:? "alt"
      childrenJson <- imageReference .: "children"
      children <- decodeJson childrenJson
      pure $ ImageReference { identifier, label, referenceType, alt, children }

    decodeBreak _ = pure Break

    decodeThematicBreak _ = pure ThematicBreak

instance EncodeJson MarkdownNode where
  encodeJson (Heading { depth, children }) = encodeJson { "type": "heading", depth, children: encodeJson children }
  encodeJson (Text { value }) = encodeJson { "type": "text", value }
  encodeJson (Html { value }) = encodeJson { "type": "html", value }
  encodeJson (InlineCode { value }) = encodeJson { "type": "inlineCode", value }
  encodeJson (Code { lang, meta, value }) = encodeJson { "type": "code", lang, meta, value }
  encodeJson (Link { title, url, children }) = encodeJson { "type": "link", title, url, children: encodeJson children }
  encodeJson (Image { title, url, alt }) = encodeJson { "type": "image", title, url, alt }
  encodeJson (Paragraph { children }) = encodeJson { "type": "paragraph", children: encodeJson children }
  encodeJson (List { ordered, start, spread, children }) = encodeJson { "type": "list", ordered, start, spread, children: encodeJson children }
  encodeJson (ListItem { spread, checked, children }) = encodeJson { "type": "listItem", spread, checked, children: encodeJson children }
  encodeJson (Strong { children }) = encodeJson { "type": "strong", children: encodeJson children }
  encodeJson (Break) = encodeJson { "type": "break" }
  encodeJson (ThematicBreak) = encodeJson { "type": "thematicBreak" }
  encodeJson (Emphasis { children }) = encodeJson { "type": "emphasis", children: encodeJson children }
  encodeJson (Blockquote { children }) = encodeJson { "type": "blockquote", children: encodeJson children }
  encodeJson (Definition { identifier, label, url, title }) = encodeJson { "type": "definition", identifier, label, url, title }
  encodeJson (LinkReference { identifier, label, referenceType, children }) = encodeJson { "type": "linkReference", identifier, label, referenceType, children: encodeJson children }
  encodeJson (ImageReference { identifier, label, referenceType, alt, children }) = encodeJson { "type": "linkReference", identifier, label, referenceType, alt, children: encodeJson children }

instance Show Markdown where
  show = encodeJson >>> stringify

instance Eq Markdown where
  eq left right = eq (encodeJson left) (encodeJson right)
