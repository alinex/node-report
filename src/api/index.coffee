# commonmark:

# 13-31 thematic break
# 32-75 heading
# 76-87 preformatted

# 180-187 paragraph
# 188 blank
# 189-197 blockquote

# 199-213 blockquote
# 214-223 list

# 225-238.. list

# 240-250.. list

# 287-291.. text

###
Elements
=====================================================

This is a documentation of all possible elements and how far they are supported
in the different input and output formats.

![Formats](../formatter/formats.png)

Not all of them are currently fully supported, but see below.


Input Data
------------------------------------------------------
Beside using the programmable API some other file formats may be used. They will
be parsed, but not every format can handle all elements. The main format is markdown
but you may also use one of the others.

But only markdown can at the moment be used to store and reread data without loss
of information. The concrete implementation is based on the standards but contains
some significant changes, too.

__Support for Parsing__

| Element    | API |  MD  | HTML | ADOC |
|:---------- |:---:|:----:|:----:|:----:|
| Text       |  X  |  X   |      |      |
| Heading    |  X  |  X   |      |      |
| Paragraph  |  X  |  X   |      |      |
| Preformat  |  X  |  X   |      |      |
| Blockquote |     |  X   |      |      |
| ThemaBreak |  X  |  X   |      |      |
| CharStyle  |     |  X   |      |      |
| List       |     |  X   |      |      |
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
| Preformat  |  X  |      |      |  X   |      |       |     |
| Blockquote |     |      |      |      |      |       |     |
| ThemaBreak |  X  |  X   |  X   |  X   |      |       |     |
| CharStyle  |  X  | (X)  |  X   |  X   |      |       |     |
| List       |     |      |      |      |      |       |     |
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
wanted them by auto closing tags.
###

fs = require 'fs'

list = fs.readdirSync __dirname
.filter (e) -> not e.match /^index\./

require "./#{file}" for file in list


###
Markdown Parser
------------------------------------------------------
The markdown parser is basically build on top of the
[CommonMark Specification](http://spec.commonmark.org/0.27/).

Generally all elements defined in this standard are build as described.
Only small changes may occur like the elements won't keep newlines as so but will
replace them with spaces if not in predefined blocks.

See the elements itself of how much it is extended or optimized to this standard.
###
