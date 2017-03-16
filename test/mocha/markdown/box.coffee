### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe.only "markdown block", ->

  describe "single box", ->

    it "should allow simple", (cb) ->
      test.markdown null, """
        :::
        foo
        :::
        """, [
        {type: 'document', nesting: 1}
        {type: 'box', nesting: 1, box: 'detail', title: 'Detail'}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'foo'}, {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow setting type", (cb) ->
      test.markdown null, """
        ::: info
        foo
        :::
        """, [
        {type: 'document', nesting: 1}
        {type: 'box', nesting: 1, box: 'info', title: 'Info'}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'foo'}, {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow setting title", (cb) ->
      test.markdown null, """
        ::: info Message
        foo
        :::
        """, [
        {type: 'document', nesting: 1}
        {type: 'box', nesting: 1, box: 'info', title: 'Message'}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'foo'}, {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow setting title", (cb) ->
      test.markdown null, """
        ::: info Message
        foo
        :::
        """, [
        {type: 'document', nesting: 1}
        {type: 'box', nesting: 1, box: 'info', title: 'Message'}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'foo'}, {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow setting title (with additional spaces)", (cb) ->
      test.markdown null, """
        ::: info            Message
        foo
        :::
        """, [
        {type: 'document', nesting: 1}
        {type: 'box', nesting: 1, box: 'info', title: 'Message'}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'foo'}, {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow setting title (multi word)", (cb) ->
      test.markdown null, """
        ::: info Top Message
        foo
        :::
        """, [
        {type: 'document', nesting: 1}
        {type: 'box', nesting: 1, box: 'info', title: 'Top Message'}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'foo'}, {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow auto closing", (cb) ->
      test.markdown null, """
        :::
        foo
        """, [
        {type: 'document', nesting: 1}
        {type: 'box', nesting: 1, box: 'detail', title: 'Detail'}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'foo'}, {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should allow multibox entry", (cb) ->
      test.markdown null, """
        ::: info
        foo
        ::: warning
        bar
        :::
        """, [
        {type: 'document', nesting: 1}
        {type: 'box', nesting: 1, box: 'info', title: 'Info', concat: true}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'foo'}, {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1, concat: true}
        {type: 'box', nesting: 1, box: 'warning', title: 'Warning'}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'bar'}, {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
