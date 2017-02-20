### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe.only "markdown raw html", ->

  describe "block", ->

    # http://spec.commonmark.org/0.27/#example-115
    # http://spec.commonmark.org/0.27/#example-116
    it "should parse simple link", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '\n<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table>\n\nokay.', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table>', format: 'html', block: true}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'okay.'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, ' <div>\n  *hello*\n         <foo><a>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: ' <div>\n  *hello*\n         <foo><a>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-117
    it "should allow to start with closing tag", (cb) ->
      test.markdown null, '</div>\n*foo*', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '</div>\n*foo*', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-118
    it "should work with html blocks and markdown", (cb) ->
      test.markdown null, '<DIV CLASS="foo">\n\n*Markdown*\n\n</DIV>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<DIV CLASS="foo">', format: 'html', block: true}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'Markdown'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'raw', content: '</DIV>', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-119
    # http://spec.commonmark.org/0.27/#example-120
    it "should allow the first tag to be split at whitespace position", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<div id="foo"\n  class="bar">\n</div>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div id="foo"\n  class="bar">\n</div>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<div id="foo" class="bar\n  baz">\n</div>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div id="foo" class="bar\n  baz">\n</div>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-121
    it "should allow unclosed open tag", (cb) ->
      test.markdown null, '<div>\n*foo*\n\n*bar*', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<div>\n*foo*', format: 'html', block: true}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-122
    # http://spec.commonmark.org/0.27/#example-123
    it "should work with incomplete tags", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<div id="foo"\n*hi*', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div id="foo"\n*hi*', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<div class\nfoo', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div class\nfoo', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-124
    it "should allow unclosed open tag", (cb) ->
      test.markdown null, '<div *???-&&&-<---\n*foo*', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<div *???-&&&-<---\n*foo*', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-125
    # http://spec.commonmark.org/0.27/#example-126
    it "should allow on one or multiple lines", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<div><a href="bar">*foo*</a></div>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div><a href="bar">*foo*</a></div>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<table><tr><td>\nfoo\n</td></tr></table>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<table><tr><td>\nfoo\n</td></tr></table>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-127
    it "should contain everything till next blank line", (cb) ->
      test.markdown null, '<div></div>\n``` c\nint x = 33;\n```', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<div></div>\n``` c\nint x = 33;\n```', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-128
    it "should allow tags which are noit block level only if they are complete in first line", (cb) ->
      test.markdown null, '<a href="foo">\n*bar*\n</a>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<a href="foo">\n*bar*\n</a>', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-129
    # http://spec.commonmark.org/0.27/#example-130
    # http://spec.commonmark.org/0.27/#example-131
    it "should allow any tag if complete in first line", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<Warning>\n*bar*\n</Warning>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<Warning>\n*bar*\n</Warning>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<i class="foo">\n*bar*\n</i>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<i class="foo">\n*bar*\n</i>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '</ins>\n*bar*', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '</ins>\n*bar*', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-132
    it "should be made if inline tag is on first line by itself", (cb) ->
      test.markdown null, '<del>\n*foo*\n</del>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<del>\n*foo*\n</del>', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-133
    it "should be made if close tag is on first line by itself", (cb) ->
      test.markdown null, '<del>\n\n*foo*\n\n</del>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<del>', format: 'html', block: true}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'raw', content: '</del>', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-134
    it "should fail if not by itself and render as inline", (cb) ->
      test.markdown null, '<del>*foo*</del>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'raw', content: '<del>', format: 'html'}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'raw', content: '</del>', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
