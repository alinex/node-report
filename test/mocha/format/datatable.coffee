### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'
Table = require 'alinex-table'

describe.only "visual datatable", ->
  @timeout 10000

  it "should create simple datatable", (cb) ->
    report = new Report()
    report.h1 "Interactive Table"
    report.datatable new Table([
      ['ID', 'English', 'German']
      [1, 'one', 'eins']
      [2, 'two', 'zw_ei']
      [3, 'three', 'drei']
      [12, 'twelve', 'zwölf']
    ])
    test.report 'datatable', report, """


      Interactive Table
      ================================================================================

      | ID | English | German |
      |:-- |:------- |:------ |
      | 1  | one     | eins   |
      | 2  | two     | zw_ei  |
      | 3  | three   | drei   |
      | 12 | twelve  | zwölf  |
      <!-- {table:#datatable1} -->
      $$$ js
      $(document).ready(function () {
        $('#datatable1').DataTable({
        "paging": false,
        "info": false
      });
      });
      $$$

      """, null, cb
