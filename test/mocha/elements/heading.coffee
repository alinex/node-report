### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "heading", ->

  describe "examples", ->

    it "should make examples", (cb) ->
      test.markdown 'heading/levels', """
      # heading 1
      ## heading 2
      ### heading 3
      #### heading 4
      ##### heading 5
      ###### heading 6
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
      ], cb


  describe "api", ->

    it "should create with given text", (cb) ->
      # create report
      report = new Report()
      report.heading 1, 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'heading', data: {level: 1}, nesting: 1}
        {type: 'text', data: {text: 'foo'}}
        {type: 'heading', data: {level: 1}, nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo\n===+\n/}
        {format: 'text', re: /foo\n═══+\n/}
        {format: 'html', text: "<h1>foo</h1>\n"}
        {format: 'man', text: ".TH foo\n"}
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
        {type: 'heading', data: {level: 1}, nesting: 1}
        {type: 'text', data: {text: 'foo'}}
        {type: 'text', data: {text: 'bar'}}
        {type: 'heading', data: {level: 1}, nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foobar\n===+\n/}
        {format: 'text', re: /foobar\n═══+\n/}
        {format: 'html', text: "<h1>foobar</h1>\n"}
        {format: 'man', text: ".TH foobar\n"}
      ], cb

    it "should work with shortcut", (cb) ->
      # create report
      report = new Report()
      report.h 1, 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'heading', data: {level: 1}, nesting: 1}
        {type: 'text', data: {text: 'foo'}}
        {type: 'heading', data: {level: 1}, nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo\n===+\n/}
        {format: 'text', re: /foo\n═══+\n/}
        {format: 'html', text: "<h1>foo</h1>\n"}
        {format: 'man', text: ".TH foo\n"}
      ], cb

    it "should allow level shortcuts", (cb) ->
      async.series [
        (cb) ->
          report = new Report()
          report.h1 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', data: {level: 1}, nesting: 1}
            {type: 'text', data: {text: 'foo'}}
            {type: 'heading', data: {level: 1}, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          report = new Report()
          report.h2 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', data: {level: 2}, nesting: 1}
            {type: 'text', data: {text: 'foo'}}
            {type: 'heading', data: {level: 2}, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          report = new Report()
          report.h3 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', data: {level: 3}, nesting: 1}
            {type: 'text', data: {text: 'foo'}}
            {type: 'heading', data: {level: 3}, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          report = new Report()
          report.h4 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', data: {level: 4}, nesting: 1}
            {type: 'text', data: {text: 'foo'}}
            {type: 'heading', data: {level: 4}, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          report = new Report()
          report.h5 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', data: {level: 5}, nesting: 1}
            {type: 'text', data: {text: 'foo'}}
            {type: 'heading', data: {level: 5}, nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          report = new Report()
          report.h6 'foo'
          # check it
          test.report null, report, [
            {type: 'document', nesting: 1}
            {type: 'heading', data: {level: 6}, nesting: 1}
            {type: 'text', data: {text: 'foo'}}
            {type: 'heading', data: {level: 6}, nesting: -1}
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
        {type: 'heading', data: {level: 1}, nesting: 1}
        {type: 'text', data: {text: 'foo'}}
        {type: 'heading', data: {level: 1}, nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo\n===+\n/}
        {format: 'text', re: /foo\n═══+\n/}
        {format: 'html', text: "<h1>foo</h1>\n"}
        {format: 'man', text: ".TH foo\n"}
      ], cb

    it "should close heading before opening new one", (cb) ->
      # create report
      report = new Report()
      report.h1 true
      report.h1 'foo'
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'heading', data: {level: 1}, nesting: 1}
        {type: 'heading', data: {level: 1}, nesting: -1}
        {type: 'heading', data: {level: 1}, nesting: 1}
        {type: 'text', data: {text: 'foo'}}
        {type: 'heading', data: {level: 1}, nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb


  describe "markdown", ->

    describe "atx heading", ->

      # http://spec.commonmark.org/0.27/#example-32
      it "should work with level 1", (cb) ->
        test.markdown null, '# foo', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
          {type: 'document', nesting: -1}
        ], [
          {format: 'md', re: /foo\n===+\n/}
          {format: 'text', re: /foo\n═══+\n/}
          {format: 'html', text: "<h1>foo</h1>\n"}
          {format: 'man', text: ".TH foo\n"}
        ], cb
      it "should work with level 2", (cb) ->
        test.markdown null, '## foo', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'document', nesting: -1}
        ], [
          {format: 'md', re: /foo\n---+\n/}
          {format: 'text', re: /foo\n━━━+\n/}
          {format: 'html', text: "<h2>foo</h2>\n"}
          {format: 'man', text: ".SH foo\n"}
        ], cb
      it "should work with level 3", (cb) ->
        test.markdown null, '### foo', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 3}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 3}, nesting: -1}
          {type: 'document', nesting: -1}
        ], [
          {format: 'md', re: /### foo\n/}
          {format: 'text', re: /foo\n╍╍╍+\n/}
          {format: 'html', text: "<h3>foo</h3>\n"}
          {format: 'man', text: ".SS foo\n"}
        ], cb
      it "should work with level 4", (cb) ->
        test.markdown null, '#### foo', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 4}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 4}, nesting: -1}
          {type: 'document', nesting: -1}
        ], [
          {format: 'md', re: /#### foo\n/}
          {format: 'text', re: /foo\n┅┅┅+\n/}
          {format: 'html', text: "<h4>foo</h4>\n"}
          {format: 'man', text: ".SS foo\n"}
        ], cb
      it "should work with level 5", (cb) ->
        test.markdown null, '##### foo', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 5}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 5}, nesting: -1}
          {type: 'document', nesting: -1}
        ], [
          {format: 'md', re: /##### foo\n/}
          {format: 'text', re: /foo\n───+\n/}
          {format: 'html', text: "<h5>foo</h5>\n"}
          {format: 'man', text: ".SS foo\n"}
        ], cb
      it "should work with level 6", (cb) ->
        test.markdown null, '###### foo', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 6}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 6}, nesting: -1}
          {type: 'document', nesting: -1}
        ], [
          {format: 'md', re: /###### foo\n/}
          {format: 'text', re: /foo\n┄┄┄┄+\n/}
          {format: 'html', text: "<h6>foo</h6>\n"}
          {format: 'man', text: ".SS foo\n"}
        ], cb

      # http://spec.commonmark.org/0.27/#example-33
      it "should fail with more than 6 # characters", (cb) ->
        test.markdown null, '####### foo', [
          {type: 'document', nesting: 1}
          {type: 'paragraph'}
          {type: 'text', data: {text: '####### foo'}}
          {type: 'paragraph'}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-34
      it "should fail if the space after # characters is missing", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, '#5 bolt', [
              {type: 'document', nesting: 1}
              {type: 'paragraph'}
              {type: 'text', data: {text: '#5 bolt'}}
              {type: 'paragraph'}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '#hashtag', [
              {type: 'document', nesting: 1}
              {type: 'paragraph'}
              {type: 'text', data: {text: '#hashtag'}}
              {type: 'paragraph'}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-35
      it "should fail if the first # characters is escaped", (cb) ->
        test.markdown null, '\\## foo', [
          {type: 'document', nesting: 1}
          {type: 'paragraph'}
          {type: 'text', data: {text: '## foo'}}
          {type: 'paragraph'}
          {type: 'document', nesting: -1}
        ], [
          format: 'md', text: '\\## foo'
        ], cb

      # http://spec.commonmark.org/0.27/#example-36
      it "should parse inline content", (cb) ->
        test.markdown null, '# foo *bar* \\*baz\\*', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'foo '}}
          {type: 'emphasis', nesting: 1}
          {type: 'text', data: {text: 'bar'}}
          {type: 'emphasis', nesting: -1}
          {type: 'text', data: {text: ' *baz*'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
          {type: 'document', nesting: -1}
        ], [
          format: 'md', text: 'foo *bar* \\*baz\\*\n==='
        ], cb

      # http://spec.commonmark.org/0.27/#example-37
      it "should work with more leading and trailing spaces", (cb) ->
        test.markdown null, '#       foo          ', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-38
      it "should work with 1-3 spaces indention", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, ' ### foo', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 3}, nesting: 1}
              {type: 'text', data: {text: 'foo'}}
              {type: 'heading', data: {level: 3}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '  ## foo', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 2}, nesting: 1}
              {type: 'text', data: {text: 'foo'}}
              {type: 'heading', data: {level: 2}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '   # foo', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 1}, nesting: 1}
              {type: 'text', data: {text: 'foo'}}
              {type: 'heading', data: {level: 1}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-39
      # http://spec.commonmark.org/0.27/#example-40
      it "should fail with over 3 spaces indention", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, '    # foo', [
              {type: 'document', nesting: 1}
              {type: 'preformatted', nesting: 1}
              {type: 'text', data: {text: '# foo'}}
              {type: 'preformatted', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, 'foo\n    # bar', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: 'foo # bar'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-41
      it "should work with closing # characters", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, '## foo ##', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 2}, nesting: 1}
              {type: 'text', data: {text: 'foo'}}
              {type: 'heading', data: {level: 2}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '  ###   bar    ###', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 3}, nesting: 1}
              {type: 'text', data: {text: 'bar'}}
              {type: 'heading', data: {level: 3}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-42
      it "should work with more or less # characters at the end than at the start", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, '# foo ##################################', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 1}, nesting: 1}
              {type: 'text', data: {text: 'foo'}}
              {type: 'heading', data: {level: 1}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '##### foo ##', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 5}, nesting: 1}
              {type: 'text', data: {text: 'foo'}}
              {type: 'heading', data: {level: 5}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-43
      it "should work with closing # characters and ending spaces", (cb) ->
        test.markdown null, '### foo ### ', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 3}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 3}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-44
      it "should work with closing # characters and others go into text", (cb) ->
        test.markdown null, '### foo ### b', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 3}, nesting: 1}
          {type: 'text', data: {text: 'foo ### b'}}
          {type: 'heading', data: {level: 3}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-45
      it "should work with closing # characters not separated go into text", (cb) ->
        test.markdown null, '# foo#', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'foo#'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-46
      it "should work with escaped closing # characters go into text", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, '### foo \\###', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 3}, nesting: 1}
              {type: 'text', data: {text: 'foo ###'}}
              {type: 'heading', data: {level: 3}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '## foo #\\##', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 2}, nesting: 1}
              {type: 'text', data: {text: 'foo ###'}}
              {type: 'heading', data: {level: 2}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '# foo ##\\#', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 1}, nesting: 1}
              {type: 'text', data: {text: 'foo ###'}}
              {type: 'heading', data: {level: 1}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-47
      # http://spec.commonmark.org/0.27/#example-48
      it "should work without separation to surrounding content", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, '****\n## foo\n****', [
              {type: 'document', nesting: 1}
              {type: 'thematic_break'}
              {type: 'heading', data: {level: 2}, nesting: 1}
              {type: 'text', data: {text: 'foo'}}
              {type: 'heading', data: {level: 2}, nesting: -1}
              {type: 'thematic_break'}
              {type: 'document', nesting: -1}
            ], [
              format: 'md'
            ], cb
          (cb) ->
            test.markdown null, 'Foo bar\n# baz\nBar foo', [
              {type: 'document', nesting: 1}
              {type: 'paragraph'}
              {type: 'text'}
              {type: 'paragraph'}
              {type: 'heading', data: {level: 1}, nesting: 1}
              {type: 'text', data: {text: 'baz'}}
              {type: 'heading', data: {level: 1}, nesting: -1}
              {type: 'paragraph'}
              {type: 'text'}
              {type: 'paragraph'}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-49
      it "should work with empty headings", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, '## ', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 2}, nesting: 1}
              {type: 'heading', data: {level: 2}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '#', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 1}, nesting: 1}
              {type: 'heading', data: {level: 1}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '### ###', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 3}, nesting: 1}
              {type: 'heading', data: {level: 3}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb


    describe "setext heading", ->

      # http://spec.commonmark.org/0.27/#example-50
      it "should work with level 1 and 2", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, 'Foo bar\n=========', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 1}, nesting: 1}
              {type: 'text', data: {text: 'Foo bar'}}
              {type: 'heading', data: {level: 1}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, 'Foo bar\n---------', [
              {type: 'document', nesting: 1}
              {type: 'heading', data: {level: 2}, nesting: 1}
              {type: 'text', data: {text: 'Foo bar'}}
              {type: 'heading', data: {level: 2}, nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-51
      it "should work with multiline header", (cb) ->
        test.markdown null, 'Foo bar\nbaz\n===', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'Foo bar baz'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-52
      it "should work with different underline length", (cb) ->
        test.markdown null, 'Foo\n-------------------------\nFoo\n=', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-53
      it "should work with different indention", (cb) ->
        test.markdown null, '   Foo\n---\n  Foo\n-----\n  Foo\n  ===', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-54
      it "should fail with 4 or more spaces of indention", (cb) ->
        test.markdown null, '    Foo\n    ---\n\n    Foo\n----', [
          {type: 'document', nesting: 1}
          {type: 'preformatted', nesting: 1}
          {type: 'text', data: {text: 'Foo\n---'}}
          {type: 'preformatted', nesting: -1}
          {type: 'preformatted', nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'preformatted', nesting: -1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-55
      it "should work with different indention of underline", (cb) ->
        test.markdown null, 'Foo\n   ----      ', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-56
      it "should fail with 4 or more spaces of indention of underline", (cb) ->
        test.markdown null, 'Foo\n    ---', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Foo ---'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-57
      it "should fail with spaces in underline", (cb) ->
        test.markdown null, 'Foo\n= =\n\nFoo\n--- -', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Foo = ='}}
          {type: 'paragraph', nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'paragraph', nesting: -1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-58
      it.only "should work with trailing spaces reduced", (cb) ->
        test.markdown null, 'Foo  \n-----', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo '}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'document', nesting: -1}
        ], [
          {format: 'html', re: /<h2>Foo<\/h2>/}
        ], cb

      # http://spec.commonmark.org/0.27/#example-59
      it "should work with backslash at the end not replaced", (cb) ->
        test.markdown null, 'Foo\\\n----', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo\\'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-60
      it "should have precedence for block over inline elements", (cb) ->
        test.markdown null, """
          `Foo
          ----
          `

          <a title="a lot
          ---
          of dashes"/>
        """, [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: '`Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '`'}}
          {type: 'paragraph', nesting: -1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: '<a title="a lot'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'of dashes"/>'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

#######################################################
# go on at example 61 - 63
#######################################################

      # http://spec.commonmark.org/0.27/#example-64
      it "should make heading if blank line is missing between paragraph and heading", (cb) ->
        test.markdown null, 'Foo\nBar\n---', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo\nBar'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-65
      it "should work without blank line before or after", (cb) ->
        test.markdown null, '---\nFoo\n---\nBar\n---\nBaz', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Bar'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Baz'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-66
      it "should fail on empty heading", (cb) ->
        test.markdown null, '\n====', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '===='}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-67
      it "should not make heading if text is thematic break", (cb) ->
        test.markdown null, '---\n---', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb

#################################################
# example 68-70 missing
#################################################

      # http://spec.commonmark.org/0.27/#example-71
      it "should make heading of masked other characters", (cb) ->
        test.markdown null, '\> foo\n------', [
          {type: 'document', nesting: 1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: '> foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-72
      it "should work with paragraph before heading", (cb) ->
        test.markdown null, 'Foo\n\nbar\n---\nbaz', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'paragraph', nesting: -1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'bar'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'baz'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-73
      it "should use thematic break between paragraphs", (cb) ->
        test.markdown null, 'Foo\nbar\n\n---\n\nbaz', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Foo\nbar'}}
          {type: 'paragraph', nesting: -1}
          {type: 'thematic_break'}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'baz'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-74
      it "should use thematic break with characters not used for setext", (cb) ->
        test.markdown null, 'Foo\nbar\n* * *\nbaz', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Foo\nbar'}}
          {type: 'paragraph', nesting: -1}
          {type: 'thematic_break'}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'baz'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-75
      # behaviour chnaged to original to make all text here
      it "should contain dashes in text with escaping", (cb) ->
        test.markdown null, 'Foo\nbar\n\\---\nbaz', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Foo\nbar\n---\nbaz'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
