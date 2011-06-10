package layer.tooltip.tooltiptutorial.step3 {

	import layer.tooltip.tooltiptutorial.final.Globals;
	import layer.tooltip.tooltiptutorial.step1.BoxToolTip;

	import org.as3commons.ui.layer.tooltip.ToolTipAdapter;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	public class BoxToolTipAdapter extends ToolTipAdapter {
		override protected function onToolTip(toolTip : DisplayObject) : void {
			offset = new Point(-5, 5);
			autoHideAfter = 2000;
			bounds = Globals.bounds;
			autoSwapAnchorsH = true;
			autoSwapAnchorsHDiff = 25;
			autoSwapAnchorsV = true;
			autoSwapAnchorsVDiff = 10;
		}

		override protected function onContent(toolTip : DisplayObject, content : *) : void {
			BoxToolTip(toolTip).text = content;
		}
	}
}