package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.CellConfig;
	import org.as3commons.ui.layout.HLayout;
	import flash.display.Sprite;

	public class CellConfig2 extends Sprite {
		public function CellConfig2() {
			var h : HLayout = new HLayout();
			h.maxItemsPerRow = 6;
			
			var config : CellConfig = new CellConfig();
			config.marginY = 10;
			h.setCellConfig(config, -1, 2);
			
			config = new CellConfig();
			config.marginX = 10;
			h.setCellConfig(config, 2, -1);
			
			h.add(Box.create(24));
			h.layout(this);
		}
	}
}