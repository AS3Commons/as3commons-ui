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
		 * Constant defining the invalidation during the render phase message.
		 */
		public static const INVALIDATE_FROM_RENDER : String = "invalidate_from_render_method";

		/**
		 * Constant defining the defaults invalidation during the calculates default phase message.
		 */
		public static const INVALIDATE_DEFAULTS_FROM_CALCULATE_DEFAULTS : String = "invalidate_defaults_from_calculate_defaults_phase";
		
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
				case INVALIDATE_FROM_RENDER:
					message = <![CDATA[
						You cannot invalidate anything from within the render phase.
						The render phase is meant to update the display list according to properties calculated and
						validated in the preceeding phases. If there is something left, consider modifications
						of your validate or calculate defaults methods.
					]]>;
					break;
				case INVALIDATE_DEFAULTS_FROM_CALCULATE_DEFAULTS:
					message = <![CDATA[
						You cannot schedule a defaults calculation from within the calculate defaults phase.
						If there is something to be calculated later, make a roundtrip to the validate phase.
					]]>;
					break;
			}
			
			super(message);
		}

	}
}
