Package: alinex-report
=================================================

[![Build Status](https://travis-ci.org/alinex/node-report.svg?branch=master)](https://travis-ci.org/alinex/node-report)
[![Coverage Status](https://coveralls.io/repos/alinex/node-report/badge.png?branch=master)](https://coveralls.io/r/alinex/node-report?branch=master)
[![Dependency Status](https://gemnasium.com/alinex/node-report.png)](https://gemnasium.com/alinex/node-report)

This report module should help you create complex reports in an easy
way. You create a new object and append different text objects step by step. At last
you may access the markdown text or get it converted to HTML.

But you may also use it to simply convert full-featured markdown into HTML or other
formats.

The key features are:

- easy markdown writing
- feature rich markdown
- export as text or html (also optimized for email)
- export as pdf, png or jpg
- console formatting support

See example output in [text](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.txt)
, [markdown](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.md), [HTML](http://htmlpreview.github.io/?https://github.com/alinex/node-report/blob/master/src/doc/test.html),
[PDF](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.pdf),
[PNG](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.png)
and [JPG](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.jpg) format.

Internally this works with a markdown syntax which has a limited number of possibilities
but is easy to transform in nearly any other format. If you know markdown you will
find the possibilities here enormous.

The html export can also be optimized for email using `ìnlineCss` option. With
this the styles from the head section will moved into the document because
webmail client will remove the head section completely.

> It is one of the modules of the [Alinex Universe](http://alinex.github.io/code.html)
> following the code standards defined in the [General Docs](http://alinex.github.io/develop).


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

This package will install a lot of subpackages to ensure the full functionality
but only the ones really needed are loaded on demand.

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

If you want to only convert existing markdown into html do this like:

``` coffee
html = new Report({source: markdownText}).toHtml()
```


Report Builder
-------------------------------------------------
The report builder is a collection of methods used to easily create the needed
markup. They often are handy to convert your objects into formatted text. In
contrast you may define the markup by yourself (see below) and use the `raw()`
method to add it.

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

See [highlight.js](https://highlightjs.org/static/demo/) for possible languages
to use.

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
- tt - typewriter like \`typewriter\`
- mark - marked text like highlighted with an text marker like `==marked==`

``` coffee
report.p "This paragraoh is #{Report.p 'important'}. " + Report.i 'Alex'
```
If you don't want to interpret is use `\\` before the sign or automatically
mask them using `Report.mask text`.


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
    <mask>    : (boolean) use Report.mask() on each field value

All other formats will be converted into this filling missing information with
default values.

There are lots of ways to use this:

__With a Table Instance__

If you have a [table] (http://alinex.github.io/node-table) instance you may directly
add this to your report. This supports 'align' settings on the columns or sheet:

``` coffee
# setup the table data
Table = require 'alinex-table'
table = new Table [
  ['ID', 'English', 'German']
  [1, 'one', 'eins']
  [2, 'two', 'zwei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
]
table.style null, 'ID', {align: 'right'}
# add them to existing report
report.table table
```

Now in the report output you get something like:

``` text
| ID | English | German |
| --:|:------- |:------ |
|  1 | one     | eins   |
|  2 | two     | zwei   |
|  3 | three   | drei   |
| 12 | twelve  | zwölf  |
```

__Direct table__

Next you may add a table containing a header row itself:

``` coffee
report.table  [
  ['ID', 'English', 'German']
  [1, 'one', 'eins']
  [2, 'two', 'zwei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
]
```

__Full Options__

Or at last give everything like you want it (all arguments above):

``` coffee
# obj-list-map
report.table [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
]
# obj-list-map with col-map-map
report.table [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
],
  id:
    title: 'ID'
    align: 'right'
  de:
    title: 'German'
  en:
    title: 'English'
# obj-list-map with col-list-array
report.table [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
], [
  ['id', 'en']
  ['ID', 'English']
]
# obj-list-map with col-list
report.table [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
], ['ID', 'English', 'German']
# obj-list-map with col-map
report.table [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
],
  id: 'ID'
  en: 'English'
# obj-list-map with col-map-map using sort-map
report.table [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
],
  id:
    title: 'ID'
    align: 'right'
  de:
    title: 'German'
  en:
    title: 'English'
, {de: 'desc'}
# obj-list-map with col-map-map using sort-list
report.table [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
],
  id:
    title: 'ID'
    align: 'right'
  de:
    title: 'German'
  en:
    title: 'English'
, ['de']
# obj-list-map with col-map-map using sort-key
report.table [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
],
  id:
    title: 'ID'
    align: 'right'
  de:
    title: 'German'
  en:
    title: 'English'
, 'de'
# obj-list-array
report.table [
  [1, 'one', 'eins']
  [2, 'two', 'zwei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
]
# obj-list-array with col-list
report.table [
  [1, 'one', 'eins']
  [2, 'two', 'zwei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
], ['ID', 'English', 'German']
# obj-list-array with col-array-array
report.table [
  [1, 'one', 'eins']
  [2, 'two', 'zwei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
], [
  [0, 1]
  ['ID', 'English']
]
# obj-list-array with col-array-map
report.table [
  [1, 'one', 'eins']
  [2, 'two', 'zwei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
], [
    title: 'ID'
    align: 'right'
  ,
    title: 'English'
  ,
    title: 'German'
  ]
# obj-map
report.table
  id: '001'
  name: 'alex'
  position: 'developer'
# obj-map with col-array
report.table
  id: '001'
  name: 'alex'
  position: 'developer'
, ['NAME', 'VALUE']
# mask in table with array
report.table
  id: '*001*'
  name: 'alex'
, ['Name', 'Value'], null, true
```

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

### Visualization

This will only work in HTML format, else the definition is displayed.

#### QR Code

``` coffee
report = new Report()
report.qr "http://alinex.de"
```

Or if you want to specify the parameters:

``` coffee
report = new Report()
report.qr
  content: 'http://alinex.github.io'
  padding: 1
  width: 600
  height: 600
  color: '#ff0000'
  background: '#ffffff'
  ecl: 'M'
report.qr "http://alinex.de"
```


Output
-------------------------------------------------
You have multiple possibilities to output the created markdown object.

### Markdown

Example: [markdown](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.md)

To get this native output you can directly convert the object to a string:

``` coffee
report.toString()
```

### Text Output

Example: [text](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.txt)

``` coffee
report.toText()
```

Here all non presentable elements are removed to get a clean plain text output.
This means the table of contents, decorator rules and backslashes at the end of line
are removed as well as image sources.

### Console Output

``` coffee
report.toConsole()
```

This is targeted to output on the console. Therefore the plain text from above will
be marked with ascii escape sequences to add color highlighting. All markup which
is possible in console like bold, strikethrough, italic... will be used.

Tables will be drawn using ASCII art grid lines.

### HTML Document

Example: [html](http://htmlpreview.github.io/?https://github.com/alinex/node-report/blob/master/src/doc/test.html)

``` coffee
report.toHtml() # deprectaed syntax without inline css support

report.toHtml options, (err, html) ->
  # use the html
```

Options are:

- title (string) - to be used instead of h1 content
- style (string) - reference to the used style under src/style/xxx.css
- locale (string) - language to use like 'de'
- inlineCss (boolean) - move css from head to the tags as styles (useful for mails)

This is the most powerful output method. In which all markdown elements will be
supported and interpreted. It will create one HTML file to be used in emails...

Only links to internet resources like images and css are kept as they are. local
links in the format 'file:///....' will be replaced with their content included
as data uri in the document. This makes the document larger but helps to keep
everything in one file. In emails you may extract these again and replace them
with cid uri to the now attached resource.

### PDF Document

Example: [PDF](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.pdf)

``` coffee
report.toPdf (err, data) ->
  # you may store this to a file
```

You can also give some options:

``` coffee
report.toPdf options, (err, data) ->
  # you may store this to a file
```

Possible options are:

- format - A3, A4, A5, Legal, Letter or Tabloid
- height - like "10.5in" allowed units: mm, cm, in, px
- width - like "8in" allowed units: mm, cm, in, px
- orientation - portrait or landscape
- border - like "0" allowed units: mm, cm, in, px \
  or as an object with top, right, bottom nad left settings


### Image

Example: [PNG](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.png)
and [JPG](https://raw.githubusercontent.com/alinex/node-report/master/src/doc/test.jpg)

``` coffee
report.toImage (err, data) ->
  # you may store this to a file
```

You can also give some options:

``` coffee
report.toImage options, (err, data) ->
  # you may store this to a file
```

Possible options are:

- type - png or jpg
- quality - integer between 0 and 100 as best quality default is 75


Markup Syntax
-------------------------------------------------
The following syntax may be used alternatively to create your report. To add
it use the 'source' option of the constructor or the 'raw()' method.

### Text blocks

You write your text directly, line breaks will not be held but made like needed.
An empty line starts a new paragraph but if you need a line break on a specific
position use a slash at the end:

    This is an example paragraph which will not break here
    but at the position there it is optimal but here \
    a break will be kept.

    And this is the next paragraph.

### Headings

There are six levels of heading to be used. But only the biggest two can have a
specific alternative format:

    # h1 Heading
    ## h2 Heading
    ### h3 Heading
    #### h4 Heading
    ##### h5 Heading
    ###### h6 Heading

    h1 Heading
    ==========================================================================

    h2 Heading
    --------------------------------------------------------------------------

### Horizontal Rules

All of the following types with 3 or more characters are recognized as lines and
all will look the same in most output formats.

    ___

    ---

    ***


### Typographic Replacements

Some special typographic elements will automatically be converted into their specific
character:

    (c) (C) (r) (R) (tm) (TM) (p) (P) +-

    test... test..... test?..... test!....

    -- ---

### Character Format

    **This is bold text**

    __This is bold text__

    *This is italic text*

    _This is italic text_

    ~~Strikethrough~~

    ++Inserted text++

    ==Marked text==

    19^th^ with superscript

    H~2~O with subscript

### Blockquotes

    > Blockquotes can also be nested...
    >> ...by using additional greater-than signs right next to each other...
    > > > ...or with spaces between arrows.

### Lists

Unordered

    + Create a list by starting a line with `+`, `-`, or `*`
    + Sub-lists are made by indenting 2 spaces:
      - Marker character change forces new list start:
        * Ac tristique libero volutpat at
        + Facilisis in pretium nisl aliquet
        - Nulla volutpat aliquam velit
    + Very easy!

Ordered

    1. Lorem ipsum dolor sit amet
    2. Consectetur adipiscing elit
    3. Integer molestie lorem at massa


    1. You can use sequential numbers...
    1. ...or keep all the numbers as `1.`

Start numbering with offset:

    57. foo
    1. bar

Definition lists

    Term 1

    :   Definition 1
    with lazy continuation.

    Term 2 with *inline markup*

    :   Definition 2

            { some code, part of Definition 2 }

        Third paragraph of definition 2.

Compact style

    Term 1
      ~ Definition 1

    Term 2
      ~ Definition 2a
      ~ Definition 2b

Check Lists

    [x] todo list
    [x] with elements done
    [ ] and something todo

### Code

    Inline `code`

Indented code

        // Some comments
        line 1 of code
        line 2 of code
        line 3 of code


Block code "fences"

    ```
    Sample text here...
    ```

Syntax highlighting

    ``` js
    var foo = function (bar) {
      return bar++;
    };

    console.log(foo(5));
    ```

See [highlight.js](https://highlightjs.org/static/demo/) for possible languages
to use.

### Tables

``` text
| Option | Description |
| ------ | ----------- |
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |
```

Right aligned columns

``` text
| Option | Description |
| ------:| -----------:|
| data   | path to data files to supply the data that will be passed into templates. |
| engine | engine to be used for processing templates. Handlebars is the default. |
| ext    | extension to be used for dest files. |
```

### Links

    [link text](http://dev.nodeca.com)

    [link with title](http://nodeca.github.io/pica/demo/ "title text!")

    Autoconverted link https://github.com/nodeca/pica

### Images

    ![Minion](https://octodex.github.com/images/minion.png)
    ![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

Like links, Images also have a footnote style syntax

    ![Alt text][id]

With a reference later in the document defining the URL location:

    [id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"

### Emojies and Signs

A lot of emojies will be replaced with special UTF characters or colorful images:

    Classic markup: :wink: :crush: :cry: :tear: :laughing: :yum:

    Shortcuts (emoticons): :-) :-( 8-) ;)

Also the [fontawesome](https://fortawesome.github.io/Font-Awesome/icons/) icons
may be used like:

    :fa-anchor:

### Footnotes

    Footnote 1 link[^first].

    Footnote 2 link[^second].

    Inline footnote^[Text of inline footnote] definition.

    Duplicated footnote reference[^second].

    [^first]: Footnote **can have markup**

        and multiple paragraphs.

    [^second]: Footnote text.

### Abbreviations

    This is HTML abbreviation example.

    It converts "HTML", but keep intact partial entries like "xxxHTMLyyy" and so on.

    *[HTML]: Hyper Text Markup Language

### Boxes

    ::: detail
    *here be dragons*
    :::

    ::: info
    *here be dragons*
    :::

    ::: warning
    *here be dragons*
    :::

    ::: alert
    *here be dragons*
    :::

### Table of Contents
The following code will add an table of contents in some output types.

    @[toc]

### Specific Style

For html and, pdf and image output a specific style can be set. This belongs to
the element atrated in front of the style definition.

    <!-- {color:red} -->

    <!-- {p:.center} -->

The second example specifies the previouse &lt;p> tag and sets the style class
'.center' for it.

### Visualizations

This will only work in HTML format, else the definition is displayed.

#### QR Code

This will display a qr code image. It will be in a default size of 256 x 256 pixel.

    $$$ qr
      http://alinex.de
    $$$

To make it more specific you may use the extended form:

    $$$ qr
      content: http://alinex.github.io
      padding: 1
      width: 600
      height: 600
      color: #ff0000
      background: #ffffff
      ecl: M
    $$$


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
