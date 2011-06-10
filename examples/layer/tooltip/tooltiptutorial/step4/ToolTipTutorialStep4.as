package layer.tooltip.tooltiptutorial.step4 {
	import layer.tooltip.tooltiptutorial.final.Box;
	import layer.tooltip.tooltiptutorial.final.BoxToolTipSelector;
	import layer.tooltip.tooltiptutorial.final.Globals;
	import layer.tooltip.tooltiptutorial.step1.BoxToolTip;
	import org.as3commons.ui.layer.ToolTipManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ToolTipTutorialStep4 extends Sprite {
		public function ToolTipTutorialStep4() {
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

			// init tooltips
			var container : Sprite = addChild(new Sprite()) as Sprite;
			Globals.toolTipManager = new ToolTipManager(container);
			Globals.toolTipManager.registerToolTip(
				new BoxToolTipSelector(),
				new BoxToolTipAdapter(),
				new BoxToolTip()
			);

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