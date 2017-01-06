Headings
=====================================================


API Builder
----------------------------------------------------


Markdown Spec
----------------------------------------------------

The markdown parsing is based on CommonMark Specification:
[ATX Headings](http://spec.commonmark.org/0.27/#atx-headings),
[Setext Headings](http://spec.commonmark.org/0.27/#setext-headings)

Exceptions to the standard are:
- Escaped Underline of an setext heading is also not interpreted as thematic break
  which makes it more consistent and the behaviour in
  [example 75](http://spec.commonmark.org/0.27/#example-75)
  is never really needed.

  
Examples
----------------------------------------------------

::: API
```
code
```
:::

::: Markdown
```
include from file
![html](../examples/heading/levels.jpg)
```
:::

::: Text
```
![html](../examples/heading/levels.jpg)
```
:::

::: HTML
```
iframe
![html](../examples/heading/levels.jpg)
```
:::
