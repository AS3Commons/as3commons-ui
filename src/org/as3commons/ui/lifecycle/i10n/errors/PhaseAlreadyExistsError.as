package org.as3commons.ui.lifecycle.i10n.errors {

	/**
	 * Error thrown if a phase of the same name already has been added.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class PhaseAlreadyExistsError extends Error {

		/**
		 * PhaseAlreadyExistsError constructor.
		 * 
		 * @param phaseName The name of the existing phase.
		 */
		public function PhaseAlreadyExistsError(phaseName : String) {
			super("A phase with the name " + phaseName + " has already been added.");
		}

	}
}
