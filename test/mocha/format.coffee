chai = require 'chai'
expect = chai.expect
util = require 'util'

Report = require '../../src/index'
{string} = require 'alinex-util'

equal = (a, b) ->
  console.log a
  console.log util.inspect a
  console.log util.inspect b
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

  describe "paragraph", ->

    it "should make a paragraph", ->
      equal Report.p("This is a short text."), "\nThis is a short text.\n"
    it "should make a paragraph with breaks", ->
      equal Report.p("And now comes a very long line to test if it will be broken into
        multiple lines by the report module."), """
      \nAnd now comes a very long line to test if it will be broken into multiple lines
      by the report module.\n"""

    it "should make a horizontal line", ->
      equal Report.hr(), "\n---\n"

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

  describe "lists", ->

    list = ['one', 'two', "and this is a long text because i can't only write numbers down here to show
    the proper use of the lists also with long text lines", 'last\ntwo lines']
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

  describe "instance", ->

    report = new Report()

    it "should add a heading 1", ->
      report.h1 'My Test'
      equal report.toString(), """
      My Test
      ================================================================================\n
      """
    it "should add a heading 2", ->
      report.h2 'Subheading'
      equal report.toString(), """
      My Test
      ================================================================================


      Subheading
      --------------------------------------------------------------------------------\n
      """
    it "should add a paragraph", ->
      report.p 'This is my first paragraph in this example which will show how it will break in
      markdown syntax.'
      equal report.toString(), """
      My Test
      ================================================================================


      Subheading
      --------------------------------------------------------------------------------

      This is my first paragraph in this example which will show how it will break in
      markdown syntax.\n
      """
    it "should add a list", ->
      report.ul ['one', 'two', 'three']
      equal report.toString(), """
      My Test
      ================================================================================


      Subheading
      --------------------------------------------------------------------------------

      This is my first paragraph in this example which will show how it will break in
      markdown syntax.

      - one
      - two
      - three\n
      """
