### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "lists", ->
  @timeout 5000

  list = ['one', 'two', "and this is a long text because i can't only write numbers
  down here to show the proper use of the lists also with long text lines", 'last\ntwo lines']
  sublist = ['one', 'two', ['subline', 'and more'], 'three']

  it "should create an unordered list", (cb) ->
    report = new Report()
    report.ul list
    report.hr()
    report.ul sublist
    test.report 'list-unordered', report, """

      - one
      - two
      - and this is a long text because i can't only write numbers down here to show
        the proper use of the lists also with long text lines
      - last\\
        two lines

      ---

      - one
      - two
        - and more
        - subline
      - three

      """, """
      <body><ul>
      <li>one</li>
      <li>two</li>
      <li>and this is a long text because i can’t only write numbers down here to show
      the proper use of the lists also with long text lines</li>
      <li>last<br />
      two lines</li>
      </ul>
      <hr />
      <ul>
      <li>one</li>
      <li>two
      <ul>
      <li>and more</li>
      <li>subline</li>
      </ul>
      </li>
      <li>three</li>
      </ul>
      </body>
      """, cb

  it "should create an ordered list", (cb) ->
    report = new Report()
    report.ol list
    report.hr()
    report.ol sublist
    test.report 'list-ordered', report, """

      1. one
      2. two
      3. and this is a long text because i can't only write numbers down here to show
         the proper use of the lists also with long text lines
      4. last\\
         two lines

      ---

      1. one
      2. two
         1. and more
         2. subline
      3. three

      """, """
      <body><ol>
      <li>one</li>
      <li>two</li>
      <li>and this is a long text because i can’t only write numbers down here to show
      the proper use of the lists also with long text lines</li>
      <li>last<br />
      two lines</li>
      </ol>
      <hr />
      <ol>
      <li>one</li>
      <li>two
      <ol>
      <li>and more</li>
      <li>subline</li>
      </ol>
      </li>
      <li>three</li>
      </ol>
      </body>
      """, cb

  it "should create a definition list", (cb) ->
    report = new Report()
    report.dl
      html: 'Markup language for internet pages'
      css: 'Style language to bring the layout into html'
    , true
    test.report 'list-definition', report, """

      css

      : Style language to bring the layout into html

      html

      : Markup language for internet pages

      """, """
      <body><dl>
      <dt>css</dt>
      <dd>Style language to bring the layout into html</dd>
      <dt>html</dt>
      <dd>Markup language for internet pages</dd>
      </dl>
      </body>
      """, cb
