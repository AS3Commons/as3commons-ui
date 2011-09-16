package org.as3commons.ui.framework.uiservice.errors {

	/**
	 * Error thrown if the service already has been started.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class ServiceAlreadyStartedError extends Error {

		/**
		 * ServiceAlreadyStartedError constructor.
		 */
		public function ServiceAlreadyStartedError() {
			super("You can't call this method after the service has started.");
		}

	}
}
