# List Item
# =================================================


# Node Modules
# ----------------------------------------------------
util = require 'alinex-util'


# Implementation
# ----------------------------------------------------

# Post rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  # Add title to document element from first heading
  text:
    type: 'item'
    format: ['md', 'text', 'roff']
    nesting: 1
    fn: (num, token) ->
      indent = util.string.repeat ' ', token.out.length
      token.collect = token.collect
      .replace /^\n/, ''  # remove first newline
      .replace /\n/g, "\n#{indent}" # indent text
      .replace /\ +$/, '' # but remove indent of last return
      token.collect = '\n' unless token.collect?.length
  # Add title to document element from first heading
  html:
    type: 'item'
    format: 'html'
    nesting: 1
    fn: (num, token) ->
      token.collect = token.collect.trim()
