package org.as3commons.ui.framework.uiservice.errors {

	/**
	 * Error thrown if an object already has been registered.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class ObjectAlreadyRegisteredError extends Error {

		/**
		 * ObjectAlreadyRegisteredError constructor.
		 */
		public function ObjectAlreadyRegisteredError() {
			super("You can't register an object twice.");
		}

	}
}
