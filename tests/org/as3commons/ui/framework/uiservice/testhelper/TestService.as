package org.as3commons.ui.framework.uiservice.testhelper {

	import org.as3commons.ui.framework.uiservice.AbstractUIAdapter;
	import org.as3commons.ui.framework.uiservice.AbstractUIService;

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 15.09.2011
	 */
	public class TestService extends AbstractUIService {
		
		private var _numSetUpCalls : uint;
		private var _numCleanUpCalls : uint;
		
		public function start() : void {
			start_protected();
		}
		
		public function registerDisplayObject(displayObject : DisplayObject, adapter : AbstractUIAdapter) : void {
			registerDisplayObject_protected(displayObject, adapter);
		}
		
		public function unregisterDisplayObject(displayObject : DisplayObject) : void {
			unregisterDisplayObject_protected(displayObject);
		}
		
		public function cleanUp() : void {
			cleanUp_protected();
		}

		public function get numSetUpCalls() : uint {
			return _numSetUpCalls;
		}

		public function get numCleanUpCalls() : uint {
			return _numCleanUpCalls;
		}

		override protected function onStart() : void {
			_numSetUpCalls++;
		}
		
		override protected function onCleanUp() : void {
			_numCleanUpCalls++;
		}

	}
}
