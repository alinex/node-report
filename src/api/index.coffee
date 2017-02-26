###
Elements
=====================================================

This is a documentation of all possible elements and how far they are supported
in the different input and output formats.

![Formats](../formatter/formats.png)

Not all of them are currently fully supported, but see below.


Builder API
------------------------------------------------------
This follows a common schema with most methods are available with its full name
and a short name. Block elements can be called completely with all data or with a
boolean value to open and close it separately.

As far as possible the API won't throw errors but interpret all calls like you maybe
wanted them using auto closing tags.
###

fs = require 'fs'

list = fs.readdirSync __dirname
.filter (e) -> not e.match /^index\./

require "./#{file}" for file in list


###
Input Formats
------------------------------------------------------
Beside using the programmable API some other file formats may be used. They will
be parsed, but not every format can handle all elements. The main format is markdown
but you may also use one of the others. You also may mix the parsing formats and
place them into API calls.

But only markdown can at the moment be used to store and reread data without loss
of information. The concrete implementation is based on the standards but contains
some significant changes, too.C

__Support for Parsing__

| Element    | API |  MD  | HTML | ADOC |
|:---------- |:---:|:----:|:----:|:----:|
| Text       |  X  |  X   |      |      |
| Heading    |  X  |  X   |      |      |
| Paragraph  |  X  |  X   |      |      |
| Preformat  |  X  |  X   |      |      |
| Code       |  X  |  X   |      |      |
| Blockquote |  X  |  X   |      |      |
| ThemeBreak |  X  |  X   |      |      |
| List       |  X  |  X   |      |      |
| Fixed      |  X  |  X   |      |      |
| Emphasis   |  X  |  X   |      |      |
| HTML       |     |  X   |      |      |
| Box        |     |      |      |      |
| Style      |     |      |      |      |
| ToC        |     |      |      |      |
| Execute    |     |      |      |      |

^`X` -> supported; `-` -> not possible; `(X)` -> partly supported;
empty -> not currently done^


Output Formats
------------------------------------------------------

But not every format can handle all elements. The markdown format is the only one
which can be used to store the report without loosing anything.

Each of the formats support different options you may set by configuration or on call
(see the {@link ../configSchema.coffee}).

| Element    | MD  | Text | HTML | ROFF | ADOC | LaTeX | RTF |
|:---------- |:---:|:----:|:----:|:----:|:----:|:-----:|:---:|
| Text       |  X  |  X   |  X   |  X   |      |  X    |  X  |
| Paragraph  |  X  |  X   |  X   |  X   |      |       |     |
| Heading    |  X  |  X   |  X   |  X   |      |       |     |
| Preformat  |  X  |      |      |  X   |      |       |     |
| Blockquote |  X  |      |      |      |      |       |     |
| ThemaBreak |  X  |  X   |  X   |  X   |      |       |     |
| CharStyle  |  X  | (X)  |  X   |  X   |      |       |     |
| List       |  X  |  X   |  X   |      |      |       |     |
| HTML       |  X  |      |      |      |      |       |     |
| Box        |     |      |      |      |      |       |     |
| Style      |     |      |      |      |      |       |     |
| ToC        |     |      |      |      |      |       |     |
| Execute    |     |      |      |      |      |       |     |

^`X` -> supported; `-` -> not possible; `(X)` -> partly supported;
empty -> not currently done^


Markdown
------------------------------------------------------
The **markdown** format is the base format of the report package and the most
powerful of all. It allows complete output without loss of information.

Markdown is a plain text format for writing structured documents, based on conventions
used for indicating formatting in email and usenet posts. It was developed in 2004
by John Gruber and adapted in a lot of projects and languages. Some of them extended
the original syntax with conventions for more elements. It is also used in different
web applications like GitHub, StackOverflow, Trello and more.
In contrast to other formats like AsciDoc it is more readable and easier to write.

The markdown parser is basically build to support the following specifications:
- [Daring Fireball](https://daringfireball.net/projects/markdown/)
- [CommonMark Specification](http://spec.commonmark.org/0.27/)
- [GitHub Flavored Markdown](https://help.github.com/categories/writing-on-github/)

See the elements itself of how much it is extended or optimized to this standards.
Also there are some more elements added like:
- ????

The output is based on the parser standards but may be optimized using the configuration
settings. But if you combine this with the parser you will often not get the exact same
output which was parsed earlier. But you will get an optimized version which contains
the exact same information.

All elements are divided into block level or inline elements and may or not may contain
further markdown. Read more about this in each element.



This is extended to also support GFM styles like:
- [Tables](https://help.github.com/articles/organizing-information-with-tables/)
- [TaskLists](https://help.github.com/articles/basic-writing-and-formatting-syntax/#task-lists)
- mentioning (maybe using linkify)
- emoji


HTML Output
---------------------------------------------
Like in all other formats you may specify the output by configuration.

The generated tags will be xhtml compliant and properly nested. But included raw
code may not follow these guidelines.
###
