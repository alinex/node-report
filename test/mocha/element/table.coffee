### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb
Table = require 'alinex-table'

describe "table", ->

  describe "examples", ->

    it "should make two tables", (cb) ->
      test.markdown 'table/align', """
      | Left-aligned | Center-aligned | Right-aligned |
      | :---         |     :---:      |          ---: |
      | 1            | one            | eins          |
      | 2            | two            | zwei          |
      | 3            | three          | drei          |
      | 4            | four           | vier          |
      | 5            | five           | fünf          |
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'console'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe.only "api", ->

    describe "from alinex-table", ->

      table = null

      beforeEach ->
        table = new Table [
          ['ID', 'English', 'German']
          [1, 'one', 'eins']
          [2, 'two', '_zwei_']
          [12, 'twelve', 'zwölf']
        ]

      it "should create table", (cb) ->
        # create report
        report = new Report()
        report.table table
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'ID'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'English'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'German'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'one'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'eins'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: '_zwei_'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'twelve'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwölf'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should align column", (cb) ->
        table.style null, 'ID', {align: 'right'}
        report = new Report()
        report.table table
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'right'}, {type: 'text', content: 'ID'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'English'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'German'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'one'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'eins'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: '_zwei_'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'twelve'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwölf'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should allow markdown within", (cb) ->
        table.style null, 'ID', {align: 'right'}
        report = new Report()
        report.table table, true
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'right'}, {type: 'text', content: 'ID'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'English'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'German'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'one'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'eins'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'emphasis'}, {type: 'text', content: 'zwei'}, {type: 'emphasis'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'twelve'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwölf'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

# test inline markdown

    describe "from list map", ->

      table = [
        {id: 1, en: 'one', de: 'eins'}
        {id: 2, en: 'two', de: 'zwei'}
        {id: 3, en: 'three', de: 'drei'}
        {id: 12, en: 'twelve', de: 'zwölf'}
      ]

#      it "should create table", (cb) ->
#        report = new Report()
#        report.table table
