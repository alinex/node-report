# Token List
# =============================================
# The tokens are the internal structure of the report component.
# They are collected in a flat list with tree structur information.
#
# ### Structure
#
# The `data` element contains a simple array holding all the `Tokens` from the
# report. But to work with it there are different methods within for easy access
# and manipulation.
#
# A positional marker is also used to have a current position within the list
# to work at if no other position is specified in the methods.
# - `set(Integer)` set a specific position for the marker
# - `pos` get the marker position in the array
# - `token` access last token before the marker
#
# ### Tokens
#
# The elements of the list (contained in the `data` element) have the following
# structure:
# - `type` - `String` defines the tokens element type
# . `nesting` - `Integer` specifies if it is the opening element `1` or closing
# element `-1` the default will be set to `0` for single elements
#
# Further structural information will be set on input automatically like:
# - `level` - `Integer` the current level of depth in the structure starting with `0`
# - `parent` - `Token` reference to the parent opening element
#
# Some tokens may contain specific fields.
# - `content` - `String` used in text, text styling elements like `strong`
# - `heading` - `Integer` level of heading (between 0..6)
# - 'list' - `String` the type of list (bullet, ordered)
# - `start` - `Integer` start number in ordered list


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
  constructor: (source) ->
    if source?.data
      @data = util.clone source.data
      return
    # initial document
    @data = []
    @insert [
      type: 'document'
      nesting: 1
    ,
      type: 'document'
      nesting: -1
    ], null, 1

  # Get specified or last token.
  #
  # @param {Integer} [pos] get element at this position or last token
  # @return {Object} at the defined position
  get: (pos) ->
    return @token unless pos? # default to current token
    pos = @data.length + pos if pos < 0
    @data[pos]

  in: (type) ->
    type = [type] unless Array.isArray type
    t = @token
    loop
      return t if t.type in type
      return false unless t.parent
      t = t.parent

  # Set the current marker.
  #
  # @param {Integer} pos set marker for current position
  # @return {TokenList} for command concatenation
  set: (@pos) ->
    @pos ?= @data.length # default after last token
    @pos = @data.length + @pos if @pos <= 0
    @token = @data[@pos - 1]
    debug "set position to #{@pos}" if debug
    this

  setAfterClosing: (type) ->
    # step behind close tag
    for pos in [@pos..@data.length-1]
      t = @get pos
      break if t.type is type and t.level is @token.level and t.nesting is -1
    @set pos + 1

  # Insert one or multiple tokens.
  #
  # @param {Array<Token>|Token} list to be added to the tokens
  # @param {Integer} [pos] add at this position or at the current marker
  # @param {Integer} [marker] number of elements to move marker (default to end of
  # inserted list)
  # @return {TokenList} for command concatenation
  insert: (list, pos, marker) ->
    list = [list] unless Array.isArray list
    pos ?= @pos ? 0
    pos = @data.length + pos if pos < 0
    marker ?= list.length
    # optimize tokens
    parent = []
    level = 0
    if pos > 0
      last = @get pos - 1
      parent.unshift if last.nesting > 0 then last else last.parent
      level = parent[0].level + 1
    for e in list
      if e.nesting < 0
        level--
        parent.shift()
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
        debug "INSERT #{util.string.lpad '#' + num++ + '/' + (@data.length-1), 6}", chalk.gray @dump e
    @set pos + marker
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
    # deleted before marker
    if pos < @pos < pos + num
      @set pos
    # deleted around marker
    else if pos < @pos
      @set @pos - num
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
