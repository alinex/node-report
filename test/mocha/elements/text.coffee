### eslint-env node, mocha ###
test = require './test'

describe "parser", ->

  describe "markdown", ->

    describe.skip "text", ->

      it "should remove backslash before initial # character", ->
        test.success '\\## foo', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '## foo'}}
          {type: 'paragraph', nesting: -1}
        ]

      it "should remove backslash before ASCII punctuation", ->
        test.success '\\!\\"\\#\\$\\%\\&\\\'\\(\\)\\*\\+\\,\\-\\.\\/\\:\\;\\<\\=\\>\\?\\@\\[\\\\\\]\\^\\_\\`\\{\\|\\}\\~', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'}}
          {type: 'paragraph', nesting: -1}
        ]

      it "should keep backslash before other characters", ->
        test.success '\\→\\A\\a\\ \\3\\φ\\«', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '\\→\\A\\a\\ \\3\\φ\\«'}}
          {type: 'paragraph', nesting: -1}
        ]

      it "should not interpret markdown if escaped", ->
        test.success """
          \\*not emphasized*
          \\<br/> not a tag
          \\[not a link](/foo)
          \\`not code`
          1\\. not a list
          \\* not a list
          \\# not a heading
          \\[foo]: /url "not a reference"
          """, [
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
        ]

      it "should interpret element if backslash is escaped itself", ->
        test.success '\\\\`hi`', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '\\'}}
          {type: 'code', nesting: 1}
          {type: 'text', data: {text: 'hi'}}
          {type: 'code', nesting: -1}
          {type: 'paragraph', nesting: -1}
        ]
