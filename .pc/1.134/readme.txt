
Action Swf can create swf files.
The program is a set of objects made with O Language.
A swf with actionscript example is in the example folder for static o language.
The libactionswf-dev actionswf.h is for c/c++ language and import.oh are the imports for o language.
The files swf.es and action.es has the main functions that can be used; functions from tool.es can be used in rare situations.
When using the debug_log flag at swf_new_ex, action,action_sprite,swf_sprite_done calls are logged. The syntax is as follow:

SpriteId
ActionInitBool
TextLinesNumber
TextLines
{*NumberAX...sNumberB1-NumberBN}

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
ActionInitBool is a 0/1 digit.
FinalSpriteId is the id in the swf
these are at prexx_flags:
	TextLinesNumber is the number of lines that TextLines has.
	TextLines is the text like in action[_sprite] call.
	* NumberA1-NumberAN lines from TextLinesNumber
	... ? the notation is at include/xlog.oh ,there are special chars and numbers, a minimal example: ,1F,,F -> 3 actions, first is an action with ACTIONRECORDHEADER of 0x1F Length, second has ActionCode < 0x80, third has Length 0xF
