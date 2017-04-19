Version changes
=================================================

The following list gives a short overview about what is changed between
individual versions:

Version 3.0.0 (2017-04-19)
-------------------------------------------------
Complete rewrite of API and formatter.

- Revert version number.
- Fix typographic replacement.
- Make message about not able to highlighting a debug warning.
- Fix highlighting of multiline comments in html.
- Replace typographic currency with own implementation.
- Fox for missing toc settings.
- Make typographic setting selectable.
- Fix example name.
- Make all code display bold in default style.
- Allow setting start level for toc through config.
- Fix display of pre and code.
- Allow styles to be defined as object.
- Rename container class to box-container because of name conflict with bootstrap.
- Fix word break.
- Merge branch 'master' of https://github.com/alinex/node-report
- Add raw test.
- Inline raw html without newlines arround.
- Enhance spacing before level 1+2 heading in markdown to two lines.
- Added information for version 3.0.0
- Remove clean-css.
- Update some packages.
- Cache loaded and setup styles.
- Remove examples from npm package.
- Optimized and fixed style inclusion to include every one once.
- Fix segmentation fault in report by explicitly calling the callback.
- Remove unneccessary line.
- Fix inclusion of local html styles.
- Optimize formatter call.
- Updated inline docs.
- Add automatic read from file.
- Disable fuzzy linkify.
- Fix output format access.
- Fix lint errors.
- Fix format error.
- Update search for api methods.
- Add navigation methods to api.
- Update  async@2.1.5, debug@2.6.3, twemoji@2.2.5, highlight.js@9.10.0, markdown-it@8.3.1, moment@2.18.1, clean-css@4.0.9, mermaid@7.0.0, memoizee@0.4.4
- Allow title setting throughz style.
- Add support for toc.
- Completed typograph test and examples.
- Add typographic replacements and language specification using styles.
- Add support for mark, insert, sub and sup formatting.
- Added auto create element for include.
- Simple includes working.
- Finished boxes implementation.
- Added api for boxes.
- Finish html layout for simple boxes.
- Allow multibox in console and text output.
- Add heading anchor check.
- Smaller fixes to make all tests work again.
- Add formatter for text boxes.
- Begin text and html formatter.
- Implement markdown parsing and formatting of boxes.
- Start new plugin for box.
- Support kramdown style syntax.
- Add api for definition list.
- Add container markdown parsing.
- Add output formats for definition list.
- Implement markdown for definition lists.
- Fix target depth in html style.
- Add styles for html decoration.
- Fixed html markdown test to support new comment elements.
- Add more list api tests.
- Completed html, md, text, console outputs for basic elements.
- Fixed output of task lists.
- Make test for html list layout.
- Add more examples.
- Optimize fixed html output.
- Add more highlighting examples.
- Add highlighting to console output.
- Test pdf export.
- Add more examples of html code highlighting.
- Small fixes.
- Add syntax highlighting for code blocks.
- More examples blockquote.
- Add html2png conversion.
- Add stylesheets to html output.
- Add plugin for gfm tasklists.
- Finish table API with tests.
- Implement api for alinex-table.
- Finish html, text and console output for table.
- Add more colors to console output.
- Implement ansi escapes.
- Allow escaped pipe in table.
- Add strikethrough implementation.
- Api for raw, link and image.
- Support keep breaks (softbreak) setting in html output.
- Allow switch to use references on markdown output.
- All commonmark tests added.
- Add tests for linebreaks.
- More tests for autolink and inline html.
- More tests.
- Complete all element tests.
- Add more text escape tests.
- Merge branch 'v3' of https://github.com/alinex/node-report into v3
- Add image markdown tests.
- Complete link tests.
- Complete tests for html blocks.
- Added html tag transforming from/to markdown.
- Complete link markdown tests.
- Fix formatting of image and link also if nested.
- Some more link tests ans initial image parser implementation.
- Implement links in markdown.
- Finished markdown emphasis tests.
- More emphasis tests.
- Some emphasis/strong tests.
- Optimize API and add fixed().
- Optimize masking of characters.
- Finish list tests.
- Implement loose and tight lists with more tokenlist elements.
- Support tight list parsing and writting.
- A lot more list tests.
- Start list tests.
- Add tests for text (tabs).
- Update all blockquote tests.
- Add tests for paragraph.
- Fix set after close of token.
- Small fixes in man conversion of code and preformatted.
- Added markdown parsing tests for fixed.
- Run all current tests.
- Only rtrim newlines in preformatted text.
- Complete thematic break tests.
- Start tests for thematic break.
- Work with complete heading api.
- Set marker on api close of heading.
- Heading with API in one step.
- First heading API tests with new structure.
- Support more heading specifica.
- Add support for preformatted, softbreak and hardbreak.
- Fix duplicate masking of # to prevent heading.
- First tests to pass reparse check with markdown.
- Integrate parsing through markdown-it into own tokenlist.
- redesign.
- Next redesign phase started.
- Some more tests.
- Small fix.
- Made all current tests pass.
- Redesign with some running tests.
- Redesign emphasis rules.
- Allow inner marker in underscore.
- Some more tests.
- First tests for strong.
- Completed fixed style tests.
- First tests for fixed style.
- Finished code tests.
- More tests for code blocks.
- Closing code block at end of document automatically.
- Enable language definition in code tags and alias through config.
- Change code parser.
- New element code added.
- Simplified list RegExp.
- Added more tests for lists.
- Add more list tests.
- Add some fixes for lists.
- Add more tests for lists.
- Run all tests for blockquotes.
- Fix some more blockquote problems with lazyness.
- Add some blockquote tests.
- More debug output in formatter.
- Optimize token list display in test.
- Complete tests for preformatted.
- Blank lines won't break current predefined section.
- Add moment.js package.
- Add more roff formatters.
- Add more tests for preformatted text.
- Run first tests for preformatted text.
- Trim text output.
- Fix output for formats without page header and footer.
- update todo list
- Update documentation.
- Complete thematic break tests.
- Run all commonmark examples for headings.
- Allow relative paths in include.
- Basic implementation of includes.
- Add anchor to headings for direct call within links.
- Fixed list to work with list -> item -> paragraph -> text.
- Add rudimentary list support.
- Added basic blockquote support.
- Made all current tests working again.
- Use post formatters and collect in reverse order (deepest first).
- Prepare new formatter step with post rules.
- Added todo overview.
- Fixes found out by more tests.
- Add more tests for text element.
- Optimize autoclose to throw error if specified.
- Improve autoclose to include into heading api.
- Restructure API into multiple files.
- Remove possibility to show current parsing position because not possible if includes are used.
- Restructure for new preformatted element.
- Change graphical overview.
- Change for better html output.
- Updated overview graphics for documentation.
- Added paragraph tests.
- Restructure API coding.
- Update tests for thematic breaks.
- Completed heading tests excluding ones depending on other elements.
- Run all commonmark examples for atx headings in test.
- More tests for heading rewritten.
- Support format in headings.
- Also allow document header/footer in text output per config.
- Support templates for the html output in configuration.
- Finished toFile() method.
- Heading passing more tests again and new format element implementation.
- Move old files away and fix lint errors.
- Upgrade clean-css@3.4.23, debug@2.6.0, highlight.js@9.9.0, alinex-builder@2.4.1
- Changed heading tests.
- Added element test for heading 2-6.
- Add format support table to documentation.
- Add extension to formatter setting as default file extension.
- Add support for rtf output.
- Add pre formatter run.
- Add pre run to formatter to detect title.
- Add tests for api creation.
- Add title to html.
- Add output for man pages.
- Add text formating output.
- Cleanup src directory.
- Add configuration to formatters.
- Run formatter through tests and create examples.
- Create structure for formatter.
- Completely working again.
- Better debugging.
- More tests for setext heading.
- Fully support paragraph parsing.
- Simplify check conditions in test tool.
- Fixed parsing of headings.
- Support laiy block continuing.
- Support full ATX headings from commonmark.
- Add first post processing rule tp parser.
- Parse markdown with thematic_break and ATX heading.
- Reenable parsing with new structure.
- Done implementing parser pre optimizations.
- Merge branch 'v3' of https://github.com/alinex/node-report into v3
- Restructure project to make it more modular.
- Add initial transformer.
- Support domain in state and document tokens.
- Add graph of lexer states.
- Add cleanup rules, run before parsing.
- Implement autoclose and added first automatic tests.
- Optimized debugging output and added code comments.
- Parsing with different state.
- Throw error message on parse problems.
- Merge branch 'v3' of https://github.com/alinex/node-report into v3
- Basic parser.
- Initial lexer test.
- Added information for version 2.2.2
- Fixed test for title in table of contents.
- Remove empty lines from handlebars templates.
- Update phantomjs-prebuilt@2.1.14
- Fixed: Tables were being removed in the process of putting boxes into tabs.
- Optimize table of contents display and box titles.
- Smaller fixes in html style.
- Added information for version 2.2.1
- Bug fix include of trans submodule.
- Add documentation of themes.
- Fix links of general examples.

Version 3.0.0 (2017-04-07)
-------------------------------------------------
New major realease with completely changed internal structure and some special features missing.

- Remove clean-css.
- Update some packages.
- Cache loaded and setup styles.
- Remove examples from npm package.
- Optimized and fixed style inclusion to include every one once.
- Fix segmentation fault in report by explicitly calling the callback.
- Remove unneccessary line.
- Fix inclusion of local html styles.
- Optimize formatter call.
- Updated inline docs.
- Add automatic read from file.
- Disable fuzzy linkify.
- Fix output format access.
- Fix lint errors.
- Fix format error.
- Update search for api methods.
- Add navigation methods to api.
- Update  async@2.1.5, debug@2.6.3, twemoji@2.2.5, highlight.js@9.10.0, markdown-it@8.3.1, moment@2.18.1, clean-css@4.0.9, mermaid@7.0.0, memoizee@0.4.4
- Allow title setting throughz style.
- Add support for toc.
- Completed typograph test and examples.
- Add typographic replacements and language specification using styles.
- Add support for mark, insert, sub and sup formatting.
- Added auto create element for include.
- Simple includes working.
- Finished boxes implementation.
- Added api for boxes.
- Finish html layout for simple boxes.
- Allow multibox in console and text output.
- Add heading anchor check.
- Smaller fixes to make all tests work again.
- Add formatter for text boxes.
- Begin text and html formatter.
- Implement markdown parsing and formatting of boxes.
- Start new plugin for box.
- Support kramdown style syntax.
- Add api for definition list.
- Add container markdown parsing.
- Add output formats for definition list.
- Implement markdown for definition lists.
- Fix target depth in html style.
- Add styles for html decoration.
- Fixed html markdown test to support new comment elements.
- Add more list api tests.
- Completed html, md, text, console outputs for basic elements.
- Fixed output of task lists.
- Make test for html list layout.
- Add more examples.
- Optimize fixed html output.
- Add more highlighting examples.
- Add highlighting to console output.
- Test pdf export.
- Add more examples of html code highlighting.
- Small fixes.
- Add syntax highlighting for code blocks.
- More examples blockquote.
- Add html2png conversion.
- Add stylesheets to html output.
- Add plugin for gfm tasklists.
- Finish table API with tests.
- Implement api for alinex-table.
- Finish html, text and console output for table.
- Add more colors to console output.
- Implement ansi escapes.
- Allow escaped pipe in table.
- Add strikethrough implementation.
- Api for raw, link and image.
- Support keep breaks (softbreak) setting in html output.
- Allow switch to use references on markdown output.
- All commonmark tests added.
- Add tests for linebreaks.
- More tests for autolink and inline html.
- More tests.
- Complete all element tests.
- Add more text escape tests.
- Merge branch 'v3' of https://github.com/alinex/node-report into v3
- Add image markdown tests.
- Complete link tests.
- Complete tests for html blocks.
- Added html tag transforming from/to markdown.
- Complete link markdown tests.
- Fix formatting of image and link also if nested.
- Some more link tests ans initial image parser implementation.
- Implement links in markdown.
- Finished markdown emphasis tests.
- More emphasis tests.
- Some emphasis/strong tests.
- Optimize API and add fixed().
- Optimize masking of characters.
- Finish list tests.
- Implement loose and tight lists with more tokenlist elements.
- Support tight list parsing and writting.
- A lot more list tests.
- Start list tests.
- Add tests for text (tabs).
- Update all blockquote tests.
- Add tests for paragraph.
- Fix set after close of token.
- Small fixes in man conversion of code and preformatted.
- Added markdown parsing tests for fixed.
- Run all current tests.
- Only rtrim newlines in preformatted text.
- Complete thematic break tests.
- Start tests for thematic break.
- Work with complete heading api.
- Set marker on api close of heading.
- Heading with API in one step.
- First heading API tests with new structure.
- Support more heading specifica.
- Add support for preformatted, softbreak and hardbreak.
- Fix duplicate masking of # to prevent heading.
- First tests to pass reparse check with markdown.
- Integrate parsing through markdown-it into own tokenlist.
- redesign.
- Next redesign phase started.
- Some more tests.
- Small fix.
- Made all current tests pass.
- Redesign with some running tests.
- Redesign emphasis rules.
- Allow inner marker in underscore.
- Some more tests.
- First tests for strong.
- Completed fixed style tests.
- First tests for fixed style.
- Finished code tests.
- More tests for code blocks.
- Closing code block at end of document automatically.
- Enable language definition in code tags and alias through config.
- Change code parser.
- New element code added.
- Simplified list RegExp.
- Added more tests for lists.
- Add more list tests.
- Add some fixes for lists.
- Add more tests for lists.
- Run all tests for blockquotes.
- Fix some more blockquote problems with lazyness.
- Add some blockquote tests.
- More debug output in formatter.
- Optimize token list display in test.
- Complete tests for preformatted.
- Blank lines won't break current predefined section.
- Add moment.js package.
- Add more roff formatters.
- Add more tests for preformatted text.
- Run first tests for preformatted text.
- Trim text output.
- Fix output for formats without page header and footer.
- update todo list
- Update documentation.
- Complete thematic break tests.
- Run all commonmark examples for headings.
- Allow relative paths in include.
- Basic implementation of includes.
- Add anchor to headings for direct call within links.
- Fixed list to work with list -> item -> paragraph -> text.
- Add rudimentary list support.
- Added basic blockquote support.
- Made all current tests working again.
- Use post formatters and collect in reverse order (deepest first).
- Prepare new formatter step with post rules.
- Added todo overview.
- Fixes found out by more tests.
- Add more tests for text element.
- Optimize autoclose to throw error if specified.
- Improve autoclose to include into heading api.
- Restructure API into multiple files.
- Remove possibility to show current parsing position because not possible if includes are used.
- Restructure for new preformatted element.
- Change graphical overview.
- Change for better html output.
- Updated overview graphics for documentation.
- Added paragraph tests.
- Restructure API coding.
- Update tests for thematic breaks.
- Completed heading tests excluding ones depending on other elements.
- Run all commonmark examples for atx headings in test.
- More tests for heading rewritten.
- Support format in headings.
- Also allow document header/footer in text output per config.
- Support templates for the html output in configuration.
- Finished toFile() method.
- Heading passing more tests again and new format element implementation.
- Move old files away and fix lint errors.
- Upgrade clean-css@3.4.23, debug@2.6.0, highlight.js@9.9.0, alinex-builder@2.4.1
- Changed heading tests.
- Added element test for heading 2-6.
- Add format support table to documentation.
- Add extension to formatter setting as default file extension.
- Add support for rtf output.
- Add pre formatter run.
- Add pre run to formatter to detect title.
- Add tests for api creation.
- Add title to html.
- Add output for man pages.
- Add text formating output.
- Cleanup src directory.
- Add configuration to formatters.
- Run formatter through tests and create examples.
- Create structure for formatter.
- Completely working again.
- Better debugging.
- More tests for setext heading.
- Fully support paragraph parsing.
- Simplify check conditions in test tool.
- Fixed parsing of headings.
- Support laiy block continuing.
- Support full ATX headings from commonmark.
- Add first post processing rule tp parser.
- Parse markdown with thematic_break and ATX heading.
- Reenable parsing with new structure.
- Done implementing parser pre optimizations.
- Merge branch 'v3' of https://github.com/alinex/node-report into v3
- Restructure project to make it more modular.
- Add initial transformer.
- Support domain in state and document tokens.
- Add graph of lexer states.
- Add cleanup rules, run before parsing.
- Implement autoclose and added first automatic tests.
- Optimized debugging output and added code comments.
- Parsing with different state.
- Throw error message on parse problems.
- Merge branch 'v3' of https://github.com/alinex/node-report into v3
- Basic parser.
- Initial lexer test.

Version 2.2.2 (2016-12-10)
-------------------------------------------------
- Fixed test for title in table of contents.
- Remove empty lines from handlebars templates.
- Update phantomjs-prebuilt@2.1.14
- Fixed: Tables were being removed in the process of putting boxes into tabs.
- Optimize table of contents display and box titles.
- Smaller fixes in html style.

Version 2.2.1 (2016-12-08)
-------------------------------------------------
- Bug fix include of trans submodule.
- Add documentation of themes.
- Fix links of general examples.

Version 2.2.0 (2016-12-08)
-------------------------------------------------
Boxes will stack together as tabbed box.

- Allow longer runtime for plantuml.
- Remove support for nodejs 0.10 because submodules no longer support it.
- Fix tests to work with variing html.
- Add top link in table of contents.
- Allow all tests to run again.
- Add implementation of output specific parts.
- Allow initialization with markdown.
- Remove unneccessary parts from documentation.
- Set default height for boxes to 300px.
- Added examples for tables within boxes.
- Finished code in boxes examples.
- Fix console output for boxed code.
- Colorize code tabs.
- Change html for code in boxes.
- Added tests for all box possibilities.
- Update async@2.1.4, clean-css@3.4.21, handlebars@4.0.6, alinex-util@2.5.0, debug@2.3.3, highlight.js@9.8.0, markdown-it@8.2.1, deasync@0.1.9
- Meke test for simple boxes.
- Inline document some more functions.
- Optimize console output of boxes.
- Extract translations into extra file.
- Finish box layout with tabs for html.
- Add color style to default boxes.
- Add print layout for boxes.
- Add simple tab css and upgrade fontawesome to 4.7.0
- Update npm markdown-it@8.2.1
- Change box transformation to create propper html for tabbed boxes.
- Transform box to tabs html structure.
- Merge branch 'master' of https://github.com/alinex/node-report
- Description of new code and box elements.
- Add testlayout for new box model.
- Add info for documentation which is created using the module itself.
- Fix blockquote nesting.
- Update style for boxes and more.
- Add example for stacked quotes.
- Optimize style of blockquotes.
- Create new documentation examples.
- Updated documentation.
- Remove unused style.
- Add header to detail box and optimize console output of boxes.
- Update alinex-fs@3.0.3 markdown-it@8.1.0 markdown-it-attrs@0.8.0 node-plantuml@0.5.0
- Create debug messages only if enabled.

Version 2.1.12 (2016-10-19)
-------------------------------------------------
- Remove line breaks before html comments for rendering.
- Describe github comment handling.
- Updated ignore files.
- Update travis.
- Update travis.

Version 2.1.11 (2016-08-18)
-------------------------------------------------
- Update html-pdf@2.1.0
- Fix test to allow slightly change of footnotes.
- Update markdown-it-attrs@0.6.3
- Update alinex-fs@2.0.7, markdown-it@7.0.1, markdown-it-footnote@3.0.1, phantomjs-prebuilt@2.1.12, alinex-builder@2.3.6, alinex-util@2.4.0, highlight.js@9.6.0
- Downgrade markdown-it to 6.1.0 because of markdown-it-attr dependency.
- Add support for alternative box titles.

Version 2.1.10 (2016-08-02)
-------------------------------------------------
- Upgraded to phantomjs-prebuilt@2.1.9.
- Allow direct styles through api.
- Allow direct styles in each elements using curly braces.

Version 2.1.9 (2016-07-25)
-------------------------------------------------
- Support includes in handlebar templates.
- Allow handlebar template includes.

Version 2.1.8 (2016-07-21)
-------------------------------------------------
- Correct line number positioning to block before not at start.

Version 2.1.7 (2016-07-21)
-------------------------------------------------
- Upgrade alinex-fs@2.0.6, alinex-builder@2.3.1
- fix decorator problem for code elements

Version 2.1.6 (2016-07-19)
-------------------------------------------------
- Remove unneccessary modules.
- Add header to table of contents.

Version 2.1.5 (2016-07-19)
-------------------------------------------------
- Fix test for new code block structure.
- Update all language formats.
- Keep multiline code highliting intact.
- Add support for stylus and css.
- Move local links to codedoc.
- Better javascript and local link support.

Version 2.1.4 (2016-07-15)
-------------------------------------------------
- Fixed style links.

Version 2.1.3 (2016-07-15)
-------------------------------------------------
- Fixed style links.

Version 2.1.2 (2016-07-15)
-------------------------------------------------
- Updated test to work with new html structure.
- Allow style on code tag be transported to pre tag before.
- Rename links to Alinex Namespace.
- Move codedoc template into it's own package.
- Fix extraction of title with starting alternative heading.
- Optimize Style.
- Update style for codedoc sidebar.
- Upgraded alinex-handlebars@1.2.1, alinex-builder@2.2.1, async@2.0.0
- Show file tree from context in handlebars template for codedoc.
- Add getReport method.
- Add files from context.
- Allow additional context for handlebars.

Version 2.1.1 (2016-07-12)
-------------------------------------------------
- Add inline styles for codedoc schema.
- Finish responsive top buttons.
- Create bootstrap layout for codedoc.
- Make own codedoc layout.

Version 2.1.0 (2016-07-11)
-------------------------------------------------
- Upgradet alinex-fs@2.0.3, alinex-util@2.3.1, alinex-builder@2.2.0
- Support handlebars for styles.
- Make handlebars template working.
- Use template search for css and handlebars.
- Add addintional style.
- Small code updates.

Version 2.0.0 (2016-06-30)
-------------------------------------------------
Now with support for multiple graphical visualization, restructered documentation and more.

- Define mermaid as required binary package.
- Fix check to work with new footnote anchors.
- Add current version id to style link for CDN.
- Add mermaid to depending packages.
- Only create examples on test if environment setting.
- Update markdown-it-footnotes.
- Add toFile() method.
- Fix code in toText() and toConsole() for better output.
- Test text and console conversion.
- Finished mermaid includion using cli calls.
- Added all mermaid diagrams, but not working correctly, at the moment.
- Add report styles and jui through CDN.
- Allow text display of mermaid graph as code.
- Try to get phantom error on webshot.
- Add mermaid support for html but problem in image conversion.
- Add examples of bar, column and area charts.
- Use js code in charts or png images for noJS option.
- Make all tests run again.
- Add example with all features of datatable.
- Add support for datatable.
- Fix plantuml sequence conversion to text.
- Added support for plantuml syntax.
- Upgraded markdown-it package and optimized chart markdown.
- Fixed box style and compress css style and rules in html.
- Optimize ability to convert to image.
- Add simple chart example.
- Fix qr code parser to use yaml as default.
- Added qr visualization support also in console and text output.
- Document header() method.
- Add support for javascript and stylesheets through execute plugin.
- changes for js collection
- Allow js and css methods to become markdown.
- Fix use of decorade styles.
- Reformat docs for styles and javascript.
- Update docs for document elements.
- Finish table documentation with examples.
- Upgraded markdown-it and builder packages.
- Document tale with list-map.
- Upgrade docu for alinex tables.
- Add console output images.
- Optimize stacked icons parsing.
- Add own fontawesome plugin to allow stackable and combinded signs.
- Update docs for lists, links, images and signs.
- Restructure tests and documentation.
- Add more language support for code highlighting.
- Fix bug in setting width (instance calls).
- Update docs.
- Upgrade markdown-it and table packages.
- Rename visual plugin to code plugin.
- Support javascript optimized tables using jquery.
- Add jquery optimized tables and automatically add only needed css and js.
- Finish more tests on qr and chart integration.
- Fix docu links to examples.
- Add column chart example.
- Made charts useable.
- Integrate jui-chart with partly working chart creation.
- Also transform visual effects for console output.
- Complete qr code integration.
- Basic test for running markdown with separate parse and render calls.
- Implement graph parser in plugin.
- Add link to highlight.js for possible languages.

Version 1.4.1 (2016-05-31)
-------------------------------------------------
- Fix bug with duplicate callback in toHtml().
- Fix doxu style.

Version 1.4.0 (2016-05-31)
-------------------------------------------------
Now supporting http://alinex.github.io/node-table instances.

- Added table examples to documentation.
- Upgraded table, markdown-it and emoji support packages.
- Add table instance support.
- Remove debug output.

Version 1.3.15 (2016-05-20)
-------------------------------------------------
- Upgraded util, highlight, markdown-it and builder packages.
- Support new table format with header as first row.
- Upgraded markdown-it-toc-and-anchor to now working new version.
- Added test script for bug in toc package.

Version 1.3.14 (2016-05-04)
-------------------------------------------------
- Fix console test (disabling autodetect color mode).
- Downgrade markdown-it-toc-and-anchor because of problems.
- Downgrade markdown-it-toc-and-anchor because of problems.
- Update util and async calls.
- Upgraded util, fs, markdownit-toc-and-anchor, builder packages.
- Added v6 for travis but didn't activate, yet.
- Add missing package alinex-fs.

Version 1.3.13 (2016-04-06)
-------------------------------------------------
- Fixes in console conversion.
- Fixes in console conversion.
- Fixes in console conversion.
- Fix code formats within toConsole() conversion.

Version 1.3.12 (2016-04-06)
-------------------------------------------------
- Upgraded util, highlight, markdown-it and builder packages.
- Fixed bug in transform marked text to console.

Version 1.3.11 (2016-03-31)
-------------------------------------------------
- upgraded builder.
- Clone object in table to prevent changes to the outside.

Version 1.3.10 (2016-03-30)
-------------------------------------------------
- Fix wrong package in package.json.
- Fixed display of undefined values.

Version 1.3.9 (2016-03-29)
-------------------------------------------------
- Fix format of list-map tables.

Version 1.3.8 (2016-03-29)
-------------------------------------------------
- Add mask to instance table creation.

Version 1.3.7 (2016-03-29)
-------------------------------------------------
- Fix demask in toConsole().

Version 1.3.6 (2016-03-29)
-------------------------------------------------
- Demask markdown for text output.
- Add mask option to report and table format.

Version 1.3.5 (2016-03-29)
-------------------------------------------------
- Fix more toString() conversion problems with undefined values.
- Merge branch 'master' of https://github.com/alinex/node-report
- Fix more toString() conversion problems with undefined values.

Version 1.3.4 (2016-03-24)
-------------------------------------------------
- Update examples.
- Update dependent packages twemoji, highlight, css, deflist, util and builder.
- Fix rendering of tables with empty cells.
- Merge branch 'master' of http://github.com/alinex/node-report
- Updated examples.

Version 1.3.3 (2016-02-18)
-------------------------------------------------
- Upgraded pdf creation.
- Added specific decorator styles.

Version 1.3.2 (2016-02-16)
-------------------------------------------------
- Make table header bold in console output.
- Updated documentation.
- Updated examples.

Version 1.3.1 (2016-02-16)
-------------------------------------------------
- Increase test time for image inclusion.
- Updated example output.
- Also support locales with country.
- Updated examples.

Version 1.3.0 (2016-02-16)
-------------------------------------------------
- Upgraded markdown-it package.
- Support locale-option with german language.
- Extract html handling into separate module.
- Add inline css support.
- Updated pdf example.
- Added new test plugin for markdown-it.
- Completed documentation of direct markdown.
- Added description of markup style.
- Added example pdf and images.

Version 1.2.0 (2016-02-06)
-------------------------------------------------
- Support newest toc plugin.
- Extended documentation.
- Added pdf, png and jpg export.
- Add example for simple convert.

Version 1.1.5 (2016-02-05)
-------------------------------------------------
- Upgraded alinex-builder.
- Fixed style to display sql code.
- Fixed layout of html.
- Fixed constructor with source to work.

Version 1.1.4 (2016-02-04)
-------------------------------------------------
- Fixed small bug in tests.
- Load initial markup with starting newlines.
- updated ignore files.
- Fixed style of test cases.
- Updated meta data of package and travis build versions.
- Removed async package because no longer used.
- Upgraded markdown anchor module.
- Allow all tests to run.
- Include local resources locally in html as data uri.
- Updated copyright, travis and npmignore.

Version 1.1.3 (2016-01-27)
-------------------------------------------------
- Stick markdown-it-toc-and-anchor to version 2.0.0 because it breaks in version 2.1.0.
- Remove unused variables from script.
- Fixed html conversion to work on second run without reinitializing, too.
- Make checked checkbox in toText() better visible.

Version 1.1.2 (2016-01-06)
-------------------------------------------------
- Optimized regex for emoji.
- Fixed tests for new possibilities in lists.
- Allow multiline entries in lists.
- Fix length calculation for box in toConsole().
- Fixed bug in multiline boxes.
- Added direct markdown support for inline elements.
- Format tt text for console and fixed length calculation in boxes for console out.

Version 1.1.1 (2016-01-04)
-------------------------------------------------
- Updated test.
- Updated documentation.
- Added Report.style() method for decoration.
- Reenable decorator after it is better backward compatible with es3.

Version 1.1.0 (2016-01-02)
-------------------------------------------------
- Deactivated decorate module because it has syntax errors.
- Add decorator support.
- Add fontawesome icons support.
- Make info box green in html output.
- Also convert checkboxes using utf-8 in toConsole().
- Replace emoticons in toConsole().
- Support boxes in toConsole().
- Transform code blocks in toConsole() to indented text.
- Support strikethrough, italic and marked in toConsole().
- Replace hr and typographic signs in toConsole().
- Transform headings for console out.
- Update copyright.
- Replace tables with ascii art table in toConsole().
- Added example ascii art table for console in comment.

Version 1.0.2 (2015-12-21)
-------------------------------------------------
- Don't trim in toString().
- Git text and markdown working, too.
- Now got the link working to display html as is.
- Changed link to examples.
- Added example and optimized html layout style.
- Add sort option to all lists.
- Fixed wrong word breaks in dl lists.
- Updated documentation.
- Optimized style of html output.
- Replace toc module and optimize formatting.
- Use block function for paragraphs which will optimize already breaking blocks.
- Added some more usage examples.
- Optimize highlighter to support shorter css styles.
- Get html title through plugin and optimize code style.

Version 1.0.1 (2015-12-16)
-------------------------------------------------
- Fixed bug in console.log output converter for bold elements.
- Added support for table of contents.
- Add checkbox formatting.
- Fix abbreviation transform.
- Automatically extract title from html content.
- Remove console.log debugging output.

Version 1.0.0 (2015-12-10)
-------------------------------------------------
- Adding support for abbr() and footnote().
- Allow adding reports.
- Added definition list support.
- Allow arrays and objects in table.
- Working html style and emoji images.
- added example form github markdown
- Create html report.
- updated
- Added html transformation.

Version 0.1.3 (2015-12-05)
-------------------------------------------------
- Separate instance tests.
- Change console color mode to work at last using toConsole().
- Support optional color mode for console output.

Version 0.1.2 (2015-12-04)
-------------------------------------------------
- Added option to preload source into new instance.
- Add log support to the report class.

Version 0.1.1 (2015-12-04)
-------------------------------------------------
- Added table to instance methods.

Version 0.1.0 (2015-12-04)
-------------------------------------------------
- Remove some empty lines.
- Finish table() with corrected default align and easy map support.
- Extended table() to work with all combinations of obj-list-map.
- Added more sort definitions with reverse order.
- Add sort option to table display and make it work.
- Added roadmap.
- Added code support.
- Enable lists and quoted paragraphs.
- Made first methods runable.
- Made initial structure for class oriented design.
- Initial commit
