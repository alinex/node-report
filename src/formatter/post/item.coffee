# List Item
# =================================================


# Node Modules
# ----------------------------------------------------
util = require 'alinex-util'
chalk = require 'chalk'


# Implementation
# ----------------------------------------------------

# Post rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  textLoose:
    type: 'item'
    format: ['md', 'text', 'roff']
    fn: (num, token) ->
      paragraphs = @tokens.contains 'paragraph', num, token
      # check if list is tight or loose
      hidden = true
      for n, p of paragraphs
        hidden = false unless p.hidden
      # add newline to only paragraph to make it loose and recalculate collect
      if Object.keys(paragraphs).length is 1 and not hidden
        para = paragraphs[Object.keys(paragraphs)[0]]
        para.collect += "\n"
        @tokens.collect num, token

  # Add title to document element from first heading
  text:
    type: 'item'
    format: ['md', 'text', 'roff']
    fn: (num, token) ->
      indent = util.string.repeat ' ', token.out.length
      add = ''
      if token.task?
        chalk = new chalk.constructor {enabled: Boolean @setup.ansi_escape}
        add = chalk.bold if @setup.ascii_art
          if token.task then '☒ ' else '☐ '
        else
          if token.task then '[X] ' else '[ ] '
      token.collect = add + token.collect
      .replace /^\n/, ''  # remove first newline
      .replace /\n/g, "\n#{indent}" # indent text
      .replace /\ +(\n|$)/g, '$1' # but remove indent of last return
      token.collect = '\n' unless token.collect?.length

  # Add title to document element from first heading
  html:
    type: 'item'
    format: 'html'
    fn: (num, token) ->
      token.collect = token.collect.trim()
