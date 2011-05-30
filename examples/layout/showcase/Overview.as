package layout.showcase {

	import layout.common.box.Box;

	import org.as3commons.ui.layout.HLayout;
	import org.as3commons.ui.layout.VLayout;
	import org.as3commons.ui.layout.shortcut.hlayout;
	import org.as3commons.ui.layout.shortcut.vlayout;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author Jens Struwe 13.04.2011
	 */
	public class Overview extends Sprite {
		public function Overview() {

			// HLayout
			var hLayout : HLayout = hlayout(
				"marginX", 10, "marginY", 10,
				"maxItemsPerRow", 5,
				"hGap", 1, "vGap", 1,

				createBoxes(18)
			);
			hLayout.layout(this);
			drawRect(hLayout.visibleRect, 0xCCCCCC);

			// VLayout
			var vLayout : VLayout = vlayout(
				"marginX", 150, "marginY", 10,
				"maxItemsPerColumn", 4,
				"hGap", 1, "vGap", 1,

				createBoxes(18)
			);
			vLayout.layout(this);
			drawRect(vLayout.visibleRect, 0xCCCCCC);


		}

		private function drawRect(rect : Rectangle, color : uint) : void {
			rect.inflate(10, 10);
			with (graphics) {
				beginFill(color);
				drawRect(rect.x, rect.y, rect.width, rect.height);
			}
		}

		private function createBoxes(numBoxes : uint) : Array {
			Box.setNextID(1);
			return Box.create(numBoxes, true, 20, 20);
		}
	}
}
