### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe.only "box", ->
  @timeout 5000

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

      """, """
      <body><div id="page"><p>detail:</p>
      <div class="tabs">
      <input type="radio" name="tabs1" class="tab tab1" id="tab1" checked=""><label for="tab1" class="detail" title="Switch tab">Details</label>
      <input type="radio" name="tabs-size1" class="tabs-size tabs-size-max" id="tabs-size-max1"><label for="tabs-size-max1" title="Maximize box to show full content"><i class="fa fa-window-maximize" aria-hidden="true"></i></label>
      <input type="radio" name="tabs-size1" class="tabs-size tabs-size-scroll" id="tabs-size-scroll1" checked=""><label for="tabs-size-scroll1" title="Show in default view with possible scroll bars"><i class="fa fa-window-restore" aria-hidden="true"></i></label>
      <input type="radio" name="tabs-size1" class="tabs-size tabs-size-min" id="tabs-size-min1"><label for="tabs-size-min1" title="Close box content"><i class="fa fa-window-minimize" aria-hidden="true"></i></label>
      <div class="tab-content tab-content1 detail">
      <p>Some more details here…</p>
      </div>
      </div>
      """, cb

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
