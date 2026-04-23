
import ctypes


class ButtonData(ctypes.Structure):
	pass
ButtonData._fields_ = [("def_fill", ctypes.c_uint)
				,("def_line_sz", ctypes.c_int)
				,("def_line", ctypes.c_uint)

				,("ov_fill", ctypes.c_uint)
				,("ov_line_sz", ctypes.c_int)
				,("ov_line", ctypes.c_uint)

				,("dn_fill", ctypes.c_uint)
				,("dn_line_sz", ctypes.c_int)
				,("dn_line", ctypes.c_uint)

				,("xcurve", ctypes.c_int)
				,("ycurve", ctypes.c_int)

				,("text", ctypes.c_char_p)
				,("font_id", ctypes.c_int)
				,("font_height", ctypes.c_int)
				,("font_vertical_offset", ctypes.c_int)
				,("font_color", ctypes.c_int)

				,("actions", ctypes.c_char_p)]
ButtonData._pack_ = 4

class EditText(ctypes.Structure):
	pass
EditText._fields_ = [("fontid", ctypes.c_int)
				,("font_height", ctypes.c_int)
				,("fontclassname", ctypes.c_char_p)
				,("rgba", ctypes.c_int)
				,("maxlength", ctypes.c_int)
				,("initialtext", ctypes.c_char_p)
				,("layout_align", ctypes.c_int)
				,("layout_leftmargin", ctypes.c_int)
				,("layout_rightmargin", ctypes.c_int)
				,("layout_indent", ctypes.c_int)
				,("layout_leading", ctypes.c_int)]
EditText._pack_ = 4

def init(lib):
	lib.swf_button.argtypes = [ctypes.c_int,ctypes.c_int,ctypes.POINTER(ButtonData)] #lib.swf_button.restype = c_int #https://docs.python.org/3/library/ctypes.html: By default functions are assumed to return the C int type.
	lib.swf_button_last.argtypes = [ctypes.c_char_p,ctypes.c_char_p] #lib.swf_button_last.restype = c_int

	lib.swf_font.argtypes = [ctypes.c_char_p,ctypes.c_char] #lib.swf_font.restype = c_int
	lib.swf_font_basic.argtypes = [ctypes.c_char_p] #lib.swf_font_basic.restype = c_int

	lib.swf_text.argtypes = [ctypes.c_int,ctypes.c_int,ctypes.c_char_p,ctypes.c_short,ctypes.POINTER(EditText)] #lib.swf_text.restype = c_int

	lib.swf_shape.argtypes = [ctypes.c_int,ctypes.c_int,ctypes.POINTER(ctypes.c_int)] #lib.swf_shape.restype = c_int  # like at ShapeArray at __init__
	lib.swf_shape_basic.argtypes = [ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_int] #lib.swf_shape_basic.restype = c_int
	lib.swf_shape_bitmap.argtypes = [ctypes.c_int,ctypes.c_int,ctypes.c_int] #lib.swf_shape_bitmap.restype = c_int
	lib.swf_shape_bitmap_clipped.argtypes = [ctypes.c_int,ctypes.c_int,ctypes.c_int] #lib.swf_shape_bitmap_clipped.restype = c_int
	lib.swf_shape_border.argtypes = [ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_int] #lib.swf_shape_border.restype = c_int

	lib.swf_image.argtypes = [ctypes.c_char_p] #lib.swf_image.restype = c_int
	lib.swf_image_ex.argtypes = [ctypes.c_char_p,ctypes.POINTER(ctypes.c_int)] #lib.swf_image.restype = c_int  # like at ImageSizes at __init__
	lib.swf_dbl.argtypes = [ctypes.c_char_p] #lib.swf_dbl.restype = c_int
	lib.swf_dbl_ex.argtypes = [ctypes.c_char_p,ctypes.POINTER(ctypes.c_int)] #lib.swf_dbl_ex.restype = c_int
	lib.swf_dbl_width.argtypes = [ctypes.c_char_p] #lib.swf_dbl_width.restype = c_int
	lib.swf_dbl_height.argtypes = [ctypes.c_char_p] #lib.swf_dbl_height.restype = c_int

	lib.swf_imagej.argtypes = [ctypes.c_char_p,ctypes.c_int,ctypes.c_int] #lib.swf_imagej.restype = c_int
	lib.swf_imagej_alpha.argtypes = [ctypes.c_char_p,ctypes.c_int,ctypes.c_int,ctypes.c_char_p] #lib.swf_imagej_alpha.restype = c_int
	lib.swf_imagej_clipped.argtypes = [ctypes.c_char_p,ctypes.c_int,ctypes.c_int] #lib.swf_imagej_clipped.restype = c_int
	lib.swf_imagej_alpha_clipped.argtypes = [ctypes.c_char_p,ctypes.c_int,ctypes.c_int,ctypes.c_char_p] #lib.swf_imagej_alpha_clipped.restype = c_int
	lib.swf_jpeg.argtypes = [ctypes.c_char_p] #lib.swf_jpeg.restype = c_int
	lib.swf_jpeg_alpha.argtypes = [ctypes.c_char_p,ctypes.c_char_p] #lib.swf_jpeg_alpha.restype = c_int
	lib.swf_gif_width.argtypes = [ctypes.c_char_p] #lib.swf_gif_width.restype = c_int
	lib.swf_gif_height.argtypes = [ctypes.c_char_p] #lib.swf_gif_height.restype = c_int

	lib.swf_imagex.argtypes = [ctypes.c_char_p] #lib.swf_imagex.restype = c_int
	lib.swf_imagex_ex.argtypes = [ctypes.c_char_p,ctypes.POINTER(ctypes.c_int)] #lib.swf_imagex_ex.restype = c_int
	lib.swf_img.argtypes = [ctypes.c_char_p] #lib.swf_img.restype = c_int
	lib.swf_img_ex.argtypes = [ctypes.c_char_p,ctypes.POINTER(ctypes.c_int)] #lib.swf_img_ex.restype = c_int

	#swf_done
	lib.swf_new.argtypes = [ctypes.c_char_p,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_ubyte] #lib.swf_new.restype = None # else c_int is default , is ok, there is still a wrapper to enforce nr of args
	lib.swf_new_ex.argtypes = [ctypes.c_char_p,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_ubyte,ctypes.c_int]
	lib.swf_placeobject.argtypes = [ctypes.c_int,ctypes.c_int]
	lib.swf_placeobject_coords.argtypes = [ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_int]
	lib.swf_removeobject.argtypes = [ctypes.c_int]
	#swf_showframe

	lib.swf_sprite_done.argtypes = [ctypes.c_int] #lib.swf_sprite_done.restype = c_int
	#lib.swf_sprite_new.restype = c_int
	lib.swf_sprite_placeobject.argtypes = [ctypes.c_int,ctypes.c_int,ctypes.c_int]
	lib.swf_sprite_placeobject_coords.argtypes = [ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_int]
	lib.swf_sprite_removeobject.argtypes = [ctypes.c_int,ctypes.c_int]
	lib.swf_sprite_showframe.argtypes = [ctypes.c_int]

	lib.swf_exports_add.argtypes = [ctypes.c_int,ctypes.c_char_p]
	#swf_exports_done

	global _lib
	_lib=lib

def button(width,height,buttondata):
	return _lib.swf_button(width,height,buttondata)
def button_last(actions,newtext):
	return _lib.swf_button_last(actions.encode('utf-8'),newtext.encode('utf-8'))

def font(fontname,font_flags):
	return _lib.swf_font(fontname.encode('utf-8'),font_flags)
def font_basic(fontname):
	return _lib.swf_font_basic(fontname.encode('utf-8'))

def text(bound_width,bound_height,variablename,flags,structure):
	return _lib.swf_text(bound_width,bound_height,variablename.encode('utf-8'),flags,structure)

def shape(width,height,args):
	return _lib.swf_shape(width,height,args)
def shape_basic(width,height,fillcolor,linecolor):
	return _lib.swf_shape_basic(width,height,fillcolor,linecolor)
def shape_bitmap(bitmapId,width,height):
	return _lib.swf_shape_bitmap(bitmapId,width,height)
def shape_bitmap_clipped(bitmapId,width,height):
	return _lib.swf_shape_bitmap_clipped(bitmapId,width,height)
def shape_border(width,height,linesize,linecolor):
	return _lib.swf_shape_border(width,height,linesize,linecolor)

def image(imagepath):
	return _lib.swf_image(imagepath.encode('utf-8'))
def image_ex(imagepath,wh):
	return _lib.swf_image_ex(imagepath.encode('utf-8'),wh)
def dbl(imagepath):
	return _lib.swf_dbl(imagepath.encode('utf-8'))
def dbl_ex(imagepath,wh):
	return _lib.swf_dbl_ex(imagepath.encode('utf-8'),wh)
def dbl_width(imagepath):
	return _lib.swf_dbl_width(imagepath.encode('utf-8'))
def dbl_height(imagepath):
	return _lib.swf_dbl_height(imagepath.encode('utf-8'))

def imagej(imagepath,width,height):
	return _lib.swf_imagej(imagepath.encode('utf-8'),width,height)
def imagej_alpha(imagepath,width,height,alphapath):
	return _lib.swf_imagej_alpha(imagepath.encode('utf-8'),width,height,alphapath.encode('utf-8'))
def imagej_clipped(imagepath,width,height):
	return _lib.swf_imagej_clipped(imagepath.encode('utf-8'),width,height)
def imagej_alpha_clipped(imagepath,width,height,alphapath):
	return _lib.swf_imagej_alpha_clipped(imagepath.encode('utf-8'),width,height,alphapath.encode('utf-8'))
def jpeg(imagepath):
	return _lib.swf_jpeg(imagepath.encode('utf-8'))
def jpeg_alpha(imagepath,alphapath):
	return _lib.swf_jpeg_alpha(imagepath.encode('utf-8'),alphapath.encode('utf-8'))
def gif_width(imagepath):
	return _lib.swf_gif_width(imagepath.encode('utf-8'))
def gif_height(imagepath):
	return _lib.swf_gif_height(imagepath.encode('utf-8'))

def imagex(imagepath):
	return _lib.swf_imagex(imagepath.encode('utf-8'))
def imagex_ex(imagepath,wh):
	return _lib.swf_imagex_ex(imagepath.encode('utf-8'),wh)
def img(imagepath):
	return _lib.swf_img(imagepath.encode('utf-8'))
def img_ex(imagepath,wh):
	return _lib.swf_img_ex(imagepath.encode('utf-8'),wh)

def done():
	_lib.swf_done()
def new(path,width,height,backgroundcolor,fps):
	_lib.swf_new(path.encode('utf-8'),width,height,backgroundcolor,fps)
def new_ex(path,width,height,backgroundcolor,fps,flags):
	_lib.swf_new_ex(path.encode('utf-8'),width,height,backgroundcolor,fps,flags)
def placeobject(refid,depth):
	_lib.swf_placeobject(refid,depth)
def placeobject_coords(refid,depth,x,y):
	_lib.swf_placeobject_coords(refid,depth,x,y)
def removeobject(depth):
	_lib.swf_removeobject(depth)
def showframe():
	_lib.swf_showframe()

def sprite_done(spriteid):
	return _lib.swf_sprite_done(spriteid)
def sprite_new():
	return _lib.swf_sprite_new()
def sprite_placeobject(spriteid,object,depth):
	_lib.swf_sprite_placeobject(spriteid,object,depth)
def sprite_placeobject_coords(spriteid,object,depth,x,y):
	_lib.swf_sprite_placeobject_coords(spriteid,object,depth,x,y)
def sprite_removeobject(spriteid,depth):
	_lib.swf_sprite_removeobject(spriteid,depth)
def sprite_showframe(spriteid):
	_lib.swf_sprite_showframe(spriteid)

def exports_add(id,name):
	_lib.swf_exports_add(id,name.encode('utf-8'))
def exports_done():
	_lib.swf_exports_done()
