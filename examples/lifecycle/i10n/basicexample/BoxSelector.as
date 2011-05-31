package lifecycle.i10n.basicexample {
	import org.as3commons.ui.lifecycle.i10n.II10NSelector;
	import flash.display.DisplayObject;

	public class BoxSelector implements II10NSelector {
		public function approve(displayObject : DisplayObject) : Boolean {
			return displayObject is Box;
		}
	}
}