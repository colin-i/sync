
@:bitmap('../a.jpg') class My_BitmapData extends flash.display.BitmapData { }
// no dbl at haxe but still can do @:bitmap('a.jpg', 'mask.png') for jpeg+alphaChannel, more at tmp

class Main{
	static
	function main(){
		var stage=flash.Lib.current.stage;

		var texture=new My_BitmapData(0,0);
		var text=new flash.display.Shape();stage.addChild(text);
		var matrix=new flash.geom.Matrix();
		text.graphics.beginBitmapFill(texture,matrix,true);
		text.graphics.drawRect(0, 0,120, 80);
		text.graphics.endFill();

		var shape=new MyClip();stage.addChild(shape);
		shape.x = (stage.stageWidth - 100) / 2;
		shape.y = (stage.stageHeight - 100) / 2;

		//more tests
		var a=1;
		var shape2=new MyClip2(a,a);stage.addChild(shape2);shape2.name='shape2';
		trace("shape2 b is this: "+shape2.b);
		new 
		Loader();
		new Loader();
		if(a!=0)
			trace("okkkkkkkkkkkkkkk");
		var b=0;
		if(b==0)
			trace("okkkkkkkkkkkkkkk2");
		var arcon=[1,2,3];
		
		//dual mode
		trace('dual mode here is visible only on as3');
		
		trace('dual mode here is visible only on as3');
		var c=new MyClip();
		var solved_w=new flash.display.Shape();stage.addChild(solved_w);solved_w.name='solved_w'+1;
	}
}
class Loader{public function new(){
trace('the loader is working');
}
}
/*more tests
stage.addChild(text);
stage.addChild(shape);
import a.b.c;
static function main(){
public function new(){super();
var shape=new Shape();
var shape=new Shape();shape.name='shape';

q=[q,w,2];
q=[q,w,2];
buttonMode=x;useHandCursor=x;
buttonMode=x;useHandCursor=x;
function (e)(e)
(e)
class dollar$_isok_at_as2{public function new(e){
public function newsuper();
class newq{public function new
var a:Array<Dynamic>;
alpha=x/100;
alpha=x/100;
leftPart=flash.text.TextFormatAlign.TYPE;
=flash.text.TextFormatAlign.TYPE;
(!=0)
(a!=0)
q.graphics.begin(a);x
var texture=new MyBitmapData(0,0);
a=new q(0,0);
new Loader();
new Loader;
stage.addEventListener(flash.events.Event.ENTERFRAME,fune);
stage.addEventListener(flash.events.Event.ENTER_FRAME,q);
var z=new q(
q.graphics.drawRect(x,y,width,height);
x(e)
y(e)
x
var q=new flash.text.TextField();q.x=x;q.y=y;q.width=width;q.height=height;
var label=new flash.text.TextField();label.y=16;label.width= 120;label.height= 48;
var p=new q();
var p=new flash.display.Shape();stage.addChild(p);
var p=new flash.display.Shape();stage.addChild(p);p.name='p'+1;
var q=new name();
var q=new flash.display.DisplayObjectContainer();
var q=new flash();stage.addChild(q);
var _p=new q();w.addChild(_p);
var q=new name();q.name='q'+2;
var q=new flash.display.Shape();q.name='q'+1;
var q=new flash();q.name='q'+1;
var q=new flash();w.addChild(q);q.name='q';
qwerty
*/

var is_dual_mode_off=new MyClip();


