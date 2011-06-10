package layer.tooltip.tooltiptutorial.step3 {
	import layer.tooltip.tooltiptutorial.step1.BoxToolTip;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layer.tooltip.ToolTipAdapter;
	import flash.display.DisplayObject;
	public class TestBoxToolTipAdapter extends ToolTipAdapter {
		override protected function onToolTip(toolTip : DisplayObject) : void {
			ownerAnchor = PlacementAnchor.BOTTOM;
			toolTipAnchor = PlacementAnchor.TOP;
		}

		override protected function onContent(toolTip : DisplayObject, content : *) : void {
			BoxToolTip(toolTip).text = content;
		}
	}
}