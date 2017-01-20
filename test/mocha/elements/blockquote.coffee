### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "blockquote", ->

#  it "should run first test", (cb) ->
#    test.markdown 'blockquote/multiple', """
#      > Manfred said:
#      >
#      > > Everything will work next week.
#      >
#      But we don't think so.
#    """, null, null, cb

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
        {type: 'text', data: {text: 'foo'}}
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
        {type: 'text', data: {text: 'foo'}}
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
        {type: 'text', data: {text: 'foo'}}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bar'}}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "markdown", ->

    # http://spec.commonmark.org/0.27/#example-189
    it "should work with simple block", (cb) ->
      test.markdown null, '> # Foo\n> bar\n> baz', [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'heading', nesting: 1}
        {type: 'text', data: {text: 'Foo'}}
        {type: 'heading', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bar baz'}}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-190
    it "should work with omitted space after >", (cb) ->
      test.markdown null, '># Foo\n>bar\n> baz', [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'heading', nesting: 1}
        {type: 'text', data: {text: 'Foo'}}
        {type: 'heading', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bar baz'}}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-191
    it "should indention of up to 3 spaces", (cb) ->
      test.markdown null, '   > # Foo\n   > bar\n > baz', [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'heading', nesting: 1}
        {type: 'text', data: {text: 'Foo'}}
        {type: 'heading', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bar baz'}}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-192
    it "should fail with 4 spaces indention", (cb) ->
      test.markdown null, '    > # Foo\n    > bar\n    > baz', [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', data: {text: '> # Foo\n> bar\n> baz'}}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-193
    it "should allow lazy continuation", (cb) ->
      test.markdown null, '> # Foo\n> bar\nbaz', [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'heading', nesting: 1}
        {type: 'text', data: {text: 'Foo'}}
        {type: 'heading', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bar baz'}}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-194
    it "should allow lazy continuation within", (cb) ->
      test.markdown null, '> bar\nbaz\n> foo', [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bar baz foo'}}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-195
    # http://spec.commonmark.org/0.27/#example-196
    # http://spec.commonmark.org/0.27/#example-197
    it "should not be lazy for other other elements than paragraph", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '> foo\n---', [
            {type: 'document', nesting: 1}
            {type: 'blockquote', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: 'foo'}}
            {type: 'paragraph', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'thematic_break'}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '> - foo\n- bar', [
            {type: 'document', nesting: 1}
            {type: 'blockquote', nesting: 1}
            {type: 'list', nesting: 1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: 'foo'}}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'list', nesting: 1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: 'bar'}}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '>     foo\n    bar', [
            {type: 'document', nesting: 1}
            {type: 'blockquote', nesting: 1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', data: {text: 'foo'}}
            {type: 'preformatted', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', data: {text: 'bar'}}
            {type: 'preformatted', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-198
############################# missing because of code block

    # http://spec.commonmark.org/0.27/#example-199
    it "should allow lazy continuation with indented list", (cb) ->
      test.markdown null, '> foo\n    - bar', [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'foo - bar'}}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-200
    # http://spec.commonmark.org/0.27/#example-201
    it "should allow empty blockquote", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '>', [
            {type: 'document', nesting: 1}
            {type: 'blockquote', nesting: 0}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          test.markdown null, '>\n>\n>', [
            {type: 'document', nesting: 1}
            {type: 'blockquote', nesting: 0}
            {type: 'document', nesting: -1}
            ], null, cb
      ], cb
