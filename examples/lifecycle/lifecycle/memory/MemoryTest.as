package lifecycle.lifecycle.memory {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;


	public class MemoryTest extends Sprite {
		private var _components : ArrayList;
		private var _tf : TextField;

		public function MemoryTest() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);

			MemoryGlobals.lifeCycle = new LifeCycle();
			MemoryGlobals.boxColor = Math.round(Math.random() * 0xCCCCCC);
			_components = new ArrayList();
			
			_tf = new TextField();
			_tf.defaultTextFormat = new TextFormat("_sans", 10, 0x555555);
			_tf.text = "Boxes: 0";
			addChild(_tf);
		}

		private function keyDown(event : KeyboardEvent) : void {
			if (event.keyCode == Keyboard.A) add();
			if (event.keyCode == Keyboard.U) update();
			if (event.keyCode == Keyboard.R) remove();
		}
		
		private function add() : void {
			for (var i : uint; i < 50; i++) {
				var component : MemoryBox = new MemoryBox();
				component.x = Math.round(Math.random() * (stage.stageWidth - 30));
				component.y = 30 + Math.round(Math.random() * (stage.stageHeight - 60));
				addChild(component);
				_components.add(component);
			}
			_tf.text = "Boxes: " + _components.size;
		}

		private function update() : void {
			MemoryGlobals.boxColor = Math.round(Math.random() * 0xCCCCCC);
			var i : IIterator = _components.iterator();
			while (i.hasNext()) {
				MemoryBox(i.next()).invalidate();
			}
		}
		
		private function remove() : void {
			for (var i : uint; i < 50; i++) {
				var component : MemoryBox = _components.removeFirst();
				if (component) {
					component.cleanUp();
					removeChild(component);
				}
			}
			_tf.text = "Boxes: " + _components.size;
		}
	}
}