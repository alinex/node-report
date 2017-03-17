### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "heading", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'heading/levels', """
      # heading 1
      ## heading 2
      ### heading 3
      #### heading 4
      ##### heading 5
      ###### heading 6
      """, null, true, cb


  describe "api", ->

    it "should create with given text", (cb) ->
      # create report
      report = new Report()
      report.heading 1, 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'heading', heading: 1, nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'heading', heading: 1, nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo\n===+/}
        {format: 'text', re: /foo\n###+/}
        {format: 'console', re: /\u001b\[33m\u001b\[1mfoo\u001b\[22m\u001b\[39m\u001b\[33m\n═══+/}
        {format: 'html', text: "<h1 id=\"foo\">foo</h1>\n"}
        {format: 'man', re: /\.TH "FOO" "" "\w+ \d+" "" ""\n\.SH "NAME"\n\\fBfoo\\fR/}
      ], cb

    it "should create in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.h1 true
      report.text 'foo'
      report.text 'bar'
      report.h1 false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'heading', heading: 1, nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'text', content: 'bar'}
        {type: 'heading', heading: 1, nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foobar\n===+/}
        {format: 'text', re: /foobar\n###+/}
        {format: 'console', re: /\u001b\[33m\u001b\[1mfoobar\u001b\[22m\u001b\[39m\u001b\[33m\n═══+/}
        {format: 'html', text: "<h1 id=\"foobar\">foobar</h1>\n"}
        {format: 'man', text: ".TH \"FOOBAR\""}
      ], cb

    it "should work with shortcut", (cb) ->
      # create report
      report = new Report()
      report.h 1, 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'heading', heading: 1, nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'heading', heading: 1, nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo\n===+/}
        {format: 'text', re: /foo\n###+/}
        {format: 'console', re: /\u001b\[33m\u001b\[1mfoo\u001b\[22m\u001b\[39m\u001b\[33m\n═══+/}
        {format: 'html', text: "<h1 id=\"foo\">foo</h1>\n"}
        {format: 'man', text: ".TH \"FOO\""}
      ], cb

    it "should allow level shortcuts", (cb) ->
      async.series [
        (cb) ->
          report = new Report()
          report.h1 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', heading: 1, nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'heading', heading: 1, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          report = new Report()
          report.h2 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', heading: 2, nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'heading', heading: 2, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          report = new Report()
          report.h3 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', heading: 3, nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'heading', heading: 3, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          report = new Report()
          report.h4 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', heading: 4, nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'heading', heading: 4, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          report = new Report()
          report.h5 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', heading: 5, nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'heading', heading: 5, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          report = new Report()
          report.h6 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', heading: 6, nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'heading', heading: 6, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
      ], cb

    it "should autoclose paragraph if heading is added", (cb) ->
      # create report
      report = new Report()
      report.p true
      report.h 1, 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'heading', heading: 1, nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'heading', heading: 1, nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo\n===+/}
        {format: 'text', re: /foo\n###+/}
        {format: 'console', re: /\u001b\[33m\u001b\[1mfoo\u001b\[22m\u001b\[39m\u001b\[33m\n═══+/}
        {format: 'html', text: "<h1 id=\"foo\">foo</h1>\n"}
        {format: 'man', text: ".TH \"FOO\""}
      ], cb

    it "should close heading before opening new one", (cb) ->
      # create report
      report = new Report()
      report.h1 true
      report.h1 'foo'
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'heading', heading: 1, nesting: 1}
        {type: 'heading', heading: 1, nesting: -1}
        {type: 'heading', heading: 1, nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'heading', heading: 1, nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should format with escape", (cb) ->
      # create report
      report = new Report()
      report.paragraph '# foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '# foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /\\# foo/}
      ], cb

    it "should automatically close heading", (cb) ->
      # create report
      report = new Report()
      report.h1 true
      report.text 'foo'
      report.h2 'bar'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'heading', heading: 1, nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'heading', heading: 1, nesting: -1}
        {type: 'heading', heading: 2, nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'heading', heading: 2, nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should automatically close paragraph", (cb) ->
      # create report
      report = new Report()
      report.p true
      report.text 'foo'
      report.h2 'bar'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'heading', heading: 2, nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'heading', heading: 2, nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
