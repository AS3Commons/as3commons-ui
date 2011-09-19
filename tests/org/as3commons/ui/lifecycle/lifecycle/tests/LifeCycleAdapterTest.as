package org.as3commons.ui.lifecycle.lifecycle.tests {

	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.framework.uiservice.errors.AdapterNotRegisteredError;
	import org.as3commons.ui.lifecycle.i10n.errors.ValidateNowInRunningCycleError;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import org.as3commons.ui.lifecycle.lifecycle.errors.InvalidationNotAllowedHereError;
	import org.as3commons.ui.lifecycle.lifecycle.testhelper.LifeCycleCallbackWatcher;
	import org.as3commons.ui.lifecycle.lifecycle.testhelper.TestLifeCycleAdapter;
	import org.as3commons.ui.lifecycle.testhelper.AsyncCallback;
	import org.as3commons.ui.testhelper.TestDisplayObject;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Jens Struwe 15.09.2011
	 */
	public class LifeCycleAdapterTest {

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

		[Test(async)]
		public function test_invalidate() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			setUpCompleteTimer(complete);
			
			function validate() : void {
				adapter.invalidateDefaults();
				adapter.scheduleRendering();
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_CALCULATE_DEFAULTS,
					s, LifeCycle.PHASE_RENDER
				], _watcher.phasesLog));
			}
		}


		[Test]
		public function test_invalidate_beforeRegistrationThrowsError() : void {
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			var errorThrown : Error;
			try {
				adapter.invalidate();
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);
		}

		[Test(async)]
		public function test_invalidate_multipleTimes() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			adapter.invalidate();
			
			setUpCompleteTimer(complete);
			
			function validate() : void {
				adapter.invalidateDefaults();
				adapter.scheduleRendering();
				adapter.invalidateDefaults();
				adapter.scheduleRendering();
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_CALCULATE_DEFAULTS,
					s, LifeCycle.PHASE_RENDER,
				], _watcher.phasesLog));
			}
		}


		[Test(async)]
		public function test_invalidate_inRenderHandler() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			_lifeCycle.registerDisplayObject(s, adapter);
			
			AsyncCallback.setUpRenderTimer(this, invalidate);
			
			function invalidate(event : Event, data : * = null) : void {
				adapter.invalidate();

				setUpCompleteTimer(complete);
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_invalidate_inValidation_currentPhase() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			setUpCompleteTimer(complete);
			
			function validate() : void {
				if (!adapter.validateCount) {
					adapter.invalidate();
				}
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.phasesLog;
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_VALIDATE
				], log));
			}
		}

		[Test(async)]
		public function test_invalidate_inValidation_allProperties() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			
			var results : Array = new Array();
			storeResults();

			setUpCompleteTimer(complete);
			
			function validate() : void {
				if (!adapter.validateCount) {
					storeResults();

					adapter.invalidate();

					storeResults();
				}

				if (adapter.validateCount) {
					storeResults();
				}
			}

			function storeResults() : void {
				results.push(
					adapter.isInvalidForAnyPhase(),
					adapter.isInvalid(),
					adapter.isInvalid("test"),
					adapter.isInvalid("test2"),
					adapter.isInvalid("all_properties")
				);
			}
			
			function complete(event : Event, data : * = null) : void {
				storeResults();
				
				assertTrue(ArrayUtils.arraysEqual([
					// immediately phase1
					true, true, true, false, false,

					// phase1 first run1
					true, true, true, false, false,
					// phase1 first run2
					true, true, true, true, true,

					// phase1 second
					true, true, true, true, true,

					// complete
					false, false, false, false, false
				], results));
			}
		}

		[Test(async)]
		/*
		 * s (validateNow -> invalidate s2, s3)
		 * -- s2
		 * s3
		 * -- s4
		 */
		public function test_invalidate_others_inValidateNow() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s, adapter);

			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);

			var s3 : Sprite = StageProxy.root.addChild(new TestDisplayObject("s3")) as Sprite;
			var adapter3 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s3, adapter3);

			adapter.invalidate();
			adapter.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([
				s, LifeCycle.PHASE_VALIDATE,
				s2, LifeCycle.PHASE_VALIDATE
			], _watcher.phasesLog));

			setUpCompleteTimer(complete);

			function validate() : void {
				adapter2.invalidate();
				adapter3.invalidate();
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s3, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
			}
		}

		[Test(async)]
		/*
		 * s
		 * -- s2 (validateNow -> invalidate s, s3)
		 * -- -- s3
		 */
		public function test_invalidate_others_inValidateNow2() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);

			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter2.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s2, adapter2);

			var s3 : Sprite = s2.addChild(new TestDisplayObject("s3")) as Sprite;
			var adapter3 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s3, adapter3);

			adapter2.invalidate();
			adapter2.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([
				s2, LifeCycle.PHASE_VALIDATE, s3, LifeCycle.PHASE_VALIDATE
			], _watcher.phasesLog));

			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.invalidate();
				adapter3.invalidate();
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_invalidate_notOnStage() : void {
			var s : DisplayObject = new TestDisplayObject("s");
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_invalidate_notOnStage_autoAdd() : void {
			var s : DisplayObject = new TestDisplayObject("s");
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.phasesLog));
				StageProxy.root.addChild(s);

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_invalidate_removedFromStageinValidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			setUpCompleteTimer(complete);
			
			function validate() : void {
				adapter.invalidateDefaults();
				adapter.scheduleRendering();
				
				StageProxy.root.removeChild(s);
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.phasesLog;
				assertTrue(log, ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE
				], log));
			}
		}

		[Test(async)]
		public function test_invalidate_addedToStageinValidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.calculateFunction = calculate;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();

			var s2 : DisplayObject = new TestDisplayObject("s2");
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);
			adapter2.invalidate();
			
			setUpCompleteTimer(complete);
			
			function validate() : void {
				adapter.invalidateDefaults();
			}

			function calculate() : void {
				StageProxy.root.addChild(s2);
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.phasesLog;
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_CALCULATE_DEFAULTS,
					s2, LifeCycle.PHASE_VALIDATE
				], log));
			}
		}

		[Test(async)]
		public function test_invalidate_removedAndAddedToStageinValidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.calculateFunction = calculate;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();

			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter2.validateFunction = validate2;
			_lifeCycle.registerDisplayObject(s2, adapter2);
			adapter2.invalidate();
			
			setUpCompleteTimer(complete);
			
			function validate() : void {
				adapter.invalidateDefaults();
				adapter.scheduleRendering();

				StageProxy.root.removeChild(s2);
			}

			function calculate() : void {
				StageProxy.root.addChild(s2);
			}

			function validate2() : void {
				adapter2.invalidateDefaults();
				adapter2.scheduleRendering();
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.phasesLog;
				assertTrue(log, ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_CALCULATE_DEFAULTS,
					s2, LifeCycle.PHASE_VALIDATE,
					s2, LifeCycle.PHASE_CALCULATE_DEFAULTS,
					s, LifeCycle.PHASE_RENDER,
					s2, LifeCycle.PHASE_RENDER
				], log));
			}
		}

		[Test(async)]
		public function test_invalidate_removedFromStage_autoAdd() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			StageProxy.root.removeChild(s);
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.phasesLog));
				StageProxy.root.addChild(s);

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_invalidate_properties() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			
			var results : Array = new Array();
			storeResults();

			setUpCompleteTimer(complete);
			
			function storeResults() : void {
				results.push(
					adapter.isInvalidForAnyPhase(),
					
					adapter.isInvalid(),
					adapter.isInvalid("test"),
					adapter.isInvalid("test2"),
					adapter.isInvalid("all_properties"),
					
					adapter.defaultIsInvalid(),
					adapter.defaultIsInvalid("test"),
					adapter.defaultIsInvalid("test2")
				);
			}
			
			function validate() : void {
				storeResults();
			}

			function complete(event : Event, data : * = null) : void {
				storeResults();

				assertTrue(ArrayUtils.arraysEqual([
					// immediately
					true,
					true, true,	false, false,
					false, false, false,
					// validate
					true,
					true, true, false, false,
					false, false, false,
					// complete
					false,
					false, false,false, false,
					false, false, false
				], results));
			}
		}

		[Test(async)]
		public function test_invalidate_allProperties() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = storeResults;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var results : Array = new Array();
			storeResults();

			setUpCompleteTimer(complete);
			
			function storeResults() : void {
				results.push(
					adapter.isInvalidForAnyPhase(),

					adapter.isInvalid(),
					adapter.isInvalid("test"),
					adapter.isInvalid("test2"),
					adapter.isInvalid("all_properties"),

					adapter.defaultIsInvalid(),
					adapter.defaultIsInvalid("test"),
					adapter.defaultIsInvalid("test2"),
					adapter.defaultIsInvalid("all_properties")
				);
			}
			
			function complete(event : Event, data : * = null) : void {
				storeResults();

				assertTrue(ArrayUtils.arraysEqual([
					// immediately
					true,
					true, true, true, true,
					false, false, false, false,
					// validate
					true,
					true, true, true, true,
					false, false, false, false,
					// complete
					false,
					false, false, false, false,
					false, false, false, false
				], results));
			}
		}

		[Test(async)]
		public function test_invalidate_allProperties2() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			adapter.invalidate();
			
			var results : Array = new Array();
			storeResults();

			setUpCompleteTimer(complete);
			
			function validate() : void {
				adapter.invalidateDefaults();
				adapter.invalidateDefaults("test");

				storeResults();
			}

			function storeResults() : void {
				results.push(
					adapter.isInvalidForAnyPhase(),

					adapter.isInvalid(),
					adapter.isInvalid("test"),
					adapter.isInvalid("test2"),
					adapter.isInvalid("all_properties"),

					adapter.defaultIsInvalid(),
					adapter.defaultIsInvalid("test"),
					adapter.defaultIsInvalid("test2"),
					adapter.defaultIsInvalid("all_properties")
				);
			}
			
			function complete(event : Event, data : * = null) : void {
				storeResults();
				
				assertTrue(ArrayUtils.arraysEqual([
					// immediately
					true,
					true, true, true, true,
					false, false, false, false,
					// validate
					true,
					true, true, true, true,
					true, true, true, true,
					// complete
					false,
					false, false, false, false,
					false, false, false, false
				], results));
			}
		}

		[Test(async)]
		public function test_invalidate_propertiesRemovedAfterPhase() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.calculateFunction = storeResults;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			adapter.invalidate("test2");
			
			
			var results : Array = new Array();
			storeResults();

			setUpCompleteTimer(complete);
			
			function validate() : void {
				adapter.invalidateDefaults();

				storeResults();
			}

			function storeResults() : void {
				results.push(
					adapter.isInvalidForAnyPhase(),

					adapter.isInvalid(),
					adapter.isInvalid("test"),
					adapter.isInvalid("test2"),
					adapter.isInvalid("test3"),
					
					adapter.defaultIsInvalid()
				);
			}

			function complete(event : Event, data : * = null) : void {
				storeResults();

				assertTrue(ArrayUtils.arraysEqual([
					// immediately
					true, true, true, true, false, false,
					// validate
					true, true, true, true, false, true,
					// calculate
					true, false, false, false, false, true,
					// complete
					false, false, false, false, false, false
				], results));
			}
		}

		[Test(async)]
		/*
		 * Reinvalidation in phase 2
		 */
		public function test_invalidate_propertiesRemovedAfterPhase2() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.calculateFunction = calculate;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			adapter.invalidate("test2");
			
			var results : Array = new Array();
			storeResults();
			
			setUpCompleteTimer(complete);
			
			function validate() : void {
				adapter.invalidateDefaults();
				
				storeResults();
			}

			function calculate() : void {
				storeResults();

				if (!adapter.calculatedCount) adapter.invalidate("test");

				storeResults();
			}

			function storeResults() : void {
				results.push(
					adapter.isInvalidForAnyPhase(),
					adapter.isInvalid(),
					adapter.isInvalid("test"),
					adapter.isInvalid("test2")
				);
			}

			function complete(event : Event, data : * = null) : void {
				storeResults();

				var log : Array = _watcher.phasesLog;
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_CALCULATE_DEFAULTS,
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_CALCULATE_DEFAULTS
				], log));

				assertTrue(results, ArrayUtils.arraysEqual([
					// immediately
					true, true, true, true,
					// validate
					true, true, true, true,
					// calculate defaults - first
					true, false, false, false,
					// calculate defaults - second
					true, true, true, false,
					// validate #2
					true, true, true, false,
					// calculate defaults #2 - first
					true, false, false, false,
					// calculate defaults #2 - second
					true, false, false, false,
					// complete
					false, false, false, false
				], results));
			}

		}

		[Test]
		public function test_isInvalid_allProperties() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			assertTrue(adapter.isInvalidForAnyPhase());
			assertTrue(adapter.isInvalid());
			assertTrue(adapter.isInvalid("test"));
			assertTrue(adapter.isInvalid("test2"));

			assertFalse(adapter.defaultIsInvalid());
			assertFalse(adapter.defaultIsInvalid("test"));
			assertFalse(adapter.shouldRender());
			assertFalse(adapter.shouldRender("test"));
		}

		[Test]
		public function test_isInvalid() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate("test");
			
			assertTrue(adapter.isInvalidForAnyPhase());
			assertTrue(adapter.isInvalid());
			assertTrue(adapter.isInvalid("test"));
			assertFalse(adapter.isInvalid("test2"));

			assertFalse(adapter.defaultIsInvalid());
			assertFalse(adapter.defaultIsInvalid("test"));
			assertFalse(adapter.shouldRender());
			assertFalse(adapter.shouldRender("test"));
		}

		[Test]
		public function test_isInvalid_beforeRegistrationThrowsError() : void {
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			var errorThrown : Error;
			try {
				assertFalse(adapter.isInvalid());
			} catch (e : Error) {
				errorThrown = e;
			}

			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);

			errorThrown = null;
			try {
				assertFalse(adapter.isInvalid("test"));
			} catch (e : Error) {
				errorThrown = e;
			}

			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);
		}

		[Test]
		public function test_defaultIsInvalid_beforeRegistrationThrowsError() : void {
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			var errorThrown : Error;
			try {
				assertFalse(adapter.defaultIsInvalid());
			} catch (e : Error) {
				errorThrown = e;
			}

			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);

			errorThrown = null;
			try {
				assertFalse(adapter.defaultIsInvalid("test"));
			} catch (e : Error) {
				errorThrown = e;
			}

			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);
		}

		[Test]
		public function test_shouldRender_beforeRegistrationThrowsError() : void {
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			var errorThrown : Error;
			try {
				assertFalse(adapter.shouldRender());
			} catch (e : Error) {
				errorThrown = e;
			}

			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);

			errorThrown = null;
			try {
				assertFalse(adapter.shouldRender("test"));
			} catch (e : Error) {
				errorThrown = e;
			}

			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);
		}

		[Test(async)]
		public function test_validateNow_inValidationThrowsError() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var errorThrown : Error;
			setUpCompleteTimer(complete);
			
			function validate() : void {
				try {
					adapter.validateNow();
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
		public function test_validateNow() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);

			adapter.invalidate();
			adapter.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
		}

		[Test]
		public function test_validateNow_beforeRegistrationThrowsError() : void {
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);

			var errorThrown : Error;
			try {
				adapter.validateNow();
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);
		}

		[Test(async)]
		public function test_validateNow_withoutInvalidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);

			adapter.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([], _watcher.validateLog));
		}

		[Test(async)]
		public function test_validateNow_validatesOnlyTarget() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);

			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);

			adapter.invalidate();
			adapter2.invalidate();
			adapter.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));

			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s2, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_validateNow_validatesOnlyTarget2() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);

			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);

			var s3 : Sprite = StageProxy.root.addChild(new TestDisplayObject("s3")) as Sprite;
			var adapter3 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s3, adapter3);

			var s4 : Sprite = s3.addChild(new TestDisplayObject("s4")) as Sprite;
			var adapter4 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s4, adapter4);

			adapter.invalidate();
			adapter2.invalidate();
			adapter3.invalidate();
			adapter4.invalidate();

			adapter.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([s, LifeCycle.PHASE_VALIDATE, s2, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));

			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s3, LifeCycle.PHASE_VALIDATE, s4, LifeCycle.PHASE_VALIDATE], _watcher.phasesLog));
			}
		}

		[Test]
		public function test_onAddedToStage_onRemovedFromStage() : void {
			var s : Sprite = new TestDisplayObject("s");
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			
			assertEquals(0, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));
			
			StageProxy.root.addChild(s);
			
			assertEquals(1, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([s], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));

			StageProxy.root.removeChild(s);

			assertEquals(1, adapter.addedToStageCount);
			assertEquals(1, adapter.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([s], _watcher.removedLog));

			StageProxy.root.addChild(s);
			
			assertEquals(2, adapter.addedToStageCount);
			assertEquals(1, adapter.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([s], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));
		}

		[Test]
		public function test_onAddedToStage_onRemovedFromStage2() : void {
			var s : Sprite = new TestDisplayObject("s");
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);
			
			assertEquals(0, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertEquals(0, adapter2.addedToStageCount);
			assertEquals(0, adapter2.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));
			
			StageProxy.root.addChild(s);
			
			assertEquals(1, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertEquals(1, adapter2.addedToStageCount);
			assertEquals(0, adapter2.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([s, s2], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));

			StageProxy.root.removeChild(s);

			assertEquals(1, adapter.addedToStageCount);
			assertEquals(1, adapter.removedFromStageCount);
			assertEquals(1, adapter.addedToStageCount);
			assertEquals(1, adapter.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([s, s2], _watcher.removedLog));

			StageProxy.root.addChild(s);
			
			assertEquals(2, adapter.addedToStageCount);
			assertEquals(1, adapter.removedFromStageCount);
			assertEquals(2, adapter.addedToStageCount);
			assertEquals(1, adapter.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([s, s2], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));
		}

		[Test(async)]
		public function test_onRemovedFromStage_onAddedToStage_inValidation() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);
			
			adapter.invalidate();
			
			assertEquals(0, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertEquals(0, adapter2.addedToStageCount);
			assertEquals(0, adapter2.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));

			setUpCompleteTimer(complete);

			function validate() : void {
				if (!adapter.validateCount) { // else, it will schedule a second run
					StageProxy.root.removeChild(s);
					StageProxy.root.addChild(s);
				}
			}

			function complete(event : Event, data : * = null) : void {
				assertEquals("1a", 1, adapter.addedToStageCount);
				assertEquals("1r", 1, adapter.removedFromStageCount);
				assertEquals("2a", 1, adapter2.addedToStageCount);
				assertEquals("2r", 1, adapter2.removedFromStageCount);
				assertTrue(ArrayUtils.arraysEqual([s, s2], _watcher.addedLog));
				assertTrue(ArrayUtils.arraysEqual([s, s2], _watcher.removedLog));
			}
		}

		[Test]
		public function test_onRemovedFromStage_onAddedToStage_afterCleanUp() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);
			
			assertEquals(0, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertEquals(0, adapter2.addedToStageCount);
			assertEquals(0, adapter2.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));
			
			_lifeCycle.cleanUp();

			StageProxy.root.removeChild(s);
			StageProxy.root.addChild(s);

			assertEquals(0, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertEquals(0, adapter2.addedToStageCount);
			assertEquals(0, adapter2.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));
		}

		[Test]
		public function test_onRemovedFromStage_onAddedToStage_afterUnregister() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);
			
			assertEquals(0, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertEquals(0, adapter2.addedToStageCount);
			assertEquals(0, adapter2.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));
			
			_lifeCycle.unregisterDisplayObject(s);

			StageProxy.root.removeChild(s);
			StageProxy.root.addChild(s);

			assertEquals(0, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertEquals(1, adapter2.addedToStageCount);
			assertEquals(1, adapter2.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([s2], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([s2], _watcher.removedLog));
		}

		[Test]
		public function test_nestLevel() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);
			
			assertEquals(2, adapter.nestLevel);
			assertEquals(3, adapter2.nestLevel);
			
			StageProxy.root.removeChild(s);

			assertEquals(-1, adapter.nestLevel);
			assertEquals(-1, adapter2.nestLevel);

			StageProxy.root.addChild(s2);
			s2.addChild(s);

			assertEquals(3, adapter.nestLevel);
			assertEquals(2, adapter2.nestLevel);
		}

		[Test]
		public function test_nestLevel_afterCleanUp() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);
			
			assertEquals(2, adapter.nestLevel);
			assertEquals(3, adapter2.nestLevel);
			
			_lifeCycle.cleanUp();
			
			assertEquals(-1, adapter.nestLevel);
			assertEquals(-1, adapter2.nestLevel);

			StageProxy.root.removeChild(s);

			assertEquals(-1, adapter.nestLevel);
			assertEquals(-1, adapter2.nestLevel);

			StageProxy.root.addChild(s);

			assertEquals(-1, adapter.nestLevel);
			assertEquals(-1, adapter2.nestLevel);
		}

		[Test]
		public function test_nestLevel_afterUnregister() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);
			
			assertEquals(2, adapter.nestLevel);
			assertEquals(3, adapter2.nestLevel);
			
			_lifeCycle.unregisterDisplayObject(s);
			
			assertEquals(-1, adapter.nestLevel);
			assertEquals(3, adapter2.nestLevel);

			StageProxy.root.removeChild(s);

			assertEquals(-1, adapter.nestLevel);
			assertEquals(-1, adapter2.nestLevel);

			StageProxy.root.addChild(s);

			assertEquals(-1, adapter.nestLevel);
			assertEquals(3, adapter2.nestLevel);
		}
		
		[Test(async)]
		public function test_invalidate_withinRenderThrowsError() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.renderFunction = render;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var errorThrown : Error;

			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.scheduleRendering();
			}

			function render() : void {
				try {
					adapter.invalidate();
				} catch (e : Error) {
					errorThrown = e;
				}
			}

			function complete(event : Event, data : * = null) : void {
				assertNotNull(errorThrown);
				assertTrue(errorThrown is InvalidationNotAllowedHereError);
				assertEquals(
					InvalidationNotAllowedHereError.INVALIDATE_FROM_RENDER,
					InvalidationNotAllowedHereError(errorThrown).messageKey
				);
				assertFalse(adapter.isInvalidForAnyPhase());
				assertFalse(adapter.isInvalid());

				assertEquals(1, adapter.validateCount);
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_RENDER
				], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_invalidate_othersWithinRenderThrowsError() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.renderFunction = render;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var s2 : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);

			var errorThrown : Error;

			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.scheduleRendering();
			}

			function render() : void {
				try {
					adapter2.invalidate();
				} catch (e : Error) {
					errorThrown = e;
				}
			}

			function complete(event : Event, data : * = null) : void {
				assertNotNull(errorThrown);
				assertTrue(errorThrown is InvalidationNotAllowedHereError);
				assertEquals(
					InvalidationNotAllowedHereError.INVALIDATE_FROM_RENDER,
					InvalidationNotAllowedHereError(errorThrown).messageKey
				);
				assertFalse(adapter2.isInvalidForAnyPhase());
				assertFalse(adapter2.isInvalid());

				assertEquals(0, adapter2.validateCount);
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_RENDER
				], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_invalidateDefaults_outsideOfCycleThrowsError() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			
			var errorThrown : Error;
			try {
				adapter.invalidateDefaults();
			} catch (e : Error) {
				errorThrown = e;
			}

			assertNotNull(errorThrown);
			assertTrue(errorThrown is InvalidationNotAllowedHereError);
			assertEquals(
				InvalidationNotAllowedHereError.INVALIDATE_FOR_SECONDARY_PHASE_OUTSIDE_OF_CYCLE,
				InvalidationNotAllowedHereError(errorThrown).messageKey
			);
			assertFalse(adapter.isInvalidForAnyPhase());
			assertFalse(adapter.defaultIsInvalid());

			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertEquals(0, adapter.calculatedCount);
				assertTrue(ArrayUtils.arraysEqual([], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_invalidateDefaults_withinCalculateDefaultsThrowsError() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.calculateFunction = calculate;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var errorThrown : Error;

			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.invalidateDefaults();
			}

			function calculate() : void {
				try {
					adapter.invalidateDefaults();
				} catch (e : Error) {
					errorThrown = e;
				}
			}

			function complete(event : Event, data : * = null) : void {
				assertNotNull(errorThrown);
				assertTrue(errorThrown is InvalidationNotAllowedHereError);
				assertEquals(
					InvalidationNotAllowedHereError.INVALIDATE_DEFAULTS_FROM_CALCULATE_DEFAULTS,
					InvalidationNotAllowedHereError(errorThrown).messageKey
				);
				assertFalse(adapter.isInvalidForAnyPhase());
				assertFalse(adapter.defaultIsInvalid());

				assertEquals(1, adapter.calculatedCount);
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_CALCULATE_DEFAULTS
				], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_invalidateDefaults_fromOtherComponentThrowsError() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var s2 : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);

			var errorThrown : Error;

			setUpCompleteTimer(complete);

			function validate() : void {
				try {
					adapter2.invalidateDefaults();
				} catch (e : Error) {
					errorThrown = e;
				}
			}

			function complete(event : Event, data : * = null) : void {
				assertNotNull(errorThrown);
				assertTrue(errorThrown is InvalidationNotAllowedHereError);
				assertEquals(
					InvalidationNotAllowedHereError.INVALIDATE_FOR_SECONDARY_PHASE_NOT_FROM_CURRENT_OBJECT,
					InvalidationNotAllowedHereError(errorThrown).messageKey
				);
				assertFalse(adapter2.isInvalidForAnyPhase());
				assertFalse(adapter2.defaultIsInvalid());

				assertEquals(0, adapter2.calculatedCount);
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE
				], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_invalidateDefaults_withinRenderThrowsError() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.renderFunction = render;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var errorThrown : Error;

			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.scheduleRendering();
			}

			function render() : void {
				try {
					adapter.invalidateDefaults();
				} catch (e : Error) {
					errorThrown = e;
				}
			}

			function complete(event : Event, data : * = null) : void {
				assertNotNull(errorThrown);
				assertTrue(errorThrown is InvalidationNotAllowedHereError);
				assertEquals(
					InvalidationNotAllowedHereError.INVALIDATE_FROM_RENDER,
					InvalidationNotAllowedHereError(errorThrown).messageKey
				);
				assertFalse(adapter.isInvalidForAnyPhase());
				assertFalse(adapter.defaultIsInvalid());

				assertEquals(0, adapter.calculatedCount);
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_RENDER
				], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_scheduleRendering_outsideOfCycleThrowsError() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s, adapter);
			
			var errorThrown : Error;
			try {
				adapter.scheduleRendering();
			} catch (e : Error) {
				errorThrown = e;
			}

			assertNotNull(errorThrown);
			assertTrue(errorThrown is InvalidationNotAllowedHereError);
			assertEquals(
				InvalidationNotAllowedHereError.INVALIDATE_FOR_SECONDARY_PHASE_OUTSIDE_OF_CYCLE,
				InvalidationNotAllowedHereError(errorThrown).messageKey
			);
			assertFalse(adapter.isInvalidForAnyPhase());
			assertFalse(adapter.shouldRender());

			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertEquals(0, adapter.renderCount);
				assertTrue(ArrayUtils.arraysEqual([], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_scheduleRendering_fromOtherComponentThrowsError() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var s2 : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter2 : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			_lifeCycle.registerDisplayObject(s2, adapter2);

			var errorThrown : Error;

			setUpCompleteTimer(complete);

			function validate() : void {
				try {
					adapter2.scheduleRendering();
				} catch (e : Error) {
					errorThrown = e;
				}
			}

			function complete(event : Event, data : * = null) : void {
				assertNotNull(errorThrown);
				assertTrue(errorThrown is InvalidationNotAllowedHereError);
				assertEquals(
					InvalidationNotAllowedHereError.INVALIDATE_FOR_SECONDARY_PHASE_NOT_FROM_CURRENT_OBJECT,
					InvalidationNotAllowedHereError(errorThrown).messageKey
				);
				assertFalse(adapter2.isInvalidForAnyPhase());
				assertFalse(adapter2.shouldRender());

				assertEquals(0, adapter2.renderCount);
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE
				], _watcher.phasesLog));
			}
		}

		[Test(async)]
		public function test_scheduleRendering_withinRenderThrowsError() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestLifeCycleAdapter = new TestLifeCycleAdapter(_watcher);
			adapter.validateFunction = validate;
			adapter.renderFunction = render;

			_lifeCycle.registerDisplayObject(s, adapter);
			adapter.invalidate();
			
			var errorThrown : Error;

			setUpCompleteTimer(complete);

			function validate() : void {
				adapter.scheduleRendering();
			}

			function render() : void {
				try {
					adapter.scheduleRendering();
				} catch (e : Error) {
					errorThrown = e;
				}
			}

			function complete(event : Event, data : * = null) : void {
				assertNotNull(errorThrown);
				assertTrue(errorThrown is InvalidationNotAllowedHereError);
				assertEquals(
					InvalidationNotAllowedHereError.INVALIDATE_FROM_RENDER,
					InvalidationNotAllowedHereError(errorThrown).messageKey
				);
				assertFalse(adapter.isInvalidForAnyPhase());
				assertFalse(adapter.shouldRender());

				assertEquals(1, adapter.renderCount);
				assertTrue(ArrayUtils.arraysEqual([
					s, LifeCycle.PHASE_VALIDATE,
					s, LifeCycle.PHASE_RENDER
				], _watcher.phasesLog));
			}
		}

	}
}
