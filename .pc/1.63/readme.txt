
Action Swf can create swf files.
The program is a set of objects made with O Language.
A swf with actionscript example is in the example folder for static o language.
The include/actionswf.h is for c/c++ language. dev/import.h are the imports for o language.
The files swf.es and action.es has the main functions that can be used; functions from tool.es can be used in rare situations.
When using the debug option, action and action_sprite calls are logged. The syntax is as follow:

SpriteId
TextLinesNumber
TextLines
{NumberA,NumberB}

Or

SpriteId
(here is a blank row, not TextLinesNumber, representing a ShowFrame, to differentiate DoAction tags)

Where:
SpriteId or 0 for root.
TextLinesNumber is the number of lines that TextLines has.
TextLines is the text like in action[_sprite] call.
NumberA lines, then NumberA1+...+NumberAN<=TextLinesNumber, less only when last line(s) is/are blank(s).
NumberB is the number of actions encountered in NumberA
