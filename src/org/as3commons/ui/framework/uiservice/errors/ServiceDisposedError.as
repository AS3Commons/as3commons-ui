package org.as3commons.ui.framework.uiservice.errors {

	/**
	 * Error thrown if the service already has been disposed.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class ServiceDisposedError extends Error {

		/**
		 * ServiceDisposedError constructor.
		 */
		public function ServiceDisposedError() {
			super("You can't call this method on a disposed service.");
		}

	}
}
