package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.*;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;

	public class AddressingItems2 extends Sprite {
		public function AddressingItems2() {
			var v : VGroup = vgroup(
				"gap", 10,
				h1("firstrow"), h1("secondrow")
			);
			
			var d : Display = v.getLayoutItem("firstrow", "firstgrid", "firstbox") as Display;
			d.displayObject.scaleX = d.displayObject.scaleY = 2;
			
			d = v.getLayoutItem("secondrow", "lastgrid", "firstbox") as Display;
			d.displayObject.scaleX = d.displayObject.scaleY = 2;

			var h : HLayout = v.getLayoutItem("secondrow", "firstgrid") as HLayout;
			h.marginX = 40;

			var hg : HGroup = v.getLayoutItem("firstrow") as HGroup;
			hg.gap = 30;

			v.layout(this);
		}

		private function h1(id : String = "") : HGroup { // 4 box grids in a line
			var h : HGroup = hgroup(
				"gap", 10,
				h2("firstgrid"),
				h2(), h2(),
				h2("lastgrid")
			);
			if (id) h.id = id;
			return h;
		}
		
		private function h2(id : String = "") : HLayout { // 2x2 box grid
			var h : HLayout = hlayout(
				"maxItemsPerRow", 2,
				display("id", "firstbox", new Box()),
				Box.create(2),
				display("id", "lastbox", new Box())
			);
			if (id) h.id = id;
			return h;
		}
	}
}