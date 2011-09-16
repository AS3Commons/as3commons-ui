package org.as3commons.ui.framework.uiservice.errors {

	/**
	 * Error thrown if an adapter has not been registered.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class AdapterNotRegisteredError extends Error {

		/**
		 * AdapterNotRegisteredError constructor.
		 */
		public function AdapterNotRegisteredError() {
			super("You can't call this method on an unregistered adapter.");
		}

	}
}
