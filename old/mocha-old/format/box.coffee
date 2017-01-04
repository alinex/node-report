### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "box", ->
  @timeout 10000

  it "should create a box in each style", (cb) ->
    report = new Report()
    report.p "detail:"
    report.box "Some more details here...", 'detail'
    report.p "info:"
    report.box "A short note for you to read.", 'info'
    report.p "warning:"
    report.box "This is important!", 'warning'
    report.p "alert:"
    report.box "Something went wrong!", 'alert'
    test.report 'box', report, """

      detail:

      ::: detail
      Some more details here...
      :::

      info:

      ::: info
      A short note for you to read.
      :::

      warning:

      ::: warning
      This is important!
      :::

      alert:

      ::: alert
      Something went wrong!
      :::

      """, null, cb

  it "should create a box with specific title", (cb) ->
    report = new Report()
    report.box "A short note.", 'info', 'Short Note'
    test.report 'box-title', report, """

    ::: info Short Note
    A short note.
    :::

    """, null, cb

  it "should create a box with multiple tabs", (cb) ->
    report = new Report()
    report.box "Some more details here...", 'detail'
    report.box "A short note.", 'info'
    report.box "This is important!", 'warning'
    report.box "Something went wrong!", 'alert'
    test.report 'box-stack', report, """

    ::: detail
    Some more details here...
    :::

    ::: info
    A short note.
    :::

    ::: warning
    This is important!
    :::

    ::: alert
    Something went wrong!
    :::

    """, null, cb

  it "should create a box in different sizes", (cb) ->
    report = new Report()
    report.box "This is a very long note to show how it will look in the different
    display modes which will show it minimized, maximized or with an scroll bar.
    It is shown in the minimized form at start but you may click it into scroll
    or maximized view as you like. In any other output which is not html it will
    always be displayed in full size (maximized). You may use the icons on the top
    left to change the appearance of this box if you want to minimize it, to open
    back in auto size (with possible scrollbars) or to maximize like in print
    view.", 'info', 'Auto {size=scroll}'
    report.p "That was the default with possible scrollbars."
    report.box "This is a very long note to show how it will look in the different
    display modes which will show it minimized, maximized or with an scroll bar.
    It is shown in the minimized form at start but you may click it into scroll
    or maximized view as you like. In any other output which is not html it will
    always be displayed in full size (maximized). You may use the icons on the top
    left to change the appearance of this box if you want to minimize it, to open
    back in auto size (with possible scrollbars) or to maximize like in print
    view.", 'info', 'Minimized {size=min}'
    report.p "Now it is minimized (click to open)."
    report.box "This is a very long note to show how it will look in the different
    display modes which will show it minimized, maximized or with an scroll bar.
    It is shown in the minimized form at start but you may click it into scroll
    or maximized view as you like. In any other output which is not html it will
    always be displayed in full size (maximized). You may use the icons on the top
    left to change the appearance of this box if you want to minimize it, to open
    back in auto size (with possible scrollbars) or to maximize like in print
    view.", 'info', 'Maximized {size=max}'
    report.p "And now maximized like for printing."
    test.report 'box-size', report, """

    ::: info Auto {size=scroll}
    This is a very long note to show how it will look in the different display modes which will show it minimized, maximized or with an scroll bar. It is shown in the minimized form at start but you may click it into scroll or maximized view as you like. In any other output which is not html it will always be displayed in full size (maximized). You may use the icons on the top left to change the appearance of this box if you want to minimize it, to open back in auto size (with possible scrollbars) or to maximize like in print view.
    :::

    That was the default with possible scrollbars.

    ::: info Minimized {size=min}
    This is a very long note to show how it will look in the different display modes which will show it minimized, maximized or with an scroll bar. It is shown in the minimized form at start but you may click it into scroll or maximized view as you like. In any other output which is not html it will always be displayed in full size (maximized). You may use the icons on the top left to change the appearance of this box if you want to minimize it, to open back in auto size (with possible scrollbars) or to maximize like in print view.
    :::

    Now it is minimized (click to open).

    ::: info Maximized {size=max}
    This is a very long note to show how it will look in the different display modes which will show it minimized, maximized or with an scroll bar. It is shown in the minimized form at start but you may click it into scroll or maximized view as you like. In any other output which is not html it will always be displayed in full size (maximized). You may use the icons on the top left to change the appearance of this box if you want to minimize it, to open back in auto size (with possible scrollbars) or to maximize like in print view.
    :::

    And now maximized like for printing.

    """, null, cb

  it "should create boxes with preformatted text", (cb) ->
    report = new Report()
    report.box Report.code 'This is a text code block.\nIt should be kept as is.'
    test.report 'box-pre', report, """

    ::: detail
        This is a text code block.
        It should be kept as is.
    :::

    """, null, cb

  it "should create boxes with code", (cb) ->
    report = new Report()
    report.box Report.code 'var x = Math.round(f);', 'js'
    report.box Report.code 'h1 {\n  font-weight: bold;\n}', 'css'
    report.box Report.code 'simple:\n  list: ["a", b, 5]', 'yaml'
    report.box Report.code '<html>\n<head><title>This is HTML</titl></head>\n<body><h1>This is HTML</h1></body>\n</html>', 'html'
    test.report 'box-code', report, """

    ::: detail
    ``` js
    var x = Math.round(f);
    ```
    :::

    ::: detail
    ``` css
    h1 {
      font-weight: bold;
    }
    ```
    :::

    ::: detail
    ``` yaml
    simple:
      list: ["a", b, 5]
    ```
    :::

    ::: detail
    ``` html
    <html>
    <head><title>This is HTML</titl></head>
    <body><h1>This is HTML</h1></body>
    </html>
    ```
    :::

    """, null, cb

  it "should create boxes with containing table", (cb) ->
    report = new Report()
    report.box Report.table [
      ['ID', 'English', 'German']
      [1, 'one', 'eins']
      [2, 'two', 'zwei']
      [3, 'three', 'drei']
      [12, 'twelve', 'zwölf']
    ]
    test.report 'box-table', report, """

    ::: detail
    | ID | English | German |
    |:-- |:------- |:------ |
    | 1  | one     | eins   |
    | 2  | two     | zwei   |
    | 3  | three   | drei   |
    | 12 | twelve  | zwölf  |
    :::

    """, null, cb
