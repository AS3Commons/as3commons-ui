package layer.placement.anchors {
	import layer.placement.common.Box;
	import org.as3commons.ui.layer.Placement;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class Anchors extends Sprite {
		private var _source : Box;
		private var _layer : Box;
		private var _controls : Controls;
		private var _placement : Placement;
		
		public function Anchors() {
			// source container
			var container : Sprite = new Sprite();
			container.x = 50;
			container.y = 300;
			addChild(container);

			// source
			_source = new Box(160, 160, 50, -200, 0xDDDDDD, 1, 0x999999);
			container.addChild(_source);

			// layer container
			container = new Sprite();
			container.x = 200;
			container.y = 200;
			addChild(container);

			// layer
			_layer = new Box(80, 80, 0, 0, 0x004499, .5, 0x666666);
			container.addChild(_layer);

			// placement
			_placement = new Placement();
			_placement.source = _source;
			_placement.layer = _layer;
			_placement.offset = new Point();

			// controls
			_controls = new Controls();
			_controls.x = 380;
			addChild(_controls);
			
			addEventListener("anchor", anchorChangedHandler);
			addEventListener("offset", offsetChangedHandler);

			place();
		}
		
		private function anchorChangedHandler(event : Event) : void {
			// highlight selected anchor
			_source.placementAnchor = _controls.sourceAnchor;
			_layer.placementAnchor = _controls.layerAnchor;
			// recalculate position
			_placement.sourceAnchor = _controls.sourceAnchor;
			_placement.layerAnchor = _controls.layerAnchor;
			place();
		}

		private function offsetChangedHandler(event : Event) : void {
			_placement.offset.x = _controls.offsetX;
			_placement.offset.y = _controls.offsetY;
			place();
		}

		private function place() : void {
			_placement.place();
			_layer.moveTo(_placement.layerLocal.x, _placement.layerLocal.y);
		}
	}
}