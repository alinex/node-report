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
      <body><div id="page"><ul>
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
      </div></body>
      """, cb

  it "should allow some more markdown for unordered", (cb) ->
    report = new Report
      source: """
        + Create a list by starting a line with `+`, `-`, or `*`
        + Sub-lists are made by indenting 2 spaces:
          - Marker character change forces new list start:
            * Ac tristique libero volutpat at
            + Facilisis in pretium nisl aliquet
            - Nulla volutpat aliquam velit
        + Very easy!
        """
    test.report 'list-unordered2', report, null, """
      <body><div id="page"><ul>
      <li>Create a list by starting a line with <code>+</code>, <code>-</code>, or <code>*</code></li>
      <li>Sub-lists are made by indenting 2 spaces:
      <ul>
      <li>Marker character change forces new list start:
      <ul>
      <li>Ac tristique libero volutpat at</li>
      </ul>
      <ul>
      <li>Facilisis in pretium nisl aliquet</li>
      </ul>
      <ul>
      <li>Nulla volutpat aliquam velit</li>
      </ul>
      </li>
      </ul>
      </li>
      <li>Very easy!</li>
      </ul>
      </div></body>
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
      <body><div id="page"><ol>
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
      </div></body>
      """, cb

  it "should allow some more markdown for ordered", (cb) ->
    report = new Report
      source: """
        1. You can use sequential numbers...
        1. ...or keep all the numbers as `1.`

        Start numbering with offset:

        57. foo
        1. bar
        """
    test.report 'list-ordered2', report, null, """
      <body><div id="page"><ol>
      <li>You can use sequential numbers…</li>
      <li>…or keep all the numbers as <code>1.</code></li>
      </ol>
      <p>Start numbering with offset:</p>
      <ol start="57">
      <li>foo</li>
      <li>bar</li>
      </ol>
      </div></body>
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
      <body><div id="page"><dl>
      <dt>css</dt>
      <dd>Style language to bring the layout into html</dd>
      <dt>html</dt>
      <dd>Markup language for internet pages</dd>
      </dl>
      </div></body>
      """, cb

  it "should allow some more markdown for definitions", (cb) ->
    report = new Report
      source: """
        Term 1

        :   Definition 1
        with lazy continuation.

        Term 2 with *inline markup*

        :   Definition 2

            Second paragraph of definition 2.

        Compact style:

        Term 1
          ~ Definition 1

        Term 2
          ~ Definition 2a
          ~ Definition 2b
        """
    test.report 'list-definition2', report, null, """
      <body><div id="page"><dl>
      <dt>Term 1</dt>
      <dd>
      <p>Definition 1
      with lazy continuation.</p>
      </dd>
      <dt>Term 2 with <em>inline markup</em></dt>
      <dd>
      <p>Definition 2</p>
      <p>Second paragraph of definition 2.</p>
      </dd>
      </dl>
      <p>Compact style:</p>
      <dl>
      <dt>Term 1</dt>
      <dd>Definition 1</dd>
      <dt>Term 2</dt>
      <dd>Definition 2a</dd>
      <dd>Definition 2b</dd>
      </dl>
      </div></body>
      """, cb

  it "should create a check list", (cb) ->
    report = new Report()
    report.check
      'todo list': true
      'with elements done': true
      'and something todo': false
    test.report 'list-check', report, """

      [x] todo list
      [x] with elements done
      [ ] and something todo

      """, null, cb
