
import { fromMarkdown } from 'mdast-util-from-markdown'
import { toMarkdown } from 'mdast-util-to-markdown'

export const fromMarkdownImpl = (doc) => () => fromMarkdown(doc)

export const toMarkdownImpl = (ast) => () => toMarkdown(ast)
