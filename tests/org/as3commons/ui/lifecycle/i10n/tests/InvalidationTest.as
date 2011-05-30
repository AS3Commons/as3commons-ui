package org.as3commons.ui.lifecycle.i10n.tests {

	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.lifecycle.i10n.AllSelector;
	import org.as3commons.ui.lifecycle.i10n.II10NApapter;
	import org.as3commons.ui.lifecycle.i10n.II10NSelector;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;
	import org.as3commons.ui.lifecycle.i10n.testhelper.GenericAdapter;
	import org.as3commons.ui.lifecycle.i10n.testhelper.InvalidationMock;
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

		protected var _i10n : InvalidationMock;
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
			_i10n = new InvalidationMock();
			_adapter = adapter ? adapter : new SimpleAdapter();
			if (configure) _i10n.registerAdapter(new AllSelector(), _adapter);
		}
		
		[After]
		public function tearDown() : void {
			if (_i10n)_i10n.cleanUp();
			_i10n = null;
			
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
			_i10n.invalidate(s);
			
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
			_i10n.invalidate(s);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testInvalidate_itemNotInDisplayList():void {
			setUpManager();
			
			var s : DisplayObject = new Sprite();
			_i10n.invalidate(s);
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s2);
			
			assertTrue(ArrayUtils.arraysEqual([s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([s], _i10n.scheduleKeysToArray()));

			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
				assertTrue(ArrayUtils.arraysEqual([s], _i10n.scheduleKeysToArray()));

				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s2], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testInvalidate_itemAddedToDisplayListAfterInvocation():void {
			setUpManager();
			
			var s : DisplayObject = new Sprite();
			_i10n.invalidate(s);
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s2);
			
			assertTrue(ArrayUtils.arraysEqual([s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([s], _i10n.scheduleKeysToArray()));
			
			StageProxy.root.addChild(s);

			assertTrue(ArrayUtils.arraysEqual([s2, s], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
				assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

				assertEquals(2, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s2, s], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testInvalidate_itemRemovedFromDisplayListAfterInvocation():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s);
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s2);
			
			assertTrue(ArrayUtils.arraysEqual([s, s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));
			
			StageProxy.root.removeChild(s);
			
			assertTrue(ArrayUtils.arraysEqual([s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([s], _i10n.scheduleKeysToArray()));
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
				assertTrue(ArrayUtils.arraysEqual([s], _i10n.scheduleKeysToArray()));

				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s2], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testInvalidate_itemRemovedAndAddedToDisplayListAfterInvocation():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s);
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s2);
			
			assertTrue(ArrayUtils.arraysEqual([s, s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));
			
			StageProxy.root.removeChild(s);
			
			assertTrue(ArrayUtils.arraysEqual([s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([s], _i10n.scheduleKeysToArray()));
			
			StageProxy.root.addChild(s);

			assertTrue(ArrayUtils.arraysEqual([s2, s], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
				assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

				assertEquals(2, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s2, s], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testInvalidate_WithProperty():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(["test"], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testInvalidate_withProperties():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s, "test");
			_i10n.invalidate(s, "test2");
			_i10n.invalidate(s, "test3");
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(["test", "test2", "test3"], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testInvalidate_withPropertiesInRightOrder():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s, "test3");
			_i10n.invalidate(s, "test");
			_i10n.invalidate(s, "test4");
			_i10n.invalidate(s, "test2");
			
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
		public function testInvalidate_withPropertiesWithDuplicates():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s, "test3");
			_i10n.invalidate(s, "test");
			_i10n.invalidate(s, "test4");
			_i10n.invalidate(s, "test");
			_i10n.invalidate(s, "test2");
			_i10n.invalidate(s, "test4");
			
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
		public function testInvalidate_withoutPropertiesSetsAllProperties():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s);
			
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
		public function testInvalidate_itemNotInDisplayList_withoutPropertiesSetsAllProperties():void {
			setUpManager();
			
			var s : DisplayObject = new Sprite();
			_i10n.invalidate(s);
			
			StageProxy.root.addChild(s);
			
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
		public function testInvalidate_withoutPropertiesIgnoresFurtherProperties():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s, "test");
			_i10n.invalidate(s, "test2");
			_i10n.invalidate(s);
			_i10n.invalidate(s, "test3");
			_i10n.invalidate(s, "test4");
			
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
		public function testInvalidate_itemAddedAndRemovedFromStage_propertiesInRightOrder():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s, "test3");
			
			assertTrue(ArrayUtils.arraysEqual([s], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));
			
			StageProxy.root.removeChild(s);

			assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([s], _i10n.scheduleKeysToArray()));

			_i10n.invalidate(s, "test");

			StageProxy.root.addChild(s);

			assertTrue(ArrayUtils.arraysEqual([s], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			_i10n.invalidate(s, "test4");

			StageProxy.root.removeChild(s);

			assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([s], _i10n.scheduleKeysToArray()));

			_i10n.invalidate(s, "test2");
			
			StageProxy.root.addChild(s);

			assertTrue(ArrayUtils.arraysEqual([s], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

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
		public function testInvalidate_validationOrderSameAsInvocation():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s3 : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s4 : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s3);
			_i10n.invalidate(s);
			_i10n.invalidate(s4);
			_i10n.invalidate(s2);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(4, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s3, s, s4, s2], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testInvalidate_multipleInvocationsAreMerged():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s);
			_i10n.invalidate(s);
			_i10n.invalidate(s);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testInvalidate_duringWillValidate():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 2) {
					_i10n.invalidate(displayObject, "test2");
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
		public function testInvalidate_duringWillValidate2():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 4) {
					_i10n.invalidate(displayObject, "test2");
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
		public function testInvalidate_duringWillValidate3():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length == 1) {
					_i10n.invalidate(s2, "test2");
				} else if (GenericAdapter(_adapter).willValidateCalls.length == 2) {
					_i10n.invalidate(s, "test3");
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
		public function testValidateNow_withoutInvalidateSkipped():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.validateNow(s);
			
			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.willValidateCalls));
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
			}
		}

		[Test(async)]
		public function testValidateNow_duringWillValidate():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 2) {
					_i10n.validateNow(displayObject);
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
		public function testValidateNow_duringWillValidate2():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 4) {
					_i10n.validateNow(displayObject);
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
		public function testValidateNow_duringWillValidate3():void {
			setUpManager(true, new GenericAdapter(willValidate, null));
			
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));

			_i10n.invalidate(s, "test");
			_i10n.invalidate(s2, "test2");
			
			setUpExitFrame(complete, _adapter);
			
			function willValidate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length == 1) {
					_i10n.validateNow(s2);
				} else if (GenericAdapter(_adapter).willValidateCalls.length == 2) {
					_i10n.invalidate(s, "test3");
					_i10n.validateNow(s);
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
		public function testInvalidate_duringValidate():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).validateCalls.length < 2) {
					_i10n.invalidate(displayObject, "test2");
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
		public function testInvalidate_duringValidate2():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).validateCalls.length < 4) {
					_i10n.invalidate(displayObject, "test2");
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
		public function testInvalidate_duringValidate3():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).validateCalls.length == 1) {
					_i10n.invalidate(s2, "test2");
				} else if (GenericAdapter(_adapter).validateCalls.length == 2) {
					_i10n.invalidate(s, "test3");
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
		public function testValidateNow_duringValidate():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 2) {
					_i10n.invalidate(displayObject, "test2");
					_i10n.validateNow(displayObject);
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
		public function testValidateNow_duringValidate2():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length < 4) {
					_i10n.invalidate(displayObject, "test2");
					_i10n.validateNow(displayObject);
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
		public function testValidateNow_duringValidate3():void {
			setUpManager(true, new GenericAdapter(null, validate));
			
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));

			_i10n.invalidate(s, "test");
			
			setUpExitFrame(complete, _adapter);
			
			function validate(displayObject : DisplayObject) : void {
				if (GenericAdapter(_adapter).willValidateCalls.length == 1) {
					_i10n.invalidate(s2, "test2");
					_i10n.validateNow(s2);
				} else if (GenericAdapter(_adapter).willValidateCalls.length == 2) {
					_i10n.invalidate(s, "test3");
					_i10n.validateNow(s);
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
		public function testStopValidation():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));

			_i10n.invalidate(s, "test");
			_i10n.invalidate(s2, "test2");
			
			assertTrue(ArrayUtils.arraysEqual([s, s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			_i10n.stopValidation(s);

			assertTrue(ArrayUtils.arraysEqual([s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			_i10n.stopValidation(s2);

			assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			_i10n.invalidate(s, "test");
			_i10n.invalidate(s2, "test2");
			
			assertTrue(ArrayUtils.arraysEqual([s, s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));
		}

		[Test(async)]
		public function testStopValidation_itemNotInDisplayList():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var s2 : DisplayObject = new TestDisplayObject("s2");

			_i10n.invalidate(s, "test");
			_i10n.invalidate(s2, "test2");
			
			assertTrue(ArrayUtils.arraysEqual([s], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([s2], _i10n.scheduleKeysToArray()));

			_i10n.stopValidation(s);

			assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([s2], _i10n.scheduleKeysToArray()));

			_i10n.stopValidation(s2);

			assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			_i10n.invalidate(s, "test");
			_i10n.invalidate(s2, "test2");
			
			assertTrue(ArrayUtils.arraysEqual([s], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([s2], _i10n.scheduleKeysToArray()));
		}

		[Test(async)]
		public function testUnregisterSkipsComponent():void {
			var selector : II10NSelector = new AllSelector();
			var adapter : II10NApapter = new SimpleAdapter();
			
			setUpManager(false, adapter);
			
			_i10n.registerAdapter(selector, adapter);

			_i10n.unregisterAdapter(selector, adapter);
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s);

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
			_i10n.registerAdapter(selector, adapter);
			_i10n.unregisterAdapter(selector, adapter);
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s);
			
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
			_i10n.registerAdapter(selector, _adapter);
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s);
			
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
			_i10n.registerAdapter(selector, adapter);
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_i10n.invalidate(s);
			
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
		public function testStopAllValidations():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s, "test");
			_i10n.invalidate(s2, "test2");
			
			assertTrue(ArrayUtils.arraysEqual([s, s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			_i10n.stopAllValidations();
			
			assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testStopAllValidations2():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s, "test");
			
			assertTrue(ArrayUtils.arraysEqual([s], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			_i10n.stopAllValidations();

			assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));
			
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s2, "test2");

			assertTrue(ArrayUtils.arraysEqual([s2], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s2], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(["test2"], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testStopAllValidations_itemsNotInDisplayList():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s, "test");
			
			var s2 : DisplayObject = new Sprite();
			_i10n.invalidate(s2, "test2");

			assertTrue(ArrayUtils.arraysEqual([s], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([s2], _i10n.scheduleKeysToArray()));

			_i10n.stopAllValidations();

			assertTrue(ArrayUtils.arraysEqual([], _i10n.queueKeysToArray()));
			assertTrue(ArrayUtils.arraysEqual([], _i10n.scheduleKeysToArray()));

			setUpExitFrame(complete, _adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(0, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual([], adapter.validateCallProperties));
			}
		}

		[Test(async)]
		public function testCleanUp():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s, "test");
			
			_i10n.cleanUp();
			
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
			_i10n.invalidate(s, "test");
			
			_i10n.cleanUp();
			
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s2, "test2");

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
			_i10n.invalidate(s, "test");
			
			_i10n.cleanUp();
			
			var adapter : II10NApapter = new SimpleAdapter();
			_i10n.registerAdapter(new AllSelector(), adapter);

			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			_i10n.invalidate(s2, "test2");

			setUpExitFrame(complete, adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				assertEquals(1, adapter.validateCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s2], adapter.validateCalls));
				assertTrue(ArrayUtils.arraysEqual(["test2"], adapter.validateCallProperties));
			}
		}

	}
}
