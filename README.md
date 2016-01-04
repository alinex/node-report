Package: alinex-report
=================================================

[![Build Status](https://travis-ci.org/alinex/node-report.svg?branch=master)](https://travis-ci.org/alinex/node-report)
[![Coverage Status](https://coveralls.io/repos/alinex/node-report/badge.png?branch=master)](https://coveralls.io/r/alinex/node-report?branch=master)
[![Dependency Status](https://gemnasium.com/alinex/node-report.png)](https://gemnasium.com/alinex/node-report)

This report module should help you create complexe text/html reports in an easy
way. You create a new object and append different text objects step by step. At last
you may access the markdown text or get it converted to html.

The key features are:

- easy markdown writing
- export as text or html
- console formatting support

See example output in [text](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.txt)
, [markdown](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.md)
and [html](http://htmlpreview.github.io/?https://github.com/alinex/node-report/blob/master/src/doc/test.html) format.

> It is one of the modules of the [Alinex Universe](http://alinex.github.io/code.html)
> following the code standards defined in the [General Docs](http://alinex.github.io/node-alinex).


Install
-------------------------------------------------

[![NPM](https://nodei.co/npm/alinex-database.png?downloads=true&downloadRank=true&stars=true)
 ![Downloads](https://nodei.co/npm-dl/alinex-database.png?months=9&height=3)
](https://www.npmjs.com/package/alinex-database)

The easiest way is to let npm add the module directly to your modules
(from within you node modules directory):

``` sh
npm install alinex-report --save
```

And update it to the latest version later:

``` sh
npm update alinex-report --save
```

Always have a look at the latest [changes](Changelog.md).


Usage
-------------------------------------------------

The first step is to load the module:

``` coffee
Report = require 'alinex-report'
```

And now you create a new object:

``` coffee
report = new Report()
```

You may also give some of the following options:

- `source` - markdown text to preload
- `log` - a function called each time something is added with the added text
- `width` - the width for line breaks (default: 80)

Now you may add content to your report:

``` coffee
report.h1 "My Test"
report.p "This is a short demonstrative test with:"
report.list [
  "headings"
  "text blocks"
  "unnumbered lists"
]
```

And finally get the complete result:

``` coffee
console.log report # same as report.toString()
text = report.toString() # markdown syntax
html = report.toHtml()   # html
log = report.toConsole() # text with ansi colors
```

Instead of creating a report you can also let this module convert single elements
on the fly:

``` coffee
console.log Report.ul ['one', 'two', 'three']
console.log Report.p "This text contains a #{Result.b 'bold'} word."
```


Formatter Overview
-------------------------------------------------

Settings to be done before using the reporter:

``` coffee
# globally
Report.width = 80
# only for instance
report = new Report()
report.width = 80
```

This setting will define the maximum line length (default is 80 characters). All
methods which use it have the ability to overwrite this default setting with an
individual number.

You may also set the width on the instance instead of globally giving it as a
parameter to the constructor. See the usage above.

### Headings

- h1 - heading level 1
- h2 - heading level 2
- h3 - heading level 3
- h4 - heading level 4
- h5 - heading level 5
- h6 - heading level 6

They are all called with a text and an optional width parameter. The width will
only specify the width of the lines in the markdown output (h1 and h2 only).

``` coffee
report = new Report()
report.h1 'My Title'
report.h2 'Subheading with specific width', 120
```

### Paragraphs

- p - add a text paragraph
- quote - add quoted text multiple level depth (second parameter)
- code - add a code block (language as additional parameter)

All this methods need a text and an optional width as last parameter used for
automatic line breaks in markdown style.

``` coffee
report.p 'A new paragraph.'
report.p 'A long text may be automatically broken into multiple lines.', 40
```

For quoted text you can give the depth level as number (default is 1):

``` coffee
report.quote 'My home is my castle!', 1
```

And for code you give the language which is used for syntax highlighting (default
is text):

``` coffee
report.code 'va x = Math.round(f);', 'js'
```

### Special Signs

You may also include some

- classic typographs like: `(c) (C) (r) (R) (tm) (TM) (p) (P) +-`
- emoji: `:wink: :crush: :cry: :tear: :laughing: :yum:`
- emoji shortcuts: `:-) :-( 8-) ;)`
- [Font Awesome](https://fortawesome.github.io/Font-Awesome/): `:fa-flag:`


### Separation

- hr - add a horizontal rule as separation
- br - line break

You may separate lines using `br` breaks (while normal single newlines are ignored in
markdown) and for paragraph separation you may use horizontal lines:

``` coffee
report.hr()
report.p "This paragraph should have a #{Report.br()} line break visible also in html."
# like: report.p "This paragraph should have a\\\nline break visible also in html."
```

### Inline Formats

These are only available on static calls not on a report instance!

- b - bold like `__bold__`
- i - italic like `_italic_`
- del - delete like `~~delete~~`
- sub - subscript like `~subscript~`
- sup - superscript like `^superscript^`
- tt - typewriter like `\`typewriter\``
- mark - marked text like highlighted with an text marker like `==marked==`

``` coffee
report.p "This paragraoh is #{Report.p 'important'}. " + Report.i 'Alex'
```

### Links and Images

- a - create a link
- img - add an image

``` coffee
report = new Report()
report.p Report.a 'google', 'http://google.com'
report.p "Autoconverted link to http://alinex.github.io"
report.p Report.img 'google', 'https://www.google.de/images/branding\
/googlelogo/2x/googlelogo_color_272x92dp.png'
```

### Lists

- ul - unordered list from array
- ol - ordered list from array
- dl - definition list from object

All this lists allow for alphanumeric sorting. Give `true` as second parameter or
`false` for reverse sorting.

``` coffee
report = new Report()
list = ['one', 'two', ['sub line', 'and more'], 'three']
report.ul list
report.ol list
```

And a definition list takes an object as argument:

``` coffee
report = new Report()
report.dl
  HTML: 'Markup language for the web'
  CSS: 'Styling language for web pages'
  JavaScript: 'Coding not only for web pages'
```

### Table

Output a table (data object and optional column object needed). This can be called
with different kind of objects making it easy to use nearly everything you have.

    Syntax: table <object>, <columns>, <sort>

The complexest format will be shown at first:

    <object>  : a list of row maps like returned from a database
    <columns> : a map of column id to use as columns with the options:
                - title - heading text
                - align - orientation (one of 'left', 'center', 'right')
                - width - the minimum width of the column (optional)
    <sort>    : a map of sort conditions defining the column id and order ('asc', 'desc')

All other formats will be converted into this filling missing information with
default values.


### Special Elements

- footnote - add a footnote text

``` coffee
report = new Report()
report.p "This is a test#{report.footnote 'simple test only'} to demonstrate footnotes."
```

- abbr - add an abbreviation entry (before use in the text)

``` coffee
report = new Report()
report.abbr 'HTTP', 'Hyper Text Transfer Protocol'
report.p "The HTTP protocol is used for transferring web content."
```

- check - add a map of elements

``` coffee
report = new Report()
report.check
  'make new module': true
  'allow html transformation': true
  'allow docx transformation': false
```

- toc - add a table of contents entry (visible only after rendering)

``` coffee
report = new Report()
report.toc()
```

### Boxes

The following code makes a colored box around a markup text which may contain of
any markup.

``` coffee
report = new Report()
report.box "Some more details here...", 'detail'
report.box "A short note.", 'info'
report.box "This is important!", 'warning'
report.box "Something went wrong!", 'alert'
```

### Specify element properties

With this you can specify some special classes but only if they are supported in
the stylesheet:

``` coffee
report = new Report()
report.p "Make this centered (using class)..." + Report.style '.center'
report.p "Make this centered and red (using classes)..." + Report.style '.center.red'
report.p "Set an id and class..." + Report.style '#top .hide'
report.p "Set an specific attriubute" + Report.img('google', 'https://www.google.de/images/branding\
/googlelogo/2x/googlelogo_color_272x92dp.png') + Report.style 'width=20'
```

This applies the given style to the innermost previous element. But you may also
specify the type of element:

``` coffee
report = new Report()
report.p "Make this #{Report.b 'bold'}..." + Report.style 'p:.center'
```

Here the class didn't go to the bold text but to the previous paragraph.

The following classes may be used:

|  STYLE  | RESULT         |
|:-------:|:-------------- |
| .bold   | make text bold |
| .red    | make text red  |
| .center | center text    |


License
-------------------------------------------------

Copyright 2015-2016 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
