Post Optimizations
=================================================
This optimization methods are run while gathering the transformed text together.
Each element is called in reverse order and may contain the `out` and `content`
fields.


Modules
-------------------------------------------------
Each module will export an object containing objects for specific tokens. They will
be matched against the tokens in the list and it's `fn` method is executed if matched
only.

The interface of these methods should be:

@name <alias>
@param {Array|String} format to be matched against format
@param {String} type to be matched against token
@param {Array} state to be matched against token
@param {Function(Integer, Token)} fn to be run on token
