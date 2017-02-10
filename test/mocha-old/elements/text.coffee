chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown text", ->

  describe "special character", ->

    # http://spec.commonmark.org/0.27/#example-287
    it "should remove backslash before ASCII punctuation", (cb) ->
      test.markdown null, '\\!\\"\\#\\$\\%\\&\\\'\\(\\)\\*\\+\\,\\-\\.\\/\\:\\;\\<\\=\\>\\?\\@\\[\\\\\\]\\^\\_\\`\\{\\|\\}\\~', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text:   '!"#$%&\'()*+,-./:;<=>?@[\\\\]\\^\\_`{|}\\~'}
        {format: 'text', text: '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'}
        {format: 'html', text: '!&quot;#$%&amp;&#39;()*+,-./:;&lt;=&gt;?@[\\]^_`{|}~'}
      ], cb

    # http://spec.commonmark.org/0.27/#example-288
    it "should keep backslash before other characters", (cb) ->
      test.markdown null, '\\→\\A\\a\\ \\3\\φ\\«', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: '\\→\\A\\a\\ \\3\\φ\\«'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-289
    it "should not interpret markdown if escaped", (cb) ->
      test.markdown null, """
        \\*not emphasized*
        \\<br/> not a tag
        \\[not a link](/foo)
        \\`not code`
        1\\. not a list
        \\* not a list
        \\# not a heading
        \\[foo]: /url "not a reference"
      """, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: "
          *not emphasized*
          <br/> not a tag
          [not a link](/foo)
          `not code`
          1. not a list
          * not a list
          # not a heading
          [foo]: /url \"not a reference\"
        "}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-290
    it "should interpret element if backslash is escaped itself", (cb) ->
      test.markdown null, '\\\\*emphasis*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: '\\'}}
        {type: 'emphasis', nesting: 1}
        {type: 'text', data: {text: 'emphasis'}}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-291
    it "should interpret hard line break", (cb) ->
      test.markdown null, 'foo\\\nbar', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'foo\nbar'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

#    # http://spec.commonmark.org/0.27/#example-292-296
#    it "should keep backslash escapes in preformatted or typewriter style", (cb) ->
#      test.markdown null, '`` \[\` ``', [
#        {type: 'document', nesting: 1}
#        {type: 'paragraph', nesting: 1}
#        {type: 'typewriter', nesting: 1}
#        {type: 'text', data: {text: '\[\`'}}
#        {type: 'typewriter', nesting: -1}
#        {type: 'paragraph', nesting: -1}
#        {type: 'document', nesting: -1}
#      ], null, cb
####################################### more to come
