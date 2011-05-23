package org.as3commons.ui.lifecycle.render {

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMapIterator;
	import org.as3commons.collections.framework.IOrderedMap;
	import org.as3commons.collections.framework.IOrderedSet;
	import org.as3commons.collections.utils.Sets;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class RenderManager implements IRenderManager {
		
		private var _stage : Stage;
		private var _selectors : IOrderedMap;

		private var _queue : IOrderedSet;
		private var _schedule : IOrderedSet;
		
		private var _isRendering : Boolean;
		
		public function RenderManager() {
			_selectors = new LinkedMap();

			_queue = new LinkedSet();
			_schedule = new LinkedSet();
		}
		
		public function set stage(stage : Stage) : void {
			_stage = stage;
		}

		public function configureProcessor(selector : IRenderObjectSelector, processor : IRenderProcessor) : void {
			var processors : IOrderedSet = _selectors.itemFor(selector);
			if (!processors) {
				processors = new LinkedSet();
				_selectors.add(selector, processors);
			}
			processors.add(processor);
		}

		public function invalidate(displayObject : DisplayObject) : void {
			// no stage assigned
			if (!_stage) throw new ArgumentError(
				"You need to pass a valid Stage instance to the RenderManager.init method."
			);

			// display object not in display list
			if (!displayObject.stage) return;
			
			// do not add new items during a rendering process
			if (_isRendering) {
				if (_schedule.has(displayObject)) return;
				_schedule.add(displayObject);
				
			// allowed to add items before rendering
			} else {
				if (_queue.has(displayObject)) return;
				_queue.add(displayObject);
				
				// first display object queued
				if (_queue.size == 1) {
					_stage.addEventListener(Event.EXIT_FRAME, stageExitFrame);
				}
			}
			
		}

		private function stageExitFrame(event : Event) : void {
			_isRendering = true;
			
			while (_queue.size) {
				var displayObject : DisplayObject = _queue.removeFirst();
				var processors : IOrderedSet = getProcessors(displayObject);
				
				var iterator : IIterator = processors.iterator();
				while (iterator.hasNext()) {
					var processor : IRenderProcessor = iterator.next();
					processor.render(displayObject);
				}
			}

			_stage.removeEventListener(Event.EXIT_FRAME, stageExitFrame);
			_isRendering = false;

			while (_schedule.size) {
				invalidate(_schedule.removeFirst());
			}
		}

		private function getProcessors(displayObject : DisplayObject) : IOrderedSet {
			var uniqueProcessors : IOrderedSet = new LinkedSet;
			
			var iterator : IMapIterator = _selectors.iterator() as IMapIterator;
			while (iterator.hasNext()) {
				var processors : LinkedSet = iterator.next();
				var selector : IRenderObjectSelector = iterator.key;
				
				if (selector.approve(displayObject)) {
					Sets.addFromCollection(uniqueProcessors, processors);
				}
			}
			
			return uniqueProcessors;
		}

	}
}
