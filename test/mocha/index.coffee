chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'


describe "Base", ->

  Report = require '../../src/index'

  before (cb) ->
    @timeout 20000
    Report.setup ->
    Report.init cb

  describe "config", ->

    it "should run the selfcheck on the schema", (cb) ->
      @timeout 5000
      validator = require 'alinex-validator'
      schema = require '../../src/configSchema'
      validator.selfcheck schema, cb

    it "should initialize config", (cb) ->
      @timeout 10000
      Report.init (err) ->
        expect(err, 'init error').to.not.exist
        config = require 'alinex-config'
        config.init (err) ->
          expect(err, 'load error').to.not.exist
          conf = config.get '/report'
          expect(conf, 'config').to.exist
          debug 'config:', conf
          cb()
