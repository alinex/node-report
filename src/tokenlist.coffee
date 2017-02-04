# Tokens
# =============================================
# The tokens are the internal structure of the report component.
#
# It is an array of token objects with the following structure:
# - `type`
# . `nesting`
# - `level`
# - `content` # only on text and inline elements
#
# Some tokens may contain specific fields.
#
# The TokenList also have different methods to work with the tokens and also keeps
# a marker as the current position to access the last token before and add new ones:
# - `set(Integer)` set a specific position for the marker
# - `pos` get the marker position in the array
# - `token` access last token before the marker

# Node Modules
# -----------------------------------------
debug = require('debug') "report:tokens"
chalk = require 'chalk'
# alinex modules
util = require 'alinex-util'

# Class Definition
# -----------------------------------------

class TokenList

  # Dump given token to string.
  #
  # @param {Token} token to dump
  # @return {String} representation of token
  @dump: (token) ->
    return "No token given." unless token
    indent = switch token.nesting
      when 1 then '> '
      when -1 then '< '
      else '  '
    util.string.rpad(util.string.repeat('  ', token.level) + indent + token.type, 16) +
    Object.keys(token).filter (e) -> e not in ['type', 'nesting', 'level', 'parent']
    .map (e) ->
      if typeof token[e] is 'number'
        "#{e}=#{token[e]}"
      else
        "#{e}=\"#{token[e]}\""
    .join ' '

  # Create new instance.
  #
  # @return {TokenList} to be used in `report.parser`
  constructor: ->
    @data = []
    # initial document
    @insert [
      type: 'document'
      nesting: 1
    ,
      type: 'document'
      nesting: -1
    ]
    # set marker within document
    @set 1

  # Get specified or last token.
  #
  # @param {Integer} [pos] get element at this position or last token
  # @return {Object} at the defined position
  get: (pos) ->
    return @token unless pos? # default to current token
    pos = @data.length - 1 + pos if pos < 0
    @data[pos]

  # Set the current marker.
  #
  # @param {Integer} pos set marker for current position
  # @return {TokenList} for command concatenation
  set: (@pos) ->
    @pos ?= @data.length # default after last token
    @pos = @data.length + @pos if @pos < 0
    @token = @data[@pos - 1]
    debug "set position to #{@pos}" if debug
    this

  # Insert one or multiple tokens.
  #
  # @param {Array<Token>|Token} list to be added to the tokens
  # @param {Integer} [pos] add at this position or at the current marker
  # @return {TokenList} for command concatenation
  insert: (list, pos) ->
    list = [list] unless Array.isArray list
    pos ?= @pos ? 0
    pos = @data.length + pos if pos < 0
    # optimize tokens
    parent = []
    level = 0
    if pos > 0
      parent.unshift @get pos - 1
      level = parent[0].level + 1
    for e in list
      if e.nesting < 0
        level--
        parent.shift
      e.level = level
      e.parent = parent[0] if parent.length
      if e.nesting > 0
        level++
        parent.unshift e
    # add tokens
    if pos is @data.length
      @data.push.apply @data, list
    else
      @data.splice.apply @data, [pos, 0].concat list
    if debug
      num = pos
      for e in list
        debug "INSERT #{util.string.lpad '#' + num++ + '/' + @data.length, 6}", chalk.gray @dump e
    @set pos + list.length
    this

  # Remove tokens from the list.
  #
  # @param {Integer} pos remove at this position
  # @param {Integer} [num] number of tokens to remove (default: 1)
  # @return {TokenList} for command concatenation
  remove: (pos, num = 1) ->
    if debug
      for e in [pos..pos+num]
        debug "REMOVE #{util.string.lpad '#' + e, 3}", chalk.gray @dump e
    @data.splice pos, num
    if @pos > @data.length
      @set()
    this

  # Dump given token to string.
  #
  # @param {Token|Integer} token to dump
  # @return {String} representation of token
  dump: (token) ->
    token = @data[token] if typeof token is 'number'
    TokenList.dump token



# Exports
# -----------------------------------------

module.exports = TokenList
