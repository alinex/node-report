### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "format", ->
  @timeout 5000

  it "should create different text styles", (cb) ->
    report = new Report()
    report.p "This should show as #{Report.b "bold"} format."
    report.p "This should show as #{Report.i "italic"} format."
    report.p "This should show as #{Report.del "strikethrough"} format."
    report.p "This should show as #{Report.tt "typewriter"} format."
    report.p "This should show as #{Report.sub "subscript"} format."
    report.p "This should show as #{Report.sup "superscript"} format."
    report.p "This should show as #{Report.mark "highlight"} format."
    test.report 'format', report, """

      This should show as __bold__ format.

      This should show as _italic_ format.

      This should show as ~~strikethrough~~ format.

      This should show as `typewriter` format.

      This should show as ~subscript~ format.

      This should show as ^superscript^ format.

      This should show as ==highlight== format.

      """, """
      <body><div id="page"><p>This should show as <strong>bold</strong> format.</p>
      <p>This should show as <em>italic</em> format.</p>
      <p>This should show as <s>strikethrough</s> format.</p>
      <p>This should show as <code>typewriter</code> format.</p>
      <p>This should show as <sub>subscript</sub> format.</p>
      <p>This should show as <sup>superscript</sup> format.</p>
      <p>This should show as <mark>highlight</mark> format.</p>
      </div></body>""", cb

  it "should allow mixed styles", (cb) ->
    report = new Report()
    report.p "Water has the formula " + Report.b("H#{Report.sub 2}O") + "."
    test.report 'format-complex', report, """

        Water has the formula __H~2~O__.

        """, """
        <body><div id="page"><p>Water has the formula <strong>H<sub>2</sub>O</strong>.</p>
        </div></body>
        """, cb

  it "should allow alternative formatting in markdown", (cb) ->
    report = new Report
      source: """
        **bold** and *italic*
        """
    test.report null, report, null, """
      <body><div id="page"><p><strong>bold</strong> and <em>italic</em></p>
      </div></body>
      """, cb
