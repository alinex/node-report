### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown strikethrough", ->

  it "should work with simpel example", (cb) ->
    test.markdown null, '~~foo bar~~', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'strikethrough', nesting: 1}
      {type: 'text', content: 'foo bar'}
      {type: 'strikethrough', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should fail if to less markers", (cb) ->
    test.markdown null, '~foo bar~', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: '~foo bar~'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should use inner markers if too much", (cb) ->
    test.markdown null, '~~~foo bar~~~', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: '~'}
      {type: 'strikethrough', nesting: 1}
      {type: 'text', content: 'foo bar'}
      {type: 'strikethrough', nesting: -1}
      {type: 'text', content: '~'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should allow in emphasis", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '_~~foo bar~~_', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'emphasis', nesting: 1}
          {type: 'strikethrough', nesting: 1}
          {type: 'text', content: 'foo bar'}
          {type: 'strikethrough', nesting: -1}
          {type: 'emphasis', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '**~~foo bar~~**', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'strong', nesting: 1}
          {type: 'strikethrough', nesting: 1}
          {type: 'text', content: 'foo bar'}
          {type: 'strikethrough', nesting: -1}
          {type: 'strong', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  it "should have precedence for first opened element", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '_~~foo bar_~~', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'emphasis', nesting: 1}
          {type: 'text', content: '~~foo bar'}
          {type: 'emphasis', nesting: -1}
          {type: 'text', content: '~~'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '~~_foo bar~~_', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'strikethrough', nesting: 1}
          {type: 'text', content: '_foo bar'}
          {type: 'strikethrough', nesting: -1}
          {type: 'text', content: '_'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb
