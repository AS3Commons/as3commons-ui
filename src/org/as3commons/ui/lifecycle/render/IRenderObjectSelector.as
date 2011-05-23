package org.as3commons.ui.lifecycle.render {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public interface IRenderObjectSelector {

		function approve(displayObject : DisplayObject) : Boolean;

	}
}
