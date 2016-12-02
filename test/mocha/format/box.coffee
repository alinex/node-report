### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "box", ->
  @timeout 5000

  it.only "should create a box in each style", (cb) ->
    report = new Report()
    report.p "detail:"
    report.box "Some more details here...", 'detail', '{size=min}'
    report.p "info:"
    report.box "A short note for you to read.", 'info', 'Short Note'
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
