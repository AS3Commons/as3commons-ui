package layout.memory {
	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class MemoryTest extends Sprite {
		private var _layout : ILayout;

		public function MemoryTest() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}

		private function keyDown(event : KeyboardEvent) : void {
			if (event.keyCode == Keyboard.A) add();
			if (event.keyCode == Keyboard.C) clearReference();
			if (event.keyCode == Keyboard.R) remove();
		}
		
		private function add() : void {
			remove();
			_layout = hlayout(
				"maxItemsPerRow", 3,
				"hGap", 10, "vGap", 10,
				createHGroup(),
				createHLayout(),
				createTable(),
				createVGroup(),
				createVLayout(),
				createDynTable()
			);
			_layout.layout(this);
		}
		
		private function clearReference() : void {
			_layout = null;
		}
		
		private function remove() : void {
			while (numChildren) removeChildAt(0);
		}
		
		private function createHGroup() : ILayout {
			var color : uint = Math.round(Math.random() * 0xFFFFFF);
			return hgroup(
				"gap", 2,
				MemoryBox.create(10, color)
			);
		}
		
		private function createHLayout() : ILayout {
			var color : uint = Math.round(Math.random() * 0xFFFFFF);
			return hlayout(
				"maxItemsPerRow", 10, "hGap", 2, "vGap", 2,
				MemoryBox.create(100, color)
			);
		}
		
		private function createVGroup() : ILayout {
			var color : uint = Math.round(Math.random() * 0xFFFFFF);
			return vgroup(
				"minWidth", 118, "gap", 2,
				MemoryBox.create(10, color)
			);
		}
		
		private function createVLayout() : ILayout {
			var color : uint = Math.round(Math.random() * 0xFFFFFF);
			return vlayout(
				"maxItemsPerColumn", 10, "hGap", 2, "vGap", 2,
				MemoryBox.create(100, color)
			);
		}
		
		private function createTable() : ILayout {
			var color : uint = Math.round(Math.random() * 0xFFFFFF);
			return table(
				"numColumns", 10, "hGap", 2, "vGap", 2,
				MemoryBox.create(100, color)
			);
		}
		
		private function createDynTable() : ILayout {
			var color : uint = Math.round(Math.random() * 0xFFFFFF);
			return dyntable(
				"maxContentWidth", 118, "hGap", 2, "vGap", 2,
				MemoryBox.create(100, color)
			);
		}
	}
}