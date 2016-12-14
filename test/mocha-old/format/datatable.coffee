### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'
Table = require 'alinex-table'

describe "visual datatable", ->
  @timeout 10000

  it "should create simple datatable", (cb) ->
    report = new Report()
    report.datatable new Table([
      ['ID', 'English', 'German']
      [1, 'one', 'eins']
      [2, 'two', 'zw_ei']
      [3, 'three', 'drei']
      [12, 'twelve', 'zwölf']
    ])
    test.report 'datatable', report, """

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
        "info": false,
        "searching": false
      });
      });
      $$$

      """, null, cb

  it "should have all features", (cb) ->
    report = new Report()
    report.datatable new Table([
      ['ID', 'English', 'German']
      [1, 'one', 'eins']
      [2, 'two', 'zwei']
      [3, 'three', 'drei']
      [4, 'four', 'vier']
      [5, 'five', 'fünf']
      [6, 'six', 'sechs']
      [7, 'seven', 'sieben']
      [8, 'eight', 'acht']
      [9, 'nine', 'neun']
      [10, 'ten', 'zehn']
      [11, 'eleven', 'elf']
      [12, 'twelve', 'zwölf']
    ]),
      info: true
      paging: true
      searching: true
    test.report 'datatable-features', report, """

      | ID | English | German |
      |:-- |:------- |:------ |
      | 1  | one     | eins   |
      | 2  | two     | zwei   |
      | 3  | three   | drei   |
      | 4  | four    | vier   |
      | 5  | five    | fünf   |
      | 6  | six     | sechs  |
      | 7  | seven   | sieben |
      | 8  | eight   | acht   |
      | 9  | nine    | neun   |
      | 10 | ten     | zehn   |
      | 11 | eleven  | elf    |
      | 12 | twelve  | zwölf  |
      <!-- {table:#datatable1} -->
      $$$ js
      $(document).ready(function () {
        $('#datatable1').DataTable({
        "info": true,
        "paging": true,
        "searching": true
      });
      });
      $$$

      """, null, cb
