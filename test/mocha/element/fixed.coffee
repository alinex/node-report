chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "fixed", ->

  describe "examples", ->

    it "should make examples", (cb) ->
      test.markdown 'fixed/simple', "To shut a debian system down enter
      `shutdown -h now` in a console as `root`.", null, true, cb

  describe "api", ->

    it "should create in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.fixed 'code'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'fixed', nesting: 1}
        {type: 'text', content: 'code'}
        {type: 'fixed', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.fixed true
      report.text 'code'
      report.fixed false
      report.paragraph false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'fixed', nesting: 1}
        {type: 'text', content: 'code'}
        {type: 'fixed', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create in paragraph (shorthand call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.tt 'code'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'fixed', nesting: 1}
        {type: 'text', content: 'code'}
        {type: 'fixed', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.fixed 'code').to.throw Error
      cb()

    it "should do nothing without content", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.fixed()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
