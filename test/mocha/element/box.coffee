### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "box", ->

  describe.only "examples", ->
    @timeout 30000

    it "should allow detail", (cb) ->
      test.markdown 'box/detail', """
        ::: detail
        Some details here...
        :::
        """, null, true, cb

    it "should allow info", (cb) ->
      test.markdown 'box/info', """
        ::: info
        And a little information to help you...
        :::
        """, null, true, cb

    it "should allow ok", (cb) ->
      test.markdown 'box/ok', """
        ::: ok
        Everything works fine.
        :::
        """, null, true, cb

    it "should allow warning", (cb) ->
      test.markdown 'box/warning', """
        ::: warning
        Some orders have to wait till later...
        :::
        """, null, true, cb

    it "should allow alert", (cb) ->
      test.markdown 'box/alert', """
        ::: alert
        The process failed at...
        :::
        """, null, true, cb

    it "should allow info", (cb) ->
      test.markdown 'box/multi', """
        ::: info
        foo
        ::: ok
        bar
        :::
        """, null, true, cb

  describe "api", ->
