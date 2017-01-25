### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "code", ->

  it "should make code example", (cb) ->
    test.markdown 'code/data', """
      ``` javascript
      text = 'foo';
      ```
    """, [
      {type: 'document', nesting: 1}
      {type: 'code', nesting: 1, data: {language: 'javascript'}}
      {type: 'text', data: {text: 'text = \'foo\';'}}
      {type: 'code', nesting: -1}
      {type: 'document', nesting: -1}
    ], [
      {format: 'md'}
      {format: 'text'}
      {format: 'html'}
      {format: 'man'}
    ], cb

  describe.skip "examples", ->

    it "should make code example", (cb) ->
      test.markdown 'code/data', """
        ``` javascript
        text = 'foo';
        ```
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe.skip "api", ->

    it "should create code text section", (cb) ->
      # create report
      report = new Report()
      report.code 'text = \'foo\';', 'js'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1, data: {language: 'javascript'}}
        {type: 'text', data: {text: 'text = \'foo\';'}}
        {type: 'code', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: / {4}foo\n {7}bar/}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<pre><code>foo\n   bar</code></pre>\n"}
      ], cb

  describe.only "markdown", ->

    # http://spec.commonmark.org/0.27/#example-76
    it "should work with simple block", (cb) ->
      test.markdown null, '```\n<\n >\n```', [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1, data: {language: 'text'}}
        {type: 'text', data: {text: '<\n >'}}
        {type: 'code', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
