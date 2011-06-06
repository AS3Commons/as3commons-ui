package layer.placement.anchors {
	import layer.placement.common.Box;
	import org.as3commons.ui.layer.Placement;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Anchors extends Sprite {
		private var _placement : Placement;
		private var _controls : Controls;
		
		public function Anchors() {
			// source
			var container : Sprite = new Sprite();
			container.x = 50;
			container.y = 300;
			addChild(container);
			var source : Box = new Box(160, 160, 50, -200, 0xDDDDDD, 1, 0x999999);
			container.addChild(source);

			// layer
			container = new Sprite();
			container.x = 200;
			container.y = 200;
			addChild(container);
			var layer : Box = new Box(80, 80, 0, 0, 0x004499, .5, 0x666666);
			container.addChild(layer);

			// placement
			_placement = new Placement(source, layer);
			_placement.place();

			// controls
			_controls = new Controls();
			_controls.x = 380;
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