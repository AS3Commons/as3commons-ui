package layer.placement.common {
	import org.as3commons.ui.lifecycle.i10n.AllSelector;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;

	public class BoxI10N {
		private static var _i10n : Invalidation;
		public static function get i10n() : Invalidation {
			if (!_i10n) {
				_i10n = new Invalidation();
				_i10n.registerAdapter(new AllSelector(), new BoxI10NAdapter());
			}
			return _i10n;
		}
	}
}

import layer.placement.common.Box;
import org.as3commons.collections.framework.ISet;
import org.as3commons.ui.lifecycle.i10n.II10NApapter;
import flash.display.DisplayObject;

internal class BoxI10NAdapter implements II10NApapter {
	public function willValidate(displayObject : DisplayObject) : void {
		// do nothing
	}
	public function validate(displayObject : DisplayObject, properties : ISet) : void {
		Box(displayObject).draw();
	}
}