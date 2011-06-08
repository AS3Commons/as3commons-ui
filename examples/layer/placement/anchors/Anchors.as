package layer.placement.anchors {
	import common.UIView;
	import layer.placement.common.Box;
	import org.as3commons.ui.layer.Placement;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Anchors extends UIView {
		private var _placement : Placement;
		private var _controls : Controls;
		
		override public function draw() : void {
			// source
			var container : Sprite = new Sprite();
			container.x = 50;
			container.y = 300;
			addChild(container);
			var source : Box = new Box(160, 160, 60, -190, 0xCCCCCC, 1, 0x999999, true, false);
			container.addChild(source);

			// layer
			container = new Sprite();
			container.x = 200;
			container.y = 200;
			addChild(container);
			var layer : Box = new Box(80, 80, 0, 0, 0x4488DD, .5, 0x666666, true, false);
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