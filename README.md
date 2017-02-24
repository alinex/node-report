Alinex Report: Readme
=================================================

[![GitHub watchers](
  https://img.shields.io/github/watchers/alinex/node-report.svg?style=social&label=Watch&maxAge=2592000)](
  https://github.com/alinex/node-report/subscription)
<!-- {.hidden-small} -->
[![GitHub stars](
  https://img.shields.io/github/stars/alinex/node-report.svg?style=social&label=Star&maxAge=2592000)](
  https://github.com/alinex/node-report)
[![GitHub forks](
  https://img.shields.io/github/forks/alinex/node-report.svg?style=social&label=Fork&maxAge=2592000)](
  https://github.com/alinex/node-report)
<!-- {.hidden-small} -->
<!-- {p:.right} -->

[![npm package](
  https://img.shields.io/npm/v/alinex-table.svg?maxAge=2592000&label=latest%20version)](
  https://www.npmjs.com/package/alinex-table)
[![latest version](
  https://img.shields.io/npm/l/alinex-table.svg?maxAge=2592000)](#license)
<!-- {.hidden-small} -->
[![Travis status](
  https://img.shields.io/travis/alinex/node-report.svg?maxAge=2592000&label=develop)](
  https://travis-ci.org/alinex/node-report)
[![Coveralls status](
  https://img.shields.io/coveralls/alinex/node-report.svg?maxAge=2592000)](
  https://coveralls.io/r/alinex/node-report?branch=master)
[![Gemnasium status](
  https://img.shields.io/gemnasium/alinex/node-report.svg?maxAge=2592000)](
  https://gemnasium.com/alinex/node-report)
[![GitHub issues](
  https://img.shields.io/github/issues/alinex/node-report.svg?maxAge=2592000)](
  https://github.com/alinex/node-report/issues)
<!-- {.hidden-small} -->


This report module should help you create complex reports in an easy
way. You create a new object and append different text objects step by step. At last
you may access the markdown text or get it converted to HTML and other formats.

The key features are:

- easy writing using API, markdown or AsciiDoc
- feature rich markdown implementation
- export as text, console, HTML (also optimized for email), PDF, PNG and more
- convert text to visual representation like qr, chart or UML
- optimized interactive elements in HTML output
- configurable/themeable output

See example output within the different element descriptions below.

The report package is not another markdown to HTML converter like {@link markdown-it}
and the others but a tool to do the same with support for more formats and already
included plugins. This means you won't need to search for individual plugins which
often works only partly as good as the core but have all ready to use.

Internally the report module will create a common element structure out of all given
input formats using some of the existing parsers. This may be transformed into a lot
of output formats and all steps are based on rules which may be easily extended
and maintained.

The [Documentation of this module](https://alinex.github.io/node-report) itself
uses the `alinex-report` module to generate the html pages.

> It is one of the modules of the [Alinex Namespace](https://alinex.github.io/code.html)
> following the code standards defined in the [General Docs](https://alinex.github.io/develop).

__Read the complete documentation under
[https://alinex.github.io/node-report](https://alinex.github.io/node-report).__
<!-- {p: .hidden} -->


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

This package will install a lot of sub packages to ensure the full functionality
but only the ones really needed are loaded on demand.

Always have a look at the latest [changes](Changelog.md).


Usage
-------------------------------------------------

The first step is to load the module and initialize it:

``` coffee
Report = require 'alinex-report'
Report.init ->
  # go on
```

Because it uses the {@link alinex-config} module you may use the `setup()` and
`init()` methods the same way.

And now you create a new object:

``` coffee
report = new Report()
```

The next part is to create the report by loading it with a markdown document or
creating the content with the different Builder methods. Both may be combined:

``` coffee
# load from markdown
report.markdown 'My **markdown** is ok.'

# add using builder methods with content
report.h1 'heading'
# using builder with open and close calls (`true`/`false`)
report.p true
.text 'This '
.bold true
.text 'is bold'
.bold false
.p false
# or at last you may concat reports into one
inline = new Report()
inline.bold 'is bold'
report.concat inline
```

After creating the report you may format it in multiple different output formats
and get it's content or write it to file:

``` coffee
report.format 'md',
  type: 'markdown'
, (err, result) =>
  report.output 'md' # same as result
  report.toFile 'md', 'test.md', (err) ->
```


Output Examples
-------------------------------------------------
Coming soon...


License
-------------------------------------------------

(C) Copyright 2016-2017 Alexander Schilling

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

>  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
