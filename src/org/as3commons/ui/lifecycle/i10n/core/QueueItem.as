package org.as3commons.ui.lifecycle.i10n.core {

	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.framework.IOrderedSet;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;

	import flash.display.DisplayObject;

	/**
	 * Validation queue item.
	 * 
	 * @author Jens Struwe 27.05.2011
	 */
	public class QueueItem {

		/**
		 * The component to be validated.
		 */
		private var _displayObject : DisplayObject;
		
		/**
		 * List of invalid properties.
		 */
		private var _properties : IOrderedSet;
	
		/**
		 * <code>QueueItem</code> constructor.
		 * 
		 * @param theDisplayObject The component.
		 */
		public function QueueItem(theDisplayObject : DisplayObject) {
			_displayObject = theDisplayObject;
		}
	
		/**
		 * The component to be validated.
		 */
		public function get displayObject() : DisplayObject {
			return _displayObject;
		}
	
		/**
		 * Adds a property to the invalid properties list.
		 * 
		 * <p>If the list already contains the property <code>Invalidation.ALL_PROPERTIES</code>
		 * any other property will be refused.</p>
		 * 
		 * <p>If the given property is <code>Invalidation.ALL_PROPERTIES</code>
		 * any other property will be removed from the list.</p>
		 * 
		 * @param property The property to add.
		 */
		public function addProperty(property : String) : void {
			if (!_properties) _properties = new LinkedSet();
			if (_properties.has(Invalidation.ALL_PROPERTIES)) return;
			if (property == Invalidation.ALL_PROPERTIES) _properties.clear();
			_properties.add(property);
		}
	
		/**
		 * Returns the list of properties.
		 * 
		 * @return The list of properties.
		 */
		public function getProperties() : IOrderedSet {
			return _properties;
		}
	
	}
}
