chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "style", ->

  describe "examples", ->
    @timeout 30000

    it "should make html block examples", (cb) ->
      test.markdown 'style/html-block', """
        Red text

        <!-- {.text-red} -->
      """, null, true, cb

    it "should make html inline examples", (cb) ->
      test.markdown 'style/html-inline', 'Test class<!-- {.text-red} -->', null, true, cb

  describe "api", ->

    it "should create as block", (cb) ->
      # create report
      report = new Report()
      report.p 'foo'
      report.style '.red', 'html'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'style', content: '.red'}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "format", ->

    it "should add class", (cb) ->
      test.markdown null, """
        Red text <!-- {.red} -->
        """, null, [
        {format: 'html', text: '<p class="red">Red text </p>'}
      ], cb

    it "should add multiple classes", (cb) ->
      test.markdown null, """
        Red text <!-- {.red.center} -->
        """, null, [
        {format: 'html', text: '<p class="red center">Red text </p>'}
      ], cb

    it "should add id", (cb) ->
      test.markdown null, """
        Red text <!-- {#red} -->
        """, null, [
        {format: 'html', text: '<p id="red">Red text </p>'}
      ], cb

    it "should add attribute", (cb) ->
      test.markdown null, """
        It's an ![alinex](http://alinex.github.io/images/Alinex-200.png \"my logo\") project.
        <!-- {width=100} -->
        """, null, [
        {format: 'html', text: '<img width="100" src="http://alinex.github.io/images/Alinex-200.png" title="my logo" alt="alinex" />'}
      ], cb

    it "should specify element", (cb) ->
      test.markdown null, """
        Multiple **bold** and _italic_ elements.
        <!-- {bold:.red} -->
        """, null, [
        {format: 'html', text: '<strong class="red">bold</strong>'}
      ], cb

    it "should specify element (with depth)", (cb) ->
      test.markdown null, """
        Multiple **1**, **2**, **3** and **4**.
        <!-- {bold^:.red} -->
        """, null, [
        {format: 'html', text: '<strong class="red">3</strong>'}
      ], cb

    it "should specify element (with depth number)", (cb) ->
      test.markdown null, """
        Multiple **1**, **2**, **3** and **4**.
        <!-- {bold^2:.red} -->
        """, null, [
        {format: 'html', text: '<strong class="red">2</strong>'}
      ], cb

    it "should work on blockquote", (cb) ->
      test.markdown null, """
        > Red text <!-- {blockquote:.red} -->
        """, null, [
        {format: 'html', text: '<blockquote class="red">'}
      ], cb

    it "should work on paragraph", (cb) ->
      test.markdown null, """
        Red text <!-- {.red} -->
        """, null, [
        {format: 'html', text: '<p class="red">Red text </p>'}
      ], cb

    it "should work on image", (cb) ->
      test.markdown null, """
        ![foo](foo.gif) <!-- {.red} -->
        """, null, [
        {format: 'html', text: '<img class="red" src="foo.gif" alt="foo" />'}
      ], cb

    it "should allow kramdown syntax", (cb) ->
      test.markdown null, """
        Red text <!-- {:.red} -->
        """, null, [
        {format: 'html', text: '<p class="red">Red text </p>'}
      ], cb

    it "should allow kramdown syntax with space", (cb) ->
      test.markdown null, """
        Red text <!-- {: .red} -->
        """, null, [
        {format: 'html', text: '<p class="red">Red text </p>'}
      ], cb
