chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug')('test:format')
Report = require '../../src/index'

equal = (a, b) ->
  debug "result", a
#  console.log util.inspect a
#  console.log util.inspect b
  expect(a, 'result').to.equal b

describe "format", ->



  describe "special", ->

    it "should make a table of contents in html", ->
      equal Report.toc(), "\n@[toc]\n"

    it "should mask markdown elements", ->
      equal Report.mask("not **bold**"), "not \\*\\*bold\\*\\*"

    it "should mask in table with map", ->
      md = Report.table
        id: '*001*'
        name: 'alex'
        position: 'developer'
      , ['Name', 'Value'], null, true
      equal md, """
      \n| Name     | Value     |
      |:-------- |:--------- |
      | id       | \\*001\\*   |
      | name     | alex      |
      | position | developer |\n"""
      report = new Report
        source: md
      equal report.toText(), """
      | Name     | Value     |
      |:-------- |:--------- |
      | id       | *001*     |
      | name     | alex      |
      | position | developer |"""

    it "should mask in table with array", ->
      md = Report.table [
        [1, 'one', 'eins']
        [2, 't_w_o', 'zwei']
        [3, 'three', 'drei']
        [12, 'twelve', 'zwölf']
      ], null, null, true
      equal md, """
      \n| 1  | one     | eins  |
      |:-- |:------- |:----- |
      | 2  | t\\_w\\_o | zwei  |
      | 3  | three   | drei  |
      | 12 | twelve  | zwölf |\n"""
      report = new Report
        source: md
      equal report.toText(), """
      | 1  | one     | eins  |
      |:-- |:------- |:----- |
      | 2  | t_w_o   | zwei  |
      | 3  | three   | drei  |
      | 12 | twelve  | zwölf |"""
