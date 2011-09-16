package org.as3commons.ui.framework.uiservice {

	import org.as3commons.ui.framework.core.as3commons_ui;

	import flash.display.DisplayObject;

	use namespace as3commons_ui;

	/**
	 * Abstract UI adapter.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class AbstractUIAdapter {

		/**
		 * The object associated with this adapter.
		 */
		protected var _displayObject : DisplayObject;

		/**
		 * The particular UI service instance the adapter is implemented for.
		 */
		protected var _uiService : AbstractUIService;

		/*
		 * Public
		 */
		
		/**
		 * The object associated with this adapter.
		 */
		public function get displayObject() : DisplayObject {
			return _displayObject;
		}
		
		/*
		 * as3commons_ui
		 */

		as3commons_ui function setUp_internal(displayObject : DisplayObject, uiService : AbstractUIService) : void {
			_displayObject = displayObject;
			_uiService = uiService;
		}

		as3commons_ui function cleanUp_internal() : void {
			_displayObject = null;
			_uiService = null;
		}

	}
}
