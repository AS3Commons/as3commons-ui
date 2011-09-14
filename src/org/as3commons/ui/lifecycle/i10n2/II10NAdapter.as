package org.as3commons.ui.lifecycle.i10n2 {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 09.09.2011
	 */
	public interface II10NAdapter {
		
		function get displayObject() : DisplayObject;
		
		function get nestLevel() : int;
		
		function invalidate(phase : String, property : String = null) : void;

		function isInvalid(phaseName : String = null, property : String = null) : Boolean;
		
		function validateNow() : void;
		
	}
}
