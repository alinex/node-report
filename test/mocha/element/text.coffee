chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe.only "text", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'text/simple', """
        This is a short text.
        With each sentence in a separate line.\\
        And a hard break before this.
      """, null, true, cb

    it "should make typographic replacements", (cb) ->
      test.markdown 'text/typographic', """
        I\'m looking forward.\\
        foo "foo 'inside' bar" bar
      """, null, true, cb

    it "should make typographic replacements (german)", (cb) ->
      test.markdown 'text/typographic-de', """
        <!-- {document:lang=de} -->
        I\'m looking forward.\\
        foo "foo 'inside' bar" bar
      """, null, true, cb

  describe "api", ->

    it "should create in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.text 'Simple Text.'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Simple Text.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.text 'Simple Text.').to.throw Error
      cb()

    it "should do nothing without content", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.text()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

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

    it "should work with soft and hard breaks", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      .text 'Simple Text.'
      .hardbreak()
      .text 'And now another line.'
      .softbreak()
      .text 'With two sentences.'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Simple Text.'}
        {type: 'hardbreak'}
        {type: 'text', content: 'And now another line.'}
        {type: 'softbreak'}
        {type: 'text', content: 'With two sentences.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "format", ->

    it "should use typographic apostrophes", (cb) ->
      # create report
      report = new Report()
      report.p 'I\'m looking forward'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'I’m looking forward\n'}
        {format: 'html', text: "<p>I’m looking forward</p>\n"}
      ], cb

    it "should use typographic quotes", (cb) ->
      # create report
      report = new Report()
      report.p 'foo "foo \'inside\' bar" bar'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'foo “foo ‘inside’ bar” bar\n'}
        {format: 'html', text: "<p>foo “foo ‘inside’ bar” bar</p>\n"}
      ], cb

    it "should use typographic quotes (changed locale)", (cb) ->
      # create report
      report = new Report()
      report.style 'document:lang=de'
      report.p 'foo "foo \'inside\' bar" bar'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'foo „foo ‚inside‘ bar“ bar\n'}
        {format: 'html', text: "<p>foo „foo ‚inside‘ bar“ bar</p>\n"}
      ], cb
