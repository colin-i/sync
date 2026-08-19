
class MyClip extends flash.display.Sprite{
	function on_Enter_Frame(e){
		if(a){
			x-=c;
			if(b){
				y-=c;
				if(y<=0){
					b=false;
				}
			}else{
				y+=c;
				if(y+height>=stage.stageHeight){
					b=true;
				}
			}
			if(x<=0){
				a=false;
			}
		}else{
			x+=c;
			if(b){
				y-=c;
				if(y<=0){
					b=false;
				}
			}else{
				y+=c;
				if(y+height>=stage.stageHeight){
					b=true;
				}
			}
			if(x+width>=stage.stageWidth){
				a=true;
			}
		}
	}
	// Handlers
	function onClick(e){
		trace('Button clicked!');
	}
	function onOver(e){
		alpha= 80/100;
	}
	function onOut(e){
		alpha= 100/100;
	}
	public function new(){super();
		// Simple visual so you can see it
		graphics.beginFill(0x3399FF);
		graphics.drawRect(0, 0,120, 80);
		graphics.endFill();

		// a 1/5 margin
		var label=new flash.text.TextField();label.y=16;label.width= 120;label.height= 48;
		label.text = 'Click';
		label.selectable = false;

		// a 2/3 size format
		var tf = new flash.text.TextFormat();
		tf.size = 32;
		tf.align =flash.text.TextFormatAlign.CENTER;
		tf.color = 0xff9933;
		label.setTextFormat(tf);

		// Interactivity
		buttonMode= true;useHandCursor= true;mouseChildren=false;
		addEventListener(flash.events.MouseEvent.MOUSE_OVER, onOver);
		addEventListener(flash.events.MouseEvent.MOUSE_OUT, onOut);
		addEventListener(flash.events.MouseEvent.CLICK, onClick);

		addChild(label);

		addEventListener(flash.events.Event.ENTER_FRAME, on_Enter_Frame);
	}
	static
	var c=2;
	var a=false;var b=false;
}

