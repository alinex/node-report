### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "preformatted", ->

  describe "examples", ->

    it "should make preformatted text", (cb) ->
      test.markdown 'preformatted/data', """
        Preformatted Text:

            This line is preformatted!
                 ^^^^
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe "api", ->

    it "should create preformatted text section", (cb) ->
      # create report
      report = new Report()
      report.preformatted 'foo\n   bar'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'foo\n   bar'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: / {4}foo\n {7}bar/}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<pre><code>foo\n   bar</code></pre>\n"}
      ], cb

    it "should create preformatted text section (shorthand version)", (cb) ->
      # create report
      report = new Report()
      report.pre 'foo\n   bar'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'foo\n   bar'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: / {4}foo\n {7}bar/}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<pre><code>foo\n   bar</code></pre>\n"}
      ], cb
