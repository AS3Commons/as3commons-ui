package layer.tooltip.contextual {
	import layer.tooltip.common.SimpleToolTip;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layer.tooltip.ToolTipAdapter;
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class ContextualToolTipAdapter extends ToolTipAdapter {
		override protected function onContent(toolTip : DisplayObject, content : *) : void {
			switch (Box(owner).label) {
				case "Box1":
					ownerAnchor = PlacementAnchor.TOP_LEFT;
					toolTipAnchor = PlacementAnchor.BOTTOM_RIGHT;
					offset = new Point(5, 5);
					break;
				case "Box2":
					ownerAnchor = PlacementAnchor.TOP_RIGHT;
					toolTipAnchor = PlacementAnchor.BOTTOM_LEFT;
					offset = new Point(-5, 5);
					break;
				case "Box3":
					ownerAnchor = PlacementAnchor.BOTTOM_LEFT;
					toolTipAnchor = PlacementAnchor.TOP_RIGHT;
					offset = new Point(5, -5);
					break;
				case "Box4":
					ownerAnchor = PlacementAnchor.BOTTOM_RIGHT;
					toolTipAnchor = PlacementAnchor.TOP_LEFT;
					offset = new Point(-5, -5);
					break;
			}
			
			/*
				Alternative: evaluate position
			
				if (Box(owner).y > 150) {
					ownerAnchor = PlacementAnchor.TOP_LEFT;
					toolTipAnchor = PlacementAnchor.BOTTOM_RIGHT;
				} else {
					ownerAnchor = PlacementAnchor.BOTTOM_RIGHT;
					toolTipAnchor = PlacementAnchor.TOP_LEFT;
				}
			*/
			
			SimpleToolTip(toolTip).text = content;
		}
	}
}