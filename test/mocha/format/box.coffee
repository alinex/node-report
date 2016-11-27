### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "box", ->
  @timeout 5000

  it "should create a box in each style", (cb) ->
    report = new Report()
    report.box "Some more details here...", 'detail'
    report.box "A short note for you to read.", 'info'
    report.box "This is important!", 'warning'
    report.box "Something went wrong!", 'alert'
    test.report 'box', report, """

      ::: detail
      Some more details here...
      :::

      ::: info
      A short note for you to read.
      :::

      ::: warning
      This is important!
      :::

      ::: alert
      Something went wrong!
      :::

      """, """
      <body><div id="page"><div class="detail"><header>Details</header>
      <p>Some more details here…</p>
      </div>
      <div class="info"><header>Info</header>
      <p>A short note for you to read.</p>
      </div>
      <div class="warning"><header>Warning</header>
      <p>This is important!</p>
      </div>
      <div class="alert"><header>Attention</header>
      <p>Something went wrong!</p>
      </div>
      </div></body>
      """, cb
