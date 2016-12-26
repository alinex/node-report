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


# Report Class
# -------------------------------------------------
class Report

  # Report instance
  #
  constructor: ->
    @parser = new Parser()
    @formatter = {}

  # Parsing
  # -------------------------------------------------

  # Add markdown to report.
  #
  # @param {String} text to be parsed
  # @return {Report} instance itself for command concatenation
  markdown: (text) ->
    @parser.parse text
    this

  # Formatting / Output
  # -------------------------------------------------

  format: (setup, cb) ->
    name = setup.format ?= 'md'
    @formatter[name] = new Formatter @parser, setup
    @formatter[name].process (err) ->
      return cb err if err
      cb null, name

  output: (name) ->
    @formatter[name].output

  # API Creation
  # -------------------------------------------------

  # Add heading level 1.
  #
  # @param {String|Boolean} text with content of heading or true to open tag and
  # false to close tag if content is added manually.
  # @return {Report} instance itself for command concatenation
  h1: (text) ->
    if typeof text is 'boolean'
      @parser.insert null,
        type: 'heading'
        data:
          level: 1
        nesting: if text then 1 else -1
      return this
    # add text
    @parser.insert null,
      type: 'heading'
      data:
        level: 1
      nesting: 1
    @parser.insert null,
      type: 'text'
      data:
        text: text
    @parser.insert null,
      type: 'heading'
      data:
        level: 1
      nesting: -1



module.exports = Report
