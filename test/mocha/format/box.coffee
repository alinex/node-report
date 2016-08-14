### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "box", ->
  @timeout 5000

  it "should create a box", (cb) ->
    report = new Report()
    report.box "Some more details here...", 'detail'
    report.box "A short note.", 'info'
    report.box "This is important!", 'warning'
    report.box "Something went wrong!", 'alert'
    test.report 'box', report, """

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
      <body><div id="page"><div class="detail">
      <p>Some more details here…</p>
      </div>
      <div class="info"><header>Info</header>
      <p>A short note.</p>
      </div>
      <div class="warning"><header>Warning</header>
      <p>This is important!</p>
      </div>
      <div class="alert"><header>Attention</header>
      <p>Something went wrong!</p>
      </div>
      </div></body>
      """, cb

  it "should create a box", (cb) ->
    report = new Report()
    report.box "A short note.", 'info', 'Short Note'
    test.report 'box', report, """

      ::: info Short Note
      A short note.
      :::

      """, """
      <div class="info"><header>Short Note</header>
      <p>A short note.</p>
      </div>
      """, cb
