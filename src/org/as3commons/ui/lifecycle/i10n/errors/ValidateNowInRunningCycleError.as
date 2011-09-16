package org.as3commons.ui.lifecycle.i10n.errors {

	/**
	 * Error thrown when trying to call <code>validateNow()</code> within a running validation cycle.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class ValidateNowInRunningCycleError extends Error {

		/**
		 * ValidateNowInRunningCycleError constructor.
		 */
		public function ValidateNowInRunningCycleError() {
			super("You can't call validateNow() during a running validation cycle.");
		}

	}
}
