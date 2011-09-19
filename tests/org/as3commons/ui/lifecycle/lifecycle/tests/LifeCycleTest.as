package org.as3commons.ui.lifecycle.lifecycle.tests {

	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.lifecycle.i10n.errors.ValidateNowInRunningCycleError;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import org.as3commons.ui.lifecycle.lifecycle.testhelper.LifeCycleCallbackWatcher;
	import org.as3commons.ui.lifecycle.lifecycle.testhelper.TestLifeCycleAdapter;
	import org.as3commons.ui.lifecycle.testhelper.AsyncCallback;
	import org.as3commons.ui.testhelper.TestDisplayObject;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Jens Struwe 15.09.2011
	 */
	public class LifeCycleTest {

		private var _lifeCycle : LifeCycle;
		private var _watcher : LifeCycleCallbackWatcher;

		[Before]
		public function setUp() : void {
			_lifeCycle = new LifeCycle();

			_watcher = new LifeCycleCallbackWatcher();
		}

		[After]
		public function tearDown() : void {
			_lifeCycle.cleanUp();
			_lifeCycle = null;
			_watcher = null;
			
			StageProxy.cleanUpRoot();
		}

		private function setUpCompleteTimer(callback : Function) : void {
			AsyncCallback.setUpCompleteTimer(this, callback);
		}

		[Test]
		public function test_instantiated() : void {
			assertTrue(_lifeCycle is LifeCycle);
		}

		[Test(async)]
		public function test_register() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));

				adapter.invalidate();

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_validateNow() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);
			adapter2.invalidate();
			
			_lifeCycle.validateNow();

			assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE, s2, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));

			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_validateNow_withoutInvalidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);
			
			_lifeCycle.validateNow();

			assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
		}

		[Test(async)]
		public function test_validateNow_duringValidationThrowsError() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var errorThrown : Error;
			setUpCompleteTimer(complete);

			function validate() : void {
				try {
					_lifeCycle.validateNow();
				} catch (e : Error) {
					errorThrown = e;
				}
			}
			
			function complete(event : Event, data : * = null) : void {
				assertNotNull(errorThrown);
				assertTrue(errorThrown is ValidateNowInRunningCycleError);
			}
		}

		[Test(async)]
		public function test_unregister() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));

				adapter.invalidate();
				_lifeCycle.unregisterDisplayObject(s);

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_unregister_inValidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.invalidateDefaults();
				
				_lifeCycle.unregisterDisplayObject(s);
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_unregister_inValidation_afterRemovedFromStage() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			adapter.invalidate("test2");
			
			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.invalidateDefaults();
				
				StageProxy.root.removeChild(s);
				_lifeCycle.unregisterDisplayObject(s);
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
				StageProxy.root.addChild(s);

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_cleanUp() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			_lifeCycle.cleanUp();
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_cleanUp_inValidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.invalidateDefaults();

				_lifeCycle.cleanUp();
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.phasesLog;
				assertTrue(log, ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], log));
			}
		}

		[Test(async)]
		public function test_currentPhase() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.calculateFunction = otherPhase;
			adapter.renderFunction = otherPhase;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter2.validateFunction = validate2;
			adapter2.calculateFunction = otherPhase;
			adapter2.renderFunction = otherPhase;
			_lifeCycle.registerDisplayObject(s2, adapter2);
			adapter2.invalidate();			

			assertNull(_lifeCycle.currentPhaseName);
			
			var result : Array = new Array();
			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.invalidateDefaults();
				adapter.scheduleRendering();
				result.push(_lifeCycle.currentPhaseName);
			}
			
			function validate2() : void {
				adapter2.invalidateDefaults();
				adapter2.scheduleRendering();
				result.push(LifeCycle.PHASE_VALIDATE);
			}

			function otherPhase() : void {
				result.push(_lifeCycle.currentPhaseName);
			}
			
			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					LifeCycle.PHASE_VALIDATE,
					LifeCycle.PHASE_VALIDATE,
					LifeCycle.PHASE_CALCULATE_DEFAULTS,
					LifeCycle.PHASE_CALCULATE_DEFAULTS,
					LifeCycle.PHASE_RENDER,
					LifeCycle.PHASE_RENDER
				], result));

				assertNull(_lifeCycle.currentPhaseName);
			}

		}

		[Test(async)]
		public function test_validationIsRunning() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.calculateFunction = otherPhase;
			adapter.renderFunction = otherPhase;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			assertFalse(_lifeCycle.validationIsRunning);
			
			var result : Array = new Array();
			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.invalidateDefaults();
				adapter.scheduleRendering();
				result.push(_lifeCycle.validationIsRunning);
			}
			
			function otherPhase() : void {
				result.push(_lifeCycle.validationIsRunning);
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					true, true, true
				], result));

				assertFalse(_lifeCycle.validationIsRunning);
			}

		}

		[Test(async)]
		public function test_currentDisplayObject() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.calculateFunction = otherPhase;
			adapter.renderFunction = otherPhase;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter2.validateFunction = validate2;
			adapter2.calculateFunction = otherPhase;
			adapter2.renderFunction = otherPhase;
			_lifeCycle.registerDisplayObject(s2, adapter2);
			adapter2.invalidate();
			
			assertNull(_lifeCycle.currentDisplayObject);
			
			var result : Array = new Array();
			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.invalidateDefaults();
				adapter.scheduleRendering();
				result.push(_lifeCycle.currentDisplayObject);
			}
			
			function validate2() : void {
				adapter2.invalidateDefaults();
				adapter2.scheduleRendering();
				result.push(_lifeCycle.currentDisplayObject);
			}
			
			function otherPhase() : void {
				result.push(_lifeCycle.currentDisplayObject);
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					s, s2, s, s2, s, s2
				], result));

				assertNull(_lifeCycle.currentDisplayObject);
			}

		}

	}
}
