package layer.tooltip.advanced {
	import org.as3commons.ui.layer.ToolTipManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class AdvancedExample extends Sprite {
		public function AdvancedExample() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// init bounds
			var bounds : Rectangle = new Rectangle(20, 20, 400, 300);
			with (graphics) {
				lineStyle(1, 0xCCCCCC);
				drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			}
			Globals.bounds = bounds;

			// init tooltips
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			Globals.toolTipManager = new ToolTipManager(container);
			Globals.toolTipManager.registerToolTip(
				new BoxToolTipSelector(),
				new BoxToolTipAdapter(),
				new BoxToolTip()
			);

			// add content
			addChild(new Box(60, 60, 80, 40, 0xAAAAAA));
			addChild(new Box(120, 230, 60, 60, 0x666666));
			addChild(new Box(180, 100, 40, 80, 0xEE4400));
			addChild(new Box(300, 50, 60, 60, 0x0044EE));
			addChild(new Box(280, 180, 40, 40, 0x44CC44));
		}
	}
}