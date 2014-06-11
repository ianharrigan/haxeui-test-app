package haxe.ui.test;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

class InteractiveBackground extends Sprite {
	public function new() {
		super();
		
		var background:Bitmap = new Bitmap(Assets.getBitmapData("img/slinky_large.jpg"));
		addChild(background);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}
	
	private function onMouseMove(event:MouseEvent):Void {
		var newCircle:BlueCircle = new BlueCircle();
		addChild(newCircle);
        newCircle.x = event.stageX;
        newCircle.y = event.stageY;
	}
}

class BlueCircle extends Sprite {
	public function new() {
		super();
		graphics.beginFill(0x0000FF);
		graphics.drawCircle(10, 10, 10);
		graphics.endFill();
	}
}