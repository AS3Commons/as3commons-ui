package layout.nestedboxes {
	import flash.display.Sprite;

	public class NestedBoxes extends Sprite {
		public function NestedBoxes() {
			addChild(
				new Box("Box1",
					new Box("Box1_1",
						new Box("Box1_1_1"),
						new Box("Box1_1_2"),
						new Box("Box1_1_3"),
						new Box("Box1_1_4")
					),
					new Box("Box1_2",
						new Box("Box1_2_1"),
						new Box("Box1_2_2"),
						new Box("Box1_2_3"),
						new Box("Box1_2_4")
					),
					new Box("Box2_1",
						new Box("Box2_1_1"),
						new Box("Box2_1_2"),
						new Box("Box2_1_3"),
						new Box("Box2_1_4")
					),
					new Box("Box2_2",
						new Box("Box2_2_1"),
						new Box("Box2_2_2"),
						new Box("Box2_2_3"),
						new Box("Box2_2_4")
					)
				)
			);
		}
	}
}