package layout.general {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.HGroup;
	import flash.display.Sprite;

	public class AddAll extends Sprite {
		public function AddAll() {
			addChild(new Box());
			addChild(new Box());
			addChild(new Box());
			addChild(new Box());
			addChild(new Box());
			
			var layout : HGroup = new HGroup();
			layout.addAll(this);
			layout.layout(this);
		}
	}
}