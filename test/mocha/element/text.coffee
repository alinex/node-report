### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "text", ->

  describe "examples", ->

    it "should make two paragraphs", (cb) ->
      test.markdown 'paragraph/multiple', """
        This is an example of two paragraphs in markdown style there the separation
        between them is done with an empty line.

        This follows the common definition of markdown.
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe "api", ->

    it "should create text with tabs in preformatted section", (cb) ->
      # create report
      report = new Report()
      report.pre 'foo\tbar'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'foo\tbar'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo\tbar/}
        {format: 'text', re: /foo\tbar/}
        {format: 'html', text: "<pre><code>foo\tbar</code></pre>\n"}
        {format: 'man', text: '.P\n.RS 2\n.nf\nfoo\tbar\n.fi\n.RE'}
      ], cb
