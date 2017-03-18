### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "box", ->

  describe "examples", ->
    @timeout 30000

    it "should allow detail", (cb) ->
      test.markdown 'box/detail', """
        ::: detail
        Some details here...
        :::
        """, null, true, cb

    it "should allow info", (cb) ->
      test.markdown 'box/info', """
        ::: info
        And a little information to help you...
        :::
        """, null, true, cb

    it "should allow ok", (cb) ->
      test.markdown 'box/ok', """
        ::: ok
        Everything works fine.
        :::
        """, null, true, cb

    it "should allow warning", (cb) ->
      test.markdown 'box/warning', """
        ::: warning
        Some orders have to wait till later...
        :::
        """, null, true, cb

    it "should allow alert", (cb) ->
      test.markdown 'box/alert', """
        ::: alert
        The process failed at...
        :::
        """, null, true, cb

    it "should allow info", (cb) ->
      test.markdown 'box/multi', """
        ::: info
        foo
        ::: ok
        bar
        :::
        """, null, true, cb

    it "should allow multi box", (cb) ->
      test.markdown 'box/multi', """
        ::: ok
        Everything works fine.
        ::: warning
        Some orders have to wait till later...
        ::: alert
        The process failed at...
        :::
        """, null, true, cb

    it "should allow min size display", (cb) ->
      test.markdown 'box/min', """
        ::: ok
        This is a very long note to show how it will look in the different display
        modes which will show it minimized, maximized or with an scroll bar. It is
        shown in the minimized form at start but you may click it into scroll or
        maximized view as you like. In any other output which is not HTML it will
        always be displayed in full size (maximized). You may use the icons on the
        top left to change the appearance of this box if you want to minimize it,
        to open back in auto size (with possible scrollbars) or to maximize like
        in print view.

        This is a very long note to show how it will look in the different display
        modes which will show it minimized, maximized or with an scroll bar. It is
        shown in the minimized form at start but you may click it into scroll or
        maximized view as you like. In any other output which is not HTML it will
        always be displayed in full size (maximized). You may use the icons on the
        top left to change the appearance of this box if you want to minimize it,
        to open back in auto size (with possible scrollbars) or to maximize like
        in print view.
        :::
        <!-- {container:size=min} -->
        """, null, true, cb

    it "should allow auto size display", (cb) ->
      test.markdown 'box/auto', """
        ::: ok
        This is a very long note to show how it will look in the different display
        modes which will show it minimized, maximized or with an scroll bar. It is
        shown in the minimized form at start but you may click it into scroll or
        maximized view as you like. In any other output which is not HTML it will
        always be displayed in full size (maximized). You may use the icons on the
        top left to change the appearance of this box if you want to minimize it,
        to open back in auto size (with possible scrollbars) or to maximize like
        in print view.

        This is a very long note to show how it will look in the different display
        modes which will show it minimized, maximized or with an scroll bar. It is
        shown in the minimized form at start but you may click it into scroll or
        maximized view as you like. In any other output which is not HTML it will
        always be displayed in full size (maximized). You may use the icons on the
        top left to change the appearance of this box if you want to minimize it,
        to open back in auto size (with possible scrollbars) or to maximize like
        in print view.
        :::
        <!-- {container:size=auto} -->
        """, null, true, cb

    it "should allow max size display", (cb) ->
      test.markdown 'box/max', """
        ::: ok
        This is a very long note to show how it will look in the different display
        modes which will show it minimized, maximized or with an scroll bar. It is
        shown in the minimized form at start but you may click it into scroll or
        maximized view as you like. In any other output which is not HTML it will
        always be displayed in full size (maximized). You may use the icons on the
        top left to change the appearance of this box if you want to minimize it,
        to open back in auto size (with possible scrollbars) or to maximize like
        in print view.

        This is a very long note to show how it will look in the different display
        modes which will show it minimized, maximized or with an scroll bar. It is
        shown in the minimized form at start but you may click it into scroll or
        maximized view as you like. In any other output which is not HTML it will
        always be displayed in full size (maximized). You may use the icons on the
        top left to change the appearance of this box if you want to minimize it,
        to open back in auto size (with possible scrollbars) or to maximize like
        in print view.
        :::
        <!-- {container:size=max} -->
        """, null, true, cb

    it "should allow pre content", (cb) ->
      test.markdown 'box/pre', """
        ::: detail
            Some preformatted
              text here.
            Which should work!
        :::
        """, null, true, cb

    it "should allow code content", (cb) ->
      test.markdown 'box/code', """
        ::: detail
        ``` javascript
        var x = Math.round(f);
        ```
        :::
        """, null, true, cb

    it "should allow table content", (cb) ->
      test.markdown 'box/table', """
        ::: detail
        | ID | English | German |
        |:-- |:------- |:------ |
        | 1  | one     | eins   |
        | 2  | two     | zwei   |
        | 3  | three   | drei   |
        | 12 | twelve  | zwölf  |
        :::
        """, null, true, cb

  describe "api", ->

    it "should create simple box", (cb) ->
      # create report
      report = new Report()
      report.box 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'container', nesting: 1}
        {type: 'box', nesting: 1, box: 'detail', title: 'Detail'}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'container', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text: "::: detail Detail\nfoo\n:::"}
        {format: 'text', text: '#########\n# Detail #\n#--------#\n# foo    #\n##########'}
        {format: 'console', text: '\u001b[37m╔════════╗\u001b[39m\n\u001b[37m║ \u001b[1mDetail\u001b[22m ║\u001b[39m\n\u001b[37m╟────────╢\u001b[39m\n\u001b[37m║\u001b[39m foo    \u001b[37m║\u001b[39m\n\u001b[37m╚════════╝\u001b[39m\n'}
        {format: 'html', text: '<div class="container">\n<input name="tabs1" class="tab tab1" id="tab1-1" checked="" type="radio">\n<label for="tab1-1" class="detail" title="Switch tab">Detail</label><div class="box box1 detail">\n<p>foo</p>\n</div>\n</div>'}
      ], cb

    it "should create info box", (cb) ->
      # create report
      report = new Report()
      report.box 'foo', 'info'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'container', nesting: 1}
        {type: 'box', nesting: 1, box: 'info', title: 'Info'}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'container', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create info box with title", (cb) ->
      # create report
      report = new Report()
      report.box 'foo', 'info', 'Information'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'container', nesting: 1}
        {type: 'box', nesting: 1, box: 'info', title: 'Information'}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'container', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create info box with title (through container call)", (cb) ->
      # create report
      report = new Report()
      report.container 'foo', 'info', 'Information'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'container', nesting: 1}
        {type: 'box', nesting: 1, box: 'info', title: 'Information'}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'box', nesting: -1}
        {type: 'container', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "format", ->

    it "should select start box", (cb) ->
      test.markdown null, """
        ::: ok Ok
        Everything works fine.
        ::: warning Warning
        <!-- {selected} -->
        Some orders have to wait till later...
        ::: alert Alert
        The process failed at...
        :::
        """, null, [
        {format: 'html', text: '<input name="tabs1" class="tab tab2" id="tab1-2" checked="" type="radio">'}
      ], cb

    it "should select start element on container with box title", (cb) ->
      test.markdown null, """
        ::: ok Ok
        Everything works fine.
        ::: warning Warning
        Some orders have to wait till later...
        ::: alert Alert
        The process failed at...
        :::
        <!-- {container:selected=Warning} -->
        """, null, [
        {format: 'html', text: '<input name="tabs1" class="tab tab2" id="tab1-2" checked="" type="radio">'}
      ], cb

    it "should select start element on container with box number", (cb) ->
      test.markdown null, """
        ::: ok Ok
        Everything works fine.
        ::: warning Warning
        Some orders have to wait till later...
        ::: alert Alert
        The process failed at...
        :::
        <!-- {container:selected=2} -->
        """, null, [
        {format: 'html', text: '<input name="tabs1" class="tab tab2" id="tab1-2" checked="" type="radio">'}
      ], cb
