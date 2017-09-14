chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "text", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'text/simple', """
        This is a short text.
        With each sentence in a separate line.\\
        And a hard break before this.
      """, null, true, cb

    it "should make typographic replacements", (cb) ->
      test.markdown 'text/typographic', """
        I\'m looking forward.\\
        foo "foo 'inside' bar" bar\\
        My sisters' friends' investments\\
        (c) 2017 Alexander Schilling\\
        2013 Intel (R); 2013 Intel (TM)\\
        Tickets cost 20 usd in Australia or 19 EUR in Germany\\
        foo...bar\\
        foo -- bar and foo — bar\\
        Kurt Cobain (1967-1994)\\
        1 <- 2 -> 3 <-> 4 <= 5 => 6 <=> 7\\
        2 x 3 = 6; 3 - 2 = 1; 3 =< 2; 4 >= 4; 5 +- 1; 10 -+ 1; 2 << 100; 999 >> 5\\
        foo  bar; foo.  Bar; foo,  bar
      """, null, true, cb

    it "should make typographic replacements (german)", (cb) ->
      test.markdown 'text/typographic-de', """
        <!-- {document:lang=de} -->
        I\'m looking forward.\\
        foo "foo 'inside' bar" bar\\
        My sisters' friends' investments\\
        (c) 2017 Alexander Schilling\\
        2013 Intel (R); 2013 Intel (TM)\\
        Tickets cost 20 usd in Australia or 19 EUR in Germany\\
        foo...bar\\
        foo -- bar and foo — bar\\
        Kurt Cobain (1967-1994)\\
        1 <- 2 -> 3 <-> 4 <= 5 => 6 <=> 7\\
        2 x 3 = 6; 3 - 2 = 1; 3 =< 2; 4 >= 4; 5 +- 1; 10 -+ 1; 2 << 100; 999 >> 5\\
        foo  bar; foo.  Bar; foo,  bar
      """, null, true, cb

  describe "api", ->

    it "should create in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.text 'Simple Text.'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Simple Text.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.text 'Simple Text.').to.throw Error
      cb()

    it "should do nothing without content", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.text()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create text with tabs in preformatted section", (cb) ->
      # create report
      report = new Report()
      report.pre 'foo\tbar'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'foo\tbar'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo\tbar/}
        {format: 'text', re: /foo\tbar/}
        {format: 'html', text: "<pre><code>foo\tbar</code></pre>\n"}
        {format: 'man', text: '.P\n.RS 2\n.nf\nfoo\tbar\n.fi\n.RE'}
      ], cb

    it "should work with soft and hard breaks", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      .text 'Simple Text.'
      .hardbreak()
      .text 'And now another line.'
      .softbreak()
      .text 'With two sentences.'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Simple Text.'}
        {type: 'hardbreak'}
        {type: 'text', content: 'And now another line.'}
        {type: 'softbreak'}
        {type: 'text', content: 'With two sentences.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "format", ->

    it "should use typographic apostrophes", (cb) ->
      # create report
      report = new Report()
      report.p 'I\'m looking forward'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'I’m looking forward\n'}
        {format: 'html', text: "<p>I’m looking forward</p>\n"}
      ], cb

    it "should use typographic quotes", (cb) ->
      # create report
      report = new Report()
      report.p 'foo "foo \'inside\' bar" bar'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'foo “foo ‘inside’ bar” bar\n'}
        {format: 'html', text: "<p>foo “foo ‘inside’ bar” bar</p>\n"}
      ], cb

    it "should use typographic quotes (changed locale)", (cb) ->
      # create report
      report = new Report()
      report.style 'document:lang=de'
      report.p 'foo "foo \'inside\' bar" bar'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'foo „foo ‚inside‘ bar“ bar\n'}
        {format: 'html', text: "<p>foo „foo ‚inside‘ bar“ bar</p>\n"}
      ], cb

    it "should use typographic apostrophes for possessive plurals", (cb) ->
      # create report
      report = new Report()
      report.p 'My sisters\' friends\' investments'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'My sisters’ friends’ investments\n'}
        {format: 'html', text: "<p>My sisters’ friends’ investments</p>\n"}
      ], cb

    it "should use typographic arrows", (cb) ->
      # create report
      report = new Report()
      report.p '1 <- 2 -> 3 <-> 4 <= 5 => 6 <=> 7'
      # check it
      test.report null, report, null, [
        {format: 'text', text: '1 ← 2 → 3 ↔ 4 ⇐ 5 ⇒ 6 ⇔ 7\n'}
        {format: 'html', text: "<p>1 ← 2 → 3 ↔ 4 ⇐ 5 ⇒ 6 ⇔ 7</p>\n"}
      ], cb

    it "should use typographic copyright", (cb) ->
      # create report
      report = new Report()
      report.p '(c) 2017 Alexander Schilling (C)'
      # check it
      test.report null, report, null, [
        {format: 'text', text: '© 2017 Alexander Schilling ©\n'}
        {format: 'html', text: "<p>©&nbsp;2017 Alexander Schilling ©</p>\n"}
      ], cb

    it "should use typographic currency", (cb) ->
      # create report
      report = new Report()
      report.p 'Tickets cost 20 usd in Australia or 19 EUR in Germany'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'Tickets cost 20 $ in Australia or 19 € in Germany\n'}
        {format: 'html', text: "<p>Tickets cost 20 $ in Australia or 19 € in Germany</p>\n"}
      ], cb

    it "should use typographic ellipses", (cb) ->
      # create report
      report = new Report()
      report.p 'foo...bar'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'foo…bar\n'}
        {format: 'html', text: "<p>foo…bar</p>\n"}
      ], cb

    it "should use typographic em-dashes", (cb) ->
      # create report
      report = new Report()
      report.p 'foo -- bar and foo — bar'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'foo — bar and foo — bar\n'}
        {format: 'html', text: "<p>foo — bar and foo — bar</p>\n"}
      ], cb

    it.skip "should use typographic en-dashes", (cb) ->
      # create report
      report = new Report()
      report.p 'Kurt Cobain (1967-1994)'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'Kurt Cobain (1967–1994)\n'}
        {format: 'html', text: "<p>Kurt Cobain (1967–1994)</p>\n"}
      ], cb

    it "should use typographic math symbols", (cb) ->
      # create report
      report = new Report()
      report.p '2 x 3 = 6; 3 - 2 = 1; 3 =< 2; 4 >= 4; 5 +- 1; 10 -+ 1; 2 << 100; 999 >> 5'
      # check it
      test.report null, report, null, [
        {format: 'text', text: '2 × 3 = 6; 3 − 2 = 1; 3 =< 2; 4 ≥ 4; 5 ± 1; 10 ∓ 1; 2 ≪ 100;\n999 ≫ 5\n'}
        {format: 'html', text: "<p>2 × 3 = 6; 3 − 2 = 1; 3 =&lt; 2; 4 ≥ 4; 5 ± 1; 10 ∓ 1; 2 ≪ 100; 999 ≫ 5</p>\n"}
      ], cb

    it "should use typographic registered trademark", (cb) ->
      # create report
      report = new Report()
      report.p '2013 Intel (R); 2013 Intel (r)'
      # check it
      test.report null, report, null, [
        {format: 'text', text: '2013 Intel ®; 2013 Intel ®\n'}
        {format: 'html', text: "<p>2013 Intel ®; 2013 Intel ®</p>\n"}
      ], cb

    it "should use typographic trademark", (cb) ->
      # create report
      report = new Report()
      report.p '2013 Intel (TM); 2013 Intel (tm)'
      # check it
      test.report null, report, null, [
        {format: 'text', text: '2013 Intel™; 2013 Intel™\n'}
        {format: 'html', text: "<p>2013 Intel™; 2013 Intel™</p>\n"}
      ], cb

    it "should use typographic single spaces", (cb) ->
      # create report
      report = new Report()
      report.p 'foo  bar; foo.  Bar; foo,  bar'
      # check it
      test.report null, report, null, [
        {format: 'text', text: 'foo bar; foo. Bar; foo, bar\n'}
        {format: 'html', text: "<p>foo bar; foo. Bar; foo, bar</p>\n"}
      ], cb
