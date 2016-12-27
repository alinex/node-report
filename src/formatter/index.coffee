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
config = require 'alinex-config'


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
#preLibs = libs 'pre'
#if debugRule.enabled
#  debugRule "possible pre optimizations:", util.inspect(Object.keys preLibs).replace /\n\s*/g, ' '
transLibs = libs 'transform'
# group by format
grouped = {}
for key, lib of transLibs
  for name, rule of lib
    rule.name = "#{key}:#{name}"
    grouped[rule.format] ?= []
    grouped[rule.format].push rule
transLibs = grouped
if debugRule.enabled
  for type, rules of transLibs
    debugRule "possible #{type} transformers:", util.inspect(rules.map (e) -> e.name).replace /\n +/g, ' '

#postLibs = libs 'post'
#if debugRule.enabled
#  debugRule "possible post optimizations:", util.inspect(Object.keys postLibs).replace /\n\s*/g, ' '
#convertLibs = libs 'post'
#if debugRule.enabled
#  debugRule "possible converters:", util.inspect(Object.keys convertLibs).replace /\n\s*/g, ' '

# Formatter Class
# -------------------------------------------------
class Formatter

  # Create a new parser object.
  #
  # @param {Parser} parser object to format
  # @param {Object} setup for the format
  constructor: (@parser, @setup) ->
    @tokens = null
    @output = ''

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

  # Process the parser content and generate format.
  #
  process: (cb) ->
    @parser.end()
    debug "create output as #{@setup.format}" if debug
    debugData "setup:", @setup if debugData
    @tokens = util.clone @parser.tokens
    # run transformation
    for token, num in @tokens
      for rule in transLibs[@setup.format]
        continue if rule.type and token.type isnt rule.type
        continue if rule.state and not token.state in rule.state
        continue if rule.nesting and token.nesting isnt rule.nesting
        continue if rule.data and not token.data
        continue if rule.data?.text and not token.data?.text
        debugRule "call trans #{rule.name} for token ##{num}" if debugRule
        rule.fn.call this, num, token
    # collect output
    for token, num in @tokens
      @output += token.out if token.out
    cb()



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
