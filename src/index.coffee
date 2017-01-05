###
Report Generation - API Usage
=================================================
###


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report'
chalk = require 'chalk'
deasync = require 'deasync'
fspath = require 'path'
# include more alinex modules
util = require 'alinex-util'
config = require 'alinex-config'
fs = require 'alinex-fs'
# modules
Parser = require './parser/index'
Formatter = require './formatter/index'
# internal helpers
schema = require './configSchema'


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
    # set module search path
    @setup (err) ->
      return cb err if err
      config.init cb

  # Create Report instance
  #
  constructor: ->
    @parser = new Parser()
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
    @parser.parse text
    this


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
    @formatter[setup.format] = new Formatter @parser, setup
    @formatter[setup.format].process (err) =>
      return cb err if err
      cb null, @formatter[setup.format].output

  ###
  @param {String} name to access (from previous process call)
  @return {String} complete output document
  ###
  output: (name) ->
    @formatter[name].output

  ###
  @param {String} name to access (from previous process call)
  @param {String} file to write output to
  @param {Function(Error} cb with possible error
  ###
  toFile: (name, file, cb) ->
    file += @formatter[name].setup.extension unless fspath.extname file
    file = fspath.resolve file
    debug "write #{name} output to file #{file}..."
    fs.mkdirs fspath.dirname(file), (err) =>
      return cb err if err
      fs.writeFile file, @formatter[name].output, cb


  ###
  API Creation
  -------------------------------------------------
  ###

  ###
  Add heading level 1.

  @param {String|Boolean} text with content of heading or true to open tag and
  false to close tag if content is added manually.
  @return {Report} instance itself for command concatenation
  ###
  h1: (text) ->
    @parser.begin()
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
