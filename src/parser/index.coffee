# Parser
# =================================================
# This may parse multiple text formats into token lists. This is done using the
# plugable structure with the concrete commands within.
#
# The parsing is done in three steps:
# 1. pre optimize some problematic characters in source for the defined domain
# 2. transform text into token list
# 3. post format the transformer list
#
# The parser may sometimes only parse the big structure and will run a recursive
# call to the lexer in the post run.

# ### Status Variables
#
# The parser is influenced by the following status information:
# - `token` - `Integer` current position in `@tokens` list
# - `level` - `Integer` current depth in structure

# ### Lexer
#
# The lexer itself runs through the character string and tries to create tokens
# out of it. It is influenced by the current parser settings (above).

# ### Resulting Tokens
#
# The resulting token list may contain any of the defined elements. And are stored
# in an array as object:
# - `String` - `type` name of the element
# - `Integer` - `nesting` type: `1` = open, `0` = atomic, `-1` = close
# - `Integer` - `level` depth of structure
# - `Object` - `parent` reference
# - `Object` - `data` content of this element
# - `String` - `state` that is allowed within the current element
# - `Boolean` - `closed` is set to true on blank line to stop continuing it
# - `String` - `content` content of element not parsed, yet


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report:parser'
debugData = require('debug') 'report:parser:data'
debugRule = require('debug') 'report:parser:rule'
chalk = require 'chalk'
fs = require 'fs'
path = require 'path'
# alinex modules
util = require 'alinex-util'


# Rules
# -------------------------------------------------
# They will be filled up on `init()` call.
preLibs = null
transLibs = null
postLibs = null
lexer = {}

# @type {Object<String>} start state for domain
START =
  m: 'm-doc'
  h: 'h-doc'


# Parser Class
# -------------------------------------------------
class Parser

  # Setup
  # -------------------------------------------------

  # Initialize Parser and load the lexer rules.
  #
  @init: ->
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
      debugRule "possible pre optimizations:", util.inspect(Object.keys preLibs
      ).replace /\n\s*/g, ' '
    transLibs = libs 'transform'
    if debugRule.enabled
      debugRule "possible transformer:", util.inspect(Object.keys transLibs).replace /\n\s*/g, ' '
    postLibs = libs 'post'
    for _, sub of postLibs
      for _, rule of sub
        rule.type = [rule.type] unless Array.isArray rule.type
    if debugRule.enabled
      debugRule "possible post optimizations:", util.inspect(Object.keys postLibs
      ).replace /\n\s*/g, ' '
    # collect possible states
    states = []
    for key, lib of transLibs
      for name, rule of lib
        for state in rule.state
          states.push state unless state in states
    debugRule "possible states:", util.inspect(states).replace /\n +/g, ' ' if debugRule.enabled
    # collect rules for each state
    for key, lib of transLibs
      for name, rule of lib
        rule.name = "#{key}:#{name}"
        for state in rule.state
          lexer[state] ?= []
          lexer[state].push rule
    if debugRule.enabled
      for k, v of lexer
        for e in v
          debugRule "lexer rule for #{k}:", e.name, chalk.grey e.re

  # Auto detect state for text.
  #
  # @param {String} [text] to auto detect start state (defaults to @input)
  # @return {String} start state or `m` if not possible
  @detect: (text) ->
    return 'm' unless text
    if text.match /<body/ then 'h-doc' else 'm-doc'

  # Create a new parser object.
  #
  # @param {String} input text to be parsed
  # @param {String} [state] or domain used initially for the lexer
  constructor: (@input = '', @state) ->
    @state ?= Parser.detect @input
    @state = START[@state] if START[@state]
    @initialState = @state
    @domain = @state.split(/-/)[0]
    # result collection
    @tokens = []
    # initial parsing data
    @token = -1
    @level = 0

  # Get the defined number of token.
  #
  # @return {Token} at the given position
  get: (num = @token) ->
    if num >= 0 then @tokens[num]
    else @tokens[@tokens.length + num]

  # Insert token at defined position
  #
  # @param {Integer} [num] position in tokenlist to add new token
  # @param {Token} t new token to be added
  # @return {Parser} instance itself for command concatenation
  insert: (num, t) ->
    num = @token + 1 unless num
    @level-- if t.nesting < 0
    # auto add token info
    prev = @get num - 1
    t.nesting ?= 0
    if prev
      t.level ?= prev.level + (if prev.nesting is 1 then 1 else 0) \
      + (if t.nesting is -1 then -1 else 0)
      t.state ?= if prev.nesting is 1 then prev.state else prev.parent.state
      t.state = prev.state.split(/-/)[0] + t.state if t.state?[0] is '-'
    else
      t.level ?= @level
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
      ts = chalk.yellow.bold util.inspect(t, {depth: 1})
      .replace /,\s+parent:\s+\{\s+type:\s+'(.*?)'[\s\S]*?\}/g, ", parent: <$1>"
      .replace /\s*\n\s*/g, ' '
      debugData "token insert ##{num}/#{@tokens.length} #{ts}"
    @tokens.splice num, 0, t
    # set lexer for next round
    @state = if t.nesting is 1 then t.state else t.parent?.state ? @initialState
    @level++ if t.nesting > 0
    @token++
    this

  # Remove element from tokens list.
  #
  # @param {Integer} num the token number to be removed
  remove: (num = @token) ->
    if debugData.enabled
      t = @get num
      ts = chalk.yellow.bold util.inspect(t, {depth: 1})
      .replace /,\s+parent:\s+\{\s+type:\s+'(.*?)'[\s\S]*?\}/g, ", parent: <$1>"
      .replace /\s*\n\s*/g, ' '
      debugData "token delete ##{num}/#{@tokens.length} #{ts}"
    @tokens.splice num, 1

  # Log changes of token to debug.
  #
  # @param {Integer} num the token id in list
  change: (num = @token) ->
    return unless debugData.enabled
    num = @tokens.length + num if num < 0
    t = @get num
    ts = chalk.yellow util.inspect(t, {depth: 1})
    .replace /,\s+parent:\s+\{\s+type:\s+'(.*?)'[\s\S]*?\}/g, ", parent: <$1>"
    .replace /\s*\n\s*/g, ' '
    debugData "token change ##{num}/#{@tokens.length-1} #{ts}"

  # Parse a text into `Token` list or add them to the exisitng one if called
  # again.
  #
  # @param {String} text to be parsed (defaults to @input)
  # @return {Parser} for command concatenation
  parse: (text) ->
    if text then @input += text else text = @input
    debug "pre optimizations for domain #{@domain}" if debug.enabled
    for name, rule of preLibs
      continue unless rule[@domain]
      old = text if debugRule
      text = rule[@domain] text
      debugRule "changed by pre #{name}" if debugRule and old isnt text
    debug "start transformation in state #{@state}" if debug.enabled
    start = @tokens.length
    @lexer text
    end = @tokens.length - 1
    if start <= end
      debug "post optimization"
      for name, lib of postLibs
        for sub, post of lib
          num = -1
          while ++num < @tokens.length
            token = @get num
            continue if post.type and token.type not in post.type
            continue if post.state and not token.state in post.state
            continue if post.nesting and token.nesting isnt post.nesting
            continue if post.data and not token.data
            continue if post.data?.text and not token.data?.text
            continue if post.content and not token.content
            debugRule "call post #{name}:#{sub} for token ##{num}" if debugRule
            post.fn.call this, num, token
    this

  # Run parsing a chunk of the input.
  #
  # @param {String} [chars] the part to be parsed now (may be called from lexer function recursivly)
  lexer: (chars) ->
    while chars.length
      if debugData.enabled
        ds = util.inspect chars.substr 0, 60
        debugData "parse #{chalk.grey ds} in state #{@state}"
      done = false
      # try rules for state
      throw new Error "No rules for state #{@state}" unless lexer[@state]
      for rule in lexer[@state]
        continue unless @state in rule.state
        debugRule "check rule #{rule.name}: #{chalk.grey rule.re}" if debugRule
        if m = rule.re.exec chars
          if skip = rule.fn?.call this, m
            chars = chars.substr skip
            done = true
            break
      # check for problems
      unless done
        throw new Error "Not parseable maybe missing a rule at '#{util.inspect chars.substr 0, 30}'"
    this

  # Check if tags could be autoclosed to come into defined state.
  #
  # @param {String|Integer} [goal] state or level to reach by autoclosing (null for all)
  # @param {Boolean} [errThrow] set to true to throw error if autoclose is impossible
  # @return {Boolean} `true` if state could be reached by autoclose
  autoclose: (goal, errThrow) ->
    if typeof goal is 'number'
      t =
        level: 99
        parent: @get()
      while t = t.parent
        break if t.level <= goal
        continue if t.nesting isnt 1
        t = util.clone t
        t.nesting = -1
        delete t.state
        @level = t.level
        @state = t.parent?.state ? t.state
        if debugData.enabled
          debugData "auto close to come to level #{goal}"
        @insert null, t
      return
    if errThrow
      unless @autoclose goal
        last = @get @token
        el = if last.nesting is 1 then last else last.parent
        throw new Error "Could not place heading into #{el}"
      return true
    goal = @state.split(/-/)[0] + goal if goal?[0] is '-'
    token = @get -1
    list = []
    token = {parent: token} if token.nesting is 1
    while token = token.parent
      unless token
        return false if goal
        break
      break if token.state is goal
      list.push token
    # close tags
    for token in list
      t = util.clone token
      t.nesting = -1
      delete t.state
      @level = t.level
      @state = t.parent?.state ? t.state
      if debugData.enabled
        debugData "auto close to come to #{goal ? 'initial'} state"
      @insert null, t
    true

  # Start new document if not done.
  #
  begin: ->
    return if @tokens.length
    @insert null,
      type: 'document'
      nesting: 1
      state: '-block'

  # End the document and check the result.
  #
  # @return {Array<Token>} list of parsed tokens
  end: ->
    last = @get -1
    return unless last.level
    @token = @tokens.length - 1
    @state = last.state ? last.parent?.state ? @state
    # check if parsing started
    throw new Error "Nothing parsed" unless @tokens.length
    # check for correct structure
    if @level = last
      unless @autoclose()
        throw new Error "Not all elements closed correctly (ending in level #{@level})"
    debug "Done parsing" if debug.enabled
    # return token list
    @tokens



# Make class available from the outside
module.exports = Parser
