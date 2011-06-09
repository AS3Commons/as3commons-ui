package layer.placement.anchors {
	import layer.placement.common.Box;
	import org.as3commons.ui.layer.Placement;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Anchors extends Sprite {
		private var _placement : Placement;
		private var _controls : Controls;
		
		public function Anchors() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);

			// source
			var container : Sprite = new Sprite();
			container.x = 50;
			container.y = 300;
			addChild(container);
			var source : Box = new BoxWithAnchors(
				160, 160, 60, -190, 0xCCCCCC, 1,
				0x999999,PlacementAnchor.TOP_LEFT, null
			);
			container.addChild(source);

			// layer
			container = new Sprite();
			container.x = 200;
			container.y = 200;
			addChild(container);
			var layer : Box = new BoxWithAnchors(
				80, 80, 0, 0, 0x4488DD, .5,
				0x666666, PlacementAnchor.TOP_LEFT, null
			);
			container.addChild(layer);

			// placement
			_placement = new Placement(source, layer);
			_placement.place();

			// controls
			_controls = new Controls();
			_controls.x = stage.stageWidth - 80;
			addEventListener("anchor", anchorChangedHandler);
			addEventListener("offset", offsetChangedHandler);
			addChild(_controls);
		}
		
		private function anchorChangedHandler(event : Event) : void {
			// highlight selected anchor
			Box(_placement.source).placementAnchor = _controls.sourceAnchor;
			Box(_placement.layer).placementAnchor = _controls.layerAnchor;
			// recalculate position
			_placement.sourceAnchor = _controls.sourceAnchor;
			_placement.layerAnchor = _controls.layerAnchor;
			_placement.place();
		}

		private function offsetChangedHandler(event : Event) : void {
			_placement.offset.x = _controls.offsetX;
			_placement.offset.y = _controls.offsetY;
			_placement.place();
		}
	}
}