package layer.placement.autoswap {
	import common.ControlPanelBase;
	import layer.placement.common.*;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.cellconfig;
	import org.as3commons.ui.layout.shortcut.*;

	public class Controls extends ControlPanelBase {
		private var _v : VGroup;
		
		public function Controls(callback : Function) {
			_v = vgroup(
				"gap", 4,
				cellconfig("vIndex", 5, "marginY", 5),
				cellconfig("vIndex", 7, "marginY", 5),
				headline("Source", 100),
				display(
					"id", "sourceControls",
					"offsetX", -2, "offsetY", -4,
					new BoxAnchorControls(0xCCCCCC, 1, PlacementAnchor.TOP_RIGHT)
				),
				headline("Layer", 100),
				display(
					"id", "layerControls",
					"offsetX", -2, "offsetY", -4,
					new BoxAnchorControls(0x4488DD, .5, PlacementAnchor.BOTTOM_LEFT)
				),
				new LayerSizeControls(callback),
				headline("Offset", 100),
				display(
					"id", "offsetControls",
					new OffsetControls()
				),
				headline("Swap", 100),
				display(
					"id", "autoSwapControls",
					new AutoSwapControls()
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

		public function get autoSwapAnchors() : Boolean {
			return AutoSwapControls(_v.getDisplayObject("autoSwapControls")).autoSwap;
		}

		public function get autoSwapHDiff() : uint {
			return AutoSwapControls(_v.getDisplayObject("autoSwapControls")).autoSwapHDiff;
		}

		public function get autoSwapVDiff() : uint {
			return AutoSwapControls(_v.getDisplayObject("autoSwapControls")).autoSwapVDiff;
		}
	}
}