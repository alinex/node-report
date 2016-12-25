# Formatter
# =================================================


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report:formatter'
debugData = require('debug') 'report:formatter:data'
debugRule = require('debug') 'report:formatter:rule'
chalk = require 'chalk'
fs = require 'fs'
path = require 'path'
# alinex modules
util = require 'alinex-util'


# Setup
# -------------------------------------------------
debug "Initializing..."

# @param {String} type to load
# @return {Object<Module>} the loaded modules
libs = (type) ->
  list = fs.readdirSync "#{__dirname}/#{type}"
  list.sort()
  map = {}
  for file in list
    continue unless path.extname(file) in ['.js', '.coffee']
    name = path.basename(file, path.extname file).replace /^\d+_/, ''
    map[name] = require "./#{type}/#{file}"
  map

# Load helper
preLibs = libs 'pre'
if debugRule.enabled
  debugRule "possible pre optimizations:", util.inspect(Object.keys preLibs).replace /\n\s*/g, ' '
transLibs = libs 'transform'
if debugRule.enabled
  debugRule "possible transformer:", util.inspect(Object.keys transLibs).replace /\n\s*/g, ' '
postLibs = libs 'post'
if debugRule.enabled
  debugRule "possible post optimizations:", util.inspect(Object.keys postLibs).replace /\n\s*/g, ' '
convertLibs = libs 'post'
if debugRule.enabled
  debugRule "possible converters:", util.inspect(Object.keys convertLibs).replace /\n\s*/g, ' '


# Formatter Class
# -------------------------------------------------
class Formatter

  # Create a new parser object.
  #
  # @param {Report} report to format
  # @param {Object} setup for the format
  constructor: (report, setup) ->
    @tokens = util.clone report.tokens
    @type = setup.format ? 'markdown'

  # Get the defined number of token.
  #
  # @return {Token} at the given position
  get: (num = @token) ->
    if num >= 0 then @tokens[num]
    else @tokens[@tokens.length + num]

  remove: (num) ->

  # Insert token at defined position
  #
  # @param {Integer} [num] position in tokenlist to add new token
  # @param {Token} t new token to be added
  insert: (num, t) ->
    num = @token + 1 unless num
    @level-- if t.nesting < 0
    # auto add token info
    prev = @get num - 1
    t.nesting ?= 0
    if prev
      t.level ?= prev.level + prev.nesting + (if t.nesting is -1 then -1 else 0)
      t.index ?= @index
      t.state ?= prev.state
      t.state = prev.state.split(/-/)[0] + t.state if t.state?[0] is '-'
    else
      t.level ?= @level
      t.index ?= @index
      t.state ?= @state
      t.state = @state.split(/-/)[0] + t.state if t.state?[0] is '-'
    t.parent = switch
      when t.nesting is -1
        if prev.level > t.level then prev.parent?.parent
        else prev.parent
      when prev?.nesting is 1 then prev
      else prev?.parent ? null
    # add token to list
    if debugData.enabled
      debugData "token insert ##{num}/#{@tokens.length} #{chalk.grey util.inspect(t).replace /\s*\n\s*/g, ' '}"
    @tokens.splice num, 0, t
    # set lexer for next round
    @state = if t.nesting is 1 then t.state else t.parent?.state ? @initialState
    @level++ if t.nesting > 0
    @token++

  change: (num = @token) ->
    return unless debugData.enabled
    num = @tokens.length + num if num < 0
    t = @get num
    debugData "token change ##{num}/#{@tokens.length} #{chalk.grey util.inspect(t).replace /\s*\n\s*/g, ' '}"

  # Parse a text into `Token` list or add them to the exisitng one if called
  # again.
  #
  # @param {String} text to be parsed (defaults to @input)
  # @return {Formatter} for command concatenation
  format: (cb) ->




  # Get the current position in file.
  #
  # @param {Integer} index position in source text
  # @return {String} line and column position
  pos: (index = @index) ->
    part = @input.substr 0, index
    line = part.match(/\n/g)?.length ? 0
    col = index - part.lastIndexOf('\n') - 1
    "#{line}:#{col}"

  # End the parsing and check the result.
  #
  # @return {Array<Token>} list of parsed tokens
  end: ->
    # check if parsing started
    throw new Error "Nothing parsed" unless @tokens.length
    # check for correct structure
    if @level
      unless @autoclose @states[0]
        throw new Error "Not all elements closed correctly (ending in level #{@level})"
    debug "Done parsing" if debug.enabled
    # return token list
    @tokens



# Make class available from the outside
module.exports = Formatter
