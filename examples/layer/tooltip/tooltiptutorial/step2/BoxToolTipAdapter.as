package layer.tooltip.tooltiptutorial.step2 {
	import layer.tooltip.tooltiptutorial.step1.BoxToolTip;
	import org.as3commons.ui.layer.tooltip.ToolTipAdapter;
	import flash.display.DisplayObject;
	public class BoxToolTipAdapter extends ToolTipAdapter {
		override protected function onContent(toolTip : DisplayObject, content : *) : void {
			BoxToolTip(toolTip).text = content;
		}
	}
}