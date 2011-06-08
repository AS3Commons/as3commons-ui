package layer.tooltip.animated {
	import layer.tooltip.common.SimpleSelector;
	import layer.tooltip.common.SimpleToolTip;
	import layout.common.box.Box;
	import org.as3commons.ui.layer.ToolTipManager;
	import org.as3commons.ui.layout.shortcut.hlayout;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class AnimatedExample extends Sprite {
		private var _toolTipManager : ToolTipManager;
		
		public function AnimatedExample() {
			var container : Sprite = stage.addChild(new Sprite()) as Sprite;
			_toolTipManager = new ToolTipManager(container);
			_toolTipManager.registerToolTip(
				new SimpleSelector(),
				new AnimatedAdapter(),
				new SimpleToolTip()
			);
			
			hlayout(
				"marginX", 20, "marginY", 20, 
				"maxItemsPerRow", 6,
				"hGap", 20, "vGap", 20,
				Box.create(18)
			).layout(this);
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		private function mouseOverHandler(event : MouseEvent) : void {
			var box : Box = event.target as Box;
			_toolTipManager.show(box, box.toString());
		}

		private function mouseOutHandler(event : MouseEvent) : void {
			_toolTipManager.hide();
		}
	}
}