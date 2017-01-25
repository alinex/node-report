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

    # http://spec.commonmark.org/0.27/#example-88
    it "should work with back quotes", (cb) ->
      test.markdown null, '```\n<\n >\n```', [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1, data: {language: 'text'}}
        {type: 'text', data: {text: '<\n >'}}
        {type: 'code', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-89
    it "should work with tilde", (cb) ->
      test.markdown null, '~~~\n<\n >\n~~~', [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1, data: {language: 'text'}}
        {type: 'text', data: {text: '<\n >'}}
        {type: 'code', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-90
    # http://spec.commonmark.org/0.27/#example-91
    it "should use same marker for opening and closing", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '```\naaa\n~~~\n```', [
            {type: 'document', nesting: 1}
            {type: 'code', nesting: 1, data: {language: 'text'}}
            {type: 'text', data: {text: 'aaa\n~~~'}}
            {type: 'code', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '~~~\naaa\n```\n~~~', [
            {type: 'document', nesting: 1}
            {type: 'code', nesting: 1, data: {language: 'text'}}
            {type: 'text', data: {text: 'aaa\n```'}}
            {type: 'code', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-92
    # http://spec.commonmark.org/0.27/#example-93
    it "should have at least the same length for closing marker", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '````\naaa\n```\n``````', [
            {type: 'document', nesting: 1}
            {type: 'code', nesting: 1, data: {language: 'text'}}
            {type: 'text', data: {text: 'aaa\n```'}}
            {type: 'code', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '~~~~\naaa\n~~~\n~~~~', [
            {type: 'document', nesting: 1}
            {type: 'code', nesting: 1, data: {language: 'text'}}
            {type: 'text', data: {text: 'aaa\n~~~'}}
            {type: 'code', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-94
    # http://spec.commonmark.org/0.27/#example-95
    # http://spec.commonmark.org/0.27/#example-96
    it "should close at the end of document or block", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '```', [
            {type: 'document', nesting: 1}
            {type: 'code', nesting: 1, data: {language: 'text'}}
            {type: 'text', data: {text: ''}}
            {type: 'code', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '`````\n\n```\naaa', [
            {type: 'document', nesting: 1}
            {type: 'code', nesting: 1, data: {language: 'text'}}
            {type: 'text', data: {text: '\n```\naaa'}}
            {type: 'code', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '> ```\n> aaa\n\nbbb', [
            {type: 'document', nesting: 1}
            {type: 'blockquote', nesting: 1}
            {type: 'code', nesting: 1, data: {language: 'text'}}
            {type: 'text', data: {text: 'aaa'}}
            {type: 'code', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: 'bbb'}}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb
