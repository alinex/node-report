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
#    console.log '>>>>', util.inspect(t).replace /\s*\n\s*/g, ' '
    unless t.type is 'inline'
      # add token itself
      token =
        type: t.type.replace /_(open|close)$/, ''
        nesting: t.nesting ? 0
      token.content = t.content if t.content
      token.heading = Number t.tag[1] if token.type is 'heading'
      # insert token to list
      list.push token
    # add children
    list = list.concat tree2tokens t.children if t.children
  list
