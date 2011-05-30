package layout {
	import layout.common.box.Box;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;

	public class NestedLayouts extends Sprite {
		public function NestedLayouts() {
			hgroup(
				vlayout(
					new Box(), // 1
					new Box(), // 2
					hlayout(
						new Box(), // 3
						new Box() // 4
					)
				),
				new Box(), // 5
				hlayout(
					vgroup(	
						new Box(), // 6
						new Box(), // 7
						new Box() // 8
					),
					new Box() // 9
				),
				new Box() // 10
			).layout(this);
		}
	}
}