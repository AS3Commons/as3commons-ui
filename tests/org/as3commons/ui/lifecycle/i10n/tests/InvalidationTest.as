package org.as3commons.ui.lifecycle.i10n.tests {

	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.lifecycle.i10n.AllSelector;
	import org.as3commons.ui.lifecycle.i10n.II10NApapter;
	import org.as3commons.ui.lifecycle.i10n.II10NSelector;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;
	import org.as3commons.ui.lifecycle.i10n.testhelper.GenericAdapter;
	import org.as3commons.ui.lifecycle.i10n.testhelper.SimpleAdapter;
	import org.as3commons.ui.lifecycle.i10n.testhelper.TestDisplayObject;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class InvalidationTest {

		protected var _rm : Invalidation;
		protected var _adapter : II10NApapter;

		protected function setUpExitFrame(callback : Function, data : Object) : void {
			StageProxy.stage.addEventListener(
				Event.EXIT_FRAME, 
				Async.asyncHandler(this, callback, 500, data, function() : void {
					throw new Error("TIMEOUT");
				}),
				false, 0, true
			);
		}
		
		protected function setUpManager(configure : Boolean = true, adapter : II10NApapter = null) : void {
			_rm = new Invalidation();
			_adapter = adapter ? adapter : new SimpleAdapter();
			if (configure) _rm.register(new AllSelector(), _adapter);
		}
		
		[After]
		public function tearDown() : void {
			if (_rm)_rm.cleanUp();
			_rm = null;
			
			_adapter = null;
			
			StageProxy.cleanUpRoot();
		}

		[Test]
		public function testInstantiated():void {
			var rm : Invalidation = new Invalidation();
			assertTrue(rm is Invalidation);
		}

		[Test(async)]
		public function testSimpleInvocation():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testAdapterWithoutRegistrationNotInvoked():void {
			setUpManager(false);
			// NOT invoked: rm.register(new AllSelector(), adapter);
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testItemNotInDisplayListNotProcessed():void {
			setUpManager();
			
			var s : DisplayObject = new Sprite();
			_rm.invalidate(s);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testValidateNowWithoutInvalidateSkipped():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.validateNow(s);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testInvalidationWithProperty():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(["test"], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testInvalidationWithProperties():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s, "test");
			_rm.invalidate(s, "test2");
			_rm.invalidate(s, "test3");
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(["test", "test2", "test3"], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testInvalidationWithPropertiesInRightOrder():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s, "test3");
			_rm.invalidate(s, "test");
			_rm.invalidate(s, "test4");
			_rm.invalidate(s, "test2");
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test3", "test", "test4", "test2"],
					adapter.validateCallProperties
				));
			}
		}

		[Test(async)]
		public function testInvalidationWithPropertiesWithDuplicates():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s, "test3");
			_rm.invalidate(s, "test");
			_rm.invalidate(s, "test4");
			_rm.invalidate(s, "test");
			_rm.invalidate(s, "test2");
			_rm.invalidate(s, "test4");
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test3", "test", "test4", "test2"],
					adapter.validateCallProperties
				));
			}
		}

		[Test(async)]
		public function testInvalidationWithoutPropertiesSetsAllProperties():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					[Invalidation.ALL_PROPERTIES],
					adapter.validateCallProperties
				));
			}
		}

		[Test(async)]
		public function testInvalidationWithoutPropertiesIgnoresFurtherProperties():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s, "test");
			_rm.invalidate(s, "test2");
			_rm.invalidate(s);
			_rm.invalidate(s, "test3");
			_rm.invalidate(s, "test4");
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					[Invalidation.ALL_PROPERTIES],
					adapter.validateCallProperties
				));
			}
		}

		[Test(async)]
		public function testRenderOrderSameAsInvocation():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s3 : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s4 : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s3);
			_rm.invalidate(s);
			_rm.invalidate(s4);
			_rm.invalidate(s2);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(4, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s3, s, s4, s2], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testMultipleInvocationsAreMerged():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s);
			_rm.invalidate(s);
			_rm.invalidate(s);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testInvalidationDuringWillValidate():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 2) {
					_rm.invalidate(displayObject, "test2");
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(1, adapter.willValidateCalls.length);
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test", "test2"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testInvalidationDuringWillValidate2():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 4) {
					_rm.invalidate(displayObject, "test2");
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(1, adapter.willValidateCalls.length);
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test", "test2"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testInvalidationDuringWillValidate3():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length == 1) {
					_rm.invalidate(s2, "test2");
				} else if (GenericAdapter(_adapter).willValidateCalls.length == 2) {
					_rm.invalidate(s, "test3");
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(3, adapter.willValidateCalls.length);
				assertEquals(3, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s2, s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s, s2, s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test", "test2", "test3"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testValidateNowDuringWillValidate():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 2) {
					_rm.validateNow(displayObject);
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(2, adapter.willValidateCalls.length);
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testValidateNowDuringWillValidate2():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 4) {
					_rm.validateNow(displayObject);
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(4, adapter.willValidateCalls.length);
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s, s, s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testValidateNowDuringWillValidate3():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));

			_rm.invalidate(s, "test");
			_rm.invalidate(s2, "test2");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length == 1) {
					_rm.validateNow(s2);
				} else if (GenericAdapter(_adapter).willValidateCalls.length == 2) {
					_rm.invalidate(s, "test3");
					_rm.validateNow(s);
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(3, adapter.willValidateCalls.length);
				assertEquals(2, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s2, s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s, s2], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test", "test3", "test2"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testInvalidationDuringValidate():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).validateCalls.length < 2) {
					_rm.invalidate(displayObject, "test2");
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(2, adapter.willValidateCalls.length);
				assertEquals(2, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s, s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test", "test2"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testInvalidationDuringValidate2():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).validateCalls.length < 4) {
					_rm.invalidate(displayObject, "test2");
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(4, adapter.willValidateCalls.length);
				assertEquals(4, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s, s, s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s, s, s, s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test", "test2", "test2", "test2"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testInvalidationDuringValidate3():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).validateCalls.length == 1) {
					_rm.invalidate(s2, "test2");
				} else if (GenericAdapter(_adapter).validateCalls.length == 2) {
					_rm.invalidate(s, "test3");
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(3, adapter.willValidateCalls.length);
				assertEquals(3, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s2, s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s, s2, s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test", "test2", "test3"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testValidateNowDuringValidate():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 2) {
					_rm.invalidate(displayObject, "test2");
					_rm.validateNow(displayObject);
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(2, adapter.willValidateCalls.length);
				assertEquals(2, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s, s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test", "test2"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testValidateNowDuringValidate2():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 4) {
					_rm.invalidate(displayObject, "test2");
					_rm.validateNow(displayObject);
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(4, adapter.willValidateCalls.length);
				assertEquals(4, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s, s, s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s, s, s, s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test", "test2", "test2", "test2"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testValidateNowDuringValidate3():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));

			_rm.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length == 1) {
					_rm.invalidate(s2, "test2");
					_rm.validateNow(s2);
				} else if (GenericAdapter(_adapter).willValidateCalls.length == 2) {
					_rm.invalidate(s, "test3");
					_rm.validateNow(s);
				}
			}

			function complete(event : Event, adapter : GenericAdapter) : void {
				assertEquals(3, adapter.willValidateCalls.length);
				assertEquals(3, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s2, s], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([s, s2, s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(
					["test", "test2", "test3"],
					adapter.validateCallProperties
				));
			}
			
		}

		[Test(async)]
		public function testUnregisterSkipsComponent():void {
			var selector : II10NSelector = new AllSelector();
			var adapter : II10NApapter = new SimpleAdapter();
			
			setUpManager(false, adapter);
			
			_rm.register(selector, adapter);

			_rm.unregister(selector, adapter);
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s);

			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testUnregisterOneOfMultipleAdaptersSkipsComponent():void {
			setUpManager();
			
			var selector : II10NSelector = new AllSelector();
			var adapter : II10NApapter = new SimpleAdapter();
			_rm.register(selector, adapter);
			_rm.unregister(selector, adapter);
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s);
			
			setUpExitFrame(complete, _adapter);
			setUpExitFrame(complete2, adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
			}
			
			function complete2(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
			}
			
		}

		[Test(async)]
		public function testMultipleSelectorsSingleInvocation():void {
			setUpManager();
			
			var selector : II10NSelector = new AllSelector();
			_rm.register(selector, _adapter);
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
			}
			
		}

		[Test(async)]
		public function testMultipleAdaptersMultipleInvocations():void {
			setUpManager();
			
			var selector : II10NSelector = new AllSelector();
			var adapter : II10NApapter = new SimpleAdapter();
			_rm.register(selector, adapter);
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s);
			
			setUpExitFrame(complete, _adapter);
			setUpExitFrame(complete2, adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
			}
			
			function complete2(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
			}
			
		}

		[Test(async)]
		public function testClear():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s, "test");
			
			_rm.clear();
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testClear2():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s, "test");
			
			_rm.clear();
			
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s2, "test2");

			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s2], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(["test2"], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testCleanUp():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s, "test");
			
			_rm.cleanUp();
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testCleanUp2():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s, "test");
			
			_rm.cleanUp();
			
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s2, "test2");

			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testCleanUp3():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s, "test");
			
			_rm.cleanUp();
			
			var adapter : II10NApapter = new SimpleAdapter();
			_rm.register(new AllSelector(), adapter);

			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s2, "test2");

			setUpExitFrame(complete, adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s2], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(["test2"], adapter.validateCallProperties));
			}
		}

	}
}
