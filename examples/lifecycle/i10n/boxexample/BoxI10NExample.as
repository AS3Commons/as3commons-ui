package lifecycle.i10n.boxexample {
	import flash.display.Sprite;

	public class BoxI10NExample extends Sprite {
		public function BoxI10NExample() {
			I10NService.start();
			
			var box1 : Box = new Box("Box1");
			addChild(box1);

			var box2 : Box = new Box("Box2");
			box2.x = 120;
			box2.backgroundColor = 0x333333;
			box2.borderColor = 0x999999;
			box2.backgroundColor = 0x999999;
			box2.borderColor = 0x333333;
			addChild(box2);

			var box3 : Box = new Box("Box3");
			box3.x = 240;
			box3.backgroundColor = 0xCC0000;
			box3.borderColor = 0x550000;
			addChild(box3);
			box3.backgroundColor = 0x3366CC;
			box3.borderColor = 0x002244;

			var box4 : Box = new Box("Box4");
			box4.x = 360;
			addChild(box4);
			box4.backgroundColor = 0x3366CC;
			box4.borderColor = 0x002244;
			box4.backgroundColor = 0xCC6633;
			box4.borderColor = 0x442200;
		}
	}
}