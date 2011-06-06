package common {
	import org.as3commons.ui.lifecycle.i10n.AllSelector;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;

	public class UII10N {
		private static var _i10n : Invalidation;
		public static function get i10n() : Invalidation {
			if (!_i10n) {
				_i10n = new Invalidation();
				_i10n.registerAdapter(new AllSelector(), new UIViewI10NAdapter());
			}
			return _i10n;
		}
	}
}

import common.UIView;
import org.as3commons.collections.framework.ISet;
import org.as3commons.ui.lifecycle.i10n.II10NApapter;
import flash.display.DisplayObject;

internal class UIViewI10NAdapter implements II10NApapter {
	public function willValidate(displayObject : DisplayObject) : void {
		// do nothing
	}
	public function validate(displayObject : DisplayObject, properties : ISet) : void {
		UIView(displayObject).draw();
	}
}