package org.as3commons.ui.lifecycle.i10n {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public interface IInvalidation {
		
		function register(selector : II10NSelector, adapter : II10NApapter) : void;
		
		function invalidate(displayObject : DisplayObject, property : String = null) : void;

		function validateNow(displayObject : DisplayObject) : void;

		function unregister(selector : II10NSelector, adapter : II10NApapter) : void;

		function clear() : void;

		function cleanUp() : void;

	}
}
