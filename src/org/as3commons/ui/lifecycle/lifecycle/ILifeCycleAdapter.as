package org.as3commons.ui.lifecycle.lifecycle {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public interface ILifeCycleAdapter {
		
		/*
		 * Component
		 */
		
		function invalidateProperty(property : String) : void;
		
		function validateNow() : void;

		function cleanUp() : void;
		
		function get component() : DisplayObject;

		/*
		 * Children
		 */
		
		function watchUpdates(child : DisplayObject) : void;

		function removeWatchUpdates(child : DisplayObject) : void;

		function autoUpdateNowChild(child : DisplayObject) : void;

		function removeAutoUpdateNowChild(child : DisplayObject) : void;

	}
}
