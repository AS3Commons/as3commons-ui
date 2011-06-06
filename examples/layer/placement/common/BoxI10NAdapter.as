package layer.placement.common {
	import org.as3commons.ui.lifecycle.i10n.II10NApapter;
	import flash.display.DisplayObject;
	import org.as3commons.collections.framework.ISet;

	public class BoxI10NAdapter implements II10NApapter {
		public function willValidate(displayObject : DisplayObject) : void {
			// do nothing
		}

		public function validate(displayObject : DisplayObject, properties : ISet) : void {
			Box(displayObject).draw();
		}
	}
}