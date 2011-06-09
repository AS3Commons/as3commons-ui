package layer.placement.tooltipplacement {
	import common.UIView;
	import layer.placement.common.Box;
	import layer.placement.common.DefaultValues;
	import org.as3commons.ui.layer.Placement;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ToolTipPlacement extends UIView {
		private var _placement : Placement;
		private var _controls : Controls;

		public function ToolTipPlacement() {
			DefaultValues.width = 100;
			DefaultValues.height = 50;
			DefaultValues.offsetX = -25;
			DefaultValues.offsetY = 5;
			DefaultValues.autoSwapHDiff = 30;
			DefaultValues.autoSwapVDiff = 10;
			DefaultValues.minWidth = 40;
			DefaultValues.minHeight = 40;
		}

		override public function draw() : void {
			// bounds
			var bounds : Rectangle = new Rectangle(70, 70, stage.stageWidth - 240, stage.stageHeight - 160);
			with (graphics) {
				lineStyle(1, 0xCCCCCC);
				drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			}

			// source
			var source : Box = new Box(40, 40, 100, 200, 0xDDDDDD, 1, 0x999999, false, true);
			var dragBounds : Rectangle = bounds.clone();
			dragBounds.inflate(55, 55);
			source.dragBounds = dragBounds;
			addChild(source);

			// layer
			var layer : Tooltip = new Tooltip(0, 0, 0, 0, 0x4488DD, 1, 0x666666, false, false);
			addChild(layer);

			// placement
			_placement = new Placement(source, layer);
			_placement.sourceAnchor = PlacementAnchor.TOP_RIGHT;
			_placement.layerAnchor = PlacementAnchor.BOTTOM_LEFT;
			_placement.bounds = bounds;
			place();

			// controls
			_controls = new Controls(sizeChanged);
			_controls.x = stage.stageWidth - 80;
			addEventListener("anchor", anchorChangedHandler);
			addEventListener("offset", offsetChangedHandler);
			addEventListener("autoswap", autoSwapChangedHandler);
			addEventListener("layerposition", layerPositionChangedHandler);
			addChild(_controls);
		}

		private function anchorChangedHandler(event : Event) : void {
			Tooltip(_placement.layer).placementAnchor = _controls.layerAnchor;
			_placement.sourceAnchor = _controls.sourceAnchor;
			_placement.layerAnchor = _controls.layerAnchor;
			place();
		}

		private function offsetChangedHandler(event : Event) : void {
			_placement.offset.x = _controls.offsetX;
			_placement.offset.y = _controls.offsetY;
			place();
		}

		private function autoSwapChangedHandler(event : Event) : void {
			_placement.autoSwapAnchorsH = _controls.autoSwapAnchorsH;
			_placement.autoSwapAnchorsHDiff = _controls.autoSwapHDiff;
			_placement.autoSwapAnchorsV = _controls.autoSwapAnchorsV;
			_placement.autoSwapAnchorsVDiff = _controls.autoSwapVDiff;
			place();
		}

		private function layerPositionChangedHandler(event : Event) : void {
			place();
		}

		private function sizeChanged(width : uint, height : uint) : void {
			Box(_placement.layer).width = width;
			Box(_placement.layer).height = height;
			place();
		}
		
		private function place() : void {
			_placement.place();
			
			var tooltip : Tooltip = _placement.layer as Tooltip;
			tooltip.placementAnchor = _placement.usedPlacement.layerAnchor;
			tooltip.sourcePlacementAnchor = _placement.usedPlacement.sourceAnchor;
			tooltip.placementHShift = _placement.usedPlacement.hShift;
			tooltip.placementVShift = _placement.usedPlacement.vShift;
		}
	}
}