package org.as3commons.ui.lifecycle.i10n {

	import org.as3commons.collections.framework.ISet;

	import flash.display.DisplayObject;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public interface II10NApapter {
		
		function willValidate(displayObject : DisplayObject) : void;

		function validate(displayObject : DisplayObject, properties : ISet) : void;
		
	}
}
