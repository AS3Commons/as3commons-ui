package org.as3commons.ui.framework.uiservice.errors {

	/**
	 * Error thrown if an adapter already has been registered.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class AdapterAlreadyRegisteredError extends Error {

		/**
		 * AdapterAlreadyRegisteredError constructor.
		 */
		public function AdapterAlreadyRegisteredError() {
			super("You can't register an adapter twice.");
		}

	}
}
