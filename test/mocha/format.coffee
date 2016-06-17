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

  describe "table", ->

    objListMap = [
      {id: 1, en: 'one', de: 'eins'}
      {id: 2, en: 'two', de: 'zwei'}
      {id: 3, en: 'three', de: 'drei'}
      {id: 12, en: 'twelve', de: 'zwölf'}
    ]
    objListArray = [
      [1, 'one', 'eins']
      [2, 'two', 'zwei']
      [3, 'three', 'drei']
      [12, 'twelve', 'zwölf']
    ]
    objListArrayEmpty = [
      [1, 'one', 'eins']
      [2, '', 'zwei']
      [3, null, 'drei']
      [12, undefined, 'zwölf']
    ]
    objMap =
      id: '001'
      name: 'alex'
      position: 'developer'

    colMapMap =
      id:
        title: 'ID'
        align: 'right'
      de:
        title: 'German'
      en:
        title: 'English'
    colList = ['ID', 'English', 'German']
    colListArray = [
      ['id', 'en']
      ['ID', 'English']
    ]
    colArrayArray = [
      [0, 1]
      ['ID', 'English']
    ]
    colMap =
      id: 'ID'
      en: 'English'
    colArrayMap = [
        title: 'ID'
        align: 'right'
      ,
        title: 'English'
      ,
        title: 'German'
      ]

    sortMap = {de: 'desc'}
    sortList = ['de']
    sortKey = 'de'

    it "should format obj-list-map with col-map-map", ->
      equal Report.table(objListMap, colMapMap), """
      \n| ID | German | English |
      | --:|:------ |:------- |
      |  1 | eins   | one     |
      |  2 | zwei   | two     |
      |  3 | drei   | three   |
      | 12 | zwölf  | twelve  |\n"""
    it "should format obj-list-map with col-list-array", ->
      equal Report.table(objListMap, colListArray), """
      \n| ID | English |
      |:-- |:------- |
      | 1  | one     |
      | 2  | two     |
      | 3  | three   |
      | 12 | twelve  |\n"""
    it "should format obj-list-map with col-list", ->
      equal Report.table(objListMap, colList), """
      \n| ID | English | German |
      |:-- |:------- |:------ |
      | 1  | one     | eins   |
      | 2  | two     | zwei   |
      | 3  | three   | drei   |
      | 12 | twelve  | zwölf  |\n"""
    it "should format obj-list-map with col-map", ->
      equal Report.table(objListMap, colMap), """
      \n| ID | English |
      |:-- |:------- |
      | 1  | one     |
      | 2  | two     |
      | 3  | three   |
      | 12 | twelve  |\n"""

    it "should resort list using sort-map", ->
      equal Report.table(objListMap, colMapMap, sortMap), """
      \n| ID | German | English |
      | --:|:------ |:------- |
      | 12 | zwölf  | twelve  |
      |  2 | zwei   | two     |
      |  1 | eins   | one     |
      |  3 | drei   | three   |\n"""
    it "should resort list using sort-list", ->
      equal Report.table(objListMap, colMapMap, sortList), """
      \n| ID | German | English |
      | --:|:------ |:------- |
      |  3 | drei   | three   |
      |  1 | eins   | one     |
      |  2 | zwei   | two     |
      | 12 | zwölf  | twelve  |\n"""
    it "should resort list using sort-key", ->
      equal Report.table(objListMap, colMapMap, sortKey), """
      \n| ID | German | English |
      | --:|:------ |:------- |
      |  3 | drei   | three   |
      |  1 | eins   | one     |
      |  2 | zwei   | two     |
      | 12 | zwölf  | twelve  |\n"""
    it "should format obj-list-map without col", ->
      equal Report.table(objListMap), """
      \n| id | en     | de    |
      |:-- |:------ |:----- |
      | 1  | one    | eins  |
      | 2  | two    | zwei  |
      | 3  | three  | drei  |
      | 12 | twelve | zwölf |\n"""

    it "should format obj-list-array", ->
      equal Report.table(objListArray), """
      \n| 1  | one    | eins  |
      |:-- |:------ |:----- |
      | 2  | two    | zwei  |
      | 3  | three  | drei  |
      | 12 | twelve | zwölf |\n"""
    it "should format obj-list-array with col-list", ->
      equal Report.table(objListArray, colList), """
      \n| ID | English | German |
      |:-- |:------- |:------ |
      | 1  | one     | eins   |
      | 2  | two     | zwei   |
      | 3  | three   | drei   |
      | 12 | twelve  | zwölf  |\n"""
    it "should format obj-list-array with col-array-array", ->
      equal Report.table(objListArray, colArrayArray), """
      \n| ID | English |
      |:-- |:------- |
      | 1  | one     |
      | 2  | two     |
      | 3  | three   |
      | 12 | twelve  |\n"""
    it "should format obj-list-array with col-array-map", ->
      equal Report.table(objListArray, colArrayMap), """
      \n| ID | English | German |
      | --:|:------- |:------ |
      |  1 | one     | eins   |
      |  2 | two     | zwei   |
      |  3 | three   | drei   |
      | 12 | twelve  | zwölf  |\n"""
    it "should format obj-list-array with empty fields", ->
      equal Report.table(objListArrayEmpty), """
      \n| 1  | one | eins  |
      |:-- |:--- |:----- |
      | 2  |     | zwei  |
      | 3  |     | drei  |
      | 12 |     | zwölf |\n"""

    it "should format obj-map", ->
      equal Report.table(objMap), """
      \n| Name     | Value     |
      |:-------- |:--------- |
      | id       | 001       |
      | name     | alex      |
      | position | developer |\n"""
    it "should format obj-map with col-array", ->
      equal Report.table(objMap, ['NAME', 'VALUE']), """
      \n| NAME     | VALUE     |
      |:-------- |:--------- |
      | id       | 001       |
      | name     | alex      |
      | position | developer |\n"""

    it "should format obj-map with list and object contents", ->
      obj =
        number: [1..8]
        name: 'alex'
        data:
          type: 'developer'
          lang: 'javascript'
      equal Report.table(obj, ['Name', 'Value']), """
      \n| Name      | Value                  |
      |:--------- |:---------------------- |
      | number    | 1, 2, 3, 4, 5, 6, 7, 8 |
      | name      | alex                   |
      | data.type | developer              |
      | data.lang | javascript             |\n"""

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
