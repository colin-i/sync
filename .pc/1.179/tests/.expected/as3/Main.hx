
@:bitmap('../a.jpg') class My_BitmapData extends flash.display.BitmapData { }
// no dbl at haxe but still can do @:bitmap('a.jpg', 'mask.png') for jpeg+alphaChannel, more at tmp

class Main{
	static
	function main(){
		var stage=flash.Lib.current.stage;

		var texture=new My_BitmapData(0,0);
		var text=new flash.display.Shape();
		var matrix=new flash.geom.Matrix();
		text.graphics.beginBitmapFill(texture,matrix,true);
		text.graphics.drawRect(0, 0,120, 80);
		text.graphics.endFill();
		stage.addChild(text);

		var shape=new MyClip();
		shape.x = (stage.stageWidth - 100) / 2;
		shape.y = (stage.stageHeight - 100) / 2;
		stage.addChild(shape);

		new
		Loader();
	}
}
class Loader{public function new(){
trace('the loader is working');
}
}

/*more tests
import a.b.c;
static function main(){
public function new(){super();
var shape=new Shape();

buttonMode=x;useHandCursor=x;
function (e)(e)
class dollar$_isok_at_as2{public function new(e){
leftPart=flash.text.TextFormatAlign.TYPE;
q.graphics.begin(a);x
var texture=new MyBitmapData(0,0);
addEventListener(flash.events.Event.ENTERFRAME,fune);
alpha=x/100;
q.graphics.drawRect(x,y,width,height);
x(e)
y(e)
var q=new flash.text.TextField();q.x=x;q.y=y;q.width=width;q.height=height;
var p=new q();
qwerty

buttonMode=x;useHandCursor=x;
(e)
public function newsuper();
a=new q(0,0);
addEventListener(flash.events.Event.ENTER_FRAME,q);
alpha=x/100;
x
var label=new flash.text.TextField();label.y=16;label.width= 120;label.height= 48;
var q=new name();
=flash.text.TextFormatAlign.TYPE;
*/

