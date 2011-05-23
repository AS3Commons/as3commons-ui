package org.as3commons.ui.lifecycle.render {

	import flash.display.DisplayObject;
	import flash.display.Stage;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public interface IRenderManager {
		
		function set stage(stage : Stage) : void;
		
		function configureProcessor(selector : IRenderObjectSelector, processor : IRenderProcessor) : void;
		
		function invalidate(displayObject : DisplayObject) : void;

	}
}
