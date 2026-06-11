
//3 import flash.Lib;

/*3 class Main {
	static
	function main() {
		var stage = Lib.current.stage;
*/
		attachMovie('MyClip','shape',getNextHighestDepth());//3 var shape = new MyClip();
		shape._x = (Stage.width - 100) / 2;//3 shape.x = (stage.stageWidth - 100) / 2;
		shape._y = (Stage.height - 100) / 2;//3 shape.y = (stage.stageHeight - 100) / 2;
/*3
		stage.addChild(shape);

//		var img = new Bitmap( new MyBitmapData(0, 0) );
//		Lib.current.addChild(img);
	}
}

//import flash.display.BitmapData;
//import flash.display.Bitmap;
//@:bitmap('relative/path/to/myfile.png')
//class MyBitmapData extends BitmapData { }//*
*/
