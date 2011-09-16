package org.as3commons.ui.framework.uiservice.errors {

	/**
	 * Error thrown if the service has not been started yet.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class ServiceNotStartedError extends Error {

		/**
		 * ServiceNotStartedError constructor.
		 */
		public function ServiceNotStartedError() {
			super("You can't call this method before the service has started.");
		}

	}
}
