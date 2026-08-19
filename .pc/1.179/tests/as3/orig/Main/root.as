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
		//3d text stage

		attachMovie('MyClip','shape',getNextHighestDepth());
		shape._x = (Stage.width - 100) / 2;
		shape._y = (Stage.height - 100) / 2;
		//3d shape @

		//3n
		Loader();
	}
//3}
function Loader(){//3f
trace('the loader is working');
}
//3}

/*more tests
//3i a.b.c
//3f s
//3f p
//3v shape Shape

useHandCursor=_x;//3 b+s
function ()()//3 e+e
function dollar$_isok_at_as2(){//3 f+e
_leftPart='type';//3 j+s
begin(a);_x//3 l q+s
var texture=flash.display.BitmapData._loadBitmap('My_BitmapData');//3 m+s
onEnterFrame=_fune;//3 o+s
_alpha=_x;//3 h+s
line(_width,_y);line(_width,_height);line(_x,_height);//3 r q+s
_x()//3 s+e
_y()//3 s_+e
create('q',n,_x,_y,_width,_height);//3 t+s
attach('q','_p',d);//3 v+s
_qty//3z wer ty+s

useHandCursor=x;//3
()//3
function new//3
a= 'q'//3
onEnterFrame=q;//3
_alpha=x;//3
_x//3
createTextField('label',1,0,16, 120, 48);//3
att('name','q',getNextHighest);//3
='type';//3
*/
main();
