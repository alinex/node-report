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

  describe "test", ->
    it "should load", (cb) ->
      report = new Report()
      report.markdown 'This __is bold__.'
      cb()


  describe.skip "config", ->

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

  describe.skip "output", ->

    it "should output result", (cb) ->
      report = new Report()
      report.markdown 'Hello'
      report.format 'md', (err, result) ->
        expect(report.output 'md').to.equal result
        cb()
    it "should write to file", (cb) ->
      report = new Report()
      report.markdown 'Hello'
      report.format 'md', (err) ->
        return cb err if err
        report.toFile 'md', "#{__dirname}/../data/test-tofile", (err) ->
          expect(err).to.not.exist
          cb()
