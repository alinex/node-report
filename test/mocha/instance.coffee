chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug')('test:instance')
Report = require '../../src/index'

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
      equal report.toString().trim(), """
      My Test
      ================================================================================
      """
    it "should add a heading 2", ->
      report.h2 'Subheading'
      equal report.toString().trim(), """
      My Test
      ================================================================================


      Subheading
      --------------------------------------------------------------------------------
      """
    it "should add a paragraph", ->
      report.p 'This is my first paragraph in this example which will show how it will break in
      markdown syntax.'
      equal report.toString().trim(), """
      My Test
      ================================================================================


      Subheading
      --------------------------------------------------------------------------------

      This is my first paragraph in this example which will show how it will break in
      markdown syntax.
      """
    it "should add a list", ->
      report.ul ['one', 'two', 'three']
      equal report.toString().trim(), """
      My Test
      ================================================================================


      Subheading
      --------------------------------------------------------------------------------

      This is my first paragraph in this example which will show how it will break in
      markdown syntax.

      - one
      - two
      - three
      """

  describe "special elements", ->


    it "should add a fotnote", ->
      report = new Report()
      report.p "This is a test#{report.footnote 'simple test only'} to demonstrate
      footnotes."
      equal report.toString().trim(), """
      This is a test[^1] to demonstrate footnotes.

      [^1]: simple test only
      """

    it "should add an abbreviation", ->
      report = new Report()
      report.abbr 'HTTP', 'Hyper Text Transfer Protocol'
      equal report.toString().trim(), """
      *[HTTP]: Hyper Text Transfer Protocol"""

  describe "convert", ->

    report = new Report()
    report.toc()
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
    list = ['one', 'two', ['subline', 'and two\\\nmore'], 'three']
    report.ul list
    report.ol list
    report.dl
      HTML: 'Markup language for the web'
      CSS: 'Styling language for web pages'
      JavaScript: 'Coding not only for web pages'

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

    report.h3 "Special Boxes"
    report.box """
    Some more details here...
    """, 'detail'
    report.box """
    A short note.
    """, 'info'
    report.box """
    This is important!
    """, 'warning'
    report.box """
    Something went wrong!
    """, 'alert'

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
    report.p Report.img 'google', 'https://www.google.de/images/branding/\
      googlelogo/2x/googlelogo_color_272x92dp.png'

    report.h3 "Emoticons"
    report.p "Classic markup: :wink: :crush: :cry: :tear: :laughing: :yum:"
    report.p "Shortcuts (emoticons): :-) :-( 8-) ;)"
    report.p "[Font Awesome](https://fortawesome.github.io/Font-Awesome/): :fa-flag:"

    report.h3 "Specialities"
    report.p "This is a test#{report.footnote 'simple test only'} to demonstrate footnotes."
    report.abbr 'HTTP', 'Hyper Text Transfer Protocol'
    report.p "The HTTP protocol is used for transferring web content."
    report.check
      'make new module': true
      'allow html transformation': true
      'allow docx transformation': false

    it "should return html", ->
      @timeout 20000
      console.log report.toConsole()
      fs = require 'fs'
      fd = fs.createWriteStream "#{__dirname}/../../src/doc/test.md"
      fd.write report.toString().trim()
      fd.end()
      fd = fs.createWriteStream "#{__dirname}/../../src/doc/test.txt"
      fd.write report.toText()
      fd.end()
      fd = fs.createWriteStream "#{__dirname}/../../src/doc/test.html" #, {encoding: 'utf8'}
      fd.write "<html><head><meta http-equiv=\"Content-Type\"
        content=\"text/html;charset=UTF-8\"></head><body>"
      fd.write report.toHtml()
      fd.write """</body></html>"""
      fd.end()
