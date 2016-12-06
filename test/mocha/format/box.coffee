### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "box", ->
  @timeout 10000

  it.only "should create a box in each style", (cb) ->
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

    """, """
    <body><div id="page"><div class="tabs">
    <input type="radio" name="tabs9" class="tab tab1" id="tab9" checked=""><label for="tab9" class="info" title="Switch tab">Short Note</label>
    <input type="radio" name="tabs-size9" class="tabs-size tabs-size-max" id="tabs-size-max9"><label for="tabs-size-max9" title="Maximize box to show full content"><i class="fa fa-window-maximize" aria-hidden="true"></i></label>
    <input type="radio" name="tabs-size9" class="tabs-size tabs-size-scroll" id="tabs-size-scroll9" checked=""><label for="tabs-size-scroll9" title="Show in default view with possible scroll bars"><i class="fa fa-window-restore" aria-hidden="true"></i></label>
    <input type="radio" name="tabs-size9" class="tabs-size tabs-size-min" id="tabs-size-min9"><label for="tabs-size-min9" title="Close box content"><i class="fa fa-window-minimize" aria-hidden="true"></i></label>
    <div class="tab-content tab-content1 info">
    <p>A short note.</p>
    </div>
    </div>
    """, cb

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

    """, """
    <body><div id="page"><div class="tabs">
    <input type="radio" name="tabs11" class="tab tab1" id="tab11" checked=""><label for="tab11" class="detail" title="Switch tab">Details</label>
    <input type="radio" name="tabs11" class="tab tab2" id="tab12"><label for="tab12" class="info" title="Switch tab">Info</label>
    <input type="radio" name="tabs11" class="tab tab3" id="tab13"><label for="tab13" class="warning" title="Switch tab">Warning</label>
    <input type="radio" name="tabs11" class="tab tab4" id="tab14"><label for="tab14" class="alert" title="Switch tab">Attention</label>
    <input type="radio" name="tabs-size11" class="tabs-size tabs-size-max" id="tabs-size-max11"><label for="tabs-size-max11" title="Maximize box to show full content"><i class="fa fa-window-maximize" aria-hidden="true"></i></label>
    <input type="radio" name="tabs-size11" class="tabs-size tabs-size-scroll" id="tabs-size-scroll11" checked=""><label for="tabs-size-scroll11" title="Show in default view with possible scroll bars"><i class="fa fa-window-restore" aria-hidden="true"></i></label>
    <input type="radio" name="tabs-size11" class="tabs-size tabs-size-min" id="tabs-size-min11"><label for="tabs-size-min11" title="Close box content"><i class="fa fa-window-minimize" aria-hidden="true"></i></label>
    <div class="tab-content tab-content1 detail">
    <p>Some more details here…</p>
    </div>
    <div class="tab-content tab-content2 info">
    <p>A short note.</p>
    </div>
    <div class="tab-content tab-content3 warning">
    <p>This is important!</p>
    </div>
    <div class="tab-content tab-content4 alert">
    <p>Something went wrong!</p>
    </div>
    </div>
    """, cb

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

    """, """
    <body><div id="page"><div class="tabs">
    <input type="radio" name="tabs13" class="tab tab1" id="tab19" checked=""><label for="tab19" class="info" title="Switch tab">Auto</label>
    <input type="radio" name="tabs-size13" class="tabs-size tabs-size-max" id="tabs-size-max13"><label for="tabs-size-max13" title="Maximize box to show full content"><i class="fa fa-window-maximize" aria-hidden="true"></i></label>
    <input type="radio" name="tabs-size13" class="tabs-size tabs-size-scroll" id="tabs-size-scroll13" checked=""><label for="tabs-size-scroll13" title="Show in default view with possible scroll bars"><i class="fa fa-window-restore" aria-hidden="true"></i></label>
    <input type="radio" name="tabs-size13" class="tabs-size tabs-size-min" id="tabs-size-min13"><label for="tabs-size-min13" title="Close box content"><i class="fa fa-window-minimize" aria-hidden="true"></i></label>
    <div class="tab-content tab-content1 info">
    <p>This is a very long note to show how it will look in the different display modes which will show it minimized, maximized or with an scroll bar. It is shown in the minimized form at start but you may click it into scroll or maximized view as you like. In any other output which is not html it will always be displayed in full size (maximized). You may use the icons on the top left to change the appearance of this box if you want to minimize it, to open back in auto size (with possible scrollbars) or to maximize like in print view.</p>
    </div>
    </div>
    <p>That was the default with possible scrollbars.</p>
    <div class="tabs">
    <input type="radio" name="tabs14" class="tab tab1" id="tab20" checked=""><label for="tab20" class="info" title="Switch tab">Minimized</label>
    <input type="radio" name="tabs-size14" class="tabs-size tabs-size-max" id="tabs-size-max14"><label for="tabs-size-max14" title="Maximize box to show full content"><i class="fa fa-window-maximize" aria-hidden="true"></i></label>
    <input type="radio" name="tabs-size14" class="tabs-size tabs-size-scroll" id="tabs-size-scroll14"><label for="tabs-size-scroll14" title="Show in default view with possible scroll bars"><i class="fa fa-window-restore" aria-hidden="true"></i></label>
    <input type="radio" name="tabs-size14" class="tabs-size tabs-size-min" id="tabs-size-min14" checked=""><label for="tabs-size-min14" title="Close box content"><i class="fa fa-window-minimize" aria-hidden="true"></i></label>
    <div class="tab-content tab-content1 info">
    <p>This is a very long note to show how it will look in the different display modes which will show it minimized, maximized or with an scroll bar. It is shown in the minimized form at start but you may click it into scroll or maximized view as you like. In any other output which is not html it will always be displayed in full size (maximized). You may use the icons on the top left to change the appearance of this box if you want to minimize it, to open back in auto size (with possible scrollbars) or to maximize like in print view.</p>
    </div>
    </div>
    <p>Now it is minimized (click to open).</p>
    <div class="tabs">
    <input type="radio" name="tabs15" class="tab tab1" id="tab21" checked=""><label for="tab21" class="info" title="Switch tab">Maximized</label>
    <input type="radio" name="tabs-size15" class="tabs-size tabs-size-max" id="tabs-size-max15" checked=""><label for="tabs-size-max15" title="Maximize box to show full content"><i class="fa fa-window-maximize" aria-hidden="true"></i></label>
    <input type="radio" name="tabs-size15" class="tabs-size tabs-size-scroll" id="tabs-size-scroll15"><label for="tabs-size-scroll15" title="Show in default view with possible scroll bars"><i class="fa fa-window-restore" aria-hidden="true"></i></label>
    <input type="radio" name="tabs-size15" class="tabs-size tabs-size-min" id="tabs-size-min15"><label for="tabs-size-min15" title="Close box content"><i class="fa fa-window-minimize" aria-hidden="true"></i></label>
    <div class="tab-content tab-content1 info">
    <p>This is a very long note to show how it will look in the different display modes which will show it minimized, maximized or with an scroll bar. It is shown in the minimized form at start but you may click it into scroll or maximized view as you like. In any other output which is not html it will always be displayed in full size (maximized). You may use the icons on the top left to change the appearance of this box if you want to minimize it, to open back in auto size (with possible scrollbars) or to maximize like in print view.</p>
    </div>
    </div>
    """, cb

  it.only "should create boxes with code", (cb) ->
    report = new Report()
    report.box Report.code 'var x = Math.round(f);', 'js'
    report.box Report.code 'h1 {\n  font-weight: bold;\n}', 'css'
    report.box Report.code 'simple:\n  list: ["a", b, 5]', 'yaml'
    report.box Report.code '<html>\n<head><title>This is HTML</titl></head>\n<body><h1>This is HTML</h1></body>\n</html>', 'html'
    test.report 'box-code', report, null, null, cb
    #"""
    #""", """
    #""", cb

# EXAMPLES=true node_modules/.bin/mocha --compilers coffee:coffee-script/register --reporter spec -c --recursive --bail test/mocha

  it.skip "special test", (cb) ->
    report = new Report()
    report.p "detail:"
    report.box "Some more details here...", 'detail', '{size=min}'
    report.p "info:"
    report.box "A short note for you to read.
    This is a very long line to display the use of an scrollbar in the box if not
    in max type.
    This is a very long line to display the use of an scrollbar in the box if not
    in max type.
    This is a very long line to display the use of an scrollbar in the box if not
    in max type.
    This is a very long line to display the use of an scrollbar in the box if not
    in max type.
    This is a very long line to display the use of an scrollbar in the box if not
    in max type.
    This is a very long line to display the use of an scrollbar in the box if not
    in max type.
    This is a very long line to display the use of an scrollbar in the box if not
    in max type.
    ", 'info', 'Short Note'
    report.p "warning:"
    report.box "This is important!", 'warning'
    report.box "Something went wrong!", 'alert'
    test.report 'box', report, null, null, cb
#"""
#
#      detail:
#
#      ::: detail
#      Some more details here...
#      :::
#
#      info:
#
#      ::: info Short Note
#      A short note for you to read.
#      :::
#
#      warning:
#
#      ::: warning
#      This is important!
#      :::
#
#      ::: alert
#      Something went wrong!
#      :::
#      <!-- {tab:size=min} -->
#      """
#      , """
#      <body><div id="page"><div class="detail"><header>Details</header>
#      <p>Some more details here…</p>
#      </div>
#      <div class="info"><header>Info</header>
#      <p>A short note for you to read.</p>
#      </div>
#      <div class="warning"><header>Warning</header>
#      <p>This is important!</p>
#      </div>
#      <div class="alert"><header>Attention</header>
#      <p>Something went wrong!</p>
#      </div>
#      </div></body>
#      """, cb
