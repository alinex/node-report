### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "blockquote", ->

  describe "examples", ->

    it "should make two blockquotes", (cb) ->
      test.markdown 'blockquote/multiple', """
        > Manfred said:
        >
        > > Everything will work next week.
        >
        But we don't think so.
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'console'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe "api", ->

    it "should create paragraph", (cb) ->
      # create report
      report = new Report()
      report.blockquote 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /> foo/}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<p>foo</p>\n"}
        {format: 'man', text: "foo"}
      ], cb

    it "should create in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.q true
      report.p true
      report.text 'foo'
      report.p false
      report.q false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should work with blockquotes in blockquotes", (cb) ->
      # create report
      report = new Report()
      report.q true
      report.p true
      report.text 'foo'
      report.p false
      report.q true
      report.p true
      report.text 'bar'
      report.p false
      report.q false
      report.q false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
