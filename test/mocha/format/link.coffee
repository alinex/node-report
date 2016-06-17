### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "link", ->
  @timeout 5000

  it "should add images", (cb) ->
    report = new Report()
    report.p "Autoconverted link to http://alinex.github.io"
    link = Report.a 'google', 'http://google.com', 'Open Google Search'
    report.p "Have a look at #{link}"
    test.report 'links', report, """

      Autoconverted link to http://alinex.github.io

      Have a look at [google](http://google.com "Open Google Search")

      """, """
      <body><p>Autoconverted link to <a href="http://alinex.github.io">http://alinex.github.io</a></p>
      <p>Have a look at <a href="http://google.com" title="Open Google Search">google</a></p>
      </body>
      """, cb
