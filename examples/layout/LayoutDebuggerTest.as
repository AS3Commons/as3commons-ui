package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.Table;
	import org.as3commons.ui.layout.constants.Align;
	import org.as3commons.ui.layout.debugger.LayoutDebugger;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;

	public class LayoutDebuggerTest extends Sprite {
		public function LayoutDebuggerTest() {
			var t : Table = table(
				"numColumns", 10,
				"hGap", 5, "vGap", 5,
				cellconfig(
					"hAlign", Align.CENTER, "vAlign", Align.MIDDLE
				),
				Box.create(45, true, 20, 40)
			);
			t.layout(this);
			
			var debugger : LayoutDebugger = new LayoutDebugger();
			addChild(debugger);
			debugger.debug(t);
		}
	}
}