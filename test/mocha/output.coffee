chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'

Report = require '../../../src'
before (cb) ->
  @timeout 20000
  Report.init cb

describe "output", ->

  describe "methods", ->

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

    it "should write to file (direct)", (cb) ->
      report = new Report()
      report.markdown 'Hello'
      report.toFile 'md', "#{__dirname}/../data/test-tofile", (err) ->
        expect(err).to.not.exist
        cb()

  describe "real life", ->

    it "should output README as html", (cb) ->
      report = new Report()
      report.markdown 'Hello'
      report.format 'md', (err, result) ->
        expect(report.output 'md').to.equal result
        cb()
