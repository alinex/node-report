Transformation
=================================================
This rules are used to match elements in the source and create the token list out
of it.

In this step the text is processed in a linear way character by character against
a list of regular expressions of the possible elements. To decide which elements
are possible at the current position a state is defined, which may change for
sub parts. The state consists mostly of two parts: `<domain>-<area>` the possible
domains are:
- `m` for markdown,
- `mh` for markdown with html
- `h` for html

Within the rules the new state may be set to `-<name>` meaning that the domain
before will be kept.

Markdown parsing is based on http://spec.commonmark.org/ and the example from there
are checked against this implementation, too.


Modules
-------------------------------------------------
Each module will export an object containing multiple rules used in different states
of parsing. But only the rules matching at the moment will be executed.

The interface of these methods should be:

@name <alias>
@param {Array<String>|String} state all the possible states in which this rule is allowed
@param {Array<String>|String} last type of last element to match rule
@param {Integer} nesting of last element to match rule
@param {RegExp} re to check if this rule should be applied
@param {Function(Match, Token, String)} fn to run if the rule matched.
Here you may call `insert()` or run sub `lexer()` and lastly
return the number of characters which were done and can be skipped for the
next run.

After importing each element rule is defined with:
- `String` - `element` name of this element (automatically set)
- `String` - `name` of this rule (automatically set)
- `Array<String>` - `state` all the possible states in which this rule is allowed
- `RegExp` - `re` to check if this rule should be applied
- `Function(Match)` - `fn` to run if the rule matched.
