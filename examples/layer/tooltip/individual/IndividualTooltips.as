package layer.tooltip.individual {
	import layer.tooltip.advanced.*;
	import layer.tooltip.common.SimpleAdapter;
	import layer.tooltip.common.SimpleToolTip;
	import org.as3commons.ui.layer.ToolTipManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class IndividualTooltips extends Sprite {
		public function IndividualTooltips() {
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

			// boxes
			var box1 : Box = addChild(new Box(60, 60, 80, 40, 0xAAAAAA)) as Box;
			var box2 : Box = addChild(new Box(120, 230, 60, 60, 0x666666)) as Box;
			var box3 : Box = addChild(new Box(180, 100, 40, 80, 0xEE4400)) as Box;
			var box4 : Box = addChild(new Box(300, 50, 60, 60, 0x0044EE)) as Box;
			var box5 : Box = addChild(new Box(280, 180, 40, 40, 0x44CC44)) as Box;

			// init tooltips
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			Globals.toolTipManager = new ToolTipManager(container);
			
			// box1, box2 tooltip
			Globals.toolTipManager.registerToolTip(
				new IndividualSelector(box1, box2),
				new BoxToolTipAdapter(),
				new BoxToolTip()
			);

			// box3, box4, box5 tooltip
			Globals.toolTipManager.registerToolTip(
				new IndividualSelector(box3, box4, box5),
				new SimpleAdapter(),
				new SimpleToolTip()
			);
		}
	}
}