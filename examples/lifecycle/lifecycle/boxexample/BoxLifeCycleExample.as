package lifecycle.lifecycle.boxexample {
	import flash.utils.setTimeout;
	import flash.display.Sprite;

	public class BoxLifeCycleExample extends Sprite {
		private var _box1 : Box;
		private var _box2 : Box;
		private var _box3 : Box;
		private var _box4 : Box;
		
		public function BoxLifeCycleExample() {
			LifeCycleService.start();
			
			_box1 = new Box("Box1");
			addChild(_box1);

			_box2 = new Box("Box2");
			_box2.x = 120;
			_box2.backgroundColor = 0x333333;
			_box2.borderColor = 0x999999;
			_box2.backgroundColor = 0x999999;
			_box2.borderColor = 0x333333;
			addChild(_box2);

			_box3 = new Box("Box3");
			_box3.x = 240;
			_box3.backgroundColor = 0xCC0000;
			_box3.borderColor = 0x550000;
			addChild(_box3);
			_box3.backgroundColor = 0x3366CC;
			_box3.borderColor = 0x002244;

			_box4 = new Box("Box4");
			_box4.x = 360;
			addChild(_box4);
			_box4.backgroundColor = 0x3366CC;
			_box4.borderColor = 0x002244;
			_box4.backgroundColor = 0xCC6633;
			_box4.borderColor = 0x442200;
			
			setTimeout(update, 1000);
		}
		
		private function update() : void {
			_box1.backgroundColor = 0x990099;
			_box1.borderColor = 0x330033;
			_box1.backgroundColor = 0x009900;
			_box1.borderColor = 0x003300;

			_box2.backgroundColor = 0x999999;
			_box2.borderColor = 0x333333;
			_box2.backgroundColor = 0x333333;
			_box2.borderColor = 0x999999;

			_box3.backgroundColor = 0x3366CC;
			_box3.borderColor = 0x002244;
			_box3.backgroundColor = 0xCC0000;
			_box3.borderColor = 0x550000;

			_box4.backgroundColor = 0xCC6633;
			_box4.borderColor = 0x442200;
			_box4.backgroundColor = 0x3366CC;
			_box4.borderColor = 0x002244;
		}
	}
}