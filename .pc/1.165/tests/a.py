
import actionswf
import os
if os.environ.get('break'):
	import pdb; pdb.set_trace()

def text(name):
	return open(name).read()

actionswf.xlog_pad_set(0x30)

import sys
if len(sys.argv)==1:
	f=actionswf.flags.prexx|actionswf.flag.pre_x_pad|actionswf.flag.pre_write_no
else:
	f=actionswf.flagss.xxu|actionswf.flag.titles
print("%x" % f)

actionswf.new_ex("a.swf",0x80,0x80,0x050607,2,f)
format=text("./aoc/a")
size=actionswf.ActionSize()
buffer=actionswf.ActionBuffer()
actionswf.actionsf(psize=actionswf.Ref(size),pbuffer=actionswf.Ref(buffer),format=format,*[1,b'a'])
actionswf.actions_free(buffer)
presprite=actionswf.sprite_new()
actionswf.action_sprite(presprite,"trace('b'+this.value)")
actionswf.action_init_sprite(presprite,text("./aoc/b"))
sprite=actionswf.sprite_done(presprite)
actionswf.exports_add(sprite,"carSymbol")

actionswf.done()

exit(0)
