### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown emphasis", ->

  describe "simple", ->

    # http://spec.commonmark.org/0.27/#example-328
    it "should work with * for emphasis", (cb) ->
      test.markdown null, '*foo bar*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo bar'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-329
    it "should fail if followed by whitespace", (cb) ->
      test.markdown null, 'a * foo bar*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a * foo bar*'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-330
    it "should fail if followed by non alphanumeric character", (cb) ->
      test.markdown null, 'a*"foo"*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a*"foo"*'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-331
    it "should fail with unicode no-breaking space", (cb) ->
      test.markdown null, '* a *', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '* a *'}
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
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '5*6*78', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '5'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: '6'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: '78'}
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
        {type: 'text', content: 'foo bar'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-335
    it "should fail for spaces after underscore", (cb) ->
      test.markdown null, '_ foo bar_', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '_ foo bar_'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-336
    it "should fail for punctuation after underscore", (cb) ->
      test.markdown null, 'a_"foo"_', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a_"foo"_'}
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
            {type: 'text', content: 'foo_bar_'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '5_6_78', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '5_6_78'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'пристаням_стремятся_', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'пристаням_стремятся_'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-340
    it "should fail if both are wrong flanked", (cb) ->
      test.markdown null, 'aa_"bb"_cc', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'aa_"bb"_cc'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-341
    it "should work if both marker are in punctuation", (cb) ->
      test.markdown null, 'foo-_(bar)_', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo-'}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: '(bar)'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-342
    it "should fail for different markers", (cb) ->
      test.markdown null, '_foo*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '_foo*'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-343
    it "should fail because closing marker is separated by space", (cb) ->
      test.markdown null, '*foo bar *', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '*foo bar *'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-344
    it "should fail because closing marker is separated by newline", (cb) ->
      test.markdown null, '*foo bar\n*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '*foo bar'}
        {type: 'softbreak'}
        {type: 'text', content: '*'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-345
    it "should fail also with wrong positioned marker", (cb) ->
      test.markdown null, '*(*foo)', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '*(*foo)'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-346
    it "should work with punctuation or word markers", (cb) ->
      test.markdown null, '*(*foo*)*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: '('}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'text', content: ')'}
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
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-348
    it "should fail for underscore marker after space", (cb) ->
      test.markdown null, '_foo bar _', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '_foo bar _'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-349
    it "should fail for underscore marker not masking word", (cb) ->
      test.markdown null, '_(_foo)', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '_(_foo)'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-350
    it "should work for underscore in underscore", (cb) ->
      test.markdown null, '_(_foo_)_', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: '('}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'text', content: ')'}
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
            {type: 'text', content: '_foo_bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '_пристаням_стремятся', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '_пристаням_стремятся'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '_foo_bar_baz_', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo_bar_baz'}
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
        {type: 'text', content: '(bar)'}
        {type: 'emphasis', nesting: -1}
        {type: 'text', content: '.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "strong", ->

    # http://spec.commonmark.org/0.27/#example-355
    it "should work on simple word", (cb) ->
      test.markdown null, '**foo bar**', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'foo bar'}
        {type: 'strong', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-356
    it "should fail for space after start marker", (cb) ->
      test.markdown null, '** foo bar**', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '** foo bar**'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-357
    it "should fail if only opening preceded by alpha", (cb) ->
      test.markdown null, 'a**"foo"**', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a**"foo"**'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-358
    it "should should work as intraword", (cb) ->
      test.markdown null, 'foo**bar**', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'bar'}
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
        {type: 'text', content: 'foo bar'}
        {type: 'strong', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-360
    it "should fail for underscore followed by space", (cb) ->
      test.markdown null, '__ foo bar__', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '__ foo bar__'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-361
    it "should fail for underscore followed by newline", (cb) ->
      test.markdown null, '__\nfoo bar__', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '__'}
        {type: 'softbreak'}
        {type: 'text', content: 'foo bar__'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-362
    it "should fail if only opening underline preceded by alpha", (cb) ->
      test.markdown null, 'a__"foo"__', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a__"foo"__'}
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
            {type: 'text', content: 'foo__bar__'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '5__6__78', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '5__6__78'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'пристаням__стремятся__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'пристаням__стремятся__'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-366
    it "should work for underscore in underscore", (cb) ->
      test.markdown null, '__foo, __bar__, baz__', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'foo, '}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'strong', nesting: -1}
        {type: 'text', content: ', baz'}
        {type: 'strong', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-367
    it "should work with underscores in punctuation", (cb) ->
      test.markdown null, 'foo-__(bar)__', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo-'}
        {type: 'strong', nesting: 1}
        {type: 'text', content: '(bar)'}
        {type: 'strong', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-368
    it "should fail for closing marker after space", (cb) ->
      test.markdown null, '**foo bar **', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '**foo bar **'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-369
    it "should fail for mixed marker", (cb) ->
      test.markdown null, '**(**foo)', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '**(**foo)'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-370
    it "should work within emphasis", (cb) ->
      test.markdown null, '*(**foo**)*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: '('}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strong', nesting: -1}
        {type: 'text', content: ')'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-371
    it "should work for mixed strong + emphasis", (cb) ->
      test.markdown null, '**Gomphocarpus (*Gomphocarpus physocarpus*, syn.\n*Asclepias physocarpa*)**', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'Gomphocarpus ('}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'Gomphocarpus physocarpus'}
        {type: 'emphasis', nesting: -1}
        {type: 'text', content: ', syn.'}
        {type: 'softbreak'}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'Asclepias physocarpa'}
        {type: 'emphasis', nesting: -1}
        {type: 'text', content: ')'}
        {type: 'strong', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-372
    it "should work for mixed strong + emphasis 2", (cb) ->
      test.markdown null, '**foo "*bar*" foo**', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'foo "'}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'emphasis', nesting: -1}
        {type: 'text', content: '" foo'}
        {type: 'strong', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-373
    it "should work for intraword", (cb) ->
      test.markdown null, '**foo**bar', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strong', nesting: -1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-374
    it "should fail with space before end marker", (cb) ->
      test.markdown null, '__foo bar __', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '__foo bar __'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-375
    it "should fail with underscore followed by word", (cb) ->
      test.markdown null, '__(__foo)', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '__(__foo)'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-376
    it "should work with underscore around punctuation", (cb) ->
      test.markdown null, '_(__foo__)_', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: '('}
        {type: 'strong', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strong', nesting: -1}
        {type: 'text', content: ')'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-377
    # http://spec.commonmark.org/0.27/#example-378
    # http://spec.commonmark.org/0.27/#example-379
    it "should fail with intraword underscore", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '__foo__bar', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '__foo__bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '__пристаням__стремятся', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '__пристаням__стремятся'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '__foo__bar__baz__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo__bar__baz'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-380
    it "should work with underscore in punct", (cb) ->
      test.markdown null, '__(bar)__.', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strong', nesting: 1}
        {type: 'text', content: '(bar)'}
        {type: 'strong', nesting: -1}
        {type: 'text', content: '.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb


  describe "mixed", ->

  ###########################
  # example 381
  ############################

    # http://spec.commonmark.org/0.27/#example-382
    it "should work with newlines", (cb) ->
      test.markdown null, '*foo\nbar*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'softbreak'}
        {type: 'text', content: 'bar'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-383
    # http://spec.commonmark.org/0.27/#example-384
    # http://spec.commonmark.org/0.27/#example-385
    # http://spec.commonmark.org/0.27/#example-386
    # http://spec.commonmark.org/0.27/#example-387
    # http://spec.commonmark.org/0.27/#example-388
    it "should work nested", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '_foo __bar__ baz_', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: ' baz'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '_foo _bar_ baz_', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' baz'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '__foo_ bar_', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*foo *bar**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*foo **bar** baz*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: ' baz'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*foo**bar**baz*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: 'baz'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-389
    # http://spec.commonmark.org/0.27/#example-390
    # http://spec.commonmark.org/0.27/#example-391
    it "should work for strong in emphasis", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '***foo** bar*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: ' bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*foo **bar***', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'strong', nesting: -1}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*foo**bar***', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'strong', nesting: -1}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-392
    # http://spec.commonmark.org/0.27/#example-393
    it "should work with indefinite nesting in emphasis", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '*foo **bar *baz* bim** bop*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'baz'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' bim'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: ' bop'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
#        (cb) ->
#          test.markdown null, '*foo [*bar*](/url)*', [
#            {type: 'document', nesting: 1}
#            {type: 'paragraph', nesting: 1}
#            {type: 'emphasis', nesting: 1}
#            {type: 'text', content: 'foo '}
#            {type: 'strong', nesting: 1}
#            {type: 'text', content: 'bar'}
#            {type: 'strong', nesting: -1}
#            {type: 'emphasis', nesting: -1}
#            {type: 'paragraph', nesting: -1}
#            {type: 'document', nesting: -1}
#          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-394
    # http://spec.commonmark.org/0.27/#example-395
    it "should fail with empty emphasis", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '** is not an empty emphasis', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '** is not an empty emphasis'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '**** is not an empty strong emphasis', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '**** is not an empty strong emphasis'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-396
    # http://spec.commonmark.org/0.27/#example-397
    it "should allow all inline in strong", (cb) ->
      async.series [
#        (cb) ->
#          test.markdown null, '**foo [bar](/url)**', [
#            {type: 'document', nesting: 1}
#            {type: 'paragraph', nesting: 1}
#            {type: 'text', content: '** is not an empty emphasis'}
#            {type: 'paragraph', nesting: -1}
#            {type: 'document', nesting: -1}
#          ], null, cb
        (cb) ->
          test.markdown null, '**foo\nbar**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'softbreak'}
            {type: 'text', content: 'bar'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-398
    # http://spec.commonmark.org/0.27/#example-399
    # http://spec.commonmark.org/0.27/#example-400
    # http://spec.commonmark.org/0.27/#example-401
    # http://spec.commonmark.org/0.27/#example-402
    # http://spec.commonmark.org/0.27/#example-403
    # http://spec.commonmark.org/0.27/#example-404
    # http://spec.commonmark.org/0.27/#example-405
    it "should allow nesting in strong", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '__foo _bar_ baz__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' baz'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '__foo __bar__ baz__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: ' baz'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '____foo__ bar__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: ' bar'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '**foo **bar****', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'strong', nesting: -1}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '**foo *bar* baz**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' baz'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '**foo*bar*baz**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: 'baz'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '***foo* bar**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' bar'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '**foo *bar***', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-406
    # http://spec.commonmark.org/0.27/#example-407
    it "should work with indefinite nesting in strong", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '**foo *bar **baz**\nbim* bop**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'baz'}
            {type: 'strong', nesting: -1}
            {type: 'softbreak'}
            {type: 'text', content: 'bim'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' bop'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
#        (cb) ->
#          test.markdown null, '**foo [*bar*](/url)**', [
#            {type: 'document', nesting: 1}
#            {type: 'paragraph', nesting: 1}
#            {type: 'emphasis', nesting: 1}
#            {type: 'text', content: 'foo '}
#            {type: 'strong', nesting: 1}
#            {type: 'text', content: 'bar'}
#            {type: 'strong', nesting: -1}
#            {type: 'emphasis', nesting: -1}
#            {type: 'paragraph', nesting: -1}
#            {type: 'document', nesting: -1}
#          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-408
    # http://spec.commonmark.org/0.27/#example-409
    it "should fail with empty underscore emphasis", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '__ is not an empty emphasis', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '__ is not an empty emphasis'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '____ is not an empty strong emphasis', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '____ is not an empty strong emphasis'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-410
    # http://spec.commonmark.org/0.27/#example-411
    # http://spec.commonmark.org/0.27/#example-412
    # http://spec.commonmark.org/0.27/#example-413
    # http://spec.commonmark.org/0.27/#example-414
    # http://spec.commonmark.org/0.27/#example-415
    it "should work with punctuation characters", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, 'foo ***', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo ***'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo *\\**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: '*'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo *_*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: '_'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo *****', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo *****'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo **\\***', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: '*'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo **_**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: '_'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-416
    # http://spec.commonmark.org/0.27/#example-417
    # http://spec.commonmark.org/0.27/#example-418
    # http://spec.commonmark.org/0.27/#example-419
    # http://spec.commonmark.org/0.27/#example-420
    # http://spec.commonmark.org/0.27/#example-421
    it "should work with unevenly delimiter", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '**foo*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '*'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*foo**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: '*'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '***foo**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '*'}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '****foo*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '***'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '**foo***', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: '*'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*foo****', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: '***'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-422
    # http://spec.commonmark.org/0.27/#example-423
    # http://spec.commonmark.org/0.27/#example-424
    # http://spec.commonmark.org/0.27/#example-425
    # http://spec.commonmark.org/0.27/#example-426
    # http://spec.commonmark.org/0.27/#example-427
    # http://spec.commonmark.org/0.27/#example-428
    it "should work with punctuation characters in underscore", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, 'foo ___', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo ___'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo _\\__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: '_'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo _*_', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: '*'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo _____', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo _____'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo __\\___', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: '_'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo __*__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: '*'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '__foo_', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '_'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-429
    # http://spec.commonmark.org/0.27/#example-43ß
    # http://spec.commonmark.org/0.27/#example-431
    # http://spec.commonmark.org/0.27/#example-432
    # http://spec.commonmark.org/0.27/#example-433
    it "should work with unevenly delimiter", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '_foo__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: '_'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '___foo__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '_'}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '____foo_', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '___'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '__foo___', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: '_'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '_foo____', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: '___'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-434
    # http://spec.commonmark.org/0.27/#example-435
    # http://spec.commonmark.org/0.27/#example-436
    # http://spec.commonmark.org/0.27/#example-437
    it "should work with different delimiters", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '**foo**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*_foo_*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '__foo__', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '_*foo*_', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-438
    # http://spec.commonmark.org/0.27/#example-439
    # http://spec.commonmark.org/0.27/#example-440
    # http://spec.commonmark.org/0.27/#example-441
    # http://spec.commonmark.org/0.27/#example-442
    it "should work with strong in strong delimiter", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '****foo****', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '____foo____', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '******foo******', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'strong', nesting: -1}
            {type: 'strong', nesting: -1}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '***foo***', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '_____foo_____', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'strong', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'strong', nesting: -1}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-443
    # http://spec.commonmark.org/0.27/#example-444
    # http://spec.commonmark.org/0.27/#example-445
    # http://spec.commonmark.org/0.27/#example-446
    it "should fail interlaced", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '*foo _bar* baz_', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo _bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' baz_'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*foo __bar *baz bim__ bam*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar *baz bim'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: ' bam'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '**foo **bar baz**', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '**foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar baz'}
            {type: 'strong', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*foo *bar baz*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '*foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar baz'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb
