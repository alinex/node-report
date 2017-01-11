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
| Paragraph  |     |  X   |      |      |
| Preformat  |     |  X   |      |      |
| ThemaBreak |  X  |  X   |      |      |
| CharStyle  |     |  X   |      |      |
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

Each of the formats support different options you may set by configuration or on call
(see the {@link ../configSchema.coffee}).

| Element    | MD  | Text | HTML | ROFF | ADOC | LaTeX | RTF |
|:---------- |:---:|:----:|:----:|:----:|:----:|:-----:|:---:|
| Text       |  X  |  X   |  X   |  X   |      |  X    |  X  |
| Paragraph  |  X  |  X   |  X   |  X   |      |       |     |
| Heading    |  X  |  X   |  X   |  X   |      |       |     |
| Preformat  |     |      |      |      |      |       |     |
| ThemaBreak |  X  |  X   |  X   |  X   |      |       |     |
| CharStyle  |  X  | (X)  |  X   |  X   |      |       |     |
| List       |     |      |      |      |      |       |     |
| Code       |     |      |      |      |      |       |     |
| Box        |     |      |      |      |      |       |     |
| Style      |     |      |      |      |      |       |     |
| ToC        |     |      |      |      |      |       |     |
| HTML       |     |      |      |      |      |       |     |
| Execute    |     |      |      |      |      |       |     |

^`X` -> supported; `-` -> not possible; `(X)` -> partly supported;
empty -> not currently done^


Builder API
------------------------------------------------------
This follows a common schema with most methods are available with its full name
and a short name. Block elements can be called completely with all data or with a
boolean value to open and close it separately.

As far as possible the API won't throw errors but interpret all calls like you maybe
wanted them by autoclosing tags.


###

fs = require 'fs'

list = fs.readdirSync __dirname
.filter (e) -> not e.match /^index\./

require "./#{file}" for file in list
