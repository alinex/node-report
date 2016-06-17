### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "headings", ->
  @timeout 5000

  it "should create each level", (cb) ->
    report = new Report()
    report.h1 "h1 Heading"
    report.h2 "h2 Heading"
    report.h3 "h3 Heading"
    report.h4 "h4 Heading"
    report.h5 "h5 Heading"
    report.h6 "h6 Heading"
    test.report 'headings', report, """


      h1 Heading
      ================================================================================


      h2 Heading
      --------------------------------------------------------------------------------

      ### h3 Heading

      #### h4 Heading

      ##### h5 Heading

      ###### h6 Heading

      """, """
      <body><h1 id="h1-heading">h1 Heading</h1>
      <h2 id="h2-heading">h2 Heading</h2>
      <h3 id="h3-heading">h3 Heading</h3>
      <h4 id="h4-heading">h4 Heading</h4>
      <h5 id="h5-heading">h5 Heading</h5>
      <h6 id="h6-heading">h6 Heading</h6>
      </body>
      """, cb

  it "should allow alternative formatting in markdown", (cb) ->
    report = new Report
      source: """
        # h1 Heading

        ## h2 Heading

        """
    test.report 'headings-md', report, null, """
      <body><h1 id="h1-heading">h1 Heading</h1>
      <h2 id="h2-heading">h2 Heading</h2>
      </body>
      """, cb
