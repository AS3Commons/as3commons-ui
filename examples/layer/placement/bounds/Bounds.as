package layer.placement.bounds {
	import common.UIView;
	import layer.placement.common.Box;
	import org.as3commons.ui.layer.Placement;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import flash.geom.Rectangle;

	public class Bounds extends UIView {
		private var _placements : Array;

		override public function draw() : void {
			_placements = new Array();
			
			addBox(
				70, 70,
				PlacementAnchor.TOP_LEFT, PlacementAnchor.BOTTOM_RIGHT
			);
			addBox(
				stage.stageWidth - 130, 70,
				PlacementAnchor.TOP_RIGHT, PlacementAnchor.BOTTOM_LEFT
			);
			addBox(
				stage.stageWidth - 130, stage.stageHeight - 130,
				PlacementAnchor.BOTTOM_RIGHT, PlacementAnchor.TOP_LEFT
			);
			addBox(
				70, stage.stageHeight - 130,
				PlacementAnchor.BOTTOM_LEFT, PlacementAnchor.TOP_RIGHT
			);

			// controls
			hgroup(
				"minWidth", stage.stageWidth, "minHeight", stage.stageHeight,
				"hAlign", Align.CENTER, "vAlign", Align.MIDDLE,
				new Controls(sizeChanged)
			).layout(this);
		}
		
		private function addBox(x : uint, y : uint, sourceAnchor : uint, layerAnchor : uint) : void {
			// source
			var source : Box = new Box(40, 40, x, y, 0xDDDDDD, 1, 0x999999);
			source.placementAnchor = sourceAnchor;
			addChild(source);

			// layer
			var layer : Box = new Box(40, 40, 0, 0, 0x004499, .5, 0x666666);
			layer.placementAnchor = layerAnchor;
			addChild(layer);

			// placement
			var placement : Placement = new Placement(source, layer);
			placement.sourceAnchor = sourceAnchor;
			placement.layerAnchor = layerAnchor;
			placement.bounds = new Rectangle(10, 10, stage.stageWidth - 20, stage.stageHeight - 20);
			placement.place();
			_placements.push(placement);
		}

		private function sizeChanged(width : uint, height : uint) : void {
			for (var i : uint; i < _placements.length; i++) {
				var placement : Placement = _placements[i];
				Box(placement.layer).width = width;
				Box(placement.layer).height = height;
				placement.place();
			}
		}
	}
}