### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe.only "visual mermaid", ->
  @timeout 20000

  it "should create simple graph", (cb) ->
    report = new Report()
    report.mermaid """
      graph LR
        A-->B
      """
    test.report 'mermaid', report, """

      $$$ mermaid
      graph LR
        A-->B
      $$$

      """, null, cb

  it "should create flowchart graph", (cb) ->
    report = new Report()
    report.mermaid """
      graph LR
        A[Square Rect] -- Link text --> B((Circle))
        A --> C(Round Rect)
        B --> D{Rhombus}
        C --> D
      """
    test.report 'mermaid-flowchart', report, null, null, cb

  it "should create sequence diagram", (cb) ->
    report = new Report()
    report.mermaid """
      sequenceDiagram
        Alice ->> Bob: Hello Bob, how are you?
        Bob-->>John: How about you John?
        Bob--x Alice: I am good thanks!
        Bob-x John: I am good thanks!
        Note right of John: Bob thinks a long<br/>long time, so long<br/>that the text does<br/>not fit on a row.

        Bob-->Alice: Checking with John...
        Alice->John: Yes... John, how are you?
      """
    test.report 'mermaid-sequence', report, null, null, cb

  it "should create gantt diagram", (cb) ->
    report = new Report()
    report.mermaid """
      gantt
        title A Gantt Diagram

        section Section
        A task           :a1, 2014-01-01, 30d
        Another task     :after a1  , 20d
        section Another
        Task in sec      :2014-01-12  , 12d
        anther task      : 24d
      """
    test.report 'mermaid-gantt', report, null, null, cb
