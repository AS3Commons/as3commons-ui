package lifecycle.lifecycle.hboxexample {
	import lifecycle.lifecycle.common.Component;
	import org.as3commons.ui.layout.HGroup;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleView;
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class HBox extends LifeCycleView {
		private var _hGroup : HGroup;

		public function HBox() {
			_hGroup = new HGroup();
		}
		
		public function set padding(padding : uint) : void {
			_hGroup.marginX = padding;
			_hGroup.marginY = padding;
			_hGroup.gap = padding;
			invalidate();
		}
		
		public function refresh() : void {
			invalidate();
		}
		
		override public function addChild(child : DisplayObject) : DisplayObject {
			child.addEventListener(Component.EVENT_RESIZE, resized);
			_hGroup.add(child);
			invalidate();
			return super.addChild(child);
		}

		override public function removeChild(child : DisplayObject) : DisplayObject {
			child.removeEventListener(Component.EVENT_RESIZE, resized);
			_hGroup.remove(child);
			invalidate();
			return super.removeChild(child);
		}
		
		override protected function validate() : void {
			scheduleUpdate();
		}
		
		override protected function update() : void {
			trace ("update");
			_hGroup.layout(this);
			
			with (graphics) {
				clear();
				beginFill(0xDDDDDD);
				drawRect(0, 0,
					_hGroup.contentRect.width + 2 * _hGroup.gap,
					_hGroup.contentRect.height + 2 * _hGroup.gap
				);
			}
		}
		
		private function resized(event : Event) : void {
			invalidate();
		}
	}
}