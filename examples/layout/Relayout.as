package layout {
	import common.ControlPanelBase;
	import layout.common.box.Box;
	import org.as3commons.ui.layout.framework.*;
	import org.as3commons.ui.layout.shortcut.*;

	public class Relayout extends ControlPanelBase {
		private var _layout : ILayout;

		public function Relayout() {
			_layout = vgroup(
				new Box(),

				hgroup(
					"id", "nested",
					Box.create(2),
					display(
						"id", "box",
						"inLayout", false,
						new Box()
					)
				),

				new Box(),

				display(
					"marginY", 20,
					labelButton({
						toggle: true,
						label: "include",
						selectedlabel: "exclude",
						change: buttonClick
					})
				)
			);
			
			trace ("LAY");
			_layout.layout(this);
			trace ("/LAY");
		}
		
		private function buttonClick(selected : Boolean) : void {
			var boxDisplay : IDisplay = _layout.getLayoutItem("box") as IDisplay;
			if (selected) {
				boxDisplay.includeInLayout();
			} else {
				boxDisplay.excludeFromLayout();
			}
			var nested : ILayout = _layout.getLayoutItem("nested") as ILayout;
			trace ("nested LAY");
			nested.layout(this, true);
		}

	}
}