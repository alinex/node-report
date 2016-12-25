# Report generation
# =================================================
# This package will give you an easy and robust way to access mysql databases.


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report'
chalk = require 'chalk'
deasync = require 'deasync'
# include more alinex modules
util = require 'alinex-util'
config = require 'alinex-config'
# modules
Parser = require './parser/index'
Formatter = require './formatter/index'


# Setup
# -------------------------------------------------


# API
# -------------------------------------------------
class Report

  # Report instance
  #
  constructor: ->
    @input = ''
    @tokens = []

  # Get the defined number of token.
  #
  # @return {Token} at the given position
  _get: (num = -1) ->
    if num >= 0 then @tokens[num]
    else @tokens[@tokens.length + num]

  _add: (t) ->
    t.nesting ?= 0
    unless t.level
      last = @_get()
      t.level = switch
        when not last?.level then 0
        when last.nesting > 0 then last.level + 1
        else last.level + t.nesting
    @tokens.push t

  # Add markdown to report.
  #
  # @param {String} text to be parsed
  # @return {Report} instance itself for command concatenation
  markdown: (text) ->
    last = @_get()
    parser = new Parser text, last?.state
    parser.parse()
    for token in parser.tokens
      if last
        token.index += parser.input.length
        token.level += last.level
      delete token.parent
      delete token.closed
      @tokens.push token
    @input += parser.input
    this

  # Add heading level 1.
  #
  # @param {String|Boolean} text with content of heading or true to open tag and
  # false to close tag if content is added manually.
  # @return {Report} instance itself for command concatenation
  h1: (text) ->
    if typeof text is 'boolean'
      @_add
        type: 'heading'
        data:
          level: 1
        nesting: if text then 1 else -1
      return this
    # add text
    @_add
      type: 'heading'
      data:
        level: 1
      nesting: 1
    @_add
      type: 'text'
      data:
        text: text
    @_add
      type: 'heading'
      data:
        level: 1
      nesting: -1


  format: (setup, cb) ->
    formatter = new Formatter this, setup
    formatter.format cb



module.exports = Report
