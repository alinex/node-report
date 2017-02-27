chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "emphasis", ->

  describe "examples", ->

    it "should make examples", (cb) ->
      test.markdown 'emphasis/simple', "That's **all** to say. _(Alex)_", null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'console'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe "api", ->

    it "should create emphasis in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.emphasis 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create emphasis in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.emphasis true
      report.text 'foo'
      report.emphasis false
      report.paragraph false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create emphasis in paragraph (shorthand call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.em 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create emphasis in paragraph (alternative call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.italic 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail emphasis if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.emphasis 'code').to.throw Error
      cb()

    it "should do nothing without content in emphasis", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.emphasis()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create strong in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.strong 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strong', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create strong in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.strong true
      report.text 'foo'
      report.strong false
      report.paragraph false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strong', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create strong in paragraph (shorthand call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.b 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strong', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create strong in paragraph (alternative call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.bold 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strong', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail strong if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.strong 'code').to.throw Error
      cb()

    it "should do nothing without content in strong", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.strong()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
