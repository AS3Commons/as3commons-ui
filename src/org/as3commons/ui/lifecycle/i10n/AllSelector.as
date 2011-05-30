package org.as3commons.ui.lifecycle.i10n {

	import flash.display.DisplayObject;

	/**
	 * Default <code>II10NSelector</code> implementation approving all objects.
	 * 
	 * @author Jens Struwe 23.05.2011
	 */
	public class AllSelector implements II10NSelector {

		/**
		 * @inheritDoc
		 */
		public function approve(displayObject : DisplayObject) : Boolean {
			return true;
		}

	}
}
