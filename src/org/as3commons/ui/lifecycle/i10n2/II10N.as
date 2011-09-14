package org.as3commons.ui.lifecycle.i10n2 {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 09.09.2011
	 */
	public interface II10N {

		function addPhase(phaseName : String, order : String, loopback : String = null) : void;
		
		function start() : void;
		
		function registerDisplayObject(displayObject : DisplayObject, adapter : I10NAdapter) : void;
		
		function unregisterDisplayObject(displayObject : DisplayObject) : void;

		function validateNow() : void;

		function get validationIsRunning() : Boolean;

		function get currentPhaseName() : String;

		function get currentDisplayObject() : DisplayObject;

		function cleanUp() : void;

	}
}
