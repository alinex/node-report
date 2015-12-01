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
- export as html

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

The first step is to create a new object:

``` coffee
Report = require 'alinex-report'

report = new Report()
```

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
html = report.toHtml()
```

Instead of creating a report you can also let this module convert single elements
on the fly:

``` coffee
console.log Report.ul ['one', 'two', 'three']
console.log Report.p "This text contains a #{Result.b 'bold'} word."
```


Formatter
-------------------------------------------------
The following methods are available:

### headings

- h1 - heading level 1
- h2 - heading level 2
- h3 - heading level 3
- h4 - heading level 4
- h5 - heading level 5
- h6 - heading level 6

### inline

These are only available on static calls not on a report instance!

- b - bold
- i - italic
- del - delete
- tt - typewriter
- link - create a link
- img - add an image
- footnote - add a footnode

### paragraphs

p - add a text paragraph
hr - add a horizontal rule as separation
quote - add quoted text multiple level depth (second parameter)
code - add a code block (language as additional parameter)
abbrv - add an abreviation entry (after the text)

### lists

ul - unordered list from array
ol - ordered list from array
dl - definitiuon list from object

### table

Output a table (data object and optional column object needed)

The column object should contain the keys of the columns to output with:

- title
- orientation



License
-------------------------------------------------

Copyright 2015 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
