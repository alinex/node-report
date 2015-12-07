chai = require 'chai'
expect = chai.expect
util = require 'util'
debug = require('debug')('test:instance')

Report = require '../../src/index'
{string} = require 'alinex-util'

equal = (a, b) ->
  debug "result", a
#  console.log util.inspect a
#  console.log util.inspect b
  expect(a, 'result').to.equal b

describe "instance", ->

  describe "create markdown", ->

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

  describe "convert", ->

    report = new Report()
    report.h1 "h1 Heading"
    report.h2 "h2 Heading"
    report.h3 "h3 Heading"
    report.h4 "h4 Heading"
    report.h5 "h5 Heading"
    report.h6 "h6 Heading"

    report.hr()

    report.h3 "Typographer"
    report.p "Typographer auto conversion: (c) (C) (r) (R) (tm) (TM) (p) (P) +-"

    report.h3 "Inline Formatting"
    report.p "Text may be #{Report.b 'bold'} #{Report.i 'italic'} #{Report.del 'strikethrough'}"
    report.p "19#{Report.sup 'th'} or H#{Report.sub '2'}O"
    report.p Report.mark "Marked Text"

    report.h3 "Block Formatting"
    report.quote "Blockquotes can also be nested..."
    report.quote "...by using additional greater-than signs right next to each other.", 2

    report.h3 "Lists"
    list = ['one', 'two', ['subline', 'and more'], 'three']
    report.ul list
    report.ol list

    report.h3 "Code"
    report.code """
    // Some comments
    line 1 of code
    line 2 of code
    line 3 of code
    """
    report.code """
    var foo = function (bar) {
      return bar++;
    };
    console.log(foo(5));
    """, 'js'

    report.h3 "Tables"
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

    report.h3 "Links / Images"
    report.p Report.a 'google', 'http://google.com'
    report.p "Autoconverted link to http://alinex.github.io"
    report.p Report.img 'google', 'https://www.google.de/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'

    report.h3 "Emoticons"
    report.p "Classic markup: :wink: :crush: :cry: :tear: :laughing: :yum:"
    report.p "Shortcuts (emoticons): :-) :-( 8-) ;)"

    it "should return html", ->
      debug report.toHtml()
