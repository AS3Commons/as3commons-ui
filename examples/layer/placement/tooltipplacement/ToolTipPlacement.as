package layer.placement.tooltipplacement {
	import layer.placement.common.Box;
	import layer.placement.common.DefaultValues;
	import org.as3commons.ui.layer.Placement;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ToolTipPlacement extends Sprite {
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

			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);

			// bounds
			var bounds : Rectangle = new Rectangle(60, 60, 320, 280);
			with (graphics) {
				lineStyle(1, 0xCCCCCC);
				drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			}

			// source
			var dragBounds : Rectangle = bounds.clone();
			dragBounds.inflate(50, 50);
			var source : Box = new Box(40, 40, 160, 200, 0xDDDDDD, 1, 33, dragBounds);
			addChild(source);

			// layer
			var layer : ToolTip = new ToolTip(0x4488DD, .5);
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
			addEventListener("sourceposition", sourcePositionChangedHandler);
			addChild(_controls);
		}

		private function anchorChangedHandler(event : Event) : void {
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

		private function sourcePositionChangedHandler(event : Event) : void {
			place();
		}

		private function sizeChanged(width : uint, height : uint) : void {
			ToolTip(_placement.layer).setSize2(width, height);
			place();
		}
		
		private function place() : void {
			_placement.place();
			
			var tooltip : ToolTip = _placement.layer as ToolTip;
			tooltip.usedPlacement = _placement.usedPlacement;
		}
	}
}