### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'
Table = require 'alinex-table'

describe.only "table", ->
  @timeout 5000

  describe "from alinex-table", ->

    table = null

    beforeEach ->
      table = new Table [
        ['ID', 'English', 'German']
        [1, 'one', 'eins']
        [2, 'two', 'zw_ei']
        [3, 'three', 'drei']
        [12, 'twelve', 'zwölf']
      ]

    it "should create table", (cb) ->
      report = new Report()
      report.table table
      test.report 'table-alinex', report, """

        | ID | English | German |
        |:-- |:------- |:------ |
        | 1  | one     | eins   |
        | 2  | two     | zw_ei  |
        | 3  | three   | drei   |
        | 12 | twelve  | zwölf  |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">ID</th>
        <th style="text-align:left">English</th>
        <th style="text-align:left">German</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">1</td>
        <td style="text-align:left">one</td>
        <td style="text-align:left">eins</td>
        </tr>
        <tr>
        <td style="text-align:left">2</td>
        <td style="text-align:left">two</td>
        <td style="text-align:left">zw_ei</td>
        </tr>
        <tr>
        <td style="text-align:left">3</td>
        <td style="text-align:left">three</td>
        <td style="text-align:left">drei</td>
        </tr>
        <tr>
        <td style="text-align:left">12</td>
        <td style="text-align:left">twelve</td>
        <td style="text-align:left">zwölf</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

    it "should align column", (cb) ->
      table.style null, 'ID', {align: 'right'}
      report = new Report()
      report.table table
      test.report 'table-alinex-align', report, """

        | ID | English | German |
        | --:|:------- |:------ |
        |  1 | one     | eins   |
        |  2 | two     | zw_ei  |
        |  3 | three   | drei   |
        | 12 | twelve  | zwölf  |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:right">ID</th>
        <th style="text-align:left">English</th>
        <th style="text-align:left">German</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:right">1</td>
        <td style="text-align:left">one</td>
        <td style="text-align:left">eins</td>
        </tr>
        <tr>
        <td style="text-align:right">2</td>
        <td style="text-align:left">two</td>
        <td style="text-align:left">zw_ei</td>
        </tr>
        <tr>
        <td style="text-align:right">3</td>
        <td style="text-align:left">three</td>
        <td style="text-align:left">drei</td>
        </tr>
        <tr>
        <td style="text-align:right">12</td>
        <td style="text-align:left">twelve</td>
        <td style="text-align:left">zwölf</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

    it "should support mask", (cb) ->
      report = new Report()
      report.table table, null, null, true
      test.report 'table-alinex-mask', report, """

        | ID | English | German |
        |:-- |:------- |:------ |
        | 1  | one     | eins   |
        | 2  | two     | zw\_ei |
        | 3  | three   | drei   |
        | 12 | twelve  | zwölf  |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">ID</th>
        <th style="text-align:left">English</th>
        <th style="text-align:left">German</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">1</td>
        <td style="text-align:left">one</td>
        <td style="text-align:left">eins</td>
        </tr>
        <tr>
        <td style="text-align:left">2</td>
        <td style="text-align:left">two</td>
        <td style="text-align:left">zw_ei</td>
        </tr>
        <tr>
        <td style="text-align:left">3</td>
        <td style="text-align:left">three</td>
        <td style="text-align:left">drei</td>
        </tr>
        <tr>
        <td style="text-align:left">12</td>
        <td style="text-align:left">twelve</td>
        <td style="text-align:left">zwölf</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

  describe "from ", ->
