Transformer
=================================================
To transform the token list into a format specific token tree.


Modules
-------------------------------------------------
Each module will export an object containing objects for specific tokens. They will
be matched against the tokens in the list and it's `fn` method is executed if matched
only.

The function should add an `out` text to each element containing the converted text
for this element.

The interface of these methods should be:

@name <alias>
@param {Array|String} format to be matched against format
@param {String} type to be matched against token
@param {Array} state to be matched against token
@param {Function(Integer, Token)} fn to be run on token
