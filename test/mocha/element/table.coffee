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
      """, null, true, cb

  describe "api", ->

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

    describe "from list map", ->

      table = [
        {id: 1, en: 'one', de: 'eins'}
        {id: 2, en: 'two', de: 'zwei'}
        {id: 12, en: 'twelve', de: 'zwölf'}
      ]

      it "should create table", (cb) ->
        report = new Report()
        report.table table
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'id'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'en'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'de'}, {type: 'th', nesting: -1}
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
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwei'}, {type: 'td', nesting: -1}
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

      it "should create table with column map-map", (cb) ->
        columns =
          id:
            title: 'ID'
            align: 'right'
          de:
            title: 'German'
          en:
            title: 'English'
        report = new Report()
        report.table table, columns
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'right'}, {type: 'text', content: 'ID'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'German'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'English'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'eins'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'one'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwei'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwölf'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'twelve'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should create table with column list array", (cb) ->
        columns = [
          ['id', 'en']
          ['ID', 'English']
        ]
        report = new Report()
        report.table table, columns
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'ID'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'English'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'one'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'twelve'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should create table with column list", (cb) ->
        columns = ['ID', 'English', 'German']
        report = new Report()
        report.table table, columns
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
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwei'}, {type: 'td', nesting: -1}
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

      it "should create table with column map", (cb) ->
        columns =
          id: 'ID'
          en: 'English'
        report = new Report()
        report.table table, columns
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'ID'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'English'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'one'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'twelve'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should create table with sort map", (cb) ->
        columns =
          id:
            title: 'ID'
            align: 'right'
          de:
            title: 'German'
          en:
            title: 'English'
        sort = {de: 'desc'}
        report = new Report()
        report.table table, columns, sort
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'right'}, {type: 'text', content: 'ID'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'German'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'English'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwölf'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'twelve'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwei'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'eins'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'one'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should create table with sort list", (cb) ->
        columns =
          id:
            title: 'ID'
            align: 'right'
          de:
            title: 'German'
          en:
            title: 'English'
        sort = ['de']
        report = new Report()
        report.table table, columns, sort
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'right'}, {type: 'text', content: 'ID'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'German'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'English'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'eins'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'one'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwei'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwölf'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'twelve'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should create table with sort key", (cb) ->
        columns =
          id:
            title: 'ID'
            align: 'right'
          de:
            title: 'German'
          en:
            title: 'English'
        sort = 'de'
        report = new Report()
        report.table table, columns, sort
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'right'}, {type: 'text', content: 'ID'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'German'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'English'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'eins'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'one'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwei'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwölf'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'twelve'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

    describe "from list array", ->

      table = null

      beforeEach ->
        table = [
          [1, 'one', 'eins']
          [2, 'two', 'zwei']
          [3, 'three', 'drei']
          [12, 'twelve', 'zwölf']
        ]

      it "should create table", (cb) ->
        report = new Report()
        report.table table
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 1}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'one'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'eins'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwei'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '3'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'three'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'drei'}, {type: 'td', nesting: -1}
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

      it "should create table with column list", (cb) ->
        columns = ['ID', 'English', 'German']
        report = new Report()
        report.table table, columns
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
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwei'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '3'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'three'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'drei'}, {type: 'td', nesting: -1}
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

      it "should create table with column list-array", (cb) ->
        columns = [
          [0, 1]
          ['ID', 'English']
        ]
        report = new Report()
        report.table table, columns
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'ID'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'English'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'one'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'two'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '3'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'three'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'twelve'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should create table with column list-map", (cb) ->
        columns = [
          title: 'ID'
          align: 'right'
        ,
          title: 'English'
        ,
          title: 'German'
        ]
        report = new Report()
        report.table table, columns
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
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwei'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '3'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'three'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'drei'}, {type: 'td', nesting: -1}
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

      it "should create table with empty fields", (cb) ->
        report = new Report()
        report.table [
          [1, 'one', 'eins']
          [2, '', 'zwei']
          [3, null, 'drei']
          [12, undefined, 'zwölf']
        ]
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 1}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'one'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'eins'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '2'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: ''}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwei'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '3'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: ''}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'drei'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: '12'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: ''}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'zwölf'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

    describe "from map", ->

      table = null

      beforeEach ->
        table =
          id: '001'
          name: 'alex'
          position: 'developer'

      it "should create table", (cb) ->
        report = new Report()
        report.table table
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'Name'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'Value'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'id'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: '001'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'name'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'alex'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'position'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'developer'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should create table with column list", (cb) ->
        columns = ['NAME', 'VALUE']
        report = new Report()
        report.table table, columns
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'NAME'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'VALUE'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'id'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: '001'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'name'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'alex'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'position'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'developer'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should create table with list and object content", (cb) ->
        report = new Report()
        report.table
          number: [1..8]
          name: 'alex'
          data:
            type: 'developer'
            lang: 'javascript'
        # check it
        test.report null, report, [
          {type: 'document', nesting: 1}
          {type: 'table', nesting: 1}
          {type: 'thead', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'Name'}, {type: 'th', nesting: -1}
          {type: 'th', nesting: 1, align: 'left'}, {type: 'text', content: 'Value'}, {type: 'th', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'thead', nesting: -1}
          {type: 'tbody', nesting: 1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'number'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: '1, 2, 3, 4, 5, 6, 7, 8'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'name'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'alex'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'data.type'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'developer'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tr', nesting: 1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'data.lang'}, {type: 'td', nesting: -1}
          {type: 'td', nesting: 1}, {type: 'text', content: 'javascript'}, {type: 'td', nesting: -1}
          {type: 'tr', nesting: -1}
          {type: 'tbody', nesting: -1}
          {type: 'table', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
