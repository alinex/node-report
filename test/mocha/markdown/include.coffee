### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown include", ->

  describe "local", ->

    it "should allow simple", (cb) ->
      test.markdown null, "@[](src/examples/paragraph/multiple.md)", [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'This is an example of two paragraphs in markdown style there the separation'}
        {type: 'softbreak'}
        {type: 'text', content: 'between them is done with an empty line.'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'This follows the common definition of markdown.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow within text", (cb) ->
      test.markdown null, "123@[](src/examples/paragraph/multiple.md)456", [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '123This is an example of two paragraphs in markdown style there the separation'}
        {type: 'softbreak'}
        {type: 'text', content: 'between them is done with an empty line.'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'This follows the common definition of markdown.456'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should work in preformatted text", (cb) ->
      test.markdown null, "    @[](src/examples/paragraph/multiple.md)", [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: """
          This is an example of two paragraphs in markdown style there the separation
          between them is done with an empty line.

          This follows the common definition of markdown.
          """}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should work in code", (cb) ->
      test.markdown null, "``` markdown\n@[](src/examples/paragraph/multiple.md)\n```", [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1, language: 'markdown'}
        {type: 'text', content: """
          This is an example of two paragraphs in markdown style there the separation
          between them is done with an empty line.

          This follows the common definition of markdown.
          """}
        {type: 'code', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should work in blockquote", (cb) ->
      test.markdown null, "> @[](src/examples/paragraph/multiple.md)", [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'This is an example of two paragraphs in markdown style there the separation'}
        {type: 'softbreak'}
        {type: 'text', content: 'between them is done with an empty line.'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'This follows the common definition of markdown.'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should auto create code element", (cb) ->
      test.markdown null, "@[code](src/examples/paragraph/multiple.md)", [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1, language: 'markdown'}
        {type: 'text', content: """
          This is an example of two paragraphs in markdown style there the separation
          between them is done with an empty line.

          This follows the common definition of markdown.
          """}
        {type: 'code', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should auto create preformatted text", (cb) ->
      test.markdown null, "@[pre](src/examples/paragraph/multiple.md)", [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: """
          This is an example of two paragraphs in markdown style there the separation
          between them is done with an empty line.

          This follows the common definition of markdown.
          """}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
