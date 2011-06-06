package layer.placement {
	import layer.placement.common.Box;
	import layer.placement.common.BoxControls;
	import org.as3commons.ui.layer.Placement;
	import org.as3commons.ui.layout.shortcut.vgroup;
	import flash.display.Sprite;

	public class PlacementExample extends ControlPanelBase {
		private var _source : Box;
		private var _layer : Box;
		private var _placement : Placement;
		
		public function PlacementExample() {
			// source
			_source = new Box(150, 150, 150, 150, 0xDDDDDD, 1, 0x999999);
			addChild(_source);

			// layer container
			var container : Sprite = new Sprite();
			container.x = 200;
			container.y = 200;
			addChild(container);

			// layer
			_layer = new Box(75, 75, 0, 0, 0x004499, .5, 0x666666);
			container.addChild(_layer);

			// placement
			_placement = new Placement();
			_placement.source = _source;
			_placement.layer = _layer;

			// controls
			vgroup(
				"marginX", 470,
				new BoxControls(_source, "Source", setSourceAnchor, place),
				new BoxControls(_layer, "Layer", setLayerAnchor, place)
			).layout(this);
		}
		
		private function setSourceAnchor(anchor : uint) : void {
			_placement.sourceAnchor = anchor;
			place();
		}

		private function setLayerAnchor(anchor : uint) : void {
			_placement.layerAnchor = anchor;
			place();
		}

		private function place() : void {
			_placement.place();
			_layer.moveTo(_placement.layerLocal.x, _placement.layerLocal.y);
		}
	}
}