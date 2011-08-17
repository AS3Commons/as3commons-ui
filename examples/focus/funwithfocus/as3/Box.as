package focus.funwithfocus.as3 {

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Box extends Sprite {
		public function Box() {
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		public function draw(color : uint) : void {
			with (graphics) {
				beginFill(color);
				drawRect(0, 0, 30, 30);
			}
		}

		private function mouseDown(event : MouseEvent) : void {
			stage.focus = this;
		}
		
		override public function toString() : String {
			return name;
		}
	}
}