package layer.tooltip.tooltiptutorial.final {
	import org.as3commons.ui.layer.tooltip.IToolTipSelector;
	import flash.display.DisplayObject;

	public class BoxToolTipSelector implements IToolTipSelector {
		public function approve(displayObject : DisplayObject) : Boolean {
			return displayObject is Box;
		}
	}
}