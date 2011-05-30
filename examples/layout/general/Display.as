package layout.general {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.HGroup;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;

	public class Display extends Sprite {
		public function Display() {
			var layout : HGroup = hgroup(
				new Box(),
				new Box(),
				new Box(),
				display(
					"id", "box",
					"marginX", 20, "marginY", 20,
					new Box()
				),
				new Box(),
				new Box(),
				new Box()
			);
			layout.layout(this);
		}
	}
}