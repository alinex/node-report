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
- export as text, console, html (also optimized for email), pdf, png or jpg
- convert text to visual representation like qr, chart or UML
- optimized html tables

See example output in within the different element descriptions below.

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

### Report builder

The report builder is a collection of methods used to easily create the needed
markup. They often are handy to convert your objects into formatted text:

``` coffee
report.h1 "My Test"
report.p "This is a short demonstrative test with:"
report.list [
  "headings"
  "text blocks"
  "unnumbered lists"
]
```

### Format output

And finally get the complete result:

``` coffee
console.log report # same as report.toString()
text = report.toString() # markdown syntax
html = report.toHtml()   # html
log = report.toConsole() # text with ansi colors
```

### Convert to Markdown

Instead of creating a report to collect everything, you can also let this module
convert single elements on the fly:

``` coffee
console.log Report.ul ['one', 'two', 'three']
console.log Report.p "This text contains a #{Result.b 'bold'} word."
```

### Markdown as Base

If you want to only convert existing markdown into html do this like:

``` coffee
html = new Report({source: markdownText}).toHtml()
```

### Mask characters

To mask some characters to be not interpreted as markdown, you may use `\` before
the special markdown signs or automatically mask them using `Report.mask text`
if you didn't want to interpret them as markdown.


Report Elements
-------------------------------------------------
The report builder is a collection of methods used to easily create the needed
markup. They often are handy to convert your objects into formatted text. In
contrast you may define the markup by yourself (see below) and use the `raw()`
method to add it.

Often the text output will look like the markdown and the console output sometimes, too.

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

### Heading

Use the methods h1 to h6 to create headings in the given level:

``` coffee
report = new Report()
report.h1 'My Title'
report.h2 'Subheading with specific width', 120
```

In the headings level 1 and 2 it is possible to give a width for the line length
as shown above.

``` markdown
h1 Heading
==========================================================================

h2 Heading
--------------------------------------------------------------------------

### h3 Heading

#### h4 Heading

##### h5 Heading

###### h6 Heading
```

With the default style this should look like:

![html](src/doc/headings.png) ![console](src/doc/headings.console.png)

Alternatively the first two levels may also defined as:

``` markdown
# h1 Heading

## h2 Heading
```

### Blocks

This allows the following types:

- p - add a text paragraph
- quote - add quoted text multiple level depth (second parameter)
- code - add a code block (language as additional parameter)

#### Normal

Use it for a normal text paragraph.

``` coffee
report.p 'A new paragraph.'
report.p 'A long text may be automatically broken into multiple lines.', 40
report.p 'And here comes a fixed\n linebreak.\n\nWith a second paragraph.'
```

You may give the line length for markdown as optional second parameter.

This goes into html as:

``` markdown
A new paragraph.

A long text may be automatically broken
into multiple lines.

And here comes a fixed\
linebreak.

With a second paragraph.
```

In markdown you write your text directly, line breaks will not be held but made
like needed. An empty line starts a new paragraph but if you need a line break
on a specific position use a slash at the end.

And renders in HTML as:

![paragraph](src/doc/block-paragraph.png)

#### Quote

Quoted text is used if you show another opinion and it may also be multiple level
deep. It is like used in emails.


``` coffee
report.quote 'My home is my castle!'
report.quote "I would like to visit a castle in north scotland, next year.", 2, 40
```

Parameters:

- (string) text for thee quote
- (integer) depth level 1.. (default: 1)
- (integer) max width in markdown

You may give the quoting depth as second parameter and maybe the line length for
markdown as third parameter.

``` markdown
> My home is my castle!

> > I would like to visit a castle in
> > north scotland, next year.
```

An alternative format is:

``` markdown
> Blockquotes can also be nested...
>> ...by using additional greater-than signs right next to each other...
> > > ...or with spaces between arrows.
```

And renders as HTML:

![quote](src/doc/block-quote.png) ![quote](src/doc/block-quote2.png)

#### Preformatted Text

This is used for any text which you didn't have a specific language but should alsobe displayed as a preformatted block.

``` coffee
report.code 'This is a text code block.\nIt should be kept as is.'
```

In the markdown this is represented with a block of at leasr three back quotes:

```` markdown
    This is a text code block.
    It should be kept as is.
````

And renders as HTML:

![html](src/doc/block-pre.png)

#### Code Highlighting

To display some code you can create a paragraph with syntax highlighting (only HTML)
in languages like:

- code like: bash, coffee, js, sh, sql
- data like: json, yaml
- documents like: handlebars, markdown

See [highlight.js](https://highlightjs.org/static/demo/) for all possible languages
to use.

``` coffee
report.code 'var x = Math.round(f);', 'js'
report.code 'This **is** a ==markdown== text', 'markdown'
report.code 'simple:\n  list: [a, b, 5]', 'yaml'
```

In the markdown this is represented with a block of at leasr three back quotes
followed by the language to use:

```` markdown
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
````

And renders as HTML:

![html](src/doc/block-code.png)

### Separation

A horizontal line may be used as seperation between text blocks.


``` coffee
report.p "My first line."
report.hr()
report.p "And another one after a separating line."
```

In the markdown this will be displayed with at least three dashes as a line:

``` markdown
My first line.

---

And another one after a separating line.
```

Alternatively you may use at least 3 or more undescores `___` or asterisk `***`
characters as a line.

And renders as HTML:

![html](src/doc/separation.png) ![console](src/doc/separation.console.png)

### Box

The following code makes a colored box around a markup text which may contain
any other markup. As second parameter the type of the box needs to be given
which is one of: 'detail', 'info', 'warning', 'alert'

``` coffee
report.box "Some more details here...", 'detail'
report.box "A short note.", 'info'
report.box "This is important!", 'warning'
report.box "Something went wrong!", 'alert'
```

An additional width parameter may also be given to set the display width in markdown.

In the markdown this is defined using driple colons as start and end with the
box type behind the start mark:

``` markdown
::: detail
Some more details here...
:::

::: info
A short note.
:::

::: warning
This is important!
:::

::: alert
Something went wrong!
:::
```

And renders as HTML or console output:

![html](src/doc/box.png) ![console](src/doc/box.console.png)

### Lists

Three types of lists are supported:

- ul - unordered list from array
- ol - ordered list from array
- dl - definition list from object

All this lists allow for alphanumeric sorting. Give `true` as second parameter or
`false` for reverse sorting but keep in mind that this is only working correctly
in straight lists (not sublists).
Also an additional width parameter for the markdown display width may be given as
third paramter.

#### Unordered List

This will create a list with bullets.

``` coffee
report.ul [
  'one'
  'two'
  "and this is a long text because i can't only write numbers
  down here to show the proper use of the lists also with long text lines" 'last\ntwo lines'
report.hr()
report.ul [
  'one'
  'two'
  ['subline', 'and more']
  'three'
]
```

In the markdown the same list is defined as:

``` markdown
- one
- two
- and this is a long text because i can't only write numbers down here to show
  the proper use of the lists also with long text lines
- last\
  two lines

---

- one
- two
  - and more
  - subline
- three
```

Alternatively `*`, `+` or `-` may also be used as list symbols, also in mixed
format.

``` markdown
+ Create a list by starting a line with `+`, `-`, or `*`
+ Sub-lists are made by indenting 2 spaces:
  - Marker character change forces new list start:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!
```

And renders as HTML:

![html](src/doc/list-unordered.png) ![html](src/doc/list-unordered2.png)

#### Ordered List

This will create a numbered list.

``` coffee
report.ol [
  'one'
  'two'
  "and this is a long text because i can't only write numbers
  down here to show the proper use of the lists also with long text lines" 'last\ntwo lines'
report.hr()
report.ol [
  'one'
  'two'
  ['subline', 'and more']
  'three'
]
```

In the markdown the same list is defined as:

``` markdown
1. one
2. two
3. and this is a long text because i can't only write numbers down here to show
   the proper use of the lists also with long text lines
4. last\
   two lines

---

1. one
2. two
   1. and more
   2. subline
3. three
```

It doesn't matter if you give the same number multiple times, only the first number's
value is used to start numbering. To start at a specific number start with it:

``` markdown
1. You can use sequential numbers...
1. ...or keep all the numbers as `1.`

Start numbering with offset:

57. foo
1. bar
```

And renders as HTML:

![html](src/doc/list-ordered.png) ![html](src/doc/list-ordered2.png)

#### Definition List

This will display some phrases as list entries with their contents.

``` coffee
report.dl
  html: 'Markup language for internet pages'
  css: 'Style language to bring the layout into html'
, true
```

Like seen in the example the sorting may be set to true.

In the markdown the same list is defined as:

``` markdown
css

: Style language to bring the layout into html

html

: Markup language for internet pages
```

In the markdown you may also use:

``` markdown
Term 1

:   Definition 1
with lazy continuation.

Term 2 with *inline markup*

:   Definition 2

    Second paragraph of definition 2.

Compact style:

Term 1
  ~ Definition 1

Term 2
  ~ Definition 2a
  ~ Definition 2b
```

And renders as HTML:

![html](src/doc/list-definition.png) ![html](src/doc/list-definition2.png)

#### Check Lists

A check list in which each row maybe done or not.

``` coffee
report.check
  'todo list': true
  'with elements done': true
  'and something todo': false
```

The values in the given map defines if they are done or not.

As markdown this is written as:

``` markdown
[x] todo list
[x] with elements done
[ ] and something todo
```

And renders as HTML and console output:

![html](src/doc/list-check.png) ![console](src/doc/list-check.console.png)

### Inline Formats

These are only available on static calls not on a report instance! But you may add
them into another instance method.

- b - bold like `__bold__`
- i - italic like `_italic_`
- del - delete like `~~delete~~`
- sub - subscript like `~subscript~`
- sup - superscript like `^superscript^`
- tt - typewriter like \`typewriter\`
- mark - marked text like highlighted with an text marker like `==marked==`

``` coffee
report.p "This should show as #{Report.b "bold"} format."
report.p "This should show as #{Report.i "italic"} format."
report.p "This should show as #{Report.del "strikethrough"} format."
report.p "This should show as #{Report.tt "typewriter"} format."
report.p "This should show as #{Report.sub "subscript"} format."
report.p "This should show as #{Report.sup "superscript"} format."
report.p "This should show as #{Report.mark "highlight"} format."
```

You may also combine this calls feeding one result into the other method:

``` coffee
report.p "Water has the formula " + Report.b("H#{Report.sub 2}O") + " *v* ."
```

The markdown will look like:

``` markdown
This should show as __bold__ format.

This should show as _italic_ format.

This should show as ~~strikethrough~~ format.

This should show as `typewriter` format.

This should show as ~subscript~ format.

This should show as ^superscript^ format.

This should show as ==highlight== format.
```

As an alternative syntax you may use `*italic*` or `**bold**` for this formats, too.

The complex example from above will look like:

``` markdown
Water has the formula __H~2~O__.
```

And renders as HTML:

![html](src/doc/format.png) ![html](src/doc/format-complex.png)

And also in console some formats are interpreted:

![console](src/doc/format.png)

### Links

If you add a link you can give the full url in the text or add the link  as an
inline element with:

- link text
- url
- title text shown as tooltip in html (optional)

``` coffee
report.p "Autoconverted link to http://alinex.github.io"
link = Report.a 'google', 'http://google.com', 'Open Google Search'
report.p "Have a look at #{link}"
```

As markdown the link text goes into square brackets, the url in brackets with the optional title text in quotes within:

``` markdown
Autoconverted link to http://alinex.github.io

Have a look at [google](http://google.com "Open Google Search")
```

And renders as HTML:

![html](src/doc/links.png)

Console and text output will be the same as markdown.

### Images

Images may be added nearly the same way as links. The parameters are:

- alternative text
- url
- title text shown as tooltip in html (optional)

``` coffee
report.p Report.img 'Alinex', 'https://alinex.github.io/images/Alinex-200.png'
report.p Report.img 'Alinex Black', 'https://alinex.github.io/images/Alinex-black-200.png', "The Alinex Logo"
image = Report.img 'Alinex', 'https://alinex.github.io/images/Alinex-200.png'
report.p "With link: " + Report.a image, 'http://alinex.github.com'
```

The markdown also looks the same as for links with an exclamation mark before:

``` markdown
![Alinex](https://alinex.github.io/images/Alinex-200.png)

![Alinex Black](https://alinex.github.io/images/Alinex-black-200.png "The Alinex
Logo")

With link:
[![Alinex](https://alinex.github.io/images/Alinex-200.png)](http://alinex.github.com)
```

With a link the image goes into the square brackets of the link text.

And renders as HTML and console output:

![html](src/doc/images.png) ![html](src/doc/images.console.png)

The text conversion is the same as conspole output.

### Special Signs

You may also include some special signs.

#### Typographic

``` coffee
report.h3 "classic typographs: "
report.ul [
  "copyright:   (c) (C)"
  "registeres:  (r) (R) "
  "trademark:   (tm) (TM) "
  "paragraph:   (p) (P) "
  "math:        +-"
]
```

``` markdown
### classic typographs

- copyright:   (c) (C)
- registeres:  (r) (R)
- trademark:   (tm) (TM)
- paragraph:   (p) (P)
- math:        +-
```

And renders as HTML and console output:

![html](src/doc/signs-typograph.png) ![console](src/doc/signs-typograph.console.png)

#### Emoji

``` coffee
report.h3 "emoji:"
report.ul [
  """angry:            :angry:            >:(     >:-("""
  """blush:            :blush:            :")     :-")"""
  """broken_heart:     :broken_heart:     </3     <\\3"""
  """confused:         :confused:         :/      :-/"""
  """cry:              :cry:              :,(   :,-("""
  """frowning:         :frowning:         :(      :-("""
  """heart:            :heart:            <3"""
  """imp:              :imp:              ]:(     ]:-("""
  """innocent:         :innocent:         o:)     O:)     o:-)      O:-)      0:)     0:-)"""
  """joy:              :joy:              :,)      :,-)   :,D      :,-D"""
  """kissing:          :kissing:          :*      :-*"""
  """laughing:         :laughing:         x-)     X-)"""
  """neutral_face:     :neutral_face:     :|      :-|"""
  """open_mouth:       :open_mouth:       :o      :-o     :O      :-O"""
  """rage:             :rage:             :@      :-@"""
  """smile:            :smile:            :D      :-D"""
  """smiley:           :smiley:           :)      :-)"""
  """smiling_imp:      :smiling_imp:      ]:)     ]:-)"""
  """sob:              :sob:              ;(     ;-("""
  """stuck_out_tongue: :stuck_out_tongue: :P      :-P"""
  """sunglasses:       :sunglasses:       8-)     B-)"""
  """sweat:            :sweat:            ,:(     ,:-("""
  """sweat_smile:      :sweat_smile:      ,:)     ,:-)"""
  """unamused:         :unamused:         :s      :-S     :z      :-Z     :$      :-$"""
  """wink:             :wink:             ;)      ;-)"""
]
```

``` markdown
### emoji:

- angry:            :angry:            >:(     >:-(
- blush:            :blush:            :")     :-")
- broken_heart:     :broken_heart:     </3     <\3
- confused:         :confused:         :/      :-/
- cry:              :cry:              :,(   :,-(
- frowning:         :frowning:         :(      :-(
- heart:            :heart:            <3
- imp:              :imp:              ]:(     ]:-(
- innocent:         :innocent:         o:)     O:)     o:-)      O:-)      0:)
     0:-)
- joy:              :joy:              :,)      :,-)   :,D      :,-D
- kissing:          :kissing:          :*      :-*
- laughing:         :laughing:         x-)     X-)
- neutral_face:     :neutral_face:     :|      :-|
- open_mouth:       :open_mouth:       :o      :-o     :O      :-O
- rage:             :rage:             :@      :-@
- smile:            :smile:            :D      :-D
- smiley:           :smiley:           :)      :-)
- smiling_imp:      :smiling_imp:      ]:)     ]:-)
- sob:              :sob:              ;(     ;-(
- stuck_out_tongue: :stuck_out_tongue: :P      :-P
- sunglasses:       :sunglasses:       8-)     B-)
- sweat:            :sweat:            ,:(     ,:-(
- sweat_smile:      :sweat_smile:      ,:)     ,:-)
- unamused:         :unamused:         :s      :-S     :z      :-Z     :$     
  :-$
- wink:             :wink:             ;)      ;-)
```

And renders as HTML:

![html](src/doc/signs-emoji.png)

Text and console output are the same as the markdown.

#### Font Awesome

Font Awesome gives you scalable vector icons that can instantly be customized — size,
color, drop shadow, and anything that can be done with the power of CSS.
You can use all the icons from [FontAwesome](http://fontawesome.io/icons/) to add
to your markup (html only):

``` coffee
report.h3 "fontawesome:"
report.p "basic icons:   :fa-flag:    :fa-camera-retro:"
report.p "larger icons:  :fa-camera-retro fa-lg: :fa-camera-retro fa-2x: :fa-camera-retro fa-3x:"
report.p "fixed width:   :fa-home fa-fw:   :fa-pencil fa-fw:"
report.ul [
  "<!-- {ul:.fa-ul}-->"
  "list symbols:  :fa-li fa-check-square:"
]
report.p ":fa-quote-left fa-3x fa-pull-left fa-border:
  ...tomorrow we will run faster, stretch out our arms farther...
  And then one fine morning— So we beat on, boats against the
  current, borne back ceaselessly into the past."
report.p "animated icons:    :fa-spinner fa-spin fa-2x fa-fw:
  :fa-circle-o-notch fa-spin fa-2x fa-fw:
  :fa-refresh fa-spin fa-2x fa-fw:
  :fa-cog fa-spin fa-2x fa-fw:
  :fa-spinner fa-pulse fa-2x fa-fw:"
report.p "flipped and rotated:   :fa-shield: normal
  :fa-shield fa-rotate-90: fa-rotate-90
  :fa-shield fa-rotate-180: fa-rotate-180
  :fa-shield fa-rotate-270: fa-rotate-270
  :fa-shield fa-flip-horizontal: fa-flip-horizontal
  :fa-shield fa-flip-vertical: fa-flip-vertical"
report.p "stacked icons:
  :fa-stack fa-lg fa-stack-2x fa-square-o fa-stack-1x fa-twitter:
  :fa-stack fa-lg fa-stack-2x fa-circle fa-stack-1x fa-flag fa-inverse:
  :fa-stack fa-lg fa-stack-2x fa-square fa-stack-1x fa-terminal fa-inverse:
  :fa-stack fa-lg fa-stack-1x fa-camera fa-stack-2x fa-ban text-danger:"
```

- __Basic Icons__

  You can place Font Awesome icons just about anywhere as inline text using the icon's
  name. The icon size and color will match the surrounding text paragraph.

  - __Colors__

  Use the classes `text-red`, `text-green`, `text-yellow`, `text-blue`, `text-magenta`, `text-cyan`
  or `text-gray` to change the colors.

- __Larger Icons__

  To increase icon sizes relative to their container, use the `fa-lg` (33% increase),
  `fa-2x`, `fa-3x`, `fa-4x`, or `fa-5x` classes.

- __Fixed Width__

  Use `fa-fw` to set icons at a fixed width. Great to use when different icon widths
  throw off alignment. Especially useful in things like lists.

- __List Icons__

  Use `fa-ul` and `fa-li` to easily replace default bullets in unordered lists.

- __Bordered Icons__

  Use `fa-border` and `fa-pull-right` or `fa-pull-left` for easy pull quotes or article icons.

- __Animated Icons__

  Use the `fa-spin` class to get any icon to rotate, and use `fa-pulse` to have it rotate
  with 8 steps. Works well with `fa-spinner`, `fa-refresh` and `fa-cog`.

- __Flipped and Rotated__

  To arbitrarily rotate and flip icons, use the `fa-rotate-*` and `fa-flip-*` classes.

- __Stacked Icons__

  To stack multiple icons, use the `fa-stack-1x` as start for the regularly sized icon, and
  `fa-stack-2x` for the larger icon and the icon itself with it's manipulations like `fa-inverse`
  behind.

``` markdown
### fontawesome:

__basic icons:__   :fa-flag:    :fa-camera-retro:

__larger icons:__  :fa-camera-retro fa-lg: :fa-camera-retro fa-2x:
:fa-camera-retro fa-3x:

__fixed width:__   :fa-home fa-fw:   :fa-pencil fa-fw:

- <!-- {ul:.fa-ul}-->
- __list symbols:__  :fa-li fa-check-square:

:fa-quote-left fa-3x fa-pull-left fa-border: __border icons:__ ...tomorrow we
will run faster, stretch out our arms farther... And then one fine morning— So
we beat on, boats against the current, borne back ceaselessly into the past.

__animated icons:__    :fa-spinner fa-spin fa-2x fa-fw: :fa-circle-o-notch
fa-spin fa-2x fa-fw: :fa-refresh fa-spin fa-2x fa-fw: :fa-cog fa-spin fa-2x
fa-fw: :fa-spinner fa-pulse fa-2x fa-fw:

__flipped and rotated:__   :fa-shield: normal :fa-shield fa-rotate-90:
fa-rotate-90 :fa-shield fa-rotate-180: fa-rotate-180 :fa-shield fa-rotate-270:
fa-rotate-270 :fa-shield fa-flip-horizontal: fa-flip-horizontal :fa-shield
fa-flip-vertical: fa-flip-vertical

__stacked icons:__ :fa-lg fa-stack-2x fa-square-o fa-stack-1x fa-twitter: :fa-lg
fa-stack-2x fa-circle fa-stack-1x fa-flag fa-inverse: :fa-lg fa-stack-2x
fa-square fa-stack-1x fa-terminal fa-inverse: :fa-lg fa-stack-1x fa-camera
fa-stack-2x fa-ban text-red:
```

And renders as HTML and console output:

![html](src/doc/signs-fontawesome.png) ![html](src/doc/signs-fontawesome.console.png)

In text and console output only the icons are kept in a compressed format. All modulations
are removed.

### Table

Output a table (data object and optional column object needed). This can be called
with different kind of objects making it easy to use nearly everything you have.

    Syntax: report.table <object>, <columns>, <sort>, <mask>

The complexest format will be shown at first:

    <object>  : a list of row maps like returned from a database
    <columns> : a map of column id to use as columns with the options:
                - title - heading text
                - align - orientation (one of 'left', 'center', 'right')
                - width - the minimum width of the column (optional)
    <sort>    : a map of sort conditions defining the column id and order ('asc', 'desc')
    <mask>    : (boolean) use Report.mask() on each field value

All other formats will be converted into this filling missing information with
default values. You may also use the [table](http://alinex.github.io/node.table)
format which can include the column settings and often is already sorted.

There are lots of ways to use this.

#### from alinex-table

__Simple conversion__

``` coffee
table = new Table [
  ['ID', 'English', 'German']
  [1, 'one', 'eins']
  [2, 'two', 'zw_ei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
]

report = new Report()
report.table table
```

``` markdown
| ID | English | German |
|:-- |:------- |:------ |
| 1  | one     | eins   |
| 2  | two     | zw_ei  |
| 3  | three   | drei   |
| 12 | twelve  | zwölf  |
```

And renders as HTML and console output:

![html](src/doc/table-alinex.png) ![console](src/doc/table-alinex.console.png)

__With align settings__

``` coffee
table = new Table [
  ['ID', 'English', 'German']
  [1, 'one', 'eins']
  [2, 'two', 'zw_ei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
]
table.style null, 'ID', {align: 'right'}

report = new Report()
report.table table
```

``` markdown
| ID | English | German |
| --:|:------- |:------ |
|  1 | one     | eins   |
|  2 | two     | zw_ei  |
|  3 | three   | drei   |
| 12 | twelve  | zwölf  |
```

And renders as HTML and console output:

![html](src/doc/table-alinex-align.png) ![console](src/doc/table-alinex-align.console.png)

__With mask settings__

``` coffee
table = new Table [
  ['ID', 'English', 'German']
  [1, 'one', 'eins']
  [2, 'two', 'zw_ei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
]

report = new Report()
report.table table, null, null, true
```

``` markdown
| ID | English | German |
|:-- |:------- |:------ |
| 1  | one     | eins   |
| 2  | two     | zw\_ei |
| 3  | three   | drei   |
| 12 | twelve  | zwölf  |
```

And renders as HTML:

![html](src/doc/table-alinex-mask.png)

#### with list-map

__Using column map-map__

``` coffee
table = [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
]
columns =
  id:
    title: 'ID'
    align: 'right'
  de:
    title: 'German'
  en:
    title: 'English'

report = new Report()
report.table table, columns
```

``` markdown
| ID | German | English |
| --:|:------ |:------- |
|  1 | eins   | one     |
|  2 | zwei   | two     |
|  3 | drei   | three   |
| 12 | zwölf  | twelve  |
```

And renders as HTML and console output:

![html](src/doc/table-list-map.png) ![console](src/doc/table-list-map.console.png)

__Using column list-map__

``` coffee
table = [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
]
columns = [
  ['id', 'en']
  ['ID', 'English']
]

report = new Report()
report.table table, columns
```

``` markdown
| ID | English |
|:-- |:------- |
| 1  | one     |
| 2  | two     |
| 3  | three   |
| 12 | twelve  |
```

And renders as HTML:

![html](src/doc/table-list-map-column-list-array.png)

__Using column list__

``` coffee
table = [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
]
columns = ['ID', 'English', 'German']

report = new Report()
report.table table, columns
```

``` markdown
| ID | English | German |
|:-- |:------- |:------ |
| 1  | one     | eins   |
| 2  | two     | zwei   |
| 3  | three   | drei   |
| 12 | twelve  | zwölf  |
```

And renders as HTML:

![html](src/doc/table-list-map-column-list.png)

__Using column map__

``` coffee
table = [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
]
columns =
  id: 'ID'
  en: 'English'

report = new Report()
report.table table, columns
```

``` markdown
| ID | English |
|:-- |:------- |
| 1  | one     |
| 2  | two     |
| 3  | three   |
| 12 | twelve  |
```

And renders as HTML:

![html](src/doc/table-list-map-column-map.png)

__Using sort map__

``` coffee
table = [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
]
columns =
  id:
    title: 'ID'
    align: 'right'
  de:
    title: 'German'
  en:
    title: 'English'
sort = {de: 'desc'}

report = new Report()
report.table table, columns, sort
```

``` markdown
| ID | German | English |
| --:|:------ |:------- |
| 12 | zwölf  | twelve  |
|  2 | zwei   | two     |
|  1 | eins   | one     |
|  3 | drei   | three   |
```

And renders as HTML:

![html](src/doc/table-list-map-sort-map.png)

__Using sort list__

``` coffee
table = [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
]
columns =
  id:
    title: 'ID'
    align: 'right'
  de:
    title: 'German'
  en:
    title: 'English'
sort = ['de']

report = new Report()
report.table table, columns, sort
```

``` markdown
| ID | German | English |
| --:|:------ |:------- |
|  3 | drei   | three   |
|  1 | eins   | one     |
|  2 | zwei   | two     |
| 12 | zwölf  | twelve  |
```

And renders as HTM:

![html](src/doc/table-list-map-sort-list.png)

__Using sort key__

``` coffee
table = [
  {id: 1, en: 'one', de: 'eins'}
  {id: 2, en: 'two', de: 'zwei'}
  {id: 3, en: 'three', de: 'drei'}
  {id: 12, en: 'twelve', de: 'zwölf'}
]
columns =
  id:
    title: 'ID'
    align: 'right'
  de:
    title: 'German'
  en:
    title: 'English'
sort = 'de'

report = new Report()
report.table table, columns, sort
```

``` markdown
| ID | German | English |
| --:|:------ |:------- |
|  3 | drei   | three   |
|  1 | eins   | one     |
|  2 | zwei   | two     |
| 12 | zwölf  | twelve  |
```

And renders as HTML:

![html](src/doc/table-list-map-sort-key.png)




#### with list array

#### with map

__With align settings__

``` coffee
table = new Table [
  ['ID', 'English', 'German']
  [1, 'one', 'eins']
  [2, 'two', 'zw_ei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
]
report = new Report()
report.table table
```

``` markdown
```

And renders as HTML and console output:

![html](src/doc/table-alinex-align.png) ![console](src/doc/table-alinex-align.console.png)



__With align settings__

``` coffee
table = new Table [
  ['ID', 'English', 'German']
  [1, 'one', 'eins']
  [2, 'two', 'zw_ei']
  [3, 'three', 'drei']
  [12, 'twelve', 'zwölf']
]
report = new Report()
report.table table
```

``` markdown
```

And renders as HTML and console output:

![html](src/doc/table-alinex-align.png) ![console](src/doc/table-alinex-align.console.png)

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

- toc - add a table of contents entry (visible only after rendering)

``` coffee
report = new Report()
report.toc()
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

### Code Visualization

This will only work in HTML format, else the definition is displayed.

#### QR Code

__[QR Simple](http://htmlpreview.github.io/?https://github.com/alinex/node-report/blob/master/src/doc/visual-qr-simple.html)__

``` coffee
report = new Report()
report.qr "http://alinex.de"
```

Or if you want to specify the parameters:

__[QR Extended](http://htmlpreview.github.io/?https://github.com/alinex/node-report/blob/master/src/doc/visual-qr-extended.html)__

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
```

#### Charts

A lot of charts are possible based on [jui-chart](http://chartplay.jui.io/).
You'll find all possible settings there.

__[Simple Chart](http://htmlpreview.github.io/?https://github.com/alinex/node-report/blob/master/src/doc/visual-chart-simple.html)__

``` coffee
report = new Report()
report.chart null, [
  ['quarter', 'sales', 'profit']
  ["1Q", 50, 35]
  ["2Q", -20, -100]
  ["3Q", 10, -5]
  ["4Q", 30, 25]
]
```

This makes a simple bar chart with predefined settings for your data. But you may
also specify a lot of options and charts. The examples below shows the possible
settings, but you only need to give some of them.

__[Column Chart](http://htmlpreview.github.io/?https://github.com/alinex/node-report/blob/master/src/doc/visual-chart-column.html)__

``` coffee
report = new Report()
report.chart
  width: 800
  height: 400
  theme: 'dark'
  axis:
    padding:
      left: 5
      top: 10
    area:
      width: '80%'
      x: '10%'
    x:
      type: 'block'
      domain: "quarter"
      line: true
    y:
      type: range
      domain: [-120, 120]
      step: 10
      line: true
      orient: 'right'
  brush:
    - type: "column"
      target: ["sales", "profit"]
    - type: "focus"
      start: 1
      end: 1
  widget:
    - type: "title"
      text: "Column Chart"
    - type: "tooltip"
    - type: "legend"
, [
  ['quarter', 'sales', 'profit']
  ["1Q", 50, 35]
  ["2Q", -20, -100]
  ["3Q", 10, -5]
  ["4Q", 30, 25]
]
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




### Typographic Replacements

Some special typographic elements will automatically be converted into their specific
character:

    (c) (C) (r) (R) (tm) (TM) (p) (P) +-

    test... test..... test?..... test!....

    -- ---

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

### Footnotes

Like links, Images also have a footnote style syntax

    ![Alt text][id]

With a reference later in the document defining the URL location:

    [id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"

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

### Table of Contents
The following code will add an table of contents in some output types.

    @[toc]

### Specific Style

For html and, pdf and image output a specific style can be set. This belongs to
the element atrated in front of the style definition.

    <!-- {color:red} -->

    <!-- {p:.center} -->

    <!-- {#table1 .tlist} -->

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

#### Charts

A lot of charts are possible. To make them you have to include a markdown tag with
two parts:

- the display setup data
- the table to visualize

    $$$ chart
    width: 600
    height: 400
    axis:
      x:
        type: "block"
        domain: "quarter"
        line: true
      y:
        type: "range"
        line: true,
    brush:
      type: "column"
      target: ["sales", "profit"]

    | quarter | sales | profit |
    | ------- | ----- | ------ |
    | 1Q      | 50    | 35     |
    | 2Q      | -20   | -100   |
    | 3Q      | 10    | -5     |
    | 4Q      | 30    | 25     |
    $$$

This is based on [jui-chart](http://chartplay.jui.io/) so look there for the possible
setup. Or see the other examples above in the Report Builder description.


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
