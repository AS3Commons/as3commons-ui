package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;

	public class CellConfig4 extends Sprite {
		public function CellConfig4() {
			vgroup(
				cellconfig(
					"vIndex", 2,
					"marginY", 30
				),
				Box.create(8)
			).layout(this);
		}
	}
}