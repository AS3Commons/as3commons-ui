package org.as3commons.ui.lifecycle.render {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public interface IRenderProcessor {
		
		function render(displayObject : DisplayObject) : void;
		
	}
}
