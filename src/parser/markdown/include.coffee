# markdown-it plugin to include other markdown
# =================================================


fs = require 'fs'


INCLUDE_RE = /([>\t\ ]*)@\[([\w_]*)\]\(([^\n]+?)\)/g

# Markdown-it extension
# ---------------------------------------

# Morph tokens in core chain.
#
# @param {MarkdownIt} md object to add parser rule
module.exports = (md) ->
  md.core.ruler.before 'normalize', 'include', parser

parser = (state) ->
  state.src = replace state.src

replace = (src, processed = []) ->
  src.replace INCLUDE_RE, (m, space, param, source) ->
    throw new Error "Circular reference in include of #{source}!" if source in processed
    content = fs.readFileSync source, 'utf8'
    content = space + content.trim().replace /\n/g, "\n#{space}"
    replace content, processed.concat [source]
