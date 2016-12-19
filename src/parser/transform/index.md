Transformation
=================================================
This rules are used to match elements in the source and create the token list out
of it.


Modules
-------------------------------------------------
Each module will export an object containing multiple rules used in different states
of parsing.

The interface of these methods should be:

@name <alias>
@param {Array<String>} state all the possible states in which this rule is allowed
@param {RegExp} re to check if this rule should be applied
@param {Function(Match)} fn to run if the rule matched.
Here you may call `add()`, change the index position run sub `parse()` and lastly
return the number of characters which werde done and can be skipped for the
next run.
