package org.as3commons.ui.lifecycle.testhelper {

	import flash.display.DisplayObject;
	import org.as3commons.ui.lifecycle.render.IRenderProcessor;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class TestRenderProcessor implements IRenderProcessor {
		
		private var _calls : Array = new Array();
		
		public function render(displayObject : DisplayObject) : void {
			_calls.push(displayObject);
		}

		public function get calls() : Array {
			return _calls;
		}

	}
}
