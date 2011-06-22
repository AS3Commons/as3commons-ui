package layer.tooltip.contextual {
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class Box extends Sprite {
		private var _label : String;
		
		public function Box(label : String, color : uint) {
			_label = label;
			with (graphics) {
				beginFill(color);
				drawRect(0, 0, 40, 40);
			}
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}

		public function get label() : String {
			return _label;
		}

		private function rollOver(event : MouseEvent) : void {
			ContextualToolTips.toolTipManager.show(this, "Tooltip for " + _label);
		}

		private function rollOut(event : MouseEvent) : void {
			ContextualToolTips.toolTipManager.hide();
		}
	}
}