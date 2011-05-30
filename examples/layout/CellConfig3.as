package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.HLayout;
	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;

	public class CellConfig3 extends Sprite {
		public function CellConfig3() {
			
			var h : HLayout = hlayout(
				"maxContentWidth", 150,
				cellconfig(
					"hIndex", 2, "vIndex", 1,
					"height", 60,
					"vAlign", Align.BOTTOM
				),
				cellconfig(
					"vIndex", 2,
					"width", 60, "height", 60,
					"hAlign", Align.RIGHT
				),
				cellconfig(
					"hIndex", 2, "vIndex", 3,
					"marginY", -30
				),
				Box.create(22)
			);
			h.layout(this);
		}
	}
}