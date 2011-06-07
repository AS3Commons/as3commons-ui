package layer.placement.anchors {
	import common.ControlPanelBase;
	import layer.placement.common.*;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.*;

	public class Controls extends ControlPanelBase {
		private var _v : VGroup;
		
		public function Controls() {
			_v = vgroup(
				"gap", 5,
				cellconfig("vIndex", 1, "marginX", -3, "marginY", -5),
				cellconfig("vIndex", 2, "marginY", -5),
				cellconfig("vIndex", 3, "marginX", -3, "marginY", -5),
				cellconfig("vIndex", 4, "marginY", -5),
				headline("Source", 100),
				display(
					"id", "sourceControls",
					new BoxAnchorControls(0xCCCCCC, 1, PlacementAnchor.TOP_LEFT)
				),
				headline("Layer", 100),
				display(
					"id", "layerControls",
					new BoxAnchorControls(0x4488DD, .5, PlacementAnchor.TOP_LEFT)
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
		
		public function get offsetX() : int {
			return OffsetControls(_v.getDisplayObject("offsetControls")).offsetX;
		}
		
		public function get offsetY() : int {
			return OffsetControls(_v.getDisplayObject("offsetControls")).offsetY;
		}
	}
}