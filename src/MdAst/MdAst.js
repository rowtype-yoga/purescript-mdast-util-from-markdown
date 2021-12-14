const cjs = require("mdast-util-from-markdown-facade")

exports.fromMarkdownImpl = (doc) => () => cjs.mdastUtilFromMarkdown.then((m) => m.fromMarkdown(doc))
