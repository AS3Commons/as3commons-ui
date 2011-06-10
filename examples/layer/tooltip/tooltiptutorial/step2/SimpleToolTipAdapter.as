package layer.tooltip.tooltiptutorial.step2 {
	import layer.tooltip.tooltiptutorial.step1.SimpleToolTip;
	import org.as3commons.ui.layer.tooltip.ToolTipAdapter;
	import flash.display.DisplayObject;
	public class SimpleToolTipAdapter extends ToolTipAdapter {
		override protected function onContent(toolTip : DisplayObject, content : *) : void {
			SimpleToolTip(toolTip).text = content;
		}
	}
}