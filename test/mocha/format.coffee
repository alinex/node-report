chai = require 'chai'
expect = chai.expect
util = require 'util'
debug = require('debug')('test:format')

Report = require '../../src/index'
{string} = require 'alinex-util'

equal = (a, b) ->
  debug "result", a
#  console.log util.inspect a
#  console.log util.inspect b
  expect(a, 'result').to.equal b

describe "format", ->

  describe "headings", ->

    it "should create heading 1", ->
      equal Report.h1("My Test"), """
      \n\nMy Test
      ================================================================================\n
      """
    it "should create heading 2", ->
      equal Report.h2("Subheading"), """
      \n\nSubheading
      --------------------------------------------------------------------------------\n
      """
    it "should create heading 3", ->
      equal Report.h3("Subheading"), "\n### Subheading\n"
    it "should create heading 4", ->
      equal Report.h4("Subheading"), "\n#### Subheading\n"
    it "should create heading 5", ->
      equal Report.h5("Subheading"), "\n##### Subheading\n"
    it "should create heading 6", ->
      equal Report.h6("Subheading"), "\n###### Subheading\n"

  describe "inline", ->

    it "should make text bold", ->
      equal Report.b("bold"), "__bold__"
    it "should make text italic", ->
      equal Report.i("italic"), "_italic_"
    it "should make text italic", ->
      equal Report.del("old"), "~~old~~"
    it "should make typewriter text", ->
      equal Report.tt("variable"), "`variable`"
    it "should make link text", ->
      equal Report.a("google", "http://google.de"), "[google](http://google.de)"
    it "should add an external image", ->
      equal Report.img("google", "http://google.de/favicon.ico"), "![google](http://google.de/favicon.ico)"
    it "should make text subscript", ->
      equal Report.sub("2"), "~2~"
    it "should make text superscript", ->
      equal Report.sup("th"), "^th^"
    it "should make text marked", ->
      equal Report.mark("mandatory"), "==mandatory=="

  describe "paragraph", ->

    it "should make a paragraph", ->
      equal Report.p("This is a short text."), "\nThis is a short text.\n"
    it "should make a paragraph with breaks", ->
      equal Report.p("And now comes a very long line to test if it will be broken into
        multiple lines by the report module."), """
      \nAnd now comes a very long line to test if it will be broken into multiple lines
      by the report module.\n"""

    it "should make a quoted paragraph", ->
      equal Report.quote("This is a short text."), "\n> This is a short text.\n"
    it "should make a quoted paragraph with breaks", ->
      equal Report.quote("And now comes a very long line to test if it will be broken into
        multiple lines by the report module."), """
      \n> And now comes a very long line to test if it will be broken into multiple
      > lines by the report module.\n"""
    it "should make a quoted paragraph in sevcond level", ->
      equal Report.quote("This is a short text.", 2), "\n> > This is a short text.\n"

    it "should make a code paragraph", ->
      equal Report.code("My code\ncomes here."), "\n    My code\n    comes here.\n"
    it "should make a language paragraph", ->
      equal Report.code("My code\ncomes here.", 'coffee'), "\n``` coffee\nMy code\ncomes here.\n```\n"

  describe "separation", ->

    it "should make a horizontal line", ->
      equal Report.hr(), "\n---\n"
    it "should allow breaks in paragraphs", ->
      equal Report.p("My first line #{Report.br()} and the ongoing second line."),
      "\nMy first line \\\n and the ongoing second line.\n"

  describe "list", ->

    list = ['one', 'two', "and this is a long text because i can't only write numbers down here to show
    the proper use of the lists also with long text lines", 'last\ntwo lines']
    sublist = ['one', 'two', ['subline', 'and more'], 'three']
    it "should make an unordered list", ->
      equal Report.ul(list), """
      \n- one
      - two
      - and this is a long text because i can't only write numbers down here to show
        the proper use of the lists also with long text lines
      - last
        two lines\n"""
    it "should make an ordered list", ->
      equal Report.ol(list), """
      \n1. one
      2. two
      3. and this is a long text because i can't only write numbers down here to show
         the proper use of the lists also with long text lines
      4. last
         two lines\n"""
    it "should make an unordered sublist", ->
      equal Report.ul(sublist), """
      \n- one
      - two
        - subline
        - and more
      - three\n"""

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
      \n| 0  | 1      | 2     |
      |:-- |:------ |:----- |
      | 1  | one    | eins  |
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

    it "should format obj-map", ->
      equal Report.table(objMap), """
      \n| 0        | 1         |
      |:-------- |:--------- |
      | id       | 001       |
      | name     | alex      |
      | position | developer |\n"""
    it "should format obj-map with col-array", ->
      equal Report.table(objMap, ['Name', 'Value']), """
      \n| Name     | Value     |
      |:-------- |:--------- |
      | id       | 001       |
      | name     | alex      |
      | position | developer |\n"""
