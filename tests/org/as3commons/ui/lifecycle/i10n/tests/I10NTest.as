package org.as3commons.ui.lifecycle.i10n.tests {

	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.framework.uiservice.errors.ServiceAlreadyStartedError;
	import org.as3commons.ui.framework.uiservice.errors.ServiceNotStartedError;
	import org.as3commons.ui.lifecycle.i10n.I10N;
	import org.as3commons.ui.lifecycle.i10n.errors.NoValidationPhaseError;
	import org.as3commons.ui.lifecycle.i10n.errors.PhaseAlreadyExistsError;
	import org.as3commons.ui.lifecycle.i10n.errors.ValidateNowInRunningCycleError;
	import org.as3commons.ui.lifecycle.i10n.testhelper.I10NCallbackWatcher;
	import org.as3commons.ui.lifecycle.i10n.testhelper.TestI10NAdapter;
	import org.as3commons.ui.lifecycle.testhelper.AsyncCallback;
	import org.as3commons.ui.testhelper.TestDisplayObject;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Jens Struwe 12.09.2011
	 */
	public class I10NTest {
		
		private var _i10n : I10N;
		private var _watcher : I10NCallbackWatcher;

		[Before]
		public function setUp() : void {
			_i10n = new I10N();

			_watcher = new I10NCallbackWatcher();
		}

		[After]
		public function tearDown() : void {
			_i10n.cleanUp();
			_i10n = null;
			_watcher = null;
			
			StageProxy.cleanUpRoot();
		}

		private function setUpCompleteTimer(callback : Function) : void {
			AsyncCallback.setUpCompleteTimer(this, callback);
		}

		[Test]
		public function test_instantiated() : void {
			assertTrue(_i10n is I10N);
		}

		[Test]
		public function test_addPhase_afterStartThrowsError() : void {
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var errorThrown : Error;
			try {
				_i10n.addPhase("test2", I10N.PHASE_ORDER_TOP_DOWN);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is ServiceAlreadyStartedError);
		}

		[Test]
		public function test_addPhase_nameExistsThrowsError() : void {
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);

			var errorThrown : Error;
			try {
				_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is PhaseAlreadyExistsError);
		}

		[Test]
		public function test_start_noPhaseThrowsError() : void {
			var errorThrown : Error;
			try {
				_i10n.start();
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is NoValidationPhaseError);
		}

		[Test(async)]
		public function test_register() : void {
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("test2", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "test"], _watcher.validateLog));

				adapter.invalidate("test2");

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "test2"], _watcher.validateLog));
			}
		}

		[Test]
		public function test_validateNow_beforeStartThrowsError() : void {
			var errorThrown : Error;
			try {
				_i10n.validateNow();
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is ServiceNotStartedError);
		}

		[Test(async)]
		public function test_validateNow() : void {
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("test");
			
			_i10n.validateNow();

			assertTrue(ArrayUtils.arraysEqual([s, "test", s2, "test"], _watcher.validateLog));

			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_validateNow_withoutInvalidation() : void {
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			
			_i10n.validateNow();

			assertTrue(ArrayUtils.arraysEqual([s, "test"], _watcher.validateLog));
		}

		[Test(async)]
		public function test_validateNow_duringValidationThrowsError() : void {
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			
			var errorThrown : Error;
			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				try {
					_i10n.validateNow();
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
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("test2", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "test"], _watcher.validateLog));

				adapter.invalidate("test2");
				_i10n.unregisterDisplayObject(s);

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_unregister_inValidation() : void {
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("test2", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			adapter.invalidate("test2");
			
			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				_i10n.unregisterDisplayObject(s);
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "test"], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_unregister_inValidation_afterRemovedFromStage() : void {
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("test2", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			adapter.invalidate("test2");
			
			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				StageProxy.root.removeChild(s);
				_i10n.unregisterDisplayObject(s);
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "test"], _watcher.validateLog));
				StageProxy.root.addChild(s);

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_cleanUp() : void {
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			
			_i10n.cleanUp();
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_cleanUp_inValidation() : void {
			_i10n.addPhase("test", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("test2", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			adapter.invalidate("test2");
			
			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				_i10n.cleanUp();
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(log, ArrayUtils.arraysEqual([s, "test"], log));
			}
		}

		[Test(async)]
		public function test_currentPhase() : void {
			_i10n.addPhase("phase1", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("phase2", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("phase3", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter2.validateFunction = validate;
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("phase1");
			adapter2.invalidate("phase2");
			adapter2.invalidate("phase3");
			
			assertNull(_i10n.currentPhaseName);
			
			var result : Array = new Array();
			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				result.push(_i10n.currentPhaseName);
			}
			
			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					"phase1",
					"phase1",
					"phase2",
					"phase2",
					"phase3",
					"phase3"
				], result));

				assertNull(_i10n.currentPhaseName);
			}

		}

		[Test(async)]
		public function test_validationIsRunning() : void {
			_i10n.addPhase("phase1", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("phase2", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("phase3", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			
			assertFalse(_i10n.validationIsRunning);
			
			var result : Array = new Array();
			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				result.push(_i10n.validationIsRunning);
			}
			
			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					true, true, true
				], result));

				assertFalse(_i10n.validationIsRunning);
			}

		}

		[Test(async)]
		public function test_currentDisplayObject() : void {
			_i10n.addPhase("phase1", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("phase2", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("phase3", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter2.validateFunction = validate;
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("phase1");
			adapter2.invalidate("phase2");
			adapter2.invalidate("phase3");
			
			assertNull(_i10n.currentDisplayObject);
			
			var result : Array = new Array();
			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				result.push(_i10n.currentDisplayObject);
			}
			
			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					s, s2, s, s2, s, s2
				], result));

				assertNull(_i10n.currentDisplayObject);
			}

		}

	}
}
