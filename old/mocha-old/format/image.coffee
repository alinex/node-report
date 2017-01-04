### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "image", ->
  @timeout 5000

  it "should add images", (cb) ->
    report = new Report()
    report.p Report.img 'Alinex', 'https://alinex.github.io/images/Alinex-200.png'
    report.p Report.img 'Alinex Black', 'https://alinex.github.io/images/Alinex-black-200.png', "The Alinex Logo"
    image = Report.img 'Alinex', 'https://alinex.github.io/images/Alinex-200.png'
    report.p "With link: " + Report.a image, 'http://alinex.github.com'
    test.report 'images', report, """

      ![Alinex](https://alinex.github.io/images/Alinex-200.png)

      ![Alinex Black](https://alinex.github.io/images/Alinex-black-200.png "The Alinex
      Logo")

      With link:
      [![Alinex](https://alinex.github.io/images/Alinex-200.png)](http://alinex.github.com)

      """, """
      <body><div id="page"><p><img src="https://alinex.github.io/images/Alinex-200.png" alt="Alinex" /></p>
      <p><img src="https://alinex.github.io/images/Alinex-black-200.png" alt="Alinex Black" title="The Alinex
      Logo" /></p>
      <p>With link:
      <a href="http://alinex.github.com"><img src="https://alinex.github.io/images/Alinex-200.png" alt="Alinex" /></a></p>
      </div></body>
      """, cb
