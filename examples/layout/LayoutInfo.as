package layout {
	import layout.common.box.Box;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.ui.layout.Table;
	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.framework.IDisplay;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class LayoutInfo extends Sprite {
		public function LayoutInfo() {
			var t : Table = table(
				"minWidth", 400, "minHeight", 200,
				"numColumns", 8,
				"hGap", 10, "vGap", 10,
				"hAlign", Align.CENTER, "vAlign", Align.MIDDLE,
				cellconfig(
					"hAlign", Align.CENTER, "vAlign", Align.MIDDLE
				),
				Box.create(20, true, 20, 40)
			);
			t.layout(this);
			
			drawRect(this, t.contentRect, 0xCCCCCC, 0);
			drawRect(this, t.visibleRect, 0xFFFFFF, 0);
			
			var layer : Sprite = new Sprite();
			layer.alpha = .9;
			addChild(layer);

			var d : IDisplay;
			var iterator : IIterator = t.iterator();
			while (iterator.hasNext()) {
				d = iterator.next();
				drawRect(layer, d.contentRect, 0xFFFFFF, 0x666666);
				drawRect(layer, d.visibleRect, 0, 0xFF0000);
			}
		}

		private function drawRect(sprite : Sprite, rect : Rectangle, color : uint, border : uint) : void {
			with (sprite.graphics) {
				if (border) lineStyle(1, border);
				if (color) beginFill(color);
				drawRect(rect.x, rect.y, rect.width, rect.height);
				lineStyle(undefined);
				endFill();
			}
		}
	}
}