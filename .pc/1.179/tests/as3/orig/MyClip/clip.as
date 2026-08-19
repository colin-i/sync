
//3a MyClip flash.display.Sprite
	function on_Enter_Frame(){
		if(a){
			_x-=c;
			if(b){
				_y-=c;
				if(_y<=0){
					b=false;
				}
			}else{
				_y+=c;
				if(_y+_height>=Stage.height){
					b=true;
				}
			}
			if(_x<=0){
				a=false;
			}
		}else{
			_x+=c;
			if(b){
				_y-=c;
				if(_y<=0){
					b=false;
				}
			}else{
				_y+=c;
				if(_y+_height>=Stage.height){
					b=true;
				}
			}
			if(_x+_width>=Stage.width){
				a=true;
			}
		}
	}
	// Handlers
	function onClick(){
		trace('Button clicked!');
	}
	function onOver(){
		_alpha= 80;
	}
	function onOut(){
		_alpha= 100;
	}
	function new(){//3 f
		// Simple visual so you can see it
		beginFill(0x3399FF);
		lineTo(120, 0);lineTo(120, 80);lineTo(0, 80);
		endFill();//3 _

		// a 1/5 margin
		createTextField('label',1,0,16, 120, 48);
		label.text = 'Click';
		label.selectable = false;

		// a 2/3 size format
		var tf = new TextFormat();
		tf.size = 32;
		tf.align ='center';
		tf.color = 0xff9933;
		label.setTextFormat(tf);

		// Interactivity
		useHandCursor= true;//3 bm
		onRollOver = onOver;
		onRollOut = onOut;
		onPress = onClick;

		//3d label

		onEnterFrame = on_Enter_Frame;
	}
	//3x
	var c=%u;
	var a=false;var b=false;
//3}
new();
