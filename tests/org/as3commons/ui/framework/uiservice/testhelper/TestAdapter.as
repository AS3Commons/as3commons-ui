package org.as3commons.ui.framework.uiservice.testhelper {

	import flash.display.DisplayObject;

	import org.as3commons.ui.framework.uiservice.AbstractUIService;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.framework.uiservice.AbstractUIAdapter;

	use namespace as3commons_ui;

	/**
	 * @author Jens Struwe 15.09.2011
	 */
	public class TestAdapter extends AbstractUIAdapter {
		
		private var _numSetUpCalls : uint;
		private var _numCleanUpCalls : uint;
		
		override as3commons_ui function setUp_internal(displayObject : DisplayObject, uiService : AbstractUIService) : void {
			super.as3commons_ui::setUp_internal(displayObject, uiService);
			
			_numSetUpCalls++;
		}
		
		override as3commons_ui function cleanUp_internal() : void {
			super.as3commons_ui::cleanUp_internal();
			
			_numCleanUpCalls++;
		}

		public function get numSetUpCalls() : uint {
			return _numSetUpCalls;
		}

		public function get numCleanUpCalls() : uint {
			return _numCleanUpCalls;
		}
		
		
	}
}
