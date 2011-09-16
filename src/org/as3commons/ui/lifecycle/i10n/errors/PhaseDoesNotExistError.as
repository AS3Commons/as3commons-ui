package org.as3commons.ui.lifecycle.i10n.errors {

	/**
	 * Error thrown when trying to invalidate for a unknown phase.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class PhaseDoesNotExistError extends Error {

		/**
		 * PhaseDoesNotExistError constructor.
		 * 
		 * @param phaseName The name of the not existing phase.
		 */
		public function PhaseDoesNotExistError(phaseName : String) {
			super("A phase with the name " + phaseName + " has not been configured.");
		}

	}
}
