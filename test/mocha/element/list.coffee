### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "list", ->

  describe "examples", ->
    @timeout 30000

    it "should make tight list", (cb) ->
      test.markdown 'list/tight', """
        Capital Cities:
        - Europe
          - Berlin
          - London
          - Paris
        - Africa
          - Tunis
          - Kairo
      """, null, true, cb

    it "should make loose list", (cb) ->
      test.markdown 'list/loose', """
        Capital Cities:
        - Berlin

          Capital city of germany

        - London

          Capital city of great britan

        - Paris

          Capital city of france
      """, null, true, cb

    it "should make bullet list", (cb) ->
      test.markdown 'list/bullet', """
        Capital Cities:
        - Berlin
        - London
        - Paris
        - Tunis
        - Kairo
      """, null, true, cb

    it "should make ordered list", (cb) ->
      test.markdown 'list/ordered', """
        Capital Cities:
        1. Europe
           1. London
           2. Berlin
           3. Paris
        2. Africa
           1. Kairo
           2. Tunis
      """, null, true, cb

    it "should make ordered list (with start number)", (cb) ->
      test.markdown 'list/ordered-start', """
        Capital Cities:

        4. Kairo
        5. Tunis
      """, null, true, cb

    it "should make mixed list", (cb) ->
      test.markdown 'list/mixed', """
        Capital Cities:
        1. Europe
           - London
           - Berlin
           - Paris
        2. Africa
           - Kairo
           - Tunis
      """, null, true, cb

    it "should make bullet task list", (cb) ->
      test.markdown 'list/bullet-task', """
        Solar System Exploration, 1950s – 1960s
        - [ ] Mercury
        - [x] Venus
        - [x] Earth (Orbit/Moon)
        - [x] Mars
        - [ ] Jupiter
        - [ ] Saturn
        - [ ] Uranus
        - [ ] Neptune
        - [ ] Comet Haley
        - anything missing?
      """, null, true, cb

    it "should make ordered task list", (cb) ->
      test.markdown 'list/ordered-task', """
        Solar System Exploration, 1950s – 1960s
        1.  [ ] Mercury
        2.  [x] Venus
        3.  [x] Earth (Orbit/Moon)
        4.  [x] Mars
        5.  [ ] Jupiter
        6.  [ ] Saturn
        7.  [ ] Uranus
        8.  [ ] Neptune
        9.  [ ] Comet Haley
        10. anything missing?
      """, null, true, cb

  describe "api", ->

    it "should create bullet list", (cb) ->
      # create report
      report = new Report()
      report.list ['one', 'two', 'three'], 'bullet'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'three'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /   - one\n   - two\n   - three/}
        {format: 'text', re: /   • one\n   • two\n   • three/}
        {format: 'html', text: "<ul>\n<li>one</li>\n<li>two</li>\n<li>three</li>\n</ul>\n"}
      ], cb

    it "should create ordered list", (cb) ->
      # create report
      report = new Report()
      report.list ['one', 'two', 'three'], 'ordered'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'three'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /  1. one\n  2. two\n  3. three/}
        {format: 'text', re: /  1. one\n  2. two\n  3. three/}
        {format: 'html', text: "<ol>\n<li>one</li>\n<li>two</li>\n<li>three</li>\n</ol>\n"}
      ], cb

    it "should create ordered list (with start)", (cb) ->
      # create report
      report = new Report()
      report.list ['one', 'two', 'three'], 'ordered', 3
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 3}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'three'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /  3. one\n  4. two\n  5. three/}
        {format: 'text', re: /  3. one\n  4. two\n  5. three/}
        {format: 'html', text: "<ol start=\"3\">\n<li>one</li>\n<li>two</li>\n<li>three</li>\n</ol>\n"}
      ], cb

    it "should create in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.list true, 'bullet'
      report.item 'one'
      report.item 'two'
      report.item 'three'
      report.list false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'three'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /   - one\n   - two\n   - three/}
        {format: 'text', re: /   • one\n   • two\n   • three/}
        {format: 'html', text: "<ul>\n<li>one</li>\n<li>two</li>\n<li>three</li>\n</ul>\n"}
      ], cb

    it "should create task list", (cb) ->
      # create report
      report = new Report()
      report.list true, 'bullet'
      report.item 'one', true
      report.item 'two', false
      report.item 'three'
      report.list false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1, task: true}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1, task: false}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'three'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text: '   - [X] one\n   - [ ] two\n   - three'}
        {format: 'text', text: '   • ☒ one\n   • ☐ two\n   • three'}
        {format: 'html', text: '<ul>\n<li class="task"><input class="task-checkbox" disabled="" checked="" type="checkbox"> one</li>\n<li><input class="task-checkbox" disabled="" type="checkbox"> two</li>\n<li>three</li>\n</ul>'}
      ], cb
