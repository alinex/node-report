### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "heading", ->

  describe "examples", ->

    it "should make heading examples", (cb) ->
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

    it "should create level 1", (cb) ->
      # create report
      report = new Report()
      report.h1 'foo'
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

  describe "markdown", ->

    describe "atx heading", ->

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

      it "should fail with more than 6 # characters", (cb) ->
        test.markdown null, '####### foo', [
          {type: 'document', nesting: 1}
          {type: 'paragraph'}
          {type: 'text', data: {text: '####### foo'}}
          {type: 'paragraph'}
          {type: 'document', nesting: -1}
        ], null, cb

      it "should fail if the space after # characters is missing", (cb) ->
        async.series [
          (cb) -> test.markdown null, '#5 bolt', [
            {type: 'document', nesting: 1}
            {type: 'paragraph'}
            {type: 'text', data: {text: '#5 bolt'}}
            {type: 'paragraph'}
            {type: 'document', nesting: -1}
            ], null, cb
          (cb) -> test.markdown null, '#hashtag', [
            {type: 'document', nesting: 1}
            {type: 'paragraph'}
            {type: 'text', data: {text: '#hashtag'}}
            {type: 'paragraph'}
            {type: 'document', nesting: -1}
            ], null, cb
        ], cb

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

      it.only "should parse inline content", (cb) ->
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





      it "should work with more leading or trailing spaces", ->
        test.success '#       foo', [
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
        ]
        test.success '#       foo          ', [
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
        ]

      it "should work 1-3 spaces indention", ->
        test.success ' ### foo', [
          {type: 'heading'}, {type: 'text'}, {type: 'heading'}
        ]
        test.success '  ## foo', [
          {type: 'heading'}, {type: 'text'}, {type: 'heading'}
        ]
        test.success '   # foo', [
          {type: 'heading'}, {type: 'text'}, {type: 'heading'}
        ]

      it "should fail with over 3 spaces indention", ->
        test.success '    # foo', [
          {type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}
        ]
        test.success '\t# foo', [
          {type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}
        ]

      it "should work with closing # characters", ->
        test.success '## foo ##', [
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
        ]
        test.success '  ###   bar    ###', [
          {type: 'heading', data: {level: 3}, nesting: 1}
          {type: 'text', data: {text: 'bar'}}
          {type: 'heading', data: {level: 3}, nesting: -1}
        ]

      it "should work with more or less # characters at the end than at the start", ->
        test.success '# foo ##################################', [
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
        ]
        test.success '##### foo ##', [
          {type: 'heading', data: {level: 5}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 5}, nesting: -1}
        ]

      it "should work with closing # characters and ending spaces", ->
        test.success '### foo ### ', [
          {type: 'heading', data: {level: 3}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 3}, nesting: -1}
        ]

      it "should work with closing # characters and others go into text", ->
        test.success '### foo ### b', [
          {type: 'heading', data: {level: 3}, nesting: 1}
          {type: 'text', data: {text: 'foo ### b'}}
          {type: 'heading', data: {level: 3}, nesting: -1}
        ]

      it "should work with closing # characters not separated go into text", ->
        test.success '# foo#', [
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'foo#'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
        ]

      it "should work with escaped closing # characters go into text", ->
        test.success '### foo \\###', [
          {type: 'heading', data: {level: 3}, nesting: 1}
          {type: 'text', data: {text: 'foo ###'}}
          {type: 'heading', data: {level: 3}, nesting: -1}
        ]
        test.success '## foo #\\##', [
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'foo ###'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
        ]
        test.success '# foo \\#', [
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'foo #'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
        ]

      it "should work without separation to surrounding content", ->
        test.success '****\n## foo\n****', [
          {type: 'thematic_break'}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'thematic_break'}
        ]
        test.success 'Foo bar\n# baz\nBar foo', [
          {type: 'paragraph'}
          {type: 'text'}
          {type: 'paragraph'}
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'baz'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
          {type: 'paragraph'}
          {type: 'text'}
          {type: 'paragraph'}
        ]

      it "should work with empty headings", ->
        test.success '## ', [
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'heading', data: {level: 2}, nesting: -1}
        ]
        test.success '#', [
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'heading', data: {level: 1}, nesting: -1}
        ]
        test.success '### ###', [
          {type: 'heading', data: {level: 3}, nesting: 1}
          {type: 'heading', data: {level: 3}, nesting: -1}
        ]

    describe "setext heading", ->

      it "should work with level 1 and 2", ->
        test.success 'Foo bar\n=========', [
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'Foo bar'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
        ]
        test.success 'Foo bar\n---------', [
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo bar'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
        ]

      it "should work with multiline header", ->
        test.success 'Foo bar\nbaz\n===', [
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'Foo bar\nbaz'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
        ]

      it "should work with different underline length", ->
        test.success 'Foo\n-------------------------\nFoo\n=', [
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
        ]

      it "should work with different indention", ->
        test.success '   Foo\n---\n  Foo\n-----\n  Foo\n  ===', [
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
          {type: 'heading', data: {level: 1}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 1}, nesting: -1}
        ]
#Four spaces indent is too much:
#Example 54Try It
#
#    Foo
#    ---
#
#    Foo
#---
#
#<pre><code>Foo
#---
#
#Foo
#</code></pre>
#<hr />

      it "should work with different indention of underline", ->
        test.success 'Foo\n   ----      ', [
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
        ]

      it "should fail with 4 or more spaces of indention of underline", ->
        test.success 'Foo\n    ---', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Foo\n---'}}
          {type: 'paragraph', nesting: -1}
        ]

      it "should fail with spaces in underline", ->
        test.success 'Foo\n= =\n\nFoo\n--- -', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Foo\n= ='}}
          {type: 'paragraph', nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'paragraph', nesting: -1}
          {type: 'thematic_break'}
        ]

      it "should work with trailing spaces removed", ->
        test.success 'Foo  \n-----', [
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
        ]

      it "should work with backslash at the end not replaced", ->
        test.success 'Foo\\\n----', [
          {type: 'heading', data: {level: 2}, nesting: 1}
          {type: 'text', data: {text: 'Foo\\'}}
          {type: 'heading', data: {level: 2}, nesting: -1}
        ]

# go on at example 60
