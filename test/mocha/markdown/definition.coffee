### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown definition", ->

  describe "colon format", ->

    it "should allow simple", (cb) ->
      test.markdown null, """
        Term 1
        :   Definition 1
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow indention of colon with spaces", (cb) ->
      test.markdown null, """
        Term 1
           : Definition 1
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow blank line before entry", (cb) ->
      test.markdown null, """
        Term 1

        :   Definition 1
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow multiple definitions", (cb) ->
      test.markdown null, """
        Term 1
        :   Definition 1
        :   Definition 2
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 2'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow with continuation", (cb) ->
      test.markdown null, """
        Term 1
        :   Definition 1
            goes further on
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Definition 1'}
        {type: 'softbreak'}
        {type: 'text', content: 'goes further on'}
        {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow with lazy continuation", (cb) ->
      test.markdown null, """
        Term 1
        :   Definition 1
        goes further on
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Definition 1'}
        {type: 'softbreak'}
        {type: 'text', content: 'goes further on'}
        {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow multiple terms", (cb) ->
      test.markdown null, """
        Term 1
        :   Definition 1

        Term 2
        :   Definition 2
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 2'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 2'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "tilde format", ->

    it "should allow simple", (cb) ->
      test.markdown null, """
        Term 1
          ~ Definition 1
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow multiple", (cb) ->
      test.markdown null, """
        Term 1
          ~ Definition 1
          ~ Definition 2
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 2'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "contents", ->

    it "should allow multiple paragraphs", (cb) ->
      test.markdown null, """
        Term 1
        :   Definition 1

            Definition 2
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 2'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow preformatted", (cb) ->
      test.markdown null, """
        Term 1

          : Definition 1

                Preformatted text
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'preformatted', nesting: 1}, {type: 'text', content: 'Preformatted text'}, {type: 'preformatted', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
