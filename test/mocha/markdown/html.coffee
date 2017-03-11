### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown raw html", ->

  describe "block", ->

    # http://spec.commonmark.org/0.27/#example-115
    # http://spec.commonmark.org/0.27/#example-116
    it "should parse simple link", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '\n<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table>\n\nokay.', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table>', format: 'html', block: true}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'okay.'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, ' <div>\n  *hello*\n         <foo><a>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: ' <div>\n  *hello*\n         <foo><a>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-117
    it "should allow to start with closing tag", (cb) ->
      test.markdown null, '</div>\n*foo*', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '</div>\n*foo*', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-118
    it "should work with html blocks and markdown", (cb) ->
      test.markdown null, '<DIV CLASS="foo">\n\n*Markdown*\n\n</DIV>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<DIV CLASS="foo">', format: 'html', block: true}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'Markdown'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'raw', content: '</DIV>', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-119
    # http://spec.commonmark.org/0.27/#example-120
    it "should allow the first tag to be split at whitespace position", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<div id="foo"\n  class="bar">\n</div>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div id="foo"\n  class="bar">\n</div>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<div id="foo" class="bar\n  baz">\n</div>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div id="foo" class="bar\n  baz">\n</div>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-121
    it "should allow unclosed open tag", (cb) ->
      test.markdown null, '<div>\n*foo*\n\n*bar*', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<div>\n*foo*', format: 'html', block: true}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-122
    # http://spec.commonmark.org/0.27/#example-123
    it "should work with incomplete tags", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<div id="foo"\n*hi*', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div id="foo"\n*hi*', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<div class\nfoo', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div class\nfoo', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-124
    it "should allow unclosed open tag", (cb) ->
      test.markdown null, '<div *???-&&&-<---\n*foo*', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<div *???-&&&-<---\n*foo*', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-125
    # http://spec.commonmark.org/0.27/#example-126
    it "should allow on one or multiple lines", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<div><a href="bar">*foo*</a></div>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div><a href="bar">*foo*</a></div>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<table><tr><td>\nfoo\n</td></tr></table>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<table><tr><td>\nfoo\n</td></tr></table>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-127
    it "should contain everything till next blank line", (cb) ->
      test.markdown null, '<div></div>\n``` c\nint x = 33;\n```', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<div></div>\n``` c\nint x = 33;\n```', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-128
    it "should allow tags which are noit block level only if they are complete in first line", (cb) ->
      test.markdown null, '<a href="foo">\n*bar*\n</a>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<a href="foo">\n*bar*\n</a>', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-129
    # http://spec.commonmark.org/0.27/#example-130
    # http://spec.commonmark.org/0.27/#example-131
    it "should allow any tag if complete in first line", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<Warning>\n*bar*\n</Warning>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<Warning>\n*bar*\n</Warning>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<i class="foo">\n*bar*\n</i>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<i class="foo">\n*bar*\n</i>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '</ins>\n*bar*', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '</ins>\n*bar*', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-132
    it "should be made if inline tag is on first line by itself", (cb) ->
      test.markdown null, '<del>\n*foo*\n</del>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<del>\n*foo*\n</del>', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-133
    it "should be made if close tag is on first line by itself", (cb) ->
      test.markdown null, '<del>\n\n*foo*\n\n</del>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<del>', format: 'html', block: true}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'raw', content: '</del>', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-134
    it "should fail if not by itself and render as inline", (cb) ->
      test.markdown null, '<del>*foo*</del>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'raw', content: '<del>', format: 'html'}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'emphasis', nesting: -1}
        {type: 'raw', content: '</del>', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-135
    # http://spec.commonmark.org/0.27/#example-136
    # http://spec.commonmark.org/0.27/#example-137
    it "should allow empty lines in tags containing literals", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<pre language="haskell"><code>\nimport Text.HTML.TagSoup\n\nmain :: IO ()\nmain = print $ parseTags tags\n</code></pre>\nokay', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<pre language="haskell"><code>\nimport Text.HTML.TagSoup\n\nmain :: IO ()\nmain = print $ parseTags tags\n</code></pre>', format: 'html', block: true}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'okay'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<script type="text/javascript">\n// JavaScript example\n\ndocument.getElementById("demo").innerHTML = "Hello JavaScript!";\n</script>\nokay', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<script type="text/javascript">\n// JavaScript example\n\ndocument.getElementById("demo").innerHTML = "Hello JavaScript!";\n</script>', format: 'html', block: true}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'okay'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<style\n  type="text/css">\nh1 {color:red;}\n\np {color:blue;}\n</style>\nokay', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<style\n  type="text/css">\nh1 {color:red;}\n\np {color:blue;}\n</style>', format: 'html', block: true}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'okay'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-139
    # http://spec.commonmark.org/0.27/#example-138
    # http://spec.commonmark.org/0.27/#example-140
    it "should end tags containing literals at least at the end of document or enclosing block", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<style\n  type="text/css">\n\nfoo', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<style\n  type="text/css">\n\nfoo', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '> <div>\n> foo\n\nbar', [
            {type: 'document', nesting: 1}
            {type: 'blockquote', nesting: 1}
            {type: 'raw', content: '<div>\nfoo', format: 'html', block: true}
            {type: 'blockquote', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '- <div>\n- foo', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1}
            {type: 'item', nesting: 1}
            {type: 'raw', content: '<div>', format: 'html', block: true}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-141
    # http://spec.commonmark.org/0.27/#example-142
    it "should allow the end tag in the same line", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<style>p{color:red;}</style>\n*foo*', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<style>p{color:red;}</style>', format: 'html', block: true}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<!-- foo -->*bar*\n*baz*', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<!-- foo -->*bar*', format: 'html', block: true}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'baz'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-143
    it "should keep everything in the closing line", (cb) ->
      test.markdown null, '<script>\nfoo\n</script>1. *bar*', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<script>\nfoo\n</script>1. *bar*', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-144
    it "should work with comment", (cb) ->
      test.markdown null, '<!-- Foo\n\nbar\n   baz -->\nokay', [
        {type: 'document', nesting: 1}
        {type: 'comment', content: 'Foo\n\nbar\n   baz', block: true}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'okay'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-145
    it "should work with processing instructions", (cb) ->
      test.markdown null, '<?php\n\n  echo \'>\';\n\n?>\nokay', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<?php\n\n  echo \'>\';\n\n?>', format: 'html', block: true}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'okay'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-146
    it "should work with declaration", (cb) ->
      test.markdown null, '<!DOCTYPE html>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<!DOCTYPE html>', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-147
    it "should work with cdata", (cb) ->
      test.markdown null, '<![CDATA[\nfunction matchwo(a,b)\n{\n  if (a < b && a < 0) then {\n    return 1;\n\n  } else {\n\n    return 0;\n  }\n}\n]]>\nokay', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<![CDATA[\nfunction matchwo(a,b)\n{\n  if (a < b && a < 0) then {\n    return 1;\n\n  } else {\n\n    return 0;\n  }\n}\n]]>', format: 'html', block: true}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'okay'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-148
    # http://spec.commonmark.org/0.27/#example-149
    it "should allow 1-3 spaces indention of opening tag", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '  <!-- foo -->\n\n    <!-- foo -->', [
            {type: 'document', nesting: 1}
            {type: 'comment', content: 'foo', block: true}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: '<!-- foo -->'}
            {type: 'preformatted', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '  <div>\n\n    <div>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '  <div>', format: 'html', block: true}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: '<div>'}
            {type: 'preformatted', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-150
    it "should allow html block to interrupt paragraph", (cb) ->
      test.markdown null, 'Foo\n<div>\nbar\n</div>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'raw', content: '<div>\nbar\n</div>', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-151
    it "should include following markdown", (cb) ->
      test.markdown null, '<div>\nbar\n</div>\n*foo*', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<div>\nbar\n</div>\n*foo*', format: 'html', block: true}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-152
    it "should not interrupt paragraph with inline html", (cb) ->
      test.markdown null, 'Foo\n<a href="bar">\nbaz', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Foo'}
        {type: 'softbreak'}
        {type: 'raw', content: '<a href="bar">', format: 'html'}
        {type: 'softbreak'}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-153
    # http://spec.commonmark.org/0.27/#example-154
    it "should need blank lines to include markdown", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<div>\n\n*Emphasized* text.\n\n</div>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div>', format: 'html', block: true}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'Emphasized'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' text.'}
            {type: 'paragraph', nesting: -1}
            {type: 'raw', content: '</div>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<div>\n*Emphasized* text.\n</div>', [
            {type: 'document', nesting: 1}
            {type: 'raw', content: '<div>\n*Emphasized* text.\n</div>', format: 'html', block: true}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-155
    it "should allow complex html directly", (cb) ->
      test.markdown null, '<table>\n\n<tr>\n\n<td>\nHi\n</td>\n\n</tr>\n\n</table>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<table>', format: 'html'}
        {type: 'raw', content: '<tr>', format: 'html'}
        {type: 'raw', content: '<td>\nHi\n</td>', format: 'html'}
        {type: 'raw', content: '</tr>', format: 'html'}
        {type: 'raw', content: '</table>', format: 'html'}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-156
    it "should fail with indented html", (cb) ->
      test.markdown null, '<table>\n\n  <tr>\n\n    <td>\n      Hi\n    </td>\n\n  </tr>\n\n</table>', [
        {type: 'document', nesting: 1}
        {type: 'raw', content: '<table>', format: 'html'}
        {type: 'raw', content: '  <tr>', format: 'html'}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: '<td>\n  Hi\n</td>'}
        {type: 'preformatted', nesting: -1}
        {type: 'raw', content: '  </tr>', format: 'html'}
        {type: 'raw', content: '</table>', format: 'html'}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "inline", ->

    # http://spec.commonmark.org/0.27/#example-582
    it "should allow open tags", (cb) ->
      test.markdown null, '<a><bab><c2c>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'raw', content: '<a>', format: 'html'}
        {type: 'raw', content: '<bab>', format: 'html'}
        {type: 'raw', content: '<c2c>', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-583
    it "should allow empty tags", (cb) ->
      test.markdown null, '<a/><b2/>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'raw', content: '<a/>', format: 'html'}
        {type: 'raw', content: '<b2/>', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-584
    it "should allow whitespace", (cb) ->
      test.markdown null, '<a  /><b2\ndata="foo" >', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'raw', content: '<a  />', format: 'html'}
        {type: 'raw', content: '<b2\ndata="foo" >', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-585
    it "should allow tags with attributes", (cb) ->
      test.markdown null, '<a foo="bar" bam = \'baz <em>"</em>\'\n_boolean zoop:33=zoop:33 />', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'raw', content: '<a foo="bar" bam = \'baz <em>"</em>\'\n_boolean zoop:33=zoop:33 />', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-586
    it "should allow custom tag names", (cb) ->
      test.markdown null, 'Foo <responsive-image src="foo.jpg" />', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Foo '}
        {type: 'raw', content: '<responsive-image src="foo.jpg" />', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-587
    it "should fail for illegal tag names", (cb) ->
      test.markdown null, '<33> <__>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '<33> <__>'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-588
    it "should fail for illegal attribute names", (cb) ->
      test.markdown null, '<a h*#ref="hi">', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '<a h*#ref="hi">'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-589
    it "should fail for illegal attribute values", (cb) ->
      test.markdown null, '<a href="hi\'> <a href=hi\'>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '<a href="hi\'> <a href=hi\'>'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-590
    it "should fail for illegal whitespace", (cb) ->
      test.markdown null, '< a><\nfoo><bar/ >', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '< a><'}
        {type: 'softbreak'}
        {type: 'text', content: 'foo><bar/ >'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-591
    it "should fail for missing whitespace", (cb) ->
      test.markdown null, '<a href=\'bar\'title=title>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '<a href=\'bar\'title=title>'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-592
    it "should allow closing tags", (cb) ->
      test.markdown null, '</a></foo >', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'raw', content: '</a>', format: 'html'}
        {type: 'raw', content: '</foo >', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-593
    it "should fail for illegal attribute in close tag", (cb) ->
      test.markdown null, '</a href="foo">', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '</a href="foo">'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-594
    it "should work for comment", (cb) ->
      test.markdown null, 'foo <!-- this is a\ncomment - with hyphen -->', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo '}
        {type: 'comment', content: 'this is a\ncomment - with hyphen'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-595
    it "should fail for comment with double hyphen", (cb) ->
      test.markdown null, 'foo <!-- not a comment -- two hyphens -->', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo <!-- not a comment -- two hyphens -->'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-596
    it "should fail for comment with double hyphen", (cb) ->
      test.markdown null, 'foo <!--> foo -->\n\nfoo <!-- foo--->', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo <!--> foo -->'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo <!-- foo--->'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-597
    it "should work for processing instructions", (cb) ->
      test.markdown null, 'foo <?php echo $a; ?>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo '}
        {type: 'raw', content: '<?php echo $a; ?>', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-598
    it "should work for declarations", (cb) ->
      test.markdown null, 'foo <!ELEMENT br EMPTY>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo '}
        {type: 'raw', content: '<!ELEMENT br EMPTY>', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-599
    it "should work for CDATA", (cb) ->
      test.markdown null, 'foo <![CDATA[>&<]]>', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo '}
        {type: 'raw', content: '<![CDATA[>&<]]>', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-600
    it "should preserve entities", (cb) ->
      test.markdown null, 'foo <a href="&ouml;">', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo '}
        {type: 'raw', content: '<a href="&ouml;">', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-601
    it "should not interpret escapes", (cb) ->
      test.markdown null, 'foo <a href="\*">', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo '}
        {type: 'raw', content: '<a href="\*">', format: 'html'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-602
    it "should not interpret escapes 2", (cb) ->
      test.markdown null, 'foo <a href="\"">', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo <a href="\"">'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
