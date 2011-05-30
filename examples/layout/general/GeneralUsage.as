package layout.general {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.HGroup;
	import flash.display.Sprite;

	public class GeneralUsage extends Sprite {
		public function GeneralUsage() {
			var layout : HGroup = new HGroup();
			layout.add(new Box());
			layout.add(new Box());
			layout.add(new Box());
			layout.layout(this);
		}
	}
}