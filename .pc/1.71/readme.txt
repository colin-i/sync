
Action Swf can create swf files.
The program is a set of objects made with O Language.
A swf with actionscript example is in the example folder for static o language.
The include/actionswf.h is for c/c++ language. dev/import.h are the imports for o language.
The files swf.es and action.es has the main functions that can be used; functions from tool.es can be used in rare situations.
When using a debug flag at swf_new_ex, action,action_sprite,swf_sprite_done calls are logged. The syntax is as follow:

SpriteId
TextLinesNumber
TextLines
{NumberA,NumberB1...NumberBN}

Or:

SpriteId
(here is a blank row)
(another one, here is a ShowFrame)

Or:

SpriteId
(blank row)
FinalSpriteId

Where:
SpriteId or 0 for root.
TextLinesNumber is the number of lines that TextLines has.
TextLines is the text like in action[_sprite] call.
NumberA lines, then NumberA1+...+NumberAN<=TextLinesNumber, less only when last line(s) is/are blank(s).
NumberB1...NumberBN: example ,1F,,0F -> 3 actions, first is an action with ACTIONRECORDHEADER of 0x1F Length, second has ActionCode < 0x80, third has Length 0xF
FinalSpriteId is the if from the swf
