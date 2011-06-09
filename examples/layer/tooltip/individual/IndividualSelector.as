package layer.tooltip.individual {
	import org.as3commons.ui.layer.tooltip.IToolTipSelector;
	import flash.display.DisplayObject;

	public class IndividualSelector implements IToolTipSelector {
		private var _boxes : Array;

		public function IndividualSelector(...args) {
			_boxes = args;
		}
		
		public function approve(displayObject : DisplayObject) : Boolean {
			return _boxes.indexOf(displayObject) > -1;
		}
	}
}