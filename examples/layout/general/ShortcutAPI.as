package layout.general {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.HGroup;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import flash.display.Sprite;

	public class ShortcutAPI extends Sprite {
		public function ShortcutAPI() {
			var layout : HGroup = hgroup(
				new Box(),
				new Box(),
				new Box()
			);
			layout.layout(this);
		}
	}
}