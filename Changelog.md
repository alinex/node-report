Version changes
=================================================

The following list gives a short overview about what is changed between
individual versions:

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

