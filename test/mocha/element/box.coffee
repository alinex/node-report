### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "box", ->

  describe "examples", ->
    @timeout 30000

    it "should allow detail", (cb) ->
      test.markdown 'box/detail', """
        ::: detail
        foo
        :::
        """, null, true, cb

    it "should allow info", (cb) ->
      test.markdown 'box/info', """
        ::: info
        foo
        :::
        """, null, true, cb

    it "should allow ok", (cb) ->
      test.markdown 'box/ok', """
        ::: ok
        foo
        :::
        """, null, true, cb

    it "should allow warning", (cb) ->
      test.markdown 'box/warning', """
        ::: warning
        foo
        :::
        """, null, true, cb

    it "should allow alert", (cb) ->
      test.markdown 'box/alert', """
        ::: alert
        foo
        :::
        """, null, true, cb

    it.only "should allow info", (cb) ->
      test.markdown 'box/multi', """
        ::: info
        foo
        ::: ok
        bar
        :::
        """, null, true, cb

  describe "api", ->
