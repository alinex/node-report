###
Report Generation - API Usage
=================================================
###


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report'
fspath = require 'path'
# include more alinex modules
util = require 'alinex-util'
config = require 'alinex-config'
fs = require 'alinex-fs'
# modules
Formatter = require './formatter/index'
# internal helpers
schema = require './configSchema'
TokenList = require './tokenlist'
markdownParser = null # load on demand


# Report Class
# -------------------------------------------------
class Report

  ###
  Setup
  ----------------------------------------------------
  ###

  ###
  Set the modules config paths and validation schema.

  @name Report.setup
  @param {Function(<Error>)} cb callback with possible error
  ###
  @setup: util.function.once this, (cb) ->
    # set module search path
    config.register false, fspath.dirname __dirname
    config.register false, fspath.dirname(__dirname),
      folder: 'template'
      type: 'template'
    # add schema for module's configuration
    config.setSchema '/report', schema, cb

  ###
  Set the modules config paths, validation schema and initialize the configuration.

  @name Report.init
  @param {Function(<Error>)} cb callback with possible error
  ###
  @init: util.function.once this, (cb) ->
    debug "initialize"
    require './api'
    # set module search path
    @setup (err) ->
      return cb err if err
      config.init (err) ->
        return cb err if err
        Formatter.init()
        cb()

  # Create Report instance
  #
  # @param {Object} setup specific start information
  # - `String` - `basedir` to be used for relative includes
  constructor: (@setup) ->
    @tokens = new TokenList()
    @formatter = {}


  ###
  Parsing
  -------------------------------------------------
  ###

  ###
  Add markdown to report.

  @param {String} text to be parsed
  @return {Report} instance itself for command concatenation
  ###
  markdown: (text) ->
    markdownParser ?= require './parser/markdown'
    markdownParser.call this, text

  fromFile: (file, cb) ->
    switch fspath.extname(file)[1..]
      when 'md'
        fs.readFile file, 'utf8', (err, content) =>
          return cb err if err
          @markdown content
          cb()
      when 'html'
        fs.readFile file, 'utf8', (err, content) =>
          return cb err if err
          @raw content, 'html'
          cb()
      else
        cb new Error "Unknown format of #{file}"

  ###
  Navigation
  -------------------------------------------------
  ###

  top: -> @tokens.set 1
  bottom: -> @tokens.set 0

  next: (filter) ->
    return if @tokens.pos is @tokens.data.length
    pos = @tokens.pos
    if filter and not tokenFilter @tokens.data[pos], filter
      while ++pos
        return if pos is @tokens.data.length
        break if tokenFilter @tokens.data[pos], filter
    @tokens.set pos + 1

  prev: (filter) ->
    return if @tokens.pos is 1
    pos = @tokens.pos - 2
    if filter and not tokenFilter @tokens.data[pos], filter
      while --pos
        return if pos is -1
        break if tokenFilter @tokens.data[pos], filter
    @tokens.set pos + 1

  start: ->
    [pos] = @tokens.findStart()
    @tokens.set pos + 1
  end: ->
    [pos] = @tokens.findEnd()
    @tokens.set pos + 1


  ###
  Formatting / Output
  -------------------------------------------------
  ###

  ###
  @param {Object|String} setup complete definition or name of configured setup
  @param {Function(Error, String)} cb with name of formatter to access if no `Èrror` occured
  ###
  format: (setup, cb) ->
    # load defaults for setup
    if typeof setup is 'string'
      name = setup
      setup = config.get "/report/format/#{name}"
      return cb new Error "Unknown format '#{name}' for output." unless setup
      setup.format = name
    else
      opt = config.get("/report/format/#{setup.format}") ? config.get "/report/format/md"
      return cb new Error "Unknown format '#{setup}' for output." unless opt
      util.extend setup, opt
    # initialize formatter and run it
    @formatter[setup.format] = new Formatter @tokens, setup
    @formatter[setup.format].format (err) =>
      cb err, @formatter[setup.format].output

  ###
  @param {String} name to access (from previous process call)
  @return {String} complete output document
  ###
  output: (name) ->
    @formatter[name]?.output

  ###
  @param {String} name to access (from previous process call)
  @param {String} file to write output to
  @param {Function(Error} cb with possible error
  ###
  toFile: (name, file, cb) ->
    unless @formatter[name]
      return @format name, (err) =>
        return cb err if err
        @toFile (name.format ? name), file, cb
    file += @formatter[name].setup.extension unless fspath.extname file
    file = fspath.resolve file
    debug "write #{name} output to file #{file}..."
    fs.mkdirs fspath.dirname(file), (err) =>
      return cb err if err
      fs.writeFile file, @formatter[name].output, cb

###
Export Report Class
------------------------------------------------------------------
###

module.exports = Report


tokenFilter = (token, filter) ->
  for k, v of filter
    return false unless token[k] is v
  true
