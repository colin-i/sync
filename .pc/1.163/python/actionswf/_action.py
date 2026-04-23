
import ctypes

def init(lib):
	lib.action.argtypes = [ ctypes.c_char_p ]
	lib.actionf.argtypes = [ ctypes.c_char_p, ctypes.c_char_p ]
	lib.actionsf.argtypes = [ ctypes.POINTER(ctypes.c_ulong), ctypes.POINTER(ctypes.c_char_p), ctypes.c_char_p ]
	lib.actiond.argtypes = [ ctypes.c_char_p ]

	lib.action_sprite.argtypes = [ ctypes.c_int, ctypes.c_char_p ]
	lib.action_init_sprite.argtypes = [ ctypes.c_int, ctypes.c_char_p ]
	lib.actionf_sprite.argtypes = [ ctypes.c_int, ctypes.c_char_p, ctypes.c_char_p ]
	lib.actionf_init_sprite.argtypes = [ ctypes.c_int, ctypes.c_char_p, ctypes.c_char_p ]
	lib.actionsf_sprite.argtypes = [ ctypes.c_int, ctypes.POINTER(ctypes.c_ulong), ctypes.POINTER(ctypes.c_char_p), ctypes.c_char_p ]
	lib.actionsf_init_sprite.argtypes = [ ctypes.c_int, ctypes.POINTER(ctypes.c_ulong), ctypes.POINTER(ctypes.c_char_p), ctypes.c_char_p ]

	lib.actions_free = [ ctypes.c_char_p ]

	global _lib
	_lib=lib

def action(ac):
	_lib.action(ac.encode('utf-8'))
def actionf(*args, buffer, format): #You must place the variadic ones first in the function definition  #call this like this: (buffer=b, format="...", *["a",1])
	_lib.actionf(buffer, format.encode('utf-8'), *args) #buffer example: (ctypes.c_char * 10)()       #string args can go like this: b'a_string'
def actionsf(*args, psize, pbuffer, format):
	_lib.actionsf(psize, pbuffer, format.encode('utf-8'), *args)
def actiond(ac):
	_lib.actiond(ac.encode('utf-8'))

def action_sprite(sprite, ac):
	_lib.action_sprite(sprite, ac.encode('utf-8'))
def action_init_sprite(sprite, ac):
	_lib.action_init_sprite(sprite, ac.encode('utf-8'))
def actionf_sprite(*args, sprite, buffer, format):
	_lib.actionf_sprite(sprite, buffer, format.encode('utf-8'), *args)
def actionf_init_sprite(*args, sprite, buffer, format):
	_lib.actionf_init_sprite(sprite, buffer, format.encode('utf-8'), *args)
def actionsf_sprite(*args, sprite, psize, pbuffer, format):
	_lib.actionf_sprite(sprite, psize, pbuffer, format.encode('utf-8'), *args)
def actionsf_init_sprite(*args, sprite, psize, pbuffer, format):
	_lib.actionf_init_sprite(sprite, psize, pbuffer, format.encode('utf-8'), *args)

def actions_free(buffer):
	_lib.actions_free(buffer)
