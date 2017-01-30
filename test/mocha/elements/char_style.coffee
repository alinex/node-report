### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "char_style", ->

  describe.skip "examples", ->

    it "should make examples", (cb) ->
      test.markdown 'char_style/formats', """
        `typewriter`
        **bold**
        _italic_
        ^superscript^
        ~subscript~
        ~~strikethrough~~
        ==marked==
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe.skip "api", ->

    it "should create typewriter", (cb) ->
      # create report
      report = new Report()
      report.
      report.tt 'test'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'typewriter', nesting: 1}
        {type: 'text', data: {text: 'test'}}
        {type: 'typewriter', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /`test`/}
        {format: 'text', re: /`test`/}
        {format: 'html', text: "<code>test</code>\n"}
        {format: 'man', text: "\\fBtest\\fP"}
      ], cb

  describe "markdown", ->

    describe "code span", ->

      # http://spec.commonmark.org/0.27/#example-312
      it "should work with simple code", (cb) ->
        test.markdown null, '`foo`', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'fixed', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-313
      it "should work with multiple backquotes", (cb) ->
        test.markdown null, '`` foo ` bar  ``', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: 'foo ` bar'}}
          {type: 'fixed', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-314
      it "should work with nested backquotes", (cb) ->
        test.markdown null, '` `` `', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: '``'}}
          {type: 'fixed', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-315
      it "should treat line endings like spaces", (cb) ->
        test.markdown null, '``\nfoo\n``', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'fixed', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-316
      it "should collapse into single space", (cb) ->
        test.markdown null, '`foo   bar\n  baz`', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: 'foo bar baz'}}
          {type: 'fixed', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-317
      it "should keep unicode no-breaking space", (cb) ->
        test.markdown null, '`a  b`', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: 'a  b'}}
          {type: 'fixed', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-318
      it "should keep back quotes within", (cb) ->
        test.markdown null, '`foo `` bar`', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: 'foo `` bar'}}
          {type: 'fixed', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-319
      it "should keep back quotes within", (cb) ->
        test.markdown null, '`foo\\`bar`', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: 'foo\\'}}
          {type: 'fixed', nesting: -1}
          {type: 'text', data: {text: 'bar`'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-320
      it "should have higher priority for code", (cb) ->
        test.markdown null, '*foo`*`', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '*foo'}}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: '*'}}
          {type: 'fixed', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-321
      it "should break link definition", (cb) ->
        test.markdown null, '[not a `link](/foo`)', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '[not a '}}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: 'link](/foo'}}
          {type: 'fixed', nesting: -1}
          {type: 'text', data: {text: ')'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-322
      it "should break html tags", (cb) ->
        test.markdown null, '`<a href="`">`', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: '<a href="'}}
          {type: 'fixed', nesting: -1}
          {type: 'text', data: {text: '">`'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

#################################################
# example 323

      # http://spec.commonmark.org/0.27/#example-324
      it "should break auto link", (cb) ->
        test.markdown null, '`<http://foo.bar.`baz>`', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'fixed', nesting: 1}
          {type: 'text', data: {text: '<http://foo.bar.'}}
          {type: 'fixed', nesting: -1}
          {type: 'text', data: {text: 'baz>`'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

#################################################
# example 325

      # http://spec.commonmark.org/0.27/#example-326
      # http://spec.commonmark.org/0.27/#example-327
      it "should ignore if end marker not matched", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, '```foo``', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: '```foo``'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '`foo', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: '`foo'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

    describe "emphasis", ->

      # http://spec.commonmark.org/0.27/#example-328
      it "should work with * for emphasis", (cb) ->
        test.markdown null, '*foo bar*', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'emphasis', nesting: 1}
          {type: 'text', data: {text: 'foo bar'}}
          {type: 'emphasis', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-329
      it "should fail if followed by whitespace", (cb) ->
        test.markdown null, 'a * foo bar*', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'a * foo bar*'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-330
      it "should fail if followed by non alphanumeric character", (cb) ->
        test.markdown null, 'a*"foo"*', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'a*"foo"*'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-331
      it "should fail with unicode no-breaking space", (cb) ->
        test.markdown null, '* a *', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '* a *'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-332
      # http://spec.commonmark.org/0.27/#example-333
      it "should allow within word", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, 'foo*bar*', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: 'foo'}}
              {type: 'emphasis', nesting: 1}
              {type: 'text', data: {text: 'bar'}}
              {type: 'emphasis', nesting: -1}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '5*6*78', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: '5'}}
              {type: 'emphasis', nesting: 1}
              {type: 'text', data: {text: '6'}}
              {type: 'emphasis', nesting: -1}
              {type: 'text', data: {text: '78'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-334
      it "should work with underscore", (cb) ->
        test.markdown null, '_foo bar_', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'emphasis', nesting: 1}
          {type: 'text', data: {text: 'foo bar'}}
          {type: 'emphasis', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-335
      it "should fail for spaces after underscore", (cb) ->
        test.markdown null, '_ foo bar_', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '_ foo bar_'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-336
      it "should fail for punctuation after underscore", (cb) ->
        test.markdown null, 'a_"foo"_', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'a_"foo"_'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-337
      # http://spec.commonmark.org/0.27/#example-338
      # http://spec.commonmark.org/0.27/#example-339
      it "should fail if underscore within word", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, 'foo_bar_', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: 'foo_bar_'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '5_6_78', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: '5_6_78'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, 'пристаням_стремятся_', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: 'пристаням_стремятся_'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-340
      it "should fail if both are wrong flanked", (cb) ->
        test.markdown null, 'aa_"bb"_cc', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'aa_"bb"_cc'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-341
      it "should work if both marker are in punctuation", (cb) ->
        test.markdown null, 'foo-_(bar)_', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'foo-'}}
          {type: 'emphasis', nesting: 1}
          {type: 'text', data: {text: '(bar)'}}
          {type: 'emphasis', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-342
      it "should fail for different markers", (cb) ->
        test.markdown null, '_foo*', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '_foo*'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-343
      it "should fail because closing marker is separated by space", (cb) ->
        test.markdown null, '*foo bar *', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '*foo bar *'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-344
      it "should fail because closing marker is separated by newline", (cb) ->
        test.markdown null, '*foo bar\n*', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '*foo bar *'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-345
      it "should fail also with wrong positioned marker", (cb) ->
        test.markdown null, '*(*foo)', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '*(*foo)'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-346
      it "should work with punctuation or word markers", (cb) ->
        test.markdown null, '*(*foo*)*', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'emphasis', nesting: 1}
          {type: 'text', data: {text: '('}}
          {type: 'emphasis', nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'emphasis', nesting: -1}
          {type: 'text', data: {text: ')'}}
          {type: 'emphasis', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-347
      it "should work with intraword marker", (cb) ->
        test.markdown null, '*foo*bar', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'emphasis', nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'emphasis', nesting: -1}
          {type: 'text', data: {text: 'bar'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-348
      it "should fail for underscore marker after space", (cb) ->
        test.markdown null, '_foo bar _', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '_foo bar _'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-349
      it "should fail for underscore marker not masking word", (cb) ->
        test.markdown null, '_(_foo)', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '_(_foo)'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-350
      it "should work for underscore in underscore", (cb) ->
        test.markdown null, '_(_foo_)_', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'emphasis', nesting: 1}
          {type: 'text', data: {text: '('}}
          {type: 'emphasis', nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'emphasis', nesting: -1}
          {type: 'text', data: {text: ')'}}
          {type: 'emphasis', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-351
      # http://spec.commonmark.org/0.27/#example-352
      # http://spec.commonmark.org/0.27/#example-353
      it "should disallow intraword underscore", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, '_foo_bar', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: '_foo_bar'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '_пристаням_стремятся', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: '_пристаням_стремятся'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '_foo_bar_baz_', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'emphasis', nesting: 1}
              {type: 'text', data: {text: 'foo_bar_baz'}}
              {type: 'emphasis', nesting: -1}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-354
      it "should work for underscore in punctuation", (cb) ->
        test.markdown null, '_(bar)_.', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'emphasis', nesting: 1}
          {type: 'text', data: {text: '(bar)'}}
          {type: 'emphasis', nesting: -1}
          {type: 'text', data: {text: '.'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

    describe.only "strong", ->

      # http://spec.commonmark.org/0.27/#example-355
      it "should work on simple word", (cb) ->
        test.markdown null, '**foo bar**', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'strong', nesting: 1}
          {type: 'text', data: {text: 'foo bar'}}
          {type: 'strong', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-356
      it "should fail for space after start marker", (cb) ->
        test.markdown null, '** foo bar**', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '** foo bar**'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-357
      it "should fail if only opening preceded by alpha", (cb) ->
        test.markdown null, 'a**"foo"**', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'a**"foo"**'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-358
      it "should should work as intraword", (cb) ->
        test.markdown null, 'foo**bar**', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'strong', nesting: 1}
          {type: 'text', data: {text: 'bar'}}
          {type: 'strong', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-359
      it "should should work with underscore", (cb) ->
        test.markdown null, '__foo bar__', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'strong', nesting: 1}
          {type: 'text', data: {text: 'foo bar'}}
          {type: 'strong', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-360
      it "should fail for underscore followed by space", (cb) ->
        test.markdown null, '__ foo bar__', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '__ foo bar__'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-361
      it "should fail for underscore followed by newline", (cb) ->
        test.markdown null, '__\nfoo bar__', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '__ foo bar__'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-362
      it "should fail if only opening underline preceded by alpha", (cb) ->
        test.markdown null, 'a__"foo"__', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'a__"foo"__'}}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb

      # http://spec.commonmark.org/0.27/#example-363
      # http://spec.commonmark.org/0.27/#example-364
      # http://spec.commonmark.org/0.27/#example-365
      it "should fail for intraword underscores", (cb) ->
        async.series [
          (cb) ->
            test.markdown null, 'foo__bar__', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: 'foo__bar__'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, '5__6__78', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: '5__6__78'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
          (cb) ->
            test.markdown null, 'пристаням__стремятся__', [
              {type: 'document', nesting: 1}
              {type: 'paragraph', nesting: 1}
              {type: 'text', data: {text: 'пристаням__стремятся__'}}
              {type: 'paragraph', nesting: -1}
              {type: 'document', nesting: -1}
            ], null, cb
        ], cb

      # http://spec.commonmark.org/0.27/#example-366
      it.only "should work for underscore in underscore", (cb) ->
        test.markdown null, '__foo, __bar__, baz__', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'strong', nesting: 1}
          {type: 'text', data: {text: 'foo, '}}
          {type: 'strong', nesting: 1}
          {type: 'text', data: {text: 'bar'}}
          {type: 'strong', nesting: -1}
          {type: 'text', data: {text: ', baz'}}
          {type: 'strong', nesting: -1}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
