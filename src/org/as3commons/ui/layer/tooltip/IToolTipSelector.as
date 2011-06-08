package org.as3commons.ui.layer.tooltip {

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 08.06.2011
	 */
	public interface IToolTipSelector {

		function approve(displayObject : DisplayObject) : Boolean;

	}
}
