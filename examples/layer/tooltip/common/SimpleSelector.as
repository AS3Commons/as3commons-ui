package layer.tooltip.common {
	import layout.common.box.Box;
	import org.as3commons.ui.layer.tooltip.IToolTipSelector;
	import flash.display.DisplayObject;

	public class SimpleSelector implements IToolTipSelector {
		public function approve(displayObject : DisplayObject) : Boolean {
			return displayObject is Box;
		}
	}
}