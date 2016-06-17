### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "separations", ->
  @timeout 5000

  it "should create a horizontal line", (cb) ->
    report = new Report()
    report.p "My first line."
    report.hr()
    report.p "And another one after a separating line."
    test.report 'separation', report, """

      My first line.

      ---

      And another one after a separating line.

      """, """
      <body><p>My first line.</p>
      <hr />
      <p>And another one after a separating line.</p>
      </body>
      """, cb

  it "should allow alternative formatting ____ in markdown", (cb) ->
    report = new Report
      source: """
        ___
        """
    test.report null, report, null, """
      <body><hr />
      </body>
      """, cb

  it "should allow alternative formatting *** in markdown", (cb) ->
    report = new Report
      source: """
        ***
        """
    test.report null, report, null, """
      <body><hr />
      </body>
      """, cb
