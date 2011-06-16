/**
 * Copyright 2011 The original author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.ui.lifecycle.i10n {

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.LinkedSet;
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
	 * The <code>Invalidation</code> system.
	 * 
	 * @author Jens Struwe 23.05.2011
	 */
	public class Invalidation implements IInvalidation {
		
		/**
		 * Constant for the virtual invalidation property "all properties".
		 */
		public static const ALL_PROPERTIES : String = "Invalidation_ALL_PROPERTIES";
		
		/**
		 * The mappings of selectors to adapters.
		 */
		protected var _selectors : IOrderedMap;

		/**
		 * The validation queue.
		 */
		protected var _queue : IOrderedMap;

		/**
		 * List of items to be validated but not on the stage.
		 */
		protected var _schedule : IOrderedMap;

		/**
		 * Temporary <code>Stage</code> instance to listen to the <code>Event.EXIT_FRAME</code> event. 
		 */
		protected var _stage : Stage;
		
		/**
		 * <code>Invalidation</code> constructor.
		 */
		public function Invalidation() {
			_selectors = new LinkedMap();
			_queue = new LinkedMap();
			_schedule = new LinkedMap();
		}
		
		/*
		 * IInvalidation
		 */
		
		/**
		 * @inheritDoc
		 */
		public function registerAdapter(selector : II10NSelector, adapter : II10NApapter) : void {
			var adapters : IOrderedSet = _selectors.itemFor(selector);
			if (!adapters) {
				adapters = new LinkedSet();
				_selectors.add(selector, adapters);
			}
			adapters.add(adapter);
		}
		
		/**
		 * @inheritDoc
		 */
		public function unregisterAdapter(selector : II10NSelector, adapter : II10NApapter) : void {
			var adapters : IOrderedSet = _selectors.itemFor(selector);
			if (adapters) {
				adapters.remove(adapter);
				if (!adapters.size) {
					_selectors.remove(selector);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function invalidate(displayObject : DisplayObject, property : String = null) : void {
			if (!property) property = ALL_PROPERTIES;
			
			// display object in display list
			if (displayObject.stage) {
				addToQueue(_queue, displayObject, property);
				displayObject.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	
				// add if no stage listener present
				if (!_stage) {
					_stage = displayObject.stage;
					_stage.addEventListener(Event.EXIT_FRAME, stageExitFrame);
				}

			// display object not in display list
			} else {
				addToQueue(_schedule, displayObject, property);
				displayObject.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
				return;
			}
			
		}

		/**
		 * @inheritDoc
		 */
		public function validateNow(displayObject : DisplayObject) : void {
			if (!_queue.hasKey(displayObject)) return;
			
			processValidation(_queue.itemFor(displayObject));
		}
		
		/**
		 * @inheritDoc
		 */
		public function stopValidation(displayObject : DisplayObject) : void {
			displayObject.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			_queue.removeKey(displayObject);
			_schedule.removeKey(displayObject);
			
			if (!_queue.size && _stage) {
				_stage.removeEventListener(Event.EXIT_FRAME, stageExitFrame);
				_stage = null;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function stopAllValidations() : void {
			if (_stage) _stage.removeEventListener(Event.EXIT_FRAME, stageExitFrame);
			_stage = null;
			
			var iterator : IIterator = _queue.iterator();
			while (iterator.hasNext()) {
				QueueItem(iterator.next()).displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			}
			_queue.clear();

			iterator = _schedule.iterator();
			while (iterator.hasNext()) {
				QueueItem(iterator.next()).displayObject.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			}
			_schedule.clear();
		}

		/**
		 * @inheritDoc
		 */
		public function cleanUp() : void {
			stopAllValidations();
			_selectors.clear();
		}

		/*
		 * Private
		 */
		
		/**
		 * Handler for the component's <code>Event.ADDED_TO_STAGE</code> event.
		 * 
		 * <p>The particular component will be removed from the schedule and added
		 * to the validation queue.</p>
		 */
		private function addedToStageHandler(event : Event) : void {
			var displayObject : DisplayObject = event.currentTarget as DisplayObject;
			displayObject.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			displayObject.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			var queueItem : QueueItem = _schedule.removeKey(displayObject);
			_queue.add(displayObject, queueItem);

			// add if no stage listener present
			if (!_stage) {
				_stage = displayObject.stage;
				_stage.addEventListener(Event.EXIT_FRAME, stageExitFrame);
			}
		}

		/**
		 * Handler for the component's <code>Event.REMOVED_FROM_STAGE</code> event.
		 * 
		 * <p>The particular component will be removed from the validation queue and
		 * added to the schedule.</p>
		 */
		private function removedFromStageHandler(event : Event) : void {
			var displayObject : DisplayObject = event.currentTarget as DisplayObject;
			displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			displayObject.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			var queueItem : QueueItem = _queue.removeKey(displayObject);
			_schedule.add(displayObject, queueItem);
		}

		/**
		 * Adds an item to the specified queue.
		 */
		private function addToQueue(queue : IOrderedMap, displayObject : DisplayObject, property : String) : QueueItem {
			var queueItem : QueueItem = queue.itemFor(displayObject);
			
			// item not queued yet
			if (!queueItem) {
				queueItem = new QueueItem(displayObject);
				queue.add(displayObject, queueItem);
			}

			// add property
			if (property) queueItem.addProperty(property);
			
			return queueItem;
		}

		/**
		 * Handler for the stage's <code>Event.EXIT_FRAME</code> event.
		 */
		private function stageExitFrame(event : Event) : void {
			_stage.removeEventListener(Event.EXIT_FRAME, stageExitFrame);
			_stage = null;

			while (_queue.size) {
				processValidation(_queue.first);
			}
		}
		
		/**
		 * Executes the validation process for the given queue item.
		 */
		private function processValidation(queueItem : QueueItem) : void {
			var adapters : IOrderedSet = getAdapters(queueItem.displayObject);

			// Let clients hook into the validation to perform modifications.
			invokeAdapters(adapters, function(adapter : II10NApapter) : void {
				adapter.willValidate(queueItem.displayObject);
			});
			
			// Abort if the item already has been processed during willValidate.
			if (_queue.removeKey(queueItem.displayObject)) {
				queueItem.displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
				var properties : ISet = queueItem.getProperties();
				invokeAdapters(adapters, function(adapter : II10NApapter) : void {
					adapter.validate(queueItem.displayObject, properties);
				});
			}
		}

		/**
		 * Invokes all adapters that have been found for a particular component.
		 */
		private function invokeAdapters(adapters : IOrderedSet, callback : Function) : void {
			var iterator : IIterator = adapters.iterator();
			while (iterator.hasNext()) {
				var adapter : II10NApapter = iterator.next();
				callback(adapter);
			}
		}

		/**
		 * Generates a list of adapters applicable for the given component.
		 */
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
