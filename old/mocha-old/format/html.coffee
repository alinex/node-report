### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "format html", ->
  @timeout 5000

  it "should add direct styles", (cb) ->
    report = new Report()
    # set id
    report.p "Set float\nleft and id..." + Report.style '#left .left'
    # classes
    report.p "Make this centered (using class)..." + Report.style '.center'
    report.p "Make this centered and red (using classes)..."
    report.style '.center.text-red'
    # set attribute
    google = Report.img 'google',
      'https://www.google.de/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'
    report.p "Set image width #{google}"
    report.style 'width=60'
    # combine them
    report.quote "* [Continue](#continue)"
    report.style 'a:.text-green'
    report.style 'li:.text-red'
    report.style 'blockquote:.right'
    # backreferencing
    report.p 'line 1'
    report.p 'line 2'
    report.p 'line 3'
    report.p 'line 4'
    report.p 'line 5'
    report.style 'p^3:.text-green'
    test.report 'style-direct', report, """

      Set float\\
      left and id...<!-- {#left .left} -->

      Make this centered (using class)...<!-- {.center} -->

      Make this centered and red (using classes)...
      <!-- {.center.text-red} -->

      Set image width
      ![google](https://www.google.de/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png)
      <!-- {width=60} -->

      > * [Continue](#continue)
      <!-- {a:.text-green} -->
      <!-- {li:.text-red} -->
      <!-- {blockquote:.right} -->

      line 1

      line 2

      line 3

      line 4

      line 5
      <!-- {p^3:.text-green} -->

      """, """
      <body><div id="page"><p id="left" class="left">Set float<br />
      left and id…</p>
      <p class="center">Make this centered (using class)…</p>
      <p class="center text-red">Make this centered and red (using classes)…</p>
      <p>Set image width
      <img src="https://www.google.de/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png" alt="google" width="60" /></p>
      <blockquote class="right">
      <ul>
      <li class="text-red"><a href="#continue" class="text-green">Continue</a></li>
      </ul>
      </blockquote>
      <p>line 1</p>
      <p class="text-green">line 2</p>
      <p>line 3</p>
      <p>line 4</p>
      <p>line 5</p>
      </div></body>
      """, cb

  it "should add style sheet rules", (cb) ->
    report = new Report()
    report.css "#box {padding: 3px; border: solid black 1px; background: #eee;}
    strong {color: red;}"
    report.p "This document uses **style sheets** to make look bold text be red and
    let some look like **buttons** using direct style for setting."
    report.style '#box'
    test.report 'style-sheet', report, """

      $$$ css
      #box {padding: 3px; border: solid black 1px; background: #eee;} strong {color: red;}
      $$$

      This document uses **style sheets** to make look bold text be red and let some
      look like **buttons** using direct style for setting.
      <!-- {#box} -->

      """, """
      <body><div id="page"><p>This document uses <strong>style sheets</strong> to make look bold text be red and let some
      look like <strong id="box">buttons</strong> using direct style for setting.</p>
      </div></body>
      """, cb

  it "should add javascript code", (cb) ->
    report = new Report()
    report.js "test = function() { alert('Hello World!')}"
    report.p "Call the [demo](#) which is included into the page."
    report.style 'onclick="test()"'
    test.report 'js', report, """

      $$$ js
      test = function() { alert('Hello World!')}
      $$$

      Call the [demo](#) which is included into the page.
      <!-- {onclick="test()"} -->

      """, """
      <body><div id="page"><script type="text/javascript"><!--
      test = function() { alert('Hello World!')}
      //--></script><p>Call the <a href="#" onclick="test()">demo</a> which is included into the page.</p>
      </div></body>
      """, cb