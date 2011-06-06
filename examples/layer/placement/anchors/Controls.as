package layer.placement.anchors {
	import layer.placement.common.BoxAnchorControls;
	import layer.placement.common.OffsetControls;
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.display;
	import org.as3commons.ui.layout.shortcut.vgroup;

	public class Controls extends ControlPanelBase {
		private var _v : VGroup;
		
		public function Controls() {
			_v = vgroup(
				"gap", 8,
				headline("Source", 100),
				display(
					"id", "sourceControls",
					"offsetX", -5, "offsetY", -8,
					new BoxAnchorControls(0xDDDDDD, 1)
				),
				headline("Layer", 100),
				display(
					"id", "layerControls",
					"offsetX", -5, "offsetY", -8,
					new BoxAnchorControls(0x004499, .5)
				),
				headline("Offset", 100),
				display(
					"id", "offsetControls",
					new OffsetControls()
				)
			);
			_v.layout(this);
			setSize(_v.visibleRect.width, _v.visibleRect.height);
		}

		public function get sourceAnchor() : uint {
			return BoxAnchorControls(_v.getDisplayObject("sourceControls")).placementAnchor;
		}
		
		public function get layerAnchor() : uint {
			return BoxAnchorControls(_v.getDisplayObject("layerControls")).placementAnchor;
		}
		
		public function get offsetX() : uint {
			return OffsetControls(_v.getDisplayObject("offsetControls")).offsetX;
		}
		
		public function get offsetY() : uint {
			return OffsetControls(_v.getDisplayObject("offsetControls")).offsetY;
		}
	}
}