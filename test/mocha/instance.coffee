chai = require 'chai'
expect = chai.expect
util = require 'util'
debug = require('debug')('test:instance')

Report = require '../../src/index'
{string} = require 'alinex-util'

equal = (a, b) ->
  debug "result", a
#  console.log util.inspect a
#  console.log util.inspect b
  expect(a, 'result').to.equal b

describe "instance", ->

  describe "create markdown", ->

    report = new Report()

    it "should add a heading 1", ->
      report.h1 'My Test'
      equal report.toString(), """
      My Test
      ================================================================================\n
      """
    it "should add a heading 2", ->
      report.h2 'Subheading'
      equal report.toString(), """
      My Test
      ================================================================================


      Subheading
      --------------------------------------------------------------------------------\n
      """
    it "should add a paragraph", ->
      report.p 'This is my first paragraph in this example which will show how it will break in
      markdown syntax.'
      equal report.toString(), """
      My Test
      ================================================================================


      Subheading
      --------------------------------------------------------------------------------

      This is my first paragraph in this example which will show how it will break in
      markdown syntax.\n
      """
    it "should add a list", ->
      report.ul ['one', 'two', 'three']
      equal report.toString(), """
      My Test
      ================================================================================


      Subheading
      --------------------------------------------------------------------------------

      This is my first paragraph in this example which will show how it will break in
      markdown syntax.

      - one
      - two
      - three\n
      """
