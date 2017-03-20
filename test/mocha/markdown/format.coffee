### eslint-env node, mocha ###
test = require '../test'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown format", ->

  describe "mark", ->

    it "should work", (cb) ->
      test.markdown null, "==marked==", [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'mark', nesting: 1}
        {type: 'text', content: 'marked'}
        {type: 'mark', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "insert", ->

    it "should work", (cb) ->
      test.markdown null, "++inserted++", [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'insert', nesting: 1}
        {type: 'text', content: 'inserted'}
        {type: 'insert', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "sub", ->

    it "should work", (cb) ->
      test.markdown null, "H~2~O", [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'H'}
        {type: 'subscript', nesting: 1}
        {type: 'text', content: '2'}
        {type: 'subscript', nesting: -1}
        {type: 'text', content: 'O'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "sup", ->

    it "should work", (cb) ->
      test.markdown null, "29^th^", [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '29'}
        {type: 'superscript', nesting: 1}
        {type: 'text', content: 'th'}
        {type: 'superscript', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
