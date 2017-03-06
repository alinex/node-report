### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "code", ->

  describe.only "examples", ->
    @timeout 30000

    it "should make code example", (cb) ->
      test.markdown 'code/javascript', """
        ``` javascript
        text = 'foo';
        // output text if set
        if (text.length > 0) {
          console.log(text);
        }
        ```
      """, null, true, cb

  describe "api", ->

    it "should create code text section", (cb) ->
      # create report
      report = new Report()
      report.code 'text = \'foo\';', 'js'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1, language: 'javascript'}
        {type: 'text', content: 'text = \'foo\';'}
        {type: 'code', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text: '``` javascript\ntext = \'foo\';\n```'}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<pre><code>text = &#39;foo&#39;;</code></pre>\n"}
        {format: 'man', text: '.P\n.RS 2\n.nf\ntext = \'foo\';\n.fi\n.RE'}
      ], cb

    it "should create in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.code true, 'js'
      report.text 'text = \'foo\';'
      report.code false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1, language: 'javascript'}
        {type: 'text', content: 'text = \'foo\';'}
        {type: 'code', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text: '``` javascript\ntext = \'foo\';\n```'}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<pre><code>text = &#39;foo&#39;;</code></pre>\n"}
        {format: 'man', text: '.P\n.RS 2\n.nf\ntext = \'foo\';\n.fi\n.RE'}
      ], cb
