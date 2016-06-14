### eslint-env node, mocha ###
Report = require '../../src/index'

describe "jQuery table", ->

  it "should create table with sort and search", (done) ->
    @timeout 20000

    report = new Report()
    report.toc()
    report.h1 "Table with Search and Sort"
    report.table [
      {id: 1, en: 'one', de: 'eins'}
      {id: 2, en: 'two', de: 'zwei'}
      {id: 3, en: 'three', de: 'drei'}
      {id: 12, en: 'twelve', de: 'zwölf'}
    ],
      id:
        title: 'ID'
        align: 'right'
      de:
        title: 'German'
      en:
        title: 'English'
    report.html 'js', """
      $(document).ready( function () {
        $('table').DataTable({
          "paging":   false,
          "info":     false
        });
      });
      """
    fs = require 'fs'
    fd = fs.createWriteStream "#{__dirname}/../../src/doc/table-sortSearch.html"
    report.toHtml (err, data) ->
      fd.write data
      fd.end()
      done()
