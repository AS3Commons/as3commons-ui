package org.as3commons.ui.lifecycle.i10n {

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.framework.IOrderedMap;
	import org.as3commons.collections.framework.IOrderedSet;
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.collections.utils.Sets;
	import org.as3commons.ui.lifecycle.i10n.core.QueueItem;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class Invalidation implements IInvalidation {
		
		public static const ALL_PROPERTIES : String = "Invalidation_ALL_PROPERTIES";
		
		private var _selectors : IOrderedMap;
		private var _queue : IOrderedMap;
		private var _stage : Stage;
		
		public function Invalidation() {
			_selectors = new LinkedMap();
			_queue = new LinkedMap();
		}
		
		/*
		 * IRenderManager
		 */
		
		public function register(selector : II10NSelector, adapter : II10NApapter) : void {
			var adapters : IOrderedSet = _selectors.itemFor(selector);
			if (!adapters) {
				adapters = new LinkedSet();
				_selectors.add(selector, adapters);
			}
			adapters.add(adapter);
		}
		
		public function invalidate(displayObject : DisplayObject, property : String = null) : void {
			if (!property) property = ALL_PROPERTIES;
			
			// display object not in display list
			if (!displayObject.stage) return;
			
			addToQueue(displayObject, property);

			// add if no stage listener present
			if (!_stage) {
				_stage = displayObject.stage;
				_stage.addEventListener(Event.EXIT_FRAME, stageExitFrame);
			}
		}

		/**
		 * <p>Validate only items that are scheduled.</p>
		 */
		public function validateNow(displayObject : DisplayObject) : void {
//			trace ("----validateNow", displayObject, __queue.keysToArray(), _queue.keysToArray());

			if (!_queue.hasKey(displayObject)) return;
			
			processValidation(_queue.itemFor(displayObject));
		}
		
		public function unregister(selector : II10NSelector, adapter : II10NApapter) : void {
			var adapters : IOrderedSet = _selectors.itemFor(selector);
			if (adapters) {
				adapters.remove(adapter);
				if (!adapters.size) {
					_selectors.remove(selector);
				}
			}
		}

		public function clear() : void {
			if (_stage) _stage.removeEventListener(Event.EXIT_FRAME, stageExitFrame);
			_stage = null;
			_queue.clear();
		}

		public function cleanUp() : void {
			clear();
			_selectors.clear();
		}

		/*
		 * Private
		 */
		
		private function addToQueue(displayObject : DisplayObject, property : String) : QueueItem {
			var queueItem : QueueItem = _queue.itemFor(displayObject);
			
			// item not queued yet
			if (!queueItem) {
				queueItem = new QueueItem(displayObject);
				_queue.add(displayObject, queueItem);
			}

			// add property
			if (property) queueItem.addProperty(property);
			
			return queueItem;
		}

		private function stageExitFrame(event : Event) : void {
			_stage.removeEventListener(Event.EXIT_FRAME, stageExitFrame);
			_stage = null;

			while (_queue.size) {
				processValidation(_queue.first);
			}
		}
		
		private function processValidation(queueItem : QueueItem) : void {
			var adapters : IOrderedSet = getAdapters(queueItem.displayObject);

			// Let clients hook into the validation to perform modifications.
			invokeAdapters(adapters, function(adapter : II10NApapter) : void {
				adapter.willValidate(queueItem.displayObject);
			});
			
			// Abort if the item already has been processed during willValidate.
			if (_queue.removeKey(queueItem.displayObject)) {
				var properties : ISet = queueItem.getProperties();
				if (!properties) properties = new Set();
				invokeAdapters(adapters, function(adapter : II10NApapter) : void {
					adapter.validate(queueItem.displayObject, properties);
				});
			}
		}

		private function invokeAdapters(adapters : IOrderedSet, callback : Function) : void {
			var iterator : IIterator = adapters.iterator();
			while (iterator.hasNext()) {
				var adapter : II10NApapter = iterator.next();
				callback(adapter);
			}
		}

		private function getAdapters(displayObject : DisplayObject) : IOrderedSet {
			var uniqueAdapters : IOrderedSet = new LinkedSet();
			var iterator : IMapIterator = _selectors.iterator() as IMapIterator;
			while (iterator.hasNext()) {
				iterator.next();
				if (II10NSelector(iterator.key).approve(displayObject)) {
					Sets.copy(iterator.current, uniqueAdapters);
				}
			}
			return uniqueAdapters;
		}

	}
}
