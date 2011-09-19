package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.HLayout;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;

	public class CellConfig1 extends Sprite {
		public function CellConfig1() {
			var h : HLayout = hlayout(
				"maxItemsPerRow", 6,
				cellconfig("vIndex", 2, "marginY", 10),
				cellconfig("hIndex", 2, "marginX", 10),
				Box.create(24)
			);
			h.layout(this);
		}
	}
}