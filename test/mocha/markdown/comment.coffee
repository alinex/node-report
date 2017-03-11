### eslint-env node, mocha ###
test = require '../test'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "comment", ->

  describe "markdown", ->

    describe "raw", ->

      it "should add block html", (cb) ->
        test.markdown null, "<!-- @html <hr> -->", [
          {type: 'document', nesting: 1}
          {type: 'raw', format: 'html', content: '<hr>'}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should add inline html", (cb) ->
        test.markdown null, "pppp<!-- @html <hr> -->", [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'pppp'}
          {type: 'raw', format: 'html', content: '<hr>'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should add block text", (cb) ->
        test.markdown null, "<!-- @text foo -->", [
          {type: 'document', nesting: 1}
          {type: 'raw', format: 'text', content: 'foo'}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should add inline text", (cb) ->
        test.markdown null, "pppp<!-- @text foo -->", [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'pppp'}
          {type: 'raw', format: 'text', content: 'foo'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should add block roff", (cb) ->
        test.markdown null, "<!-- @roff foo -->", [
          {type: 'document', nesting: 1}
          {type: 'raw', format: 'roff', content: 'foo'}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should add inline roff", (cb) ->
        test.markdown null, "pppp<!-- @roff foo -->", [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'pppp'}
          {type: 'raw', format: 'roff', content: 'foo'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

    describe "style", ->

      it "should add block style", (cb) ->
        test.markdown null, "<!-- @html {.red} -->", [
          {type: 'document', nesting: 1}
          {type: 'style', format: 'html', content: '.red'}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should add inline style", (cb) ->
        test.markdown null, "pppp<!-- @html {.red} -->", [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'pppp'}
          {type: 'style', format: 'html', content: '.red'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should add block style (short version)", (cb) ->
        test.markdown null, "<!-- {.red} -->", [
          {type: 'document', nesting: 1}
          {type: 'style', format: 'html', content: '.red'}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should add inline style (short version)", (cb) ->
        test.markdown null, "pppp<!-- {.red} -->", [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'pppp'}
          {type: 'style', format: 'html', content: '.red'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

    describe "comment", ->

      it "should add block comment", (cb) ->
        test.markdown null, "<!-- comment -->", [
          {type: 'document', nesting: 1}
          {type: 'comment', content: 'comment'}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should add inline comment", (cb) ->
        test.markdown null, "pppp<!-- comment -->", [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'pppp'}
          {type: 'comment', content: 'comment'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
