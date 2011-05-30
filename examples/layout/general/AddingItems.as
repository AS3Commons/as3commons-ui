package layout.general {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.HGroup;
	import flash.display.Sprite;

	public class AddingItems extends Sprite {
		public function AddingItems() {
			var layout : HGroup = new HGroup();
			layout.add(new Box());
			layout.add(new Box(), new Box(), new Box());
			layout.add(Box.create(3)); // Array
			layout.add(new Box(), Box.create(2));
			layout.layout(this);
		}
	}
}