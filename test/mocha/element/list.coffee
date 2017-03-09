### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "list", ->

#  it "should run first test", (cb) ->
#    test.markdown 'list/bullet', """
#      - write code
#      - test it
#    """, null, null, cb

  describe.only "examples", ->
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
        {type: 'list', nesting: 1}
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
        {format: 'text', re: /   ⭘ one\n   ⭘ two\n   ⭘ three/}
        {format: 'html', text: "<ul>\n<li><p>one</p></li>\n<li><p>two</p></li>\n<li><p>three</p></li>\n</ul>\n"}
      ], cb
