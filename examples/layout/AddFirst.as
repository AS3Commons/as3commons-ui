package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.HLayout;
	import flash.display.Sprite;

	public class AddFirst extends Sprite {
		public function AddFirst() {
			var h : HLayout = new HLayout();
			h.maxItemsPerRow = 5;
			
			h.add(Box.create(5)); // 1-5
			h.addFirst(Box.create(5)); // 6-10,1-5
			h.add(Box.create(5)); // 6-10,1-5,11-15
			h.addFirst(new Box(true)); // 16,6-10,1-5,11-15
			h.add(new Box(true));// 16,6-10,1-5,11-15,17

			h.layout(this);
		}
	}
}