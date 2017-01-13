### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "thematic break", ->

  describe "examples", ->

    it "should make examples", (cb) ->
      test.markdown 'thematic_break/line', '---', null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe "api", ->

    it "should create line", (cb) ->
      # create report
      report = new Report()
      report.hr()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'thematic_break'}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /\*{3,}\n/}
        {format: 'text', re: /─{3,}\n/}
        {format: 'html', text: "<hr />\n"}
        {format: 'man', text: ".HR\n"}
      ], cb

  describe "markdown", ->

    # http://spec.commonmark.org/0.27/#example-13
    it "should work with three characters", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '***', [
            {type: 'document', nesting: 1}
            {type: 'thematic_break'}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '---', [
            {type: 'document', nesting: 1}
            {type: 'thematic_break'}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '___', [
            {type: 'document', nesting: 1}
            {type: 'thematic_break'}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-14
    # http://spec.commonmark.org/0.27/#example-15
    it "should fail with wrong characters", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '+++', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: '+++'}}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '===', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: '==='}}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-16
    it "should fail with not enough characters", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '--', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: '--'}}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: '**'}}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: '__'}}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb


    # http://spec.commonmark.org/0.27/#example-17
    it "should work with one to three spaces indent", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, ' ***', [
            {type: 'document', nesting: 1}
            {type: 'thematic_break'}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '  ***', [
            {type: 'document', nesting: 1}
            {type: 'thematic_break'}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '   ***', [
            {type: 'document', nesting: 1}
            {type: 'thematic_break'}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-18
    # http://spec.commonmark.org/0.27/#example-19
    it "should fail with too much indention", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '    ****', [
            {type: 'document', nesting: 1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', data: {text: '****'}}
            {type: 'preformatted', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'Foo\n    ***', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: 'Foo ***'}}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-20
    it "should work with more than three characters", (cb) ->
      test.markdown null, '_____________________________________', [
        {type: 'document', nesting: 1}
        {type: 'thematic_break'}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-21
    # http://spec.commonmark.org/0.27/#example-22
    # http://spec.commonmark.org/0.27/#example-23
    it "should work with spaces between the characters", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, ' - - -', [
            {type: 'document', nesting: 1}
            {type: 'thematic_break'}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, ' **  * ** * ** * **', [
            {type: 'document', nesting: 1}
            {type: 'thematic_break'}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '-     -      -      -', [
            {type: 'document', nesting: 1}
            {type: 'thematic_break'}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-24
    it "should work with spaces at the end", (cb) ->
      test.markdown null, '- - - -    ', [
        {type: 'document', nesting: 1}
        {type: 'thematic_break'}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-25
    it "should fail with other characters within the line", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '_ _ _ _ a', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: '_ _ _ _ a'}}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'a------', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: 'a------'}}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '---a---', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', data: {text: '---a---'}}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-26
    it "should fail with different line characters", (cb) ->
      test.markdown null, ' *-*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: '*-*'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-27
    it "should work without blank lines before and after", (cb) ->
      test.markdown null, '- foo\n***\n- bar', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: '- foo'}}
        {type: 'paragraph', nesting: -1}
        {type: 'thematic_break'}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: '- bar'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-28
    it "should interrupt a paragraph", (cb) ->
      test.markdown null, 'foo\n***\nbar', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'foo'}}
        {type: 'paragraph', nesting: -1}
        {type: 'thematic_break'}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bar'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-29
    it "should fail if line may interpreted as setext", (cb) ->
      test.markdown null, 'Foo\n---\nbar', [
        {type: 'document', nesting: 1}
        {type: 'heading', data: {level: 2}, nesting: 1}
        {type: 'text', data: {text: 'Foo'}}
        {type: 'heading', data: {level: 2}, nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bar'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

#When both a thematic break and a list item are possible interpretations of a line, the thematic break takes precedence:
#Example 30Try It
#
#* Foo
#* * *
#* Bar
#
#<ul>
#<li>Foo</li>
#</ul>
#<hr />
#<ul>
#<li>Bar</li>
#</ul>
#
#If you want a thematic break in a list item, use a different bullet:
#Example 31Try It
#
#- Foo
#- * * *
#
#<ul>
#<li>Foo</li>
#<li>
#<hr />
