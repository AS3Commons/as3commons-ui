package org.as3commons.ui.lifecycle.lifecycle.errors {

	/**
	 * Error thrown if invalidation is not allowed at a specific place.
	 * 
	 * @author Jens Struwe 15.09.2011
	 */
	public class InvalidationNotAllowedHereError extends Error {
		
		/**
		 * Constant defining the invalidation for secondary phase outside of the validation cycle message.
		 */
		public static const INVALIDATE_FOR_SECONDARY_PHASE_OUTSIDE_OF_CYCLE : String = "invalidate_for_secondary_phase_outside_of_cycle";

		/**
		 * Constant defining the invalidation for secondary phase not from the current display object message.
		 */
		public static const INVALIDATE_FOR_SECONDARY_PHASE_NOT_FROM_CURRENT_OBJECT : String = "invalidate_for_secondary_phase_not_from_current_object";

		/**
		 * Constant defining the invalidation for secondary phase not from the first phase message.
		 */
		public static const INVALIDATE_FOR_SECONDARY_PHASE_NOT_FROM_FIRST_PHASE : String = "invalidate_for_secondary_phase_not_from_first_phase";

		public var messageKey : String;

		/**
		 * InvalidationNotAllowedHereError constructor.
		 * 
		 * @param theMessageKey Key of the error message.
		 */
		public function InvalidationNotAllowedHereError(theMessageKey : String) {
			messageKey = theMessageKey;
			
			var message : String;
			
			switch (messageKey) {
				case INVALIDATE_FOR_SECONDARY_PHASE_OUTSIDE_OF_CYCLE:
					message = <![CDATA[
						You cannot invalidate for a secondary phase outside of a running validation cycle.
						You are only allowed to invalidate within a validation method.
					]]>;
					break;
				case INVALIDATE_FOR_SECONDARY_PHASE_NOT_FROM_CURRENT_OBJECT:
					message = <![CDATA[
						You cannot invalidate an object for a secondary phase from within a validation method
						of another object.
						You are only allowed to invalidate within a validation method of the current object being validated.
					]]>;
					break;
				case INVALIDATE_FOR_SECONDARY_PHASE_NOT_FROM_FIRST_PHASE:
					message = <![CDATA[
						You cannot invalidate an object for a secondary phase outside of the first phase.
						You are only allowed to invalidate within a validation method of the current object being validated.
					]]>;
					break;
			}
			
			super(message);
		}

	}
}
