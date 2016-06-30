### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "document", ->
  @timeout 5000

  it "should add table of contents", (cb) ->
    report = new Report()
    report.toc()
    report.h1 'Table of Contents Test'
    report.h2 'My text'
    report.p 'Something I have to say...'
    report.h2 'Other opinions'
    report.h3 'My parents'
    report.p "You don't want to know."
    report.h3 "My friends"
    report.p 'They always support me.'
    test.report 'toc', report, """

      @[toc]


      Table of Contents Test
      ================================================================================


      My text
      --------------------------------------------------------------------------------

      Something I have to say...


      Other opinions
      --------------------------------------------------------------------------------

      ### My parents

      You don't want to know.

      ### My friends

      They always support me.

      """, """
      <body><div id="page"><p><ul class="table-of-contents">
      <li><a href="#my-text">My text</a></li>
      <li><a href="#other-opinions">Other opinions</a>
      <ul>
      <li><a href="#my-parents">My parents</a></li>
      <li><a href="#my-friends">My friends</a></li>
      </ul>
      </li>
      </ul>
      </p>
      <h1 id="table-of-contents-test">Table of Contents Test</h1>
      <h2 id="my-text">My text</h2>
      <p>Something I have to say…</p>
      <h2 id="other-opinions">Other opinions</h2>
      <h3 id="my-parents">My parents</h3>
      <p>You don’t want to know.</p>
      <h3 id="my-friends">My friends</h3>
      <p>They always support me.</p>
      </div></body>
      """, cb

  it "should add abbreviations", (cb) ->
    report = new Report()
    report.abbr 'HTTP', 'Hyper Text Transfer Protocol'
    report.p "The HTTP protocol is used for transferring web content. A secured
    version of HTTP called HTTPS is also available."
    test.report 'abbreviation', report, """

      The HTTP protocol is used for transferring web content. A secured version of
      HTTP called HTTPS is also available.

      *[HTTP]: Hyper Text Transfer Protocol

      """, """
      <body><div id="page"><p>The <abbr title="Hyper Text Transfer Protocol">HTTP</abbr> protocol is used for transferring web content. A secured version of
      <abbr title="Hyper Text Transfer Protocol">HTTP</abbr> called HTTPS is also available.</p>
      </div></body>
      """, cb

  it "should add footnotes", (cb) ->
    report = new Report()
    cern = report.footnote "European Organization for Nuclear Research\n\nSee more info at http://home.cern"
    me = report.footnote "Alexander Schilling", 'a'
    other = report.footnote "My colleagues as the University of Tübingen", 'b'
    report.p "The World Wide Web (WWW) is invented by CERN#{cern}. But I#{me} and
    prometheus#{other} used it to make a medical learning environment out of it.
    _Alex#{me}_"
    test.report 'footnotes', report, """

      The World Wide Web (WWW) is invented by CERN[^1]. But I[^a] and prometheus[^b]
      used it to make a medical learning environment out of it. _Alex[^a]_

      [^1]: European Organization for Nuclear Research

            See more info at http://home.cern
      [^a]: Alexander Schilling
      [^b]: My colleagues as the University of Tübingen

      """, """
      <body><div id="page"><p>The World Wide Web (WWW) is invented by CERN<sup class="footnote-ref"><a href="#fn1" id="fnref1">[1]</a></sup>. But I<sup class="footnote-ref"><a href="#fn2" id="fnref2">[2]</a></sup> and prometheus<sup class="footnote-ref"><a href="#fn3" id="fnref3">[3]</a></sup>
      used it to make a medical learning environment out of it. <em>Alex<sup class="footnote-ref"><a href="#fn2:1" id="fnref2:1">[2:1]</a></sup></em></p>
      <hr class="footnotes-sep" />
      <section class="footnotes">
      <ol class="footnotes-list">
      <li id="fn1" class="footnote-item"><p>European Organization for Nuclear Research</p>
      <p>See more info at <a href="http://home.cern">http://home.cern</a> <a href="#fnref1" class="footnote-backref">↩︎</a></p>
      </li>
      <li id="fn2" class="footnote-item"><p>Alexander Schilling <a href="#fnref2" class="footnote-backref">↩︎</a> <a href="#fnref2:1" class="footnote-backref">↩︎</a></p>
      </li>
      <li id="fn3" class="footnote-item"><p>My colleagues as the University of Tübingen <a href="#fnref3" class="footnote-backref">↩︎</a></p>
      </li>
      </ol>
      </section>
      </div></body>
      """, cb
