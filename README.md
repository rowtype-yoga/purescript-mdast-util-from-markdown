# purescript-mdast

Purescript wrapper for [mdast-util-from-markdown](https://github.com/syntax-tree/mdast-util-from-markdown). `mdast-util-from-markdown` allows you to parse markdown into a markdown abstract syntaxt tree.

## Usage 

Due to mdast being esm only, you will have to install the [`mdast-util-from-markdown-face`](./mdast-util-from-markdown-facade/) node module from this repo.

```bash
# clone this repo
git clone https://github.com/sigma-andex/purescript-mdast-util-from-markdown.git
```

Add the repo to your `packages.dhall`

```dhall
let upstream = ...
    with mdast-util-from-markdown = ../purescript-mdast-util-from-markdown/spago.dhall as Location // You might need to adapt this path

```

Install `mdast-util-from-markdown` with spago:
```bash
spago install mdast-util-from-markdown
```

Add the `mdast-util-from-markdown-facade` to your `package.json`

```json
"mdast-util-from-markdown-facade": "file:../purescript-mdast-util-from-markdown/mdast-util-from-markdown-facade",
```

