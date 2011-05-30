package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.*;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class Exclude extends Sprite {
		private var _top : VGroup;
		private var _bottom : HLayout;

		public function Exclude() {
			_top = vgroup(
				"offsetX", 10, "offsetY", 10,
				"gap", 10,
				h1, h1
			);
			_bottom = hlayout(
				"offsetX", 10, "offsetY", 170,
				"maxItemsPerRow", 9
			);
			layout();

			addEventListener(MouseEvent.CLICK, clickHandler);
		}

		private function get h1() : HGroup { // 4 box grids in a line
			return hgroup("gap", 10, h2, h2, h2, h2);
		}
		
		private function get h2() : HLayout { // 2x2 box grid
			return hlayout("maxItemsPerRow", 2, Box.create(4));
		}

		private function clickHandler(event : MouseEvent) : void {
			var box : Box = event.target as Box;
			if (_bottom.getLayoutItem(box) == null) {
				_top.getLayoutItem(box).excludeFromLayout(false);
				_bottom.add(box);
			} else {
				_bottom.remove(box);
				_top.getLayoutItem(box).includeInLayout();
			}
			layout();
		}
		
		private function layout() : void {
			_top.layout(this);
			_bottom.layout(this);

			graphics.clear();
			drawRect(_top.visibleRect);
			drawRect(_bottom.visibleRect);
		}

		private function drawRect(rect : Rectangle) : void {
			if (rect.width) rect.inflate(10, 10);
			with (graphics) {
				beginFill(0x333333);
				drawRect(rect.x, rect.y, rect.width, rect.height);
			}
		}
	}
}