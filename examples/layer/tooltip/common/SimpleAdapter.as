package layer.tooltip.common {
	import org.as3commons.ui.layer.tooltip.ToolTipAdapter;
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class SimpleAdapter extends ToolTipAdapter {
		public function SimpleAdapter() {
			offset = new Point(-5, 5);
		}

		override protected function onContent(toolTip : DisplayObject, content : *) : void {
			SimpleToolTip(toolTip).text = content;
		}

		override protected function onShow(toolTip : DisplayObject, localPosition : Point) : void {
			SimpleToolTip(toolTip).x = localPosition.x;
			SimpleToolTip(toolTip).y = localPosition.y;
		}
	}
}