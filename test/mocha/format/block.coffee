### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "block", ->
  @timeout 10000

  it "should create a paragraph", (cb) ->
    report = new Report()
    report.p 'A new paragraph.'
    report.p 'A long text may be automatically broken into multiple lines.', 40
    report.p 'And here comes a fixed\n linebreak.\n\nWith a second paragraph.'
    test.report 'block-paragraph', report, """

      A new paragraph.

      A long text may be automatically broken
      into multiple lines.

      And here comes a fixed\\
      linebreak.

      With a second paragraph.

      """, """
      <body><div id="page"><p>A new paragraph.</p>
      <p>A long text may be automatically broken
      into multiple lines.</p>
      <p>And here comes a fixed<br />
      linebreak.</p>
      <p>With a second paragraph.</p>
      </div></body>
      """, cb

  it "should create a quote", (cb) ->
    report = new Report()
    report.quote 'My home is my castle!'
    report.quote "I would like to visit a castle in north scotland, next year.", 2, 40
    test.report 'block-quote', report, """

      > My home is my castle!

      > > I would like to visit a castle in
      > > north scotland, next year.

      """, """
      <body><div id="page"><blockquote>
      <p>My home is my castle!</p>
      </blockquote>
      <blockquote>
      <blockquote>
      <p>I would like to visit a castle in
      north scotland, next year.</p>
      </blockquote>
      </blockquote>
      </div></body>
      """, cb

  it "should allow alternative format in markdown", (cb) ->
    report = new Report
      source: """
        > Blockquotes can also be nested...
        >> ...by using additional greater-than signs right next to each other...
        > > > ...or with spaces between arrows.
        """
    test.report 'block-quote2', report, null, """
      <body><div id="page"><blockquote>
      <p>Blockquotes can also be nested…</p>
      <blockquote>
      <p>…by using additional greater-than signs right next to each other…</p>
      <blockquote>
      <p>…or with spaces between arrows.</p>
      </blockquote>
      </blockquote>
      </blockquote>
      </div></body>
      """, cb

  it "should create text code block", (cb) ->
    report = new Report()
    report.code 'This is a text code block.\nIt should be kept as is.'
    test.report 'block-pre', report, "\n    This is a text code block.\n    It should be kept as is.\n", """
      <body><div id="page"><pre><code>This is a text code block.
      It should be kept as is.
      </code></pre>
      </div></body>
      """, cb

  it.only "should create a code block", (cb) ->
    report = new Report()
    report.code 'var x = Math.round(f);', 'js'
    report.code 'This **is** a ==markdown== text', 'markdown'
    report.code 'simple:\n  list: ["a", b, 5]', 'yaml'
    test.report 'block-code', report, """

      ``` js
      var x = Math.round(f);
      ```

      ``` markdown
      This **is** a ==markdown== text
      ```

      ``` yaml
      simple:
        list: ["a", b, 5]
      ```

      """, """
      <body><div id="page"><pre><code class="language js"><header>JavaScript Code</header><span class="hljs-keyword">var</span> x = <span class="hljs-built_in">Math</span>.round(f);
      </code></pre>
      <pre><code class="language markdown"><header>Markdown Document</header>This <span class="hljs-strong">**is**</span> a ==markdown== text
      </code></pre>
      <pre><code class="language yaml"><header>YAML Data</header><span class="hljs-attr">simple:</span>
      <span class="hljs-attr">  list:</span> [<span class="hljs-string">"a"</span>, b, <span class="hljs-number">5</span>]
      </code></pre>
      </div></body>
      """, cb
