package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.*;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;

	public class AddressingItems3 extends Sprite {
		public function AddressingItems3() {
			var box : Box = new Box();
			
			var h : HGroup = hgroup(
				"gap", 1,
				Box.create(4),
				box,
				Box.create(5)
			);
			
			var d : Display = h.getLayoutItem(box) as Display;
			d.marginX = d.marginY = 20;

			h.layout(this);
		}
	}
}