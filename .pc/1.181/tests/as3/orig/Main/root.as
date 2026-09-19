/*3
m ../a.jpg My_BitmapData
c no dbl at haxe but still can do @:bitmap('a.jpg', 'mask.png') for jpeg+alphaChannel, more at tmp

a Main
	x*/
	function main(){
		//3g

		var texture=flash.display.BitmapData.loadBitmap('My_BitmapData');
		createEmptyMovieClip('text',getNextHighestDepth());
		var matrix=new flash.geom.Matrix();
		text.beginBitmapFill(texture,matrix,true);
		text.lineTo(120, 0);text.lineTo(120, 80);text.lineTo(0, 80);
		text.endFill();

		attachMovie('MyClip','shape',getNextHighestDepth());
		shape._x = (Stage.width - 100) / 2;
		shape._y = (Stage.height - 100) / 2;

		//more tests
		var a=1;
		attachMovie('MyClip2','shape2', getNextHighestDepth());shape2.b=a;shape2.c=a;
		trace("shape2 b is this: "+shape2.b);
		//3n
		Loader();
		Loader();
		if(a)
			trace("okkkkkkkkkkkkkkk");
		var b=0;
		if(!b)
			trace("okkkkkkkkkkkkkkk2");
		var arcon=new Array(1,2,3);
		/*3^
		//dual mode
		trace('dual mode here is visible only on as3');
		*/
		//3^trace('dual mode here is visible only on as3');
		var c=new Object();//3_ MyClip
		createEmptyMovieClip('solved_w'+1, getNextHighestDepth());
	}
//3}
function Loader(){//3f
trace('the loader is working');
}
//3}
/*more tests
//3d text stage
//3d shape @
//3i a.b.c
//3f s
//3f p
//3v shape Shape
//3w shape Shape

_q=new Array(q,w,2);//3 a+s
q=new Array(q,w,2);//3
useHandCursor=_x;//3 b+s
useHandCursor=x;//3
function ()()//3 e+e
()//3
function dollar$_isok_at_as2(){//3 f+e
function new//3
function newq//3
var _a;//3 gArray+s
_alpha=_x;//3 h+s
_alpha=x;//3
_leftPart='type';//3 j+s
='type';//3
(_)//3k+s
(a)//3
begin(a);_x//3 l q+s
var texture=flash.display.BitmapData._loadBitmap('My_BitmapData');//3 m+s
a= 'q'//3
L_oader();//3 n+s
Loader;//3
onEnterFrame=_fune;//3 o+s
onEnterFrame=q;//3
var _z=new Object(//3 pq+s
line(_width,_y);line(_width,_height);line(_x,_height);//3 r q+s
_x()//3 s+e
_y()//3 s_+e
_x//3
create('q',n,_x,_y,_width,_height);//3 t+s
createTextField('label',1,0,16, 120, 48);//3
attach('q','_p',d);//3 v+s
create('_p',d);//3 V+s
create('_p'+1,d);//3 W+s
att('name','q',getNextHighest);//3
create('q',d);//3 v flash.display.DisplayObjectContainer
create('q',d);//3 V flash
w.attach('q','_p',d);//3 V
att('name','q'+2,getNext);//3w
create('q'+1,d);//3 w
create('q'+1,d);//3 w flash
w.attach('q','_p'+1,d);//3 W flash
_qty//3z wer ty+s
*/
/*3
v is_dual_mode_off MyClip
*/
main();
