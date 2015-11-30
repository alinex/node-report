chai = require 'chai'
expect = chai.expect
util = require 'util'

Report = require '../../src/index'
{string} = require 'alinex-util'

equal = (a, b) ->
  console.log a
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

  describe "paragraph", ->

    it "should make paragraph", ->
      equal Report.p("This is a short text."), "\nThis is a short text.\n"
    it "should make a horizontal line", ->
      equal Report.hr(), "\n---\n"
    it "should make quoted paragraph", ->
      equal Report.quote("This is a short text."), "\n> This is a short text.\n"

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
