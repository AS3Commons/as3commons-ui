package org.as3commons.ui.layer.placement {

	/**
	 * Value object containing the used placement values.
	 * 
	 * <p>Values may differ from the specified one due to auto corrections.</p>
	 */
	public class UsedPlacement {
		
		/**
		 * Used anchor of the fix object.
		 */
		public var sourceAnchor : uint;

		/**
		 * Used anchor of the object to place.
		 */
		public var layerAnchor : uint;

		/**
		 * Difference between the position determined by both used anchors
		 * and the final calculated horizontal position.
		 * 
		 * <p>A shift is set if the layer is auto corrected to fit specified
		 * bounds.</p>
		 */
		public var hShift : int;

		/**
		 * Difference between the position determined by both used anchors
		 * and the final calculated vertical position.
		 * 
		 * <p>A shift is set if the layer is auto corrected to fit specified
		 * bounds.</p>
		 */
		public var vShift : int;

		/**
		 * Indicates that anchors have been swapped horizontally.
		 */
		public var hSwapped : Boolean;

		/**
		 * Indicates that anchors have been swapped vertically.
		 */
		public var vSwapped : Boolean;
	}

}
