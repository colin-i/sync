
Action Swf can create swf files.
The program is a set of objects made with O Language.
A swf with actionscript example is in the example folder for static o language.
The libactionswf-dev actionswf.h is for c/c++ languages and actionswf.oh is for for o language.
The files swf.es and action.es has the main functions that can be used; functions from tool.es can be used in rare situations.
To override a default flag without calling swf_new_ex, write in user home folder .actionswf file (example to override flagpre_log and flag_deprecation_yes, write 8001).
When using the flagpre_log flag, action,action_sprite,swf_sprite_done calls are logged for oaalternative, more is logged at prexx_flags for debugging.

The log will look like this:

SpriteId
ActionInitBool
TextLinesNumber
TextLines
{*NumberAX...sNumberB1-NumberBN}

where:
	SpriteId or 0 for root.
	ActionInitBool is a 0/1 digit.
these are only at prexx_flags:
	TextLinesNumber is the number of lines that TextLines has.
	TextLines is the text like in action[_sprite] call.
	*NumberA1-NumberAN lines from TextLinesNumber
	... ? the notation is at dev/xlog.oh ,there are special chars and numbers, a minimal example: ,1F,,F -> 3 actions, first is an action with ACTIONRECORDHEADER of 0x1F Length, second has ActionCode < 0x80, third has Length 0xF

Or:

SpriteId
(here is a blank row)
(another one, here is a ShowFrame)
(another one only at alt log)

Or:

SpriteId
(blank row)
FinalSpriteId

where:
FinalSpriteId is the id in the swf

Or, at alt log:
SpriteId
(blank row)
(blank row)
ExportString

where:
	ExportString is the name for action script
