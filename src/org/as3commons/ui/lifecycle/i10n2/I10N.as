package org.as3commons.ui.lifecycle.i10n2 {

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.IOrderedMap;
	import org.as3commons.collections.framework.IOrderedSet;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.lifecycle.i10n2.core.I10NPhase;


	use namespace as3commons_ui;

	/**
	 * @author Jens Struwe 09.09.2011
	 */
	public class I10N implements II10N {

		public static const PHASE_ORDER_TOP_DOWN : String = "order_top_down";
		public static const PHASE_ORDER_BOTTOM_UP : String = "order_bottom_up";

		public static const PHASE_LOOPBACK_NONE : String = "loopback_none";
		public static const PHASE_LOOPBACK_AFTER_ITEM : String = "loopback_after_item";
		public static const PHASE_LOOPBACK_AFTER_PHASE : String = "loopback_after_phase";

		private var _phases : IOrderedMap;
		private var _registry : IMap;
		private var _schedule : IOrderedSet;
		private var _stageInvalidationTimer : Timer;

		private var _stage : Stage;

		private var _cycleIsScheduled : Boolean;
		private var _cycleIsRunning : Boolean;
		private var _currentPhaseName : String;
		private var _currentDisplayObject : DisplayObject;

		private var _initialized : Boolean;
		private var _validateNowTarget : I10NAdapter;
		
		public function I10N() {
			_phases = new LinkedMap();
			_registry = new Map();

			_schedule = new LinkedSet();
			
			_stageInvalidationTimer = new Timer(0);
			_stageInvalidationTimer.addEventListener(TimerEvent.TIMER, stageInvalidationTimerHandler);
		}

		/*
		 * II10N
		 */
		
		public function addPhase(phaseName : String, order : String, loopback : String = null) : void {
			if (_initialized) throw new Error("I10N: You cannot add a phase after I10N started.");
			if (_phases.hasKey(phaseName)) throw new Error("I10N: Phase with name " + phaseName + " already added.");
			
			if (!loopback) loopback = PHASE_LOOPBACK_AFTER_ITEM;

			_phases.add(phaseName, new I10NPhase(phaseName, order, loopback));
		}

		public function start() : void {
			if (!_phases.size) throw new Error("I10N: You need to create at least one validation phase.");
			
			_initialized = true;
		}

		public function registerDisplayObject(displayObject : DisplayObject, adapter : I10NAdapter) : void {
			if (!_initialized) throw new Error("I10N: You cannot register objects before starting I10N.");
			if (_registry.hasKey(displayObject)) throw new Error("I10N: You cannot register an object twice.");
			if (adapter.displayObject) throw new Error("I10N: You cannot reuse an I10NAdapter instance.");

			_registry.add(displayObject, adapter);
			adapter.setUp_internal(displayObject, this);
			adapter.nestLevel_internal = calculateNestLevel(adapter);

			displayObject.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 10);
			displayObject.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 10);
		}

		public function unregisterDisplayObject(displayObject : DisplayObject) : void {
			if (!_registry.hasKey(displayObject)) return;

			displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			displayObject.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			var adapter : I10NAdapter = _registry.removeKey(displayObject);
			removeFromAllQueues(adapter);

			adapter.cleanUp_internal();
			
			if (!_schedule.size) unscheduleCycle();
		}

		public function validateNow() : void {
			if (!_initialized) throw new Error("I10N: You can't validate now before starting I10N.");
			if (_cycleIsRunning) throw new Error("I10N: You can't validate now during a running validation.");

			unscheduleCycle();
			runCycle();
		}

		public function get validationIsRunning() : Boolean {
			return _cycleIsRunning;
		}

		public function get currentPhaseName() : String {
			return _currentPhaseName;
		}

		public function get currentDisplayObject() : DisplayObject {
			return _currentDisplayObject;
		}

		public function cleanUp() : void {
			var iterator : ICollectionIterator = _registry.iterator() as ICollectionIterator;
			while (iterator.hasNext()) {
				var adapter : I10NAdapter = iterator.next();
				unregisterDisplayObject(adapter.displayObject);
			}
			
			unscheduleCycle();
		}

		/*
		 * Internal
		 */

		as3commons_ui function getAdapter_internal(displayObject : DisplayObject) : I10NAdapter {
			return _registry.itemFor(displayObject);
		}

		as3commons_ui function hasAdapter_internal(displayObject : DisplayObject) : Boolean {
			return _registry.hasKey(displayObject);
		}

		as3commons_ui function invalidate_internal(adapter : I10NAdapter, phaseName : String) : void {
			if (!_phases.hasKey(phaseName)) throw new Error("I10N: Phase name " + phaseName + " not valid.");

			// ignore items not in display list
			if (!adapter.displayObject.stage) return;
			
			// create a stage reference
			if (!_stage) _stage = adapter.displayObject.stage;
			
			// add to the running cycle 
			if (_cycleIsRunning) {
				var addToPhase : Boolean;
				
				// if validate now - consider only children
				if (_validateNowTarget) {
					if (validateNowTargetContains(adapter)) {
						addToPhase = true;
					}

				// else - add always to the phase
				} else {
					addToPhase = true;
				}
				
				if (addToPhase) {
					var phase : I10NPhase = _phases.itemFor(phaseName);
					phase.enqueue(adapter);
					return;
				}
			}
			
			// add to the schedule
			addToSchedule(adapter);
		}
		
		as3commons_ui function validateNowObject_internal(adapter : I10NAdapter) : void {
			if (_cycleIsRunning) throw new Error("I10N: You can't validate now during a running validation.");

			_validateNowTarget = adapter;
			runCycle();
			_validateNowTarget = null;
			if (!_schedule.size) unscheduleCycle();
		}
		
		as3commons_ui function get phases_internal() : IOrderedMap {
			return _phases;
		}

		/*
		 * Private
		 */

		/**
		 * <p>Since not in the display list before, the adapter is not contained
		 * by any queue. No need to remove it.</p>
		 * 
		 * <p>If the adapter is invalid, it should be added to the appropriate queues.</p>
		 */
		private function addedToStageHandler(event : Event) : void {
			var adapter : I10NAdapter = _registry.itemFor(event.currentTarget);
			adapter.nestLevel_internal = calculateNestLevel(adapter);

			if (adapter.isInvalid()) {
				_schedule.remove(adapter);
				
				var iterator : IIterator = _phases.iterator();
				while (iterator.hasNext()) {
					var phase : I10NPhase = iterator.next();
					if (adapter.isInvalid(phase.name)) {
						invalidate_internal(adapter, phase.name);
					}
				}
			}

			adapter.notifyAdded_internal();
		}

		/**
		 * <p>If the adapter is not invalid, it is not contained by any queue.
		 * Nothing to do.</p>
		 * 
		 * <p>If the adapter is invalid, it is contained either by the
		 * schedule or by a phase. Try to remove it from the schedule
		 * as well as from all phases.</p>
		 */
		private function removedFromStageHandler(event : Event) : void {
			var adapter : I10NAdapter = _registry.itemFor(event.currentTarget);
			adapter.nestLevel_internal = -1;

			if (adapter.isInvalid()) {
				removeFromAllQueues(adapter);
			}

			adapter.notifyRemoved_internal();
		}

		private function calculateNestLevel(adapter : I10NAdapter) : int {
			var nestLevel : int = 0;
			var parent : DisplayObject = adapter.displayObject.parent;
			while (parent) {
				if (hasAdapter_internal(parent)) {
					return getAdapter_internal(parent).nestLevel + 1;
				}
				nestLevel++;
				parent = parent.parent;
			}
			return nestLevel;
		}

		private function removeFromAllQueues(adapter : I10NAdapter) : void {
			_schedule.remove(adapter);

			var iterator : IIterator = _phases.iterator();
			while (iterator.hasNext()) {
				var phase : I10NPhase = iterator.next();
				phase.remove(adapter);
			}
		}
		
		private function addToSchedule(adapter : I10NAdapter) : void {
			_schedule.add(adapter);

			if (_cycleIsScheduled) return;

			_stageInvalidationTimer.start();

			_cycleIsScheduled = true;
		}

		private function stageInvalidationTimerHandler(event : TimerEvent) : void {
			_stageInvalidationTimer.stop();
			_stage.addEventListener(Event.RENDER, renderHandler);
			_stage.invalidate();
			event.updateAfterEvent();
		}
		
		private function renderHandler(event : Event) : void {
			unscheduleCycle();
			runCycle();
		}

		private function unscheduleCycle() : void {
			if (_stage) {
				_stageInvalidationTimer.stop();
				_stage.removeEventListener(Event.RENDER, renderHandler);
			}
			_cycleIsScheduled = false;
		}

		private function validateNowTargetContains(adapter : I10NAdapter) : Boolean {
			if (adapter == _validateNowTarget) return true;
			if (adapter.nestLevel < _validateNowTarget.nestLevel) return false;

			var parent : DisplayObject = adapter.displayObject.parent;
			while (parent) {
				if (parent == _validateNowTarget.displayObject) return true;
				parent = parent.parent;
			}
			return false;
		}
		
		private function runCycle() : void {
			_cycleIsRunning = true;
			
			var adapter : I10NAdapter;
			var phase : I10NPhase;

			// add to the phases
			
			var phasesIterator : ICollectionIterator = _phases.iterator() as ICollectionIterator;

			var scheduleIterator : ICollectionIterator = _schedule.iterator() as ICollectionIterator;
			while (scheduleIterator.hasNext()) {
				adapter = scheduleIterator.next();
				
				if (_validateNowTarget && !validateNowTargetContains(adapter)) continue;
				
				scheduleIterator.remove();

				while (phasesIterator.hasNext()) {
					phase = phasesIterator.next();
					if (adapter.isInvalid(phase.name)) {
						phase.enqueue(adapter);
					}
				}
				phasesIterator.start();
			}
			
			// validate phases

			phase = findPhase();

			while (phase) {
				_currentPhaseName = phase.name;

				adapter = phase.dequeue();
				_currentDisplayObject = adapter.displayObject;
				adapter.validate_iternal(phase.name);
				
				// loopback after item
				if (phase.loopback == PHASE_LOOPBACK_AFTER_ITEM) {
					phase = findPhase();

				} else if (!phase.size) {
					// loopback after phase
					if (phase.loopback == PHASE_LOOPBACK_AFTER_PHASE) {
						phase = findPhase();

					// loopback after cycle
					} else {
						// last phase - loopback
						if (phase == _phases.last) {
							phase = findPhase();

						// intermediate phase - set next phase
						} else {
							phase = findPhase(phase);
						}
					}
				}
				
			}

			_currentDisplayObject = null;
			_currentPhaseName = null;
			_cycleIsRunning = false;
		}

		private function findPhase(phase : I10NPhase = null) : I10NPhase {
			if (!phase) phase = _phases.first;

			while (phase && !phase.size) {
				phase = _phases.itemFor(_phases.nextKey(phase.name));
			}
			
			return phase;
		}
		
	}
}
