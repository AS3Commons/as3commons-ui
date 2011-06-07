package layer.placement.autoswap {
	import common.UIView;
	import layer.placement.common.Box;
	import org.as3commons.ui.layer.Placement;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class AutoSwap extends UIView {
		private var _placement : Placement;
		private var _controls : Controls;

		override public function draw() : void {
			// bounds
			var bounds : Rectangle = new Rectangle(70, 70, stage.stageWidth - 240, stage.stageHeight - 140);
			with (graphics) {
				lineStyle(1, 0xCCCCCC);
				drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			}

			// source
			var source : Box = new Box(40, 40, 200, 200, 0xDDDDDD, 1, 0x999999, false);
			source.addEventListener(MouseEvent.MOUSE_DOWN, sourceDownHandler);
			addChild(source);

			// layer
			var layer : Box = new Box(40, 15, 0, 0, 0x004499, .5, 0x666666, false);
			addChild(layer);

			// placement
			_placement = new Placement(source, layer);
			_placement.sourceAnchor = PlacementAnchor.TOP_RIGHT;
			_placement.layerAnchor = PlacementAnchor.BOTTOM_LEFT;
			_placement.bounds = bounds;
			_placement.place();

			// controls
			_controls = new Controls(sizeChanged);
			_controls.x = stage.stageWidth - 80;
			addEventListener("anchor", anchorChangedHandler);
			addEventListener("offset", offsetChangedHandler);
			addEventListener("autoswap", autoSwapChangedHandler);
			addChild(_controls);
		}

		private function sourceDownHandler(event : MouseEvent) : void {
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			var bounds : Rectangle = _placement.bounds.clone();
			bounds.inflate(55, 55);
			Box(_placement.source).beginDrag(bounds);
		}

		private function mouseMoveHandler(event : MouseEvent) : void {
			_placement.place();
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			Box(_placement.source).stopDrag();
			_placement.place();
		}

		private function anchorChangedHandler(event : Event) : void {
			_placement.sourceAnchor = _controls.sourceAnchor;
			_placement.layerAnchor = _controls.layerAnchor;
			_placement.place();
		}

		private function offsetChangedHandler(event : Event) : void {
			_placement.offset.x = _controls.offsetX;
			_placement.offset.y = _controls.offsetY;
			_placement.place();
		}

		private function autoSwapChangedHandler(event : Event) : void {
			_placement.autoSwapAnchors = _controls.autoSwapAnchors;
			_placement.autoSwapAnchorsHDiff = _controls.autoSwapHDiff;
			_placement.autoSwapAnchorsVDiff = _controls.autoSwapVDiff;
			_placement.place();
		}

		private function sizeChanged(width : uint, height : uint) : void {
			Box(_placement.layer).width = width;
			Box(_placement.layer).height = height;
			_placement.place();
		}
	}
}