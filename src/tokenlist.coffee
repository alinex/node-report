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
# A positional cursor is also used to have a current position within the list
# to work at if no other position is specified in the methods.
# - `set(Integer)` set a specific position for the cursor
# - `pos` get the cursor position in the array
# - `token` access last token before the cursor
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
# - `hidden` - `Boolean` set to true to ignore element in rendering (for tight lists)
# - `heading` - `Integer` level of heading (between 0..6)
# - 'list' - `String` the type of list (bullet, ordered)
# - `start` - `Integer` start number in ordered list
# - `href` - `String` the target uri for a link element
# - `src` - `String` the source uri for the image element
# - `title` - `String` an additional title for image or link elements


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
    util.string.rpad(util.string.repeat('  ', token.level) + indent + token.type, 20) +
    Object.keys(token).filter (e) ->
      e not in ['type', 'nesting', 'level', 'parent', 'out', 'collect']
    .map (e) ->
      if typeof token[e] is 'number'
        "#{e}=#{token[e]}"
      else
        "#{e}=#{util.inspect token[e]}"
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

  # Dump complete token list.
  #
  # @return {String} multiline representation
  dumpall: ->
    @data.map (t) -> TokenList.dump t
    .join '\n'

  # Get specified or last token.
  #
  # @param {Integer} [pos] get element at this position or last token
  # @return {Object} at the defined position
  get: (pos) ->
    return @token unless pos? # default to current token
    pos = @data.length + pos if pos < 0
    @data[pos]

  # Check if current token is within one of the defined types.
  #
  # @param {String|Array<String>} type the list of types to check
  # @param {Token} [token] check from this or from the current cursor
  # @return {Boolean} `true` if within one of the given elements
  in: (type, token) ->
    type = [type] unless Array.isArray type
    t = token ? @token
    loop
      return t if t.type in type and t.nesting is 1
      return false unless t.parent
      t = t.parent

  # Get list of all parent tokens, highest last.
  #
  # @param {Token} [token] check from this or from the current cursor
  # @return {Boolean} `true` if within one of the given elements
  parents: (token) ->
    t = token ? @token
    parents = []
    loop
      break unless t = t.parent
      parents.push t
    parents

  # Check if current token directly contains one or more of the defined types.
  #
  # @param {String|Array<String>} type the list of types to check
  # @param {Integer} [pos] cursor for current position
  # @param {Token} [token] check from this or from the current cursor
  # @return {Object<Integer=Token>} the list of found elements
  contains: (type, pos, token) ->
    type = [type] unless Array.isArray type
    pos ?= @pos
    token ?= @token
    num = pos
    found = {}
    loop
      t = @get ++num
      continue if t.level > token.level + 1 # to deep
      break if t.level is token.level
      found[num] = t if t.type in type and t.nesting >= 0
    found

  # Find start of given end Token.
  #
  # @param {Integer} [pos] cursor for current position
  # @param {Token} [token] check from this or from the current cursor
  # @return {Integer, Token} the found start position and Token
  findStart: (pos, token) ->
    pos ?= @pos - 1
    token ?= @token
    return null if token.nesting isnt -1
    num = pos
    loop
      t = @get --num
      continue if t.level > token.level
      return [num, t] if t.level is token.level

  # Find end of given start Token.
  #
  # @param {Integer} [pos] cursor for current position
  # @param {Token} [token] check from this or from the current cursor
  # @return {Integer, Token} the found end position and Token
  findEnd: (pos, token) ->
    pos ?= @pos - 1
    token ?= @token
    return null if token.nesting isnt 1
    num = pos
    loop
      t = @get ++num
      continue if t.level > token.level
      return [num, t] if t.level is token.level

  # Set the current cursor.
  #
  # @param {Integer} pos set cursor for current position
  # @return {TokenList} for command concatenation
  set: (@pos) ->
    @pos = @data.length + @pos if @pos <= 0
    @token = @data[@pos - 1]
    debug "set position to #{@pos}" if debug
    this

  # Set the current cursor after closing tag.
  #
  # @param {Integer} pos set cursor for current position
  # @return {TokenList} for command concatenation
  setAfterClosing: (type) ->
    # step behind close tag
    for pos in [@pos..@data.length-1]
      t = @get pos
      break if t.type is type and t.level <= @token.level and t.nesting is -1
    @set pos + 1

  # Insert one or multiple tokens.
  #
  # @param {Array<Token>|Token} list to be added to the tokens
  # @param {Integer} [pos] add at this position or at the cursor
  # @param {Integer} [cursor] number of elements to move cursor (default to end of
  # inserted list)
  # @return {TokenList} for command concatenation
  insert: (list, pos, cursor) ->
    list = [list] unless Array.isArray list
    pos ?= @pos ? 0
    pos = @data.length + pos if pos < 0
    cursor ?= list.length
    # optimize tokens
    parent = []
    level = 0
    if pos > 0
      last = @get pos - 1
      p = if last.nesting > 0 then last else last.parent
      parent = @parents p
      parent.unshift p
      level = p.level + 1
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
        debug "INSERT #{util.string.lpad '#' + num++ + '/' + (@data.length-1), 6}",
          chalk.gray @dump e
    @set pos + cursor
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
    # deleted before cursor
    if pos < @pos < pos + num
      @set pos
    # deleted around cursor
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

  # Collect content of token and subtokens into string.
  #
  # @param {Token|Integer} token to dump
  # @return {String} representation of token
  collect: (pos, token) ->
    # collect content
    token.collect = ''
    n = pos
    loop
      t = @get ++n
      break if t.level is token.level # reached end of sub elements
      if t.level is token.level + 1 # only one level deeper
        token.collect += t.out if t.out
        token.collect += t.collect if t.collect


# Exports
# -----------------------------------------

module.exports = TokenList
