package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.*;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;

	public class AddressingItems1 extends Sprite {
		public function AddressingItems1() {
			var h : HGroup = hgroup(
				new Box(),
				vgroup(
					"id", "vgroup",
					Box.create(2)
				),
				new Box(),
				display(
					"id", "lastbox",
					new Box()
				)
			);
			
			var v : VGroup = h.getLayoutItem("vgroup") as VGroup;
			v.marginX = 20;
			v.marginY = 20;
			
			var d : Display = h.getLayoutItem("lastbox") as Display;
			d.marginX = -10;
			d.marginY = 10;
			var box : Box = d.displayObject as Box;
			box.scaleX = box.scaleY = 2;
			
			h.layout(this);
		}
	}
}