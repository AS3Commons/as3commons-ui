package org.as3commons.ui.lifecycle.i10n.core {

	import flash.display.DisplayObject;
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.framework.IOrderedSet;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;


	/**
	 * @author Jens Struwe 27.05.2011
	 */
	public class QueueItem {

		private var _displayObject : DisplayObject;
		private var _properties : IOrderedSet;
	
		public function QueueItem(theDisplayObject : DisplayObject) {
			_displayObject = theDisplayObject;
		}
	
		public function get displayObject() : DisplayObject {
			return _displayObject;
		}
	
		public function addProperty(property : String) : void {
			if (!_properties) _properties = new LinkedSet();
			if (_properties.has(Invalidation.ALL_PROPERTIES)) return;
			if (property == Invalidation.ALL_PROPERTIES) _properties.clear();
			_properties.add(property);
		}
	
		public function getProperties() : IOrderedSet {
			return _properties;
		}
	
	}
}
