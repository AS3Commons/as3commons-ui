package org.as3commons.ui.lifecycle.i10n {

	import flash.display.DisplayObject;

	/**
	 * <code>Invalidation</code> selector definition.
	 * 
	 * @author Jens Struwe 23.05.2011
	 */
	public interface II10NSelector {

		/**
		 * Returns <code>true</code>, if the adapter mapped to this selector
		 * should be considered for the given display object.
		 * 
		 * @param displayObject The component to test.
		 * @return <code>true</code>, if the mapped adapter should be applied to this component. 
		 */
		function approve(displayObject : DisplayObject) : Boolean;

	}
}
