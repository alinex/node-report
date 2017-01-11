chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "text", ->

  describe "examples", ->

    it "should make examples", (cb) ->
      test.markdown 'text/example', "This is a short text.\\\nWith two lines.", null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
      ], cb


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
        {type: 'text', data: {text: 'Simple Text.'}}
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


  describe "markdown", ->

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
        {type: 'text', data: {text: """
          *not emphasized*
          <br/> not a tag
          [not a link](/foo)
          `not code`
          1. not a list
          * not a list
          # not a heading
          [foo]: /url "not a reference"
          """}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-290
    it "should interpret element if backslash is escaped itself", (cb) ->
      test.markdown null, '\\\\`hi`', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: '\\'}}
        {type: 'typewriter', nesting: 1}
        {type: 'text', data: {text: 'hi'}}
        {type: 'typewriter', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

############################### go on example 291
