package org.as3commons.ui.lifecycle.i10n.tests {

	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.framework.uiservice.errors.AdapterNotRegisteredError;
	import org.as3commons.ui.lifecycle.i10n.I10N;
	import org.as3commons.ui.lifecycle.i10n.errors.PhaseDoesNotExistError;
	import org.as3commons.ui.lifecycle.i10n.errors.ValidateNowInRunningCycleError;
	import org.as3commons.ui.lifecycle.i10n.testhelper.I10NCallbackWatcher;
	import org.as3commons.ui.lifecycle.i10n.testhelper.TestI10NAdapter;
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
	 * @author Jens Struwe 13.09.2011
	 */
	public class I10NAdapterTest {

		private var _i10n : I10N;
		private var _watcher : I10NCallbackWatcher;

		[Before]
		public function setUp() : void {
			_i10n = new I10N();
			_i10n.addPhase("phase1", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("phase2", I10N.PHASE_ORDER_BOTTOM_UP);
			_i10n.addPhase("phase3", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.start();

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

		[Test(async)]
		public function test_invalidate() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					s, "phase1",
					s, "phase2",
					s, "phase3"
				], _watcher.validateLog));
			}
		}

		[Test]
		public function test_invalidate_beforeRegistrationThrowsError() : void {
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);

			var errorThrown : Error;
			try {
				adapter.invalidate("phase1");
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);
		}

		[Test(async)]
		public function test_invalidate_multipleTimes() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase1");
			adapter.invalidate("phase1");
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "phase1"], _watcher.validateLog));

				adapter.invalidate("phase2");
				adapter.invalidate("phase2");
				adapter.invalidate("phase2");

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "phase2"], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_invalidate_wrongPhaseThrowsError() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");

			var errorThrown : Error;
			try {
				adapter.invalidate("phaseWrong");
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is PhaseDoesNotExistError);
		}

		[Test(async)]
		public function test_invalidate_validateCalledOncePerPhase() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			adapter.invalidate("phase3");
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "phase1", s, "phase2", s, "phase3"], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_invalidate_validateCalledOncePerPhase2() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			
			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
				if (adapter.validateCountForPhase(phaseName)) return;
				
				if (phaseName == "phase1") adapter.invalidate("phase2");
				if (phaseName == "phase1") adapter.invalidate("phase3");
				if (phaseName == "phase2") adapter.invalidate("phase3");
			}

			function complete(event : Event, data : * = null) : void {
				assertEquals(1, adapter.validateCountForPhase("phase1"));
				assertEquals(1, adapter.validateCountForPhase("phase2"));
				assertEquals(1, adapter.validateCountForPhase("phase3"));

				assertTrue(ArrayUtils.arraysEqual([s, "phase1", s, "phase2", s, "phase3"], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_invalidate_inValidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			
			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
				if (adapter.validateCountForPhase(phaseName)) return;
				
				if (phaseName == "phase1") adapter.invalidate("phase2");
				if (phaseName == "phase1") adapter.invalidate("phase3");
				if (phaseName == "phase2") adapter.invalidate("phase3");
				if (phaseName == "phase2") adapter.invalidate("phase1");
				if (phaseName == "phase3") adapter.invalidate("phase1");
			}

			function complete(event : Event, data : * = null) : void {
				assertEquals(3, adapter.validateCountForPhase("phase1"));
				assertEquals(1, adapter.validateCountForPhase("phase2"));
				assertEquals(1, adapter.validateCountForPhase("phase3"));

				assertTrue(ArrayUtils.arraysEqual([
					s, "phase1", s, "phase2", s, "phase1", s, "phase3", s, "phase1"
				], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_invalidate_inRenderHandler() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);

			_i10n.registerDisplayObject(s, adapter);
			
			AsyncCallback.setUpRenderTimer(this, invalidate);
			
			function invalidate(event : Event, data : * = null) : void {
				adapter.invalidate("phase1");
				adapter.invalidate("phase2");
				adapter.invalidate("phase3");

				setUpCompleteTimer(complete);
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					s, "phase1", s, "phase2", s, "phase3"
				], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_invalidate_inValidation_currentPhase() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			
			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
				if (!adapter.validateCountForPhase(phaseName)) {
					adapter.invalidate(phaseName);
				}
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(ArrayUtils.arraysEqual([
					s, "phase1",
					s, "phase1",
					s, "phase2",
					s, "phase2"
				], log));
			}
		}

		[Test(async)]
		public function test_invalidate_inValidation_currentPhase2() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			
			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
				if (!adapter.validateCountForPhase(phaseName)) {
					adapter.invalidate("phase1");
					adapter.invalidate("phase2");
				}
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(ArrayUtils.arraysEqual([
					s, "phase1",
					s, "phase1",
					s, "phase2",
					s, "phase1",
					s, "phase2"
				], log));
			}
		}

		[Test(async)]
		public function test_invalidate_inValidation_allProperties() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1", "test");
			adapter.invalidate("phase2");
			
			var results : Array = new Array();
			storeResults("phase1");
			storeResults("phase2");

			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
				if (!adapter.validateCountForPhase(phaseName)) {
					storeResults(phaseName);

					if (phaseName == "phase1") adapter.invalidate("phase1");
					if (phaseName == "phase2") adapter.invalidate("phase2", "test");

					storeResults(phaseName);
				}

				if (adapter.validateCountForPhase(phaseName)) {
					storeResults(phaseName);
				}
			}

			function storeResults(phaseName : String) : void {
				results.push(
					adapter.isInvalid(),
					adapter.isInvalid(phaseName),
					adapter.isInvalid(phaseName, "test"),
					adapter.isInvalid(phaseName, "test2"),
					adapter.isInvalid(phaseName, "all_properties")
				);
			}
			
			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					// immediately phase1
					true, true, true, false, false,
					// immediately phase2
					true, true, true, true, true,

					// phase1 first run1
					true, true, true, false, false,
					// phase1 first run2
					true, true, true, true, true,

					// phase 2 first run1
					true, true, true, true, true,
					// phase 2 first run2
					true, true, true, true, true,

					// phase1 second
					true, true, true, true, true,
					// phase2 second
					true, true, true, false, false
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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);

			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);

			var s3 : Sprite = StageProxy.root.addChild(new TestDisplayObject("s3")) as Sprite;
			var adapter3 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s3, adapter3);

			adapter.invalidate("phase1");
			adapter.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([s, "phase1", s2, "phase1"], _watcher.validateLog));

			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				adapter2.invalidate("phase1");
				adapter3.invalidate("phase1");
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s3, "phase1"], _watcher.validateLog));
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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);

			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter2.validateFunction = validate;
			_i10n.registerDisplayObject(s2, adapter2);

			var s3 : Sprite = s2.addChild(new TestDisplayObject("s3")) as Sprite;
			var adapter3 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s3, adapter3);

			adapter2.invalidate("phase1");
			adapter2.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([s2, "phase1", s3, "phase1"], _watcher.validateLog));

			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				adapter.invalidate("phase1");
				adapter3.invalidate("phase1");
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "phase1"], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_invalidate_notOnStage() : void {
			var s : DisplayObject = new TestDisplayObject("s");
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_invalidate_notOnStage_autoAdd() : void {
			var s : DisplayObject = new TestDisplayObject("s");
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.validateLog));
				StageProxy.root.addChild(s);

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "phase1"], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_invalidate_removedFromStageinValidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase2");
			
			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
				if (phaseName == "phase1") {
					StageProxy.root.removeChild(s);
				}
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(log, ArrayUtils.arraysEqual([
					s, "phase1"
				], log));
			}
		}

		[Test(async)]
		public function test_invalidate_addedToStageinValidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");

			var s2 : DisplayObject = new TestDisplayObject("s2");
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("phase1");
			adapter2.invalidate("phase2");
			
			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
				if (phaseName == "phase2") {
					StageProxy.root.addChild(s2);
				}
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(ArrayUtils.arraysEqual([
					s, "phase1",
					s, "phase2",
					s2, "phase1",
					s2, "phase2"
				], log));
			}
		}

		[Test(async)]
		public function test_invalidate_removedAndAddedToStageinValidation() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");

			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("phase1");
			adapter2.invalidate("phase2");
			adapter2.invalidate("phase3");
			
			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
				if (phaseName == "phase2") {
					StageProxy.root.removeChild(s2);
				}
				if (phaseName == "phase3") {
					StageProxy.root.addChild(s2);
				}
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(ArrayUtils.arraysEqual([
					s, "phase1",
					s2, "phase1",
					s, "phase2",
					s, "phase3",
					s2, "phase2",
					s2, "phase3"
				], log));
			}
		}

		[Test(async)]
		public function test_invalidate_removedFromStage_autoAdd() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			
			StageProxy.root.removeChild(s);
			
			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([], _watcher.validateLog));
				StageProxy.root.addChild(s);

				setUpCompleteTimer(complete2);
			}

			function complete2(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s, "phase1"], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_invalidate_properties() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1", "test");
			
			var results : Array;
			storeResults();
			complete(null);

			setUpCompleteTimer(complete);
			
			function storeResults() : void {
				results = [
					adapter.isInvalid(),
					
					adapter.isInvalid("phase1"),
					adapter.isInvalid("phase1", "test"),
					adapter.isInvalid("phase1", "test2"),
					adapter.isInvalid("phase1", "all_properties"),
					
					adapter.isInvalid("phase2"),
					adapter.isInvalid("phase2", "test"),
					adapter.isInvalid("phase2", "test2")
				];
			}
			
			function validate(phaseName : String) : void {
				storeResults();
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					true,
					
					true,
					true,
					false,
					false,
					
					false,
					false,
					false
				], results));
			}
		}

		[Test(async)]
		public function test_invalidate_allProperties() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			
			var results : Array;
			storeResults();
			complete(null);

			setUpCompleteTimer(complete);
			
			function storeResults() : void {
				results = [
					adapter.isInvalid(),
					
					adapter.isInvalid("phase1"),
					adapter.isInvalid("phase1", "test"),
					adapter.isInvalid("phase1", "test2"),
					adapter.isInvalid("phase1", "all_properties"),
					
					adapter.isInvalid("phase2"),
					adapter.isInvalid("phase2", "test"),
					adapter.isInvalid("phase2", "test2")
				];
			}
			
			function validate(phaseName : String) : void {
				storeResults();
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					true,
					
					true,
					true,
					true,
					true,
					
					false,
					false,
					false
				], results));
			}
		}

		[Test(async)]
		public function test_invalidate_allProperties2() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = storeResults;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1", "test");
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase2", "test");
			
			var results : Array = new Array();
			storeResults("phase1");
			storeResults("phase2");
			storeResults("phase3");

			setUpCompleteTimer(complete);
			
			function storeResults(phaseName : String) : void {
				results.push(
					adapter.isInvalid(),
					adapter.isInvalid(phaseName),
					adapter.isInvalid(phaseName, "test"),
					adapter.isInvalid(phaseName, "test2"),
					adapter.isInvalid(phaseName, "all_properties")
				);
			}
			
			function complete(event : Event, data : * = null) : void {
				storeResults("phase3");
				
				assertTrue(ArrayUtils.arraysEqual([
					// immediately phase1
					true, true, true, true, true,
					// immediately phase2
					true, true, true, true, true,
					// immediately phase3
					true, false, false, false, false,
					// in validation phase1
					true, true, true, true, true,
					// in validation phase2
					true, true, true, true, true,
					// after validation phase3
					false, false, false, false, false
				], results));
			}
		}

		[Test(async)]
		public function test_invalidate_propertiesRemovedAfterPhase() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1", "test");
			adapter.invalidate("phase1", "test2");
			adapter.invalidate("phase2");
			
			var results : Array = new Array();

			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
				results.push(
					adapter.isInvalid(),
					
					adapter.isInvalid("phase1"),
					adapter.isInvalid("phase1", "test"),
					adapter.isInvalid("phase1", "test2")
				);
			}

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([
					// from phase 1
					true,
					true,
					true,
					true,
					// from phase 2
					true,
					false,
					false,
					false
				], results));
			}
		}

		[Test(async)]
		/*
		 * Reinvalidation in phase 2
		 */
		public function test_invalidate_propertiesRemovedAfterPhase2() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1", "test");
			adapter.invalidate("phase1", "test2");
			adapter.invalidate("phase2");
			
			var results : Array = new Array();

			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
				results.push(
					adapter.isInvalid(),
					
					adapter.isInvalid("phase1"),
					adapter.isInvalid("phase1", "test"),
					adapter.isInvalid("phase1", "test2")
				);
				
				if (phaseName == "phase2" && !adapter.validateCountForPhase("phase2")) {
					adapter.invalidate("phase1", "test");
					adapter.invalidate("phase1", "test2");
					adapter.invalidate("phase2");
				}
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(ArrayUtils.arraysEqual([
					s, "phase1",
					s, "phase2",
					s, "phase1",
					s, "phase2"
				], log));

				assertTrue(ArrayUtils.arraysEqual([
					// from phase 1
					true,
					true,
					true,
					true,
					// from phase 2
					true,
					false,
					false,
					false,
					// from phase 1 - second run
					true,
					true,
					true,
					true,
					// from phase 2 - second run
					true,
					false,
					false,
					false
				], results));
			}
		}

		[Test]
		public function test_isInvalid() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2", "test");
			
			assertTrue(adapter.isInvalid());
			assertTrue(adapter.isInvalid("phase1"));
			assertTrue(adapter.isInvalid("phase1", "test"));
			assertTrue(adapter.isInvalid("phase2", "test"));

			assertFalse(adapter.isInvalid("phase2", "test2"));
			assertFalse(adapter.isInvalid("phase3"));
			assertFalse(adapter.isInvalid("phase3", "test"));
		}

		[Test]
		public function test_isInvalid_beforeRegistrationThrowsError() : void {
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);

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
				assertFalse(adapter.isInvalid("phase1"));
			} catch (e : Error) {
				errorThrown = e;
			}

			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);

			errorThrown = null;
			try {
				assertFalse(adapter.isInvalid("phase1", "test"));
			} catch (e : Error) {
				errorThrown = e;
			}

			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);
		}

		[Test(async)]
		public function test_validateNow_inValidationThrowsError() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;

			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			
			var errorThrown : Error;
			setUpCompleteTimer(complete);
			
			function validate(phaseName : String) : void {
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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);

			adapter.invalidate("phase1");
			adapter.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([s, "phase1"], _watcher.validateLog));
		}

		[Test]
		public function test_validateNow_beforeRegistrationThrowsError() : void {
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);

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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);

			adapter.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([], _watcher.validateLog));
		}

		[Test(async)]
		public function test_validateNow_validatesOnlyTarget() : void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);

			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);

			adapter.invalidate("phase1");
			adapter2.invalidate("phase1");
			adapter.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([s, "phase1"], _watcher.validateLog));

			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s2, "phase1"], _watcher.validateLog));
			}
		}

		[Test(async)]
		public function test_validateNow_validatesOnlyTarget2() : void {
			var s : Sprite = StageProxy.root.addChild(new TestDisplayObject("s")) as Sprite;
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);

			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);

			var s3 : Sprite = StageProxy.root.addChild(new TestDisplayObject("s3")) as Sprite;
			var adapter3 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s3, adapter3);

			var s4 : Sprite = s3.addChild(new TestDisplayObject("s4")) as Sprite;
			var adapter4 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s4, adapter4);

			adapter.invalidate("phase1");
			adapter2.invalidate("phase1");
			adapter3.invalidate("phase1");
			adapter4.invalidate("phase1");

			adapter.validateNow();
			
			assertTrue(ArrayUtils.arraysEqual([s, "phase1", s2, "phase1"], _watcher.validateLog));

			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s3, "phase1", s4, "phase1"], _watcher.validateLog));
			}
		}

		[Test]
		public function test_onAddedToStage_onRemovedFromStage() : void {
			var s : Sprite = new TestDisplayObject("s");
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			
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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			
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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			
			adapter.invalidate("phase1");
			
			assertEquals(0, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertEquals(0, adapter2.addedToStageCount);
			assertEquals(0, adapter2.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));

			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			
			assertEquals(0, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertEquals(0, adapter2.addedToStageCount);
			assertEquals(0, adapter2.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));
			
			_i10n.cleanUp();

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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			
			assertEquals(0, adapter.addedToStageCount);
			assertEquals(0, adapter.removedFromStageCount);
			assertEquals(0, adapter2.addedToStageCount);
			assertEquals(0, adapter2.removedFromStageCount);
			assertTrue(ArrayUtils.arraysEqual([], _watcher.addedLog));
			assertTrue(ArrayUtils.arraysEqual([], _watcher.removedLog));
			
			_i10n.unregisterDisplayObject(s);

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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			
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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			
			assertEquals(2, adapter.nestLevel);
			assertEquals(3, adapter2.nestLevel);
			
			_i10n.cleanUp();
			
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
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			
			var s2 : Sprite = s.addChild(new TestDisplayObject("s2")) as Sprite;
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			
			assertEquals(2, adapter.nestLevel);
			assertEquals(3, adapter2.nestLevel);
			
			_i10n.unregisterDisplayObject(s);
			
			assertEquals(-1, adapter.nestLevel);
			assertEquals(3, adapter2.nestLevel);

			StageProxy.root.removeChild(s);

			assertEquals(-1, adapter.nestLevel);
			assertEquals(-1, adapter2.nestLevel);

			StageProxy.root.addChild(s);

			assertEquals(-1, adapter.nestLevel);
			assertEquals(3, adapter2.nestLevel);
		}

	}
}
