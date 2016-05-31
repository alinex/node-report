chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug')('test:table')
Report = require '../../src/index'
Table = require 'alinex-table'

table = null

equal = (a, b) ->
  debug "result", a
#  console.log util.inspect a
#  console.log util.inspect b
  expect(a, 'result').to.equal b

describe "table", ->

  beforeEach ->
    table = new Table [
      ['ID', 'English', 'German']
      [1, 'one', 'eins']
      [2, 'two', 'zw_ei']
      [3, 'three', 'drei']
      [12, 'twelve', 'zwölf']
    ]

  describe "raw", ->

    it "should format instance", ->
      equal Report.table(table), """
      \n| ID | English | German |
      |:-- |:------- |:------ |
      | 1  | one     | eins   |
      | 2  | two     | zw_ei  |
      | 3  | three   | drei   |
      | 12 | twelve  | zwölf  |\n"""

  describe "style", ->

    it "should support align style", ->
      table.style null, 'ID', {align: 'right'}
      equal Report.table(table), """
      \n| ID | English | German |
      | --:|:------- |:------ |
      |  1 | one     | eins   |
      |  2 | two     | zw_ei  |
      |  3 | three   | drei   |
      | 12 | twelve  | zwölf  |\n"""

  describe "settings", ->

    it "should support mask", ->
      equal Report.table(table, null, null, true), """
      \n| ID | English | German |
      |:-- |:------- |:------ |
      | 1  | one     | eins   |
      | 2  | two     | zw\\_ei |
      | 3  | three   | drei   |
      | 12 | twelve  | zwölf  |\n"""
