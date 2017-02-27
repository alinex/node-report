### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "code", ->

  describe "examples", ->

    it "should make code example", (cb) ->
      test.markdown 'code/data', """
        ``` javascript
        text = 'foo';
        ```
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'console'}
        {format: 'html'}
        {format: 'man'}
      ], cb

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
