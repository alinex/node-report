### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'
Table = require 'alinex-table'

describe "table", ->
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
        | 2  | two     | zw\\_ei |
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

  describe "from list map", ->

    table = [
      {id: 1, en: 'one', de: 'eins'}
      {id: 2, en: 'two', de: 'zwei'}
      {id: 3, en: 'three', de: 'drei'}
      {id: 12, en: 'twelve', de: 'zwölf'}
    ]

    it "should create table", (cb) ->
      report = new Report()
      report.table table
      test.report 'table-list-map', report, """

        | id | en     | de    |
        |:-- |:------ |:----- |
        | 1  | one    | eins  |
        | 2  | two    | zwei  |
        | 3  | three  | drei  |
        | 12 | twelve | zwölf |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">id</th>
        <th style="text-align:left">en</th>
        <th style="text-align:left">de</th>
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
        <td style="text-align:left">zwei</td>
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
      test.report 'table-list-map-column-map-map', report, """

        | ID | German | English |
        | --:|:------ |:------- |
        |  1 | eins   | one     |
        |  2 | zwei   | two     |
        |  3 | drei   | three   |
        | 12 | zwölf  | twelve  |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:right">ID</th>
        <th style="text-align:left">German</th>
        <th style="text-align:left">English</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:right">1</td>
        <td style="text-align:left">eins</td>
        <td style="text-align:left">one</td>
        </tr>
        <tr>
        <td style="text-align:right">2</td>
        <td style="text-align:left">zwei</td>
        <td style="text-align:left">two</td>
        </tr>
        <tr>
        <td style="text-align:right">3</td>
        <td style="text-align:left">drei</td>
        <td style="text-align:left">three</td>
        </tr>
        <tr>
        <td style="text-align:right">12</td>
        <td style="text-align:left">zwölf</td>
        <td style="text-align:left">twelve</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

    it "should create table with column list array", (cb) ->
      columns = [
        ['id', 'en']
        ['ID', 'English']
      ]
      report = new Report()
      report.table table, columns
      test.report 'table-list-map-column-list-array', report, """

        | ID | English |
        |:-- |:------- |
        | 1  | one     |
        | 2  | two     |
        | 3  | three   |
        | 12 | twelve  |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">ID</th>
        <th style="text-align:left">English</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">1</td>
        <td style="text-align:left">one</td>
        </tr>
        <tr>
        <td style="text-align:left">2</td>
        <td style="text-align:left">two</td>
        </tr>
        <tr>
        <td style="text-align:left">3</td>
        <td style="text-align:left">three</td>
        </tr>
        <tr>
        <td style="text-align:left">12</td>
        <td style="text-align:left">twelve</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

    it "should create table with column list", (cb) ->
      columns = ['ID', 'English', 'German']
      report = new Report()
      report.table table, columns
      test.report 'table-list-map-column-list', report, """

        | ID | English | German |
        |:-- |:------- |:------ |
        | 1  | one     | eins   |
        | 2  | two     | zwei   |
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
        <td style="text-align:left">zwei</td>
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

    it "should create table with column map", (cb) ->
      columns =
        id: 'ID'
        en: 'English'
      report = new Report()
      report.table table, columns
      test.report 'table-list-map-column-map', report, """

        | ID | English |
        |:-- |:------- |
        | 1  | one     |
        | 2  | two     |
        | 3  | three   |
        | 12 | twelve  |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">ID</th>
        <th style="text-align:left">English</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">1</td>
        <td style="text-align:left">one</td>
        </tr>
        <tr>
        <td style="text-align:left">2</td>
        <td style="text-align:left">two</td>
        </tr>
        <tr>
        <td style="text-align:left">3</td>
        <td style="text-align:left">three</td>
        </tr>
        <tr>
        <td style="text-align:left">12</td>
        <td style="text-align:left">twelve</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

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
      test.report 'table-list-map-sort-map', report, """

        | ID | German | English |
        | --:|:------ |:------- |
        | 12 | zwölf  | twelve  |
        |  2 | zwei   | two     |
        |  1 | eins   | one     |
        |  3 | drei   | three   |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:right">ID</th>
        <th style="text-align:left">German</th>
        <th style="text-align:left">English</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:right">12</td>
        <td style="text-align:left">zwölf</td>
        <td style="text-align:left">twelve</td>
        </tr>
        <tr>
        <td style="text-align:right">2</td>
        <td style="text-align:left">zwei</td>
        <td style="text-align:left">two</td>
        </tr>
        <tr>
        <td style="text-align:right">1</td>
        <td style="text-align:left">eins</td>
        <td style="text-align:left">one</td>
        </tr>
        <tr>
        <td style="text-align:right">3</td>
        <td style="text-align:left">drei</td>
        <td style="text-align:left">three</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

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
      test.report 'table-list-map-sort-list', report, """

        | ID | German | English |
        | --:|:------ |:------- |
        |  3 | drei   | three   |
        |  1 | eins   | one     |
        |  2 | zwei   | two     |
        | 12 | zwölf  | twelve  |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:right">ID</th>
        <th style="text-align:left">German</th>
        <th style="text-align:left">English</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:right">3</td>
        <td style="text-align:left">drei</td>
        <td style="text-align:left">three</td>
        </tr>
        <tr>
        <td style="text-align:right">1</td>
        <td style="text-align:left">eins</td>
        <td style="text-align:left">one</td>
        </tr>
        <tr>
        <td style="text-align:right">2</td>
        <td style="text-align:left">zwei</td>
        <td style="text-align:left">two</td>
        </tr>
        <tr>
        <td style="text-align:right">12</td>
        <td style="text-align:left">zwölf</td>
        <td style="text-align:left">twelve</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

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
      test.report 'table-list-map-sort-key', report, """

        | ID | German | English |
        | --:|:------ |:------- |
        |  3 | drei   | three   |
        |  1 | eins   | one     |
        |  2 | zwei   | two     |
        | 12 | zwölf  | twelve  |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:right">ID</th>
        <th style="text-align:left">German</th>
        <th style="text-align:left">English</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:right">3</td>
        <td style="text-align:left">drei</td>
        <td style="text-align:left">three</td>
        </tr>
        <tr>
        <td style="text-align:right">1</td>
        <td style="text-align:left">eins</td>
        <td style="text-align:left">one</td>
        </tr>
        <tr>
        <td style="text-align:right">2</td>
        <td style="text-align:left">zwei</td>
        <td style="text-align:left">two</td>
        </tr>
        <tr>
        <td style="text-align:right">12</td>
        <td style="text-align:left">zwölf</td>
        <td style="text-align:left">twelve</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

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
      test.report 'table-list-array', report, """

        | 1  | one    | eins  |
        |:-- |:------ |:----- |
        | 2  | two    | zwei  |
        | 3  | three  | drei  |
        | 12 | twelve | zwölf |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">1</th>
        <th style="text-align:left">one</th>
        <th style="text-align:left">eins</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">2</td>
        <td style="text-align:left">two</td>
        <td style="text-align:left">zwei</td>
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

    it "should create table with column list", (cb) ->
      columns = ['ID', 'English', 'German']
      report = new Report()
      report.table table, columns
      test.report 'table-list-array-column-list', report, """

        | ID | English | German |
        |:-- |:------- |:------ |
        | 1  | one     | eins   |
        | 2  | two     | zwei   |
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
        <td style="text-align:left">zwei</td>
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

    it "should create table with column list-array", (cb) ->
      columns = [
        [0, 1]
        ['ID', 'English']
      ]
      report = new Report()
      report.table table, columns
      test.report 'table-list-array-column-list-array', report, """

        | ID | English |
        |:-- |:------- |
        | 1  | one     |
        | 2  | two     |
        | 3  | three   |
        | 12 | twelve  |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">ID</th>
        <th style="text-align:left">English</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">1</td>
        <td style="text-align:left">one</td>
        </tr>
        <tr>
        <td style="text-align:left">2</td>
        <td style="text-align:left">two</td>
        </tr>
        <tr>
        <td style="text-align:left">3</td>
        <td style="text-align:left">three</td>
        </tr>
        <tr>
        <td style="text-align:left">12</td>
        <td style="text-align:left">twelve</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

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
      test.report 'table-list-array-column-list-map', report, """

        | ID | English | German |
        | --:|:------- |:------ |
        |  1 | one     | eins   |
        |  2 | two     | zwei   |
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
        <td style="text-align:left">zwei</td>
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

    it "should create table with empty fields", (cb) ->
      report = new Report()
      report.table [
        [1, 'one', 'eins']
        [2, '', 'zwei']
        [3, null, 'drei']
        [12, undefined, 'zwölf']
      ]
      test.report 'table-list-array-empty', report, """

        | 1  | one | eins  |
        |:-- |:--- |:----- |
        | 2  |     | zwei  |
        | 3  |     | drei  |
        | 12 |     | zwölf |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">1</th>
        <th style="text-align:left">one</th>
        <th style="text-align:left">eins</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">2</td>
        <td style="text-align:left"></td>
        <td style="text-align:left">zwei</td>
        </tr>
        <tr>
        <td style="text-align:left">3</td>
        <td style="text-align:left"></td>
        <td style="text-align:left">drei</td>
        </tr>
        <tr>
        <td style="text-align:left">12</td>
        <td style="text-align:left"></td>
        <td style="text-align:left">zwölf</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb


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
      test.report 'table-map', report, """

        | Name     | Value     |
        |:-------- |:--------- |
        | id       | 001       |
        | name     | alex      |
        | position | developer |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">Name</th>
        <th style="text-align:left">Value</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">id</td>
        <td style="text-align:left">001</td>
        </tr>
        <tr>
        <td style="text-align:left">name</td>
        <td style="text-align:left">alex</td>
        </tr>
        <tr>
        <td style="text-align:left">position</td>
        <td style="text-align:left">developer</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

    it "should create table with column list", (cb) ->
      columns = ['NAME', 'VALUE']
      report = new Report()
      report.table table, columns
      test.report 'table-map-column-list', report, """

        | NAME     | VALUE     |
        |:-------- |:--------- |
        | id       | 001       |
        | name     | alex      |
        | position | developer |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">NAME</th>
        <th style="text-align:left">VALUE</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">id</td>
        <td style="text-align:left">001</td>
        </tr>
        <tr>
        <td style="text-align:left">name</td>
        <td style="text-align:left">alex</td>
        </tr>
        <tr>
        <td style="text-align:left">position</td>
        <td style="text-align:left">developer</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb

    it "should create table with list and object content", (cb) ->
      report = new Report()
      report.table
        number: [1..8]
        name: 'alex'
        data:
          type: 'developer'
          lang: 'javascript'
      test.report 'table-map-list-object', report, """

        | Name      | Value                  |
        |:--------- |:---------------------- |
        | number    | 1, 2, 3, 4, 5, 6, 7, 8 |
        | name      | alex                   |
        | data.type | developer              |
        | data.lang | javascript             |

        """, """
        <body><table>
        <thead>
        <tr>
        <th style="text-align:left">Name</th>
        <th style="text-align:left">Value</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td style="text-align:left">number</td>
        <td style="text-align:left">1, 2, 3, 4, 5, 6, 7, 8</td>
        </tr>
        <tr>
        <td style="text-align:left">name</td>
        <td style="text-align:left">alex</td>
        </tr>
        <tr>
        <td style="text-align:left">data.type</td>
        <td style="text-align:left">developer</td>
        </tr>
        <tr>
        <td style="text-align:left">data.lang</td>
        <td style="text-align:left">javascript</td>
        </tr>
        </tbody>
        </table>
        </body>
        """, cb
