###
Elements
=====================================================

This is a documentation of all possible elements and how far they are supported
in the different input and output formats.

![Formats](../formatter/formats.png)

Not all of them are currently fully supported, but see below.


Input Data
------------------------------------------------------
Beside using the programatical API some other file formats may be used. They will
be parsed, but not every format can handle all elements. The main format is markdown
but you may also use one of the others.

But only markdown can at the moment be used to store and reread data without loss
of information. The concret implementation is based on the standards but contains
some significant changes, too.

__Support for Parsing__

| Element    | API |  MD  | HTML | ADOC |
|:---------- |:---:|:----:|:----:|:----:|
| Text       |  X  |  X   |      |      |
| Heading    |  X  |  X   |      |      |
| Paragraph  |  X  |  X   |      |      |
| ThemaBreak |  X  |  X   |      |      |
| CharStyle  |  X  |  X   |      |      |
| Preformat  |     |  X   |      |      |
| List       |     |  X   |      |      |
| Code       |     |  X   |      |      |
| Box        |     |  X   |      |      |
| Style      |     |  X   |      |      |
| ToC        |     |  X   |      |      |
| HTML       |     |  X   |      |      |
| Execute    |     |  X   |      |      |

^`X` -> supported; `-` -> not possible; `(X)` -> partly supported;
empty -> not currently done^



Output Formats
------------------------------------------------------

But not every format can handle all elements. The markdown format is the only one
which can be used to store the report without loosing anything.

Each of the formats support different options you may set ba configuration or on call
(see the {@link ../configSchema.coffee}).

| Element    | MD  | Text | HTML | ROFF | ADOC | LaTeX | RTF |
|:---------- |:---:|:----:|:----:|:----:|:----:|:-----:|:---:|
| Text       |  X  |  X   |  X   |  X   |      |  X    |  X  |
| Heading    |  X  |  X   |  X   |  X   |      |       |     |
| Paragraph  |  X  |  X   |  X   |  X   |      |       |     |
| ThemaBreak |  X  |  X   |  X   |  X   |      |       |     |
| CharStyle  |  X  | (X)  |  X   |  X   |      |       |     |
| Text       |     |      |      |      |      |       |     |

^`X` -> supported; `-` -> not possible; `(X)` -> partly supported;
empty -> not currently done^
###

fs = require 'fs'

list = fs.readdirSync __dirname
.filter (e) -> not e.match /^index\./

require "./#{file}" for file in list
