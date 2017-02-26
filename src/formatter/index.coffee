# Formatter
# =================================================
# Formatting is done in multiple steps:
# 1. clone token list from parser
# 2. run pre routines which may change some tokens
# 3. transform routines will create the `out` String
# 4. post routines are used while collecting output strings together
# 5. converter may be run afterwards


# Page Data
# --------------------------------------------------
# Some processing information of the formatter are needed. This is stored in the
# top opening `document` element:
# - heading = <name>: <token> # used to prevent duplicate ids in heading anchors
# - linkNames = <name>: [<href>, <title>] # used as reference list at the end of document
# - links = <href+title>: <name> # used to prevent duplicate definitions
#
# This will collect IDs for direct links or class attributes.


# Tokens
# --------------------------------------------------
# The tokens may get some type specific information in the pre transformation step
# like:
# - `html` - `Object` with <attrib> = <value>
# - `count` - `Integer` number of elements in `list` element
# - `num` - `Integer` number of `item` in list (equals to numer in ordered list)
# - `col` - `Integer` column number in table
#
# The transformator step will also add:
# - `out` - `String` the text representation of this element
# - `marker` - `String` to use if not default in list, or the one used in emphasis
#
# And later in the collector and post parsing all parent elements will get the
# following element:
# - `collect` - `String` the combination of all child output


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
# internal classes
TokenList = require '../tokenlist'


# Rules
# -------------------------------------------------
# They will be filled up on `init()` call.
preLibs = null
transLibs = null
postLibs = null
convLibs = null


# Formatter Class
# -------------------------------------------------
class Formatter

  # Setup
  # -------------------------------------------------
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

    formatLibs = (type) ->
      list = libs type
      # group by format
      grouped = {}
      for key, lib of list
        for name, rule of lib
          rule.name = "#{key}:#{name}"
          rule.format ?= ['md', 'text', 'html', 'adoc', 'roff', 'latex', 'rtf']
          rule.format = [rule.format] unless Array.isArray rule.format
          for f in rule.format
            grouped[f] ?= []
            grouped[f].push rule
      grouped

    # Load helper
    preLibs = formatLibs 'pre'
    if debugRule.enabled
      for type, rules of preLibs
        debugRule "possible pre formatter #{type}:", (rules.map (e) -> e.name
        .join ', '
        .replace /\n +/g, ' ')
    transLibs = formatLibs 'transform'
    if debugRule.enabled
      for type, rules of transLibs
        debugRule "possible transformer #{type}:", (rules.map (e) -> e.name
        .join ', '
        .replace /\n +/g, ' ')
    postLibs = formatLibs 'post'
    if debugRule.enabled
      for type, rules of postLibs
        debugRule "possible post formatter #{type}:", (rules.map (e) -> e.name
        .join ', '
        .replace /\n +/g, ' ')
    convLibs = libs 'convert'
    if debugRule.enabled
      for type, rules of convLibs
        debugRule "possible converter #{type} to:", \
        Object.keys(rules).toString().replace /\n +/g, ' '

  # Create a new parser object.
  #
  # @param {Parser} parser object to format
  # @param {Object} setup for the format
  constructor: (tokens, @setup) ->
    @tokens = new TokenList tokens
    @output = ''
    @linkNames = {}

  # Process the parser content and generate format.
  #
  format: (cb) ->
    debug "create output as #{@setup.format}" if debug
    debugData "setup:", util.inspect(@setup).replace /\s*\n\s*/g, ' ' if debugData
    # run pre formatter
    pos = -1
    while ++pos < @tokens.data.length
      token = @tokens.get pos
      if preLibs[@setup.type]
        for rule in preLibs[@setup.type]
          continue if rule.type and token.type isnt rule.type
          continue if rule.state and not token.state in rule.state
          continue if rule.nesting and token.nesting isnt rule.nesting
          continue if rule.data and not token.data
          continue if rule.data?.text and not token.data?.text
          debugRule "call pre #{rule.name} for token ##{pos}" if debugRule
          if token.out
            ts = chalk.yellow.bold util.inspect(token, {depth: 1})
            .replace /,\s+parent:\s+\{\s+type:\s+'(.*?)'[\s\S]*?\}/g, ", parent: <$1>"
            .replace /\s*\n\s*/g, ' '
            debugData "token ##{pos} #{ts}"
          rule.fn.call this, pos, token
    # run transformation
    pos = -1
    while ++pos < @tokens.data.length
      token = @tokens.get pos
      for rule in transLibs[@setup.type]
        continue if rule.type and token.type isnt rule.type
        continue if rule.state and not token.state in rule.state
        continue if rule.nesting and token.nesting isnt rule.nesting
        continue if rule.data and not token.data
        continue if rule.data?.text and not token.data?.text
        debugRule "call trans #{rule.name} for token ##{pos}" if debugRule
        rule.fn.call this, pos, token
        if token.out and debugData.enabled
          debugData "token ##{pos} out:
          #{chalk.yellow util.inspect util.string.shorten token.out, 60}"
    # collect output
    for pos in [@tokens.data.length-1..0]
      token = @tokens.get pos
#      console.log '#######################################', pos, token.type, token.nesting
#      console.log @tokens.data
      continue if token.nesting isnt 1 # only work on opening elements
      # collect content
      @tokens.collect pos, token
      # call post routine
      for rule in postLibs[@setup.type]
        continue if rule.type and token.type isnt rule.type
        continue if rule.state and not token.state in rule.state
        debugRule "call post #{rule.name} for token ##{pos}" if debugRule
        rule.fn.call this, pos, token
        if token.collect and debugData.enabled
          debugData "token ##{pos} collect:
          #{chalk.yellow util.inspect util.string.shorten token.collect, 60}"
    # collect complete output
    first = @tokens.get 0
    last = @tokens.get -1
    @output = (first.out ? '') + first.collect + (last.out ? '')
    # post optimization
    return cb() unless @setup.convert
    # run conversion
    debug "convert to #{@setup.convert.type}..."
    convLibs[@setup.format][@setup.convert.type].call this, @output, (err, result) =>
      @output = result
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
