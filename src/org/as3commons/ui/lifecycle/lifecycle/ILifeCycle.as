package org.as3commons.ui.lifecycle.lifecycle {

	import flash.display.DisplayObject;
	import flash.display.Stage;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public interface ILifeCycle {
		
		function set stage(stage : Stage) : void;
		
		function registerComponent(component : DisplayObject, adapter : LifeCycleAdapter) : void;

		function unregisterComponent(component : DisplayObject) : void;

		function cleanUp() : void;
		
	}
}
