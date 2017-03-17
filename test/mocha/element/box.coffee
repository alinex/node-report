### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "box", ->

  describe "examples", ->
    @timeout 30000

    it "should allow simple", (cb) ->
      test.markdown 'box/simple', """
        :::
        foo
        :::
        """, null, true, cb

  describe "api", ->
