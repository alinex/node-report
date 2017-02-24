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

#3 Markdown Parser

The markdown parser is basically build on top of the
[CommonMark Specification](http://spec.commonmark.org/0.27/). It runs all tests
defined there to ensure is is fully compatible. But through the already included
plugins you may have some slightly better output. If you don't want this, you may
switch them off through configuration.

See the elements itself of how much it is extended or optimized to this standard.


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

#3 Markdown Output

This is the only format, which won't lose any information of the internal structure.

The output is based on the parser standards but may be optimized using the configuration
settings. But if you combine this with the parser you will often not get the exact same
output which was parsed earlier. But you will get an optimized version which contains
the exact same information.

If `use_references` is switched on in the configuration it will use references in
the text and place the links itself at the end of the document.

#3 HTML Output

Like in all other formats you may specify the output by configuration.

The generated tags will be xhtml compliant and properly nested. But included raw
code may not follow these guidelines.
###
