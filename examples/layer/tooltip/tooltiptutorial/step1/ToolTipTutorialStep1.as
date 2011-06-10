package layer.tooltip.tooltiptutorial.step1 {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ToolTipTutorialStep1 extends Sprite {
		public function ToolTipTutorialStep1() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);

			// init bounds
			var bounds : Rectangle = new Rectangle(20, 20, 400, 300);
			with (graphics) {
				lineStyle(1, 0xCCCCCC);
				drawRect(bounds.x - 1, bounds.y - 1, bounds.width + 1, bounds.height + 1);
			}
			Globals.bounds = bounds;

			// add content
			var items : Sprite = addChildAt(new Sprite(), 0) as Sprite;
			items.addChild(new Box(60, 60, 80, 40, 0xAAAAAA));
			items.addChild(new Box(120, 230, 60, 60, 0x666666));
			items.addChild(new Box(180, 100, 40, 80, 0xEE4400));
			items.addChild(new Box(300, 50, 60, 60, 0x0044EE));
			items.addChild(new Box(280, 180, 40, 40, 0x44CC44));
		}
	}
}