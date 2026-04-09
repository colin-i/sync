
from enum import IntEnum

class flag(IntEnum):
	none=            0
	pre_log=         0x1
	alt=             0x2
	titles=          0x4
	pre_x=           0x8
	pre_x_pad=       0x10
	forin1=          0x20
	framesAsShows=   0x40
	x=               0x80
	pre_pool_write=  0x100
	pool_read=       0x200
	pre_mix=         0x400
	pool_read_unlink=0x800
	pre_write_no=    0x1000
	compress=        0x2000
	deprecation_no=  0x4000
	deprecation_yes= 0x8000
	noDuplicate=     0x10000
	verbose=         0x20000
	xx=              0x40000
class flags(IntEnum):
	pool=        flag.pre_pool_write|flag.pool_read
	x=           flag.pre_x|flag.x
	prex=        flag.pre_log|flag.pre_pool_write|flag.pre_x
	prexx=       prex|flag.xx
	antix_read=  flag.pre_log|flag.alt|flag.pre_x
	antixx_write=flag.titles
	xx=          flag.pool_read|flag.xx
class flagss(IntEnum):
	x=        flag.x|flag.pool_read
	xu=       x|flag.pool_read_unlink
	xx=       x|flag.xx
	xxu=      xu|flag.xx
	read_done=flag.pool_read|flag.pool_read_unlink

class FILLSTYLE(IntEnum):
	no=                          -1
	solid=                       0
	repeating_bitmap=            0x40
	clipped_bitmap=              0x41
	nonsmoothed_repeating_bitmap=0x42
	nonsmoothed_clipped_bitmap=  0x43
class State(IntEnum):
	MoveTo=    1
	FillStyle0=1 << 1
	FillStyle1=1 << 2
	LineStyle= 1 << 3
	NewStyles= 1 << 4
class ButtonState(IntEnum):
	Up=     1
	Over=   1 << 1
	Down=   1 << 2
	HitTest=1 << 3

class Text(IntEnum):
	HasText=     0x80
	WordWrap=    0x40
	Multiline=   0x20
	Password=    0x10
	ReadOnly=    0x8
	HasTextColor=0x4
	HasMaxLength=0x2
	HasFont=     0x1
	HasFontClass=0x8000
	AutoSize=    0x4000
	HasLayout=   0x2000
	NoSelect=    0x1000
	Border=      0x800
	WasStatic=   0x400
	HTML=        0x200
	UseOutlines= 0x100
class LayoutAlign(IntEnum):
	left=   0
	right=  1
	center= 2
	justify=3

class FontFlags(IntEnum):
	HasLayout=           0x80
	FontFlagsShiftJIS=   0x40
	FontFlagsSmallText=  0x20
	FontFlagsANSI=       0x10
	FontFlagsWideOffsets=8
	FontFlagsWideCodes=  4
	FontFlagsItalic=     2
	FontFlagsBold=       1


import ctypes

def ImageSizes():
	return (ctypes.c_int * 2)()
def ShapeArray(*values): # ShapeArray(1,2,3)
	return (ctypes.c_int * (len(values) + 1))(*values, 0)  # tests started from this: (ctypes.c_int * 2)(*[1, 0])
def ActionSize():
	return ctypes.c_ulong()  # using the .value
def ActionBuffer():
	return ctypes.c_char_p()
def Ref(a):
	return ctypes.byref(a)

#try: #in PATH
_lib=ctypes.cdll.LoadLibrary("libactionswf.so")
#except Exception:
#lib=ctypes.cdll.LoadLibrary("actionswf.dll")

from . import _swf
_swf.init(_lib)
ButtonData=_swf.ButtonData
EditText=_swf.EditText
button=_swf.button
button_last=_swf.button_last
font=_swf.font
font_basic=_swf.font_basic
text=_swf.text
shape=_swf.shape
shape_basic=_swf.shape_basic
shape_bitmap=_swf.shape_bitmap
shape_bitmap_clipped=_swf.shape_bitmap_clipped
shape_border=_swf.shape_border
image=_swf.image
image_ex=_swf.image_ex
dbl=_swf.dbl
dbl_ex=_swf.dbl_ex
dbl_width=_swf.dbl_width
dbl_height=_swf.dbl_height
imagej=_swf.imagej
imagej_alpha=_swf.imagej_alpha
imagej_clipped=_swf.imagej_clipped
imagej_alpha_clipped=_swf.imagej_alpha_clipped
jpeg=_swf.jpeg
jpeg_alpha=_swf.jpeg_alpha
gif_width=_swf.gif_width
gif_height=_swf.gif_height
imagex=_swf.imagex
imagex_ex=_swf.imagex_ex
img=_swf.img
img_ex=_swf.img_ex
done=_swf.done
new=_swf.new
new_ex=_swf.new_ex
placeobject=_swf.placeobject
placeobject_coords=_swf.placeobject_coords
removeobject=_swf.removeobject
showframe=_swf.showframe
sprite_done=_swf.sprite_done
sprite_new=_swf.sprite_new
sprite_placeobject=_swf.sprite_placeobject
sprite_placeobject_coords=_swf.sprite_placeobject_coords
sprite_removeobject=_swf.sprite_removeobject
sprite_showframe=_swf.sprite_showframe
exports_add=_swf.exports_add
exports_done=_swf.exports_done

from . import _action
_action.init(_lib)
action=_action.action
actionf=_action.actionf
actionsf=_action.actionsf
actiond=_action.actiond
action_sprite=_action.action_sprite
action_init_sprite=_action.action_init_sprite
actionf_sprite=_action.actionf_sprite
actionf_init_sprite=_action.actionf_init_sprite
actionsf_sprite=_action.actionsf_sprite
actionsf_init_sprite=_action.actionsf_init_sprite
actions_free=_action.actions_free

from . import _tool
_tool.init(_lib)
erbool_get=_tool.erbool_get
erbool_reset=_tool.erbool_reset
freereset=_tool.freereset
xlog_pad_get=_tool.xlog_pad_get
xlog_pad_set=_tool.xlog_pad_set
