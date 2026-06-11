
/*3 import flash.display.MovieClip;
import flash.display.Shape;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.events.MouseEvent;

class MyClip extends MovieClip {*/
	function on_Enter_Frame(){//3 function on_Enter_Frame(e){
		if(a){
			_x-=c;//3 x-=c;
			if(b){
				_y-=c;//3 y-=c;
				if(_y<=0){//3 if(y<=0){
					b=false;
				}
			}else{
				_y+=c;//3 y+=c;
				if(_y+_height>=Stage.height){//3 if(y+height>=stage.stageHeight){
					b=true;
				}
			}
			if(_x<=0){//3 if(x<=0){
				a=false;
			}
		}else{
			_x+=c;//3 x+=c;
			if(b){
				_y-=c;//3 y-=c;
				if(_y<=0){//3 if(y<=0){
					b=false;
				}
			}else{
				_y+=c;//3 y+=c;
				if(_y+_height>=Stage.height){//3 if(y+height>=stage.stageHeight){
					b=true;
				}
			}
			if(_x+_width>=Stage.width){//3 if(x+width>=stage.stageWidth){
				a=true;
			}
		}
	}
	// Handlers
	function onClick(){//3 function onClick(e){
		trace('Button clicked!');
	}
	function onOver(){//3 function onOver(e){
		_alpha = 80;//3 alpha = 0.8;
	}
	function onOut(){//3 function onOut(e){
		_alpha = 100;//3 alpha = 1;
	}
/*3
	public function new() {
		super();
*/
		// Simple visual so you can see it
		//3 var shape = new Shape();
		beginFill(0x3399FF);//3 shape.graphics.beginFill(0x3399FF);
		lineTo(120, 0);lineTo(120, 80);lineTo(0, 80);//3 shape.graphics.drawRect(0, 0, 120, 80);
		endFill();//3 shape.graphics.endFill();
		//3 addChild(shape);

		// a 1/5 margin
		createTextField('label', 1, 0, 16, 120, 48);//3 var label = new TextField();
		/*3
		label.y = 16;
		label.width = 120;
		label.height = 48;
		*/
		label.text = 'Click';
		label.selectable = false;

		// a 2/3 size format
		var tf = new TextFormat();
		tf.size = 32;
		tf.align = 'center';//3 tf.align = TextFormatAlign.CENTER;
		tf.color = 0xff9933;
		label.setTextFormat(tf);

		// Interactivity
		useHandCursor = true;//3 buttonMode = true;mouseChildren = false;
		onRollOver = onOver;//3 addEventListener(MouseEvent.MOUSE_OVER, onOver);
		onRollOut = onOut;//3 addEventListener(MouseEvent.MOUSE_OUT, onOut);
		onPress = onClick;//3 addEventListener(MouseEvent.CLICK, onClick);

		//3 addChild(label);

		onEnterFrame=on_Enter_Frame; //3 addEventListener(Event.ENTER_FRAME, on_Enter_Frame);
/*3	}
	static
*/
	var c=%u;
	var a=false;var b=false;
//3 }
