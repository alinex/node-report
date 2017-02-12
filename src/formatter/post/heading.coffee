# Headings
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
  title:
    type: 'heading'
    fn: (num, token) ->
      token.collect = token.collect.replace /\ $/, '' # remove last space
      unless token.collect.trim()
        token.out = "\n#{util.string.repeat '#', token.heading} "

  # Add title to document element from first heading
  empty:
    type: 'heading'
    fn: (num, token) ->
      return if token.collect.trim()
      # revert from setext to atx heading
      token.out = "\n#{util.string.repeat '#', token.heading} "
      [n, t] = @tokens.findEnd num, token
      t.out = "\n"
