package layer.placement.demo {
	import org.as3commons.ui.layer.Placement;
	import org.as3commons.ui.layer.placement.UsedPlacement;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class PlacementDemo extends Sprite {
		private var _placement : Placement;
		private var _controls : Controls;
		
		public function PlacementDemo() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);

			// bounds
			var bounds : Rectangle = new Rectangle(20, 20, 400, 300);
			with (graphics) {
				lineStyle(1, 0xCCCCCC);
				drawRect(bounds.x - 1, bounds.y - 1, bounds.width + 1, bounds.height + 1);
			}

			// source
			var source : DemoBox = new DemoBox("Source", 160, 150, 80, 80, 0xCCCCCC, 1, bounds);
			addChild(source);

			// layer
			var layer : DemoBox = new DemoBox("Layer", 0, 0, 50, 50, 0x4488DD, .5, null);
			layer.mouseEnabled = false;
			addChild(layer);

			// placement
			_placement = new Placement(source, layer);
			_placement.autoSwapAnchorsH = true;
			_placement.autoSwapAnchorsHDiff = 20;
			_placement.autoSwapAnchorsV = true;
			_placement.autoSwapAnchorsVDiff = 20;
			_placement.bounds = bounds;

			// controls
			_controls = new Controls();
			_controls.x = stage.stageWidth - 80;
			addEventListener("anchor", anchorChangedHandler);
			addEventListener("sourceposition", sourcePositionChangedHandler);
			addChild(_controls);
		}
		
		private function anchorChangedHandler(event : Event) : void {
			_placement.sourceAnchor = _controls.sourceAnchor;
			_placement.layerAnchor = _controls.layerAnchor;
			place();
		}

		private function sourcePositionChangedHandler(event : Event) : void {
			place();
		}
		
		private function place() : void {
			_placement.place();
			var box : DemoBox = _placement.layer as DemoBox;
			var used : UsedPlacement = _placement.usedPlacement;
			box.border = used.hShift != 0 || used.vShift != 0;
			box.setInfo(used.hShift, used.vShift, used.hSwapped, used.vSwapped);
		}
	}
}