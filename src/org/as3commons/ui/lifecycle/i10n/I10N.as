package org.as3commons.ui.lifecycle.i10n {

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IOrderedMap;
	import org.as3commons.collections.framework.IOrderedSet;
	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.framework.uiservice.AbstractUIAdapter;
	import org.as3commons.ui.framework.uiservice.AbstractUIService;
	import org.as3commons.ui.framework.uiservice.errors.ServiceAlreadyStartedError;
	import org.as3commons.ui.framework.uiservice.errors.ServiceNotStartedError;
	import org.as3commons.ui.lifecycle.i10n.core.I10NPhase;
	import org.as3commons.ui.lifecycle.i10n.errors.NoValidationPhaseError;
	import org.as3commons.ui.lifecycle.i10n.errors.PhaseAlreadyExistsError;
	import org.as3commons.ui.lifecycle.i10n.errors.PhaseDoesNotExistError;
	import org.as3commons.ui.lifecycle.i10n.errors.ValidateNowInRunningCycleError;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	use namespace as3commons_ui;

	/**
	 * Invalidation service.
	 * 
	 * @author Jens Struwe 09.09.2011
	 */
	public class I10N extends AbstractUIService implements II10N {

		/**
		 * Constant defining a top-down phase order.
		 */
		public static const PHASE_ORDER_TOP_DOWN : String = "order_top_down";

		/**
		 * Constant defining a bottom-up phase order.
		 */
		public static const PHASE_ORDER_BOTTOM_UP : String = "order_bottom_up";

		/**
		 * Constant defining a validation cycle loopback after all phases.
		 */
		public static const PHASE_LOOPBACK_NONE : String = "loopback_none";

		/**
		 * Constant defining a validation cycle loopback after each validated item.
		 */
		public static const PHASE_LOOPBACK_AFTER_ITEM : String = "loopback_after_item";

		/**
		 * Constant defining a validation cycle loopback after each processed phase.
		 */
		public static const PHASE_LOOPBACK_AFTER_PHASE : String = "loopback_after_phase";

		private var _phases : IOrderedMap;
		private var _schedule : IOrderedSet;
		private var _stageInvalidationTimer : Timer;

		private var _stage : Stage;

		private var _cycleIsScheduled : Boolean;
		private var _cycleIsRunning : Boolean;
		private var _currentPhaseName : String;
		private var _currentDisplayObject : DisplayObject;

		private var _validateNowTarget : I10NAdapter;
		
		/**
		 * I10N constructor.
		 */
		public function I10N() {
			_phases = new LinkedMap();

			_schedule = new LinkedSet();
			
			_stageInvalidationTimer = new Timer(0);
			_stageInvalidationTimer.addEventListener(TimerEvent.TIMER, stageInvalidationTimerHandler);
		}

		/*
		 * II10N
		 */
		
		/**
		 * @inheritDoc
		 */
		public function start() : void {
			if (!_phases.size) throw new NoValidationPhaseError();

			start_protected();
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerDisplayObject(displayObject : DisplayObject, adapter : I10NAdapter) : void {
			registerDisplayObject_protected(displayObject, adapter);
		}

		/**
		 * @inheritDoc
		 */
		public function unregisterDisplayObject(displayObject : DisplayObject) : void {
			unregisterDisplayObject_protected(displayObject);
		}

		/**
		 * @inheritDoc
		 */
		public function cleanUp() : void {
			cleanUp_protected();
		}

		/**
		 * @inheritDoc
		 */
		public function addPhase(phaseName : String, order : String, loopback : String = "loopback_after_item") : void {
			if (_initialized) throw new ServiceAlreadyStartedError();
			if (_phases.hasKey(phaseName)) throw new PhaseAlreadyExistsError(phaseName);
			
			if (!_phases.size) loopback = PHASE_LOOPBACK_NONE; // first phase

			_phases.add(phaseName, new I10NPhase(phaseName, order, loopback));
		}

		/**
		 * @inheritDoc
		 */
		public function validateNow() : void {
			if (!_initialized) throw new ServiceNotStartedError();
			if (_cycleIsRunning) throw new ValidateNowInRunningCycleError();

			unscheduleCycle();
			runCycle();
		}

		/**
		 * @inheritDoc
		 */
		public function get validationIsRunning() : Boolean {
			return _cycleIsRunning;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentPhaseName() : String {
			return _currentPhaseName;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentDisplayObject() : DisplayObject {
			return _currentDisplayObject;
		}

		/*
		 * as3commons_ui
		 */

		as3commons_ui function invalidate_internal(adapter : I10NAdapter, phaseName : String) : void {
			if (!_phases.hasKey(phaseName)) throw new PhaseDoesNotExistError(phaseName);

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
			if (_cycleIsRunning) throw new ValidateNowInRunningCycleError();

			_validateNowTarget = adapter;
			runCycle();
			_validateNowTarget = null;
			if (!_schedule.size) unscheduleCycle();
		}
		
		as3commons_ui function get phases_internal() : IOrderedMap {
			return _phases;
		}

		/*
		 * Protected
		 */

		/**
		 * @inheritDoc
		 */
		override protected function onRegister(adapter : AbstractUIAdapter) : void {
			I10NAdapter(adapter).setNestLevel_internal(calculateNestLevel(adapter as I10NAdapter));

			adapter.displayObject.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 10);
			adapter.displayObject.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 10);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onUnregister(adapter : AbstractUIAdapter, displayObject : DisplayObject) : void {
			displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			displayObject.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			removeFromAllQueues(adapter as I10NAdapter);
			
			if (!_schedule.size) unscheduleCycle();
		}

		/**
		 * @inheritDoc
		 */
		override protected function onCleanUp() : void {
			unscheduleCycle();
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
			
			adapter.setNestLevel_internal(calculateNestLevel(adapter));

			if (adapter.isInvalid()) {
				var iterator : IIterator = _phases.iterator();
				while (iterator.hasNext()) {
					var phase : I10NPhase = iterator.next();
					if (adapter.isInvalid(phase.name)) {
						
						adapter.testInvalidationAllowed_internal(phase.name);

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
			adapter.setNestLevel_internal(-1);

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
					return I10NAdapter(getAdapter_internal(parent)).nestLevel + 1;
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
			
			/*
			 * Here we want to register for the next screen update (Event.RENDER)
			 * where we want to process our schedule. We need to call _stage.invalidate()
			 * in order to get the Event.RENDER dispatched.
			 * 
			 * Unfortunately, Flash does not consider nested calls to _stage.invalidate(). Nested
			 * calls may happen when using different invalidation frameworks together such as
			 * Flex and this one here.
			 * 
			 * There is no safe way to determine whether we are in a render event handler or not.
			 * We use here the following workaround:
			 * 
			 * - Invalidate the stage as usual. If we are not in a render handler, this will
			 *   work properly and notify us right before the next screen update.
			 *   To speed up the response, we create a dummy mouse event and call its
			 *   updateAfterEvent() method. The Event.RENDER will be dispatched right after the
			 *   current block of code, which is fine and avoids jittering in movies with a
			 *   small frame rate. No need to call mouseEvent.updateAfterEvent() in client code.
			 *   
			 * - Additionally, we start a timer with a very small delay. If we are in a render
			 *   handler, the timer will fire right after the current rendering has been finished.
			 *   Tests show, that there is still a delay between the finishing of the rendering and 
			 *   the timer event dispatched, but this is hopefully imperceptible. In any case the
			 *   timer fires before the next ENTER_FRAME event, so the timer approach might be better one.
			 */

			// regular stage invalidation
			_stage.addEventListener(Event.RENDER, renderHandler);
			_stage.invalidate();
			// request immediate screen update
			new MouseEvent(MouseEvent.CLICK).updateAfterEvent();
			
			// if we are in a render handler, we cannot invalidate the stage again.
			// for this rare case we use a timer to invalidate the stage at the next
			// possibility
			_stageInvalidationTimer.start();

			_cycleIsScheduled = true;
		}

		private function stageInvalidationTimerHandler(event : TimerEvent) : void {
			_stageInvalidationTimer.stop();
			_stage.invalidate();
			// request immediate screen update
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
