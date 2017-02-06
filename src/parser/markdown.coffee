# Markdown Parser
# =================================================
# This module is using the [markdownIt](http://markdown-it.github.io) parser which
# is base on [CommonMark Specification](http://spec.commonmark.org).


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report:parse:markdown'
chalk = require 'chalk'
markdownIt = null # load on demand
# include more alinex modules
util = require 'alinex-util'


# Public
# -------------------------------------------------

# Add markdown to report.
#
# @param {String} text to be parsed
# @return {Report} instance itself for command concatenation
module.exports = (text) ->
  debug "parse and add: #{chalk.bold.yellow util.inspect text}"
  # init markdown-it
  unless markdownIt
    markdownIt = require('markdown-it')
      html: true
      linkify: true
      typographer: true
  # parse and convert tokens
  tree = markdownIt.parse text
  @tokens.insert tree2tokens tree
  this


# Specify changes for the markdown-it tokens to be done before inserting.
# This will match the name including ..._open or also without it.
modify =

  heading: (t) -> t.heading = Number t.tag[1]
  hr: (t) -> t.type = 'thematic_break'
  em: (t) -> t.type = 'emphasis'
  
  code_block: (t) ->
    list = []
    # add token itself
    content = t.content
    delete t.content
    t.type = 'preformatted'
    t.nesting = 1
    list.push node2token t
    list.push
      type: 'text'
      content: content
    t.nesting = -1
    list.push node2token t
    # return all tokens
    list


# Internal Helper
# -------------------------------------------------

# Convert markdown-it structure to report tokens.
#
# @param {Array<Object>} tree to be converted
# @param {Integer} level current parsing level
# @return {Array<Token>} list of report tokens
tree2tokens = (tree) ->
  list = []
  for t in tree
    debug 'FOUND', chalk.grey util.inspect(t).replace /\s*\n\s*/g, ' ' if debug
    unless t.type is 'inline'
      # modify tokens
      res = modify[t.type] t if modify[t.type]
      if Array.isArray(res) and res[0].type
        # already transformed
        list = list.concat res
        continue
      # default
      t.type = t.type.replace /_(open|close)$/, ''
      res = modify[t.type] t if modify[t.type]
      if Array.isArray(res) and res[0].type
        # already transformed
        list = list.concat res
        continue
      # run default conversion of single token and add to list
      list.push node2token t
    # add children
    list = list.concat tree2tokens t.children if t.children
  list

node2token = (t) ->
  # run default conversion of single token
  token =
    type: t.type
    nesting: t.nesting ? 0
  # copy specific values
  for e in ['content', 'heading']
    token[e] = t[e] if t[e]
  token
