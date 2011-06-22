package layer.tooltip.contextual {
	import layer.tooltip.common.SimpleToolTip;
	import org.as3commons.ui.layer.ToolTipManager;
	import org.as3commons.ui.layer.tooltip.AllSelector;
	import org.as3commons.ui.layout.shortcut.hlayout;
	import flash.display.Sprite;
	import flash.events.Event;

	public class ContextualToolTips extends Sprite {
		public static var toolTipManager : ToolTipManager;
		
		public function ContextualToolTips() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);

			// init tooltips
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			toolTipManager = new ToolTipManager(container);
			toolTipManager.registerToolTip(
				new AllSelector(),
				new ContextualToolTipAdapter(),
				new SimpleToolTip()
			);

			// setup boxes
			hlayout(
				"marginX", 150, "marginY", 50,
				"maxItemsPerRow", 2,
				"hGap", 20, "vGap", 20,
				new Box("Box1", 0xAAAAAA),
				new Box("Box2", 0xEE4400),
				new Box("Box3", 0x0044EE),
				new Box("Box4", 0x44CC44)
			).layout(this);
		}
	}
}