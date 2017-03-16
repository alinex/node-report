# markdown-it plugin to parse tasks
# =================================================
# It interprets tasks in the form of github flavoured markdown:
# https://github.com/blog/1375-task-lists-in-gfm-issues-pulls-comments
# https://github.com/blog/1825-task-lists-in-all-markdown-documents


# Helper Methods
# ---------------------------------------

# @param {Object} token of paragraph_open
# @param {String} name attribute to be set
# @param {String} value for attribute
attrSet = (token, name, value) ->
  index = token.attrIndex name
  attr = [name, value]
  if index < 0 then token.attrPush attr
  else token.attrs[index] = attr


# Markdown-it extension
# ---------------------------------------

# Morph tokens in core chain.
#
# @param {MarkdownIt} md object to add parser rule
module.exports = (md) ->
  md.core.ruler.after 'inline', 'github-task-lists', parser


parser = (state) ->
  tokens = state.tokens
  i = 1
  while ++i < tokens.length
    if tokens[i].type is 'inline' and
    tokens[i - 1].type is 'paragraph_open' and
    tokens[i - 2].type is 'list_item_open' and
    tokens[i].content.match /^\[[\ xX]\] /
      attrSet tokens[i - 2], 'task', Boolean tokens[i].content.match /^\[[xX]\] /
      tokens[i].children[0].content = tokens[i].children[0].content.slice 4
