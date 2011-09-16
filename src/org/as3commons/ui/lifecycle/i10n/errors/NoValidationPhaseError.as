package org.as3commons.ui.lifecycle.i10n.errors {

	/**
	 * Error thrown if no phase has been added by the time the service starts.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class NoValidationPhaseError extends Error {

		/**
		 * NoValidationPhaseError.
		 */
		public function NoValidationPhaseError() {
			super("You need to create at least one validation phase.");
		}

	}
}
