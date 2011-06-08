package org.as3commons.ui.layer.tooltip {

	import flash.display.DisplayObject;

	/**
	 * Tooltip source object selector definition.
	 * 
	 * @author Jens Struwe 08.06.2011
	 */
	public interface IToolTipSelector {

		/**
		 * Returns <code>true</code>, if the adapter mapped to this selector
		 * should be considered for the given display object.
		 * 
		 * @param displayObject The component to test.
		 * @return <code>true</code> if the mapped adapter should be applied to this component. 
		 */
		function approve(displayObject : DisplayObject) : Boolean;

	}
}
