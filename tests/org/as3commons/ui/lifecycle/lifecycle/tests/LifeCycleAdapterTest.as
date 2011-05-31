package org.as3commons.ui.lifecycle.lifecycle.tests {

	import org.flexunit.asserts.assertStrictlyEquals;
	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.lifecycle.i10n.Invalidation;
	import org.as3commons.ui.lifecycle.i10n.testhelper.TestDisplayObject;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycleAdapter;
	import org.as3commons.ui.lifecycle.lifecycle.testhelper.GenericAdapter;
	import org.as3commons.ui.lifecycle.lifecycle.testhelper.LifeCycleWatcher;
	import org.as3commons.ui.lifecycle.lifecycle.testhelper.SimpleAdapter;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Jens Struwe 27.05.2011
	 */
	public class LifeCycleAdapterTest {

		private var _lc : LifeCycle;

		protected function setUpExitFrame(callback : Function, data : Object = null) : void {
			StageProxy.stage.addEventListener(
				Event.EXIT_FRAME, 
				Async.asyncHandler(this, callback, 500, data, function() : void {
					throw new Error("TIMEOUT");
				}),
				false, 0, true
			);
		}
		
		protected function validateLifeCycle(
			initCalls : Array,
			drawCalls : Array,
			updateCalls : Array
		) : void {
			assertTrue(ArrayUtils.arraysEqual(initCalls, LifeCycleWatcher.initCalls));
			assertTrue(ArrayUtils.arraysEqual(drawCalls, LifeCycleWatcher.drawCalls));
			assertTrue(ArrayUtils.arraysEqual(updateCalls, LifeCycleWatcher.updateCalls));
			LifeCycleWatcher.clearCalls();
		}

		protected function validateInvalidProperties(
			invalidProperties : Array,
			updateKinds : Array
		) : void {
			assertTrue(ArrayUtils.arraysEqual(invalidProperties, LifeCycleWatcher.invalidProperties));
			assertTrue(ArrayUtils.arraysMatch(updateKinds, LifeCycleWatcher.updateKinds));
			LifeCycleWatcher.clearProperties();
		}

		[Before]
		public function setUp() : void {
			_lc = new LifeCycle();
		}

		[After]
		public function tearDown() : void {
			_lc.cleanUp();
			_lc = null;
			
			StageProxy.cleanUpRoot();
			LifeCycleWatcher.clear();
		}

		[Test(async)]
		public function testInit_registeredBeforeAddedToStage():void {
			var s : DisplayObject = new TestDisplayObject("s");

			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			validateLifeCycle([], [], []);

			StageProxy.root.addChild(s);

			validateLifeCycle([s], [], []);

			setUpExitFrame(complete, adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				validateLifeCycle([], [s], []);
			}
		}

		[Test(async)]
		public function testInit_registeredAfterAddedToStage():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));

			var adapter : SimpleAdapter = new SimpleAdapter();

			validateLifeCycle([], [], []);

			_lc.registerComponent(s, adapter);

			validateLifeCycle([s], [], []);

			setUpExitFrame(complete, adapter);
			
			function complete(event : Event, adapter : SimpleAdapter) : void {
				validateLifeCycle([], [s], []);
			}
		}

		[Test(async)]
		public function testInit_addedAtConstructionTime():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			_lc.registerComponent(s, new SimpleAdapter());

			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			_lc.registerComponent(s2, new SimpleAdapter());

			var s3 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s3"));
			_lc.registerComponent(s3, new SimpleAdapter());

			validateLifeCycle([s, s2, s3], [], []);

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [s, s2, s3], []);
			}
		}

		[Test(async)]
		public function testInit_addedAllAfterRegistration():void {
			var s : DisplayObject = new TestDisplayObject("s");
			_lc.registerComponent(s, new SimpleAdapter());

			var s2 : DisplayObject = new TestDisplayObject("s2");
			_lc.registerComponent(s2, new SimpleAdapter());

			var s3 : DisplayObject = new TestDisplayObject("s3");
			_lc.registerComponent(s3, new SimpleAdapter());
			
			var s4 : DisplayObject = new TestDisplayObject("s4");
			_lc.registerComponent(s4, new SimpleAdapter());
			
			validateLifeCycle([], [], []);

			StageProxy.root.addChild(s2);
			StageProxy.root.addChild(s4);
			StageProxy.root.addChild(s);
			StageProxy.root.addChild(s3);

			validateLifeCycle([s2, s4, s, s3], [], []);

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [s2, s4, s, s3], []);
			}
		}

		[Test(async)]
		public function testInit_addedAllBeforeRegistration():void {
			var s : DisplayObject = new TestDisplayObject("s");
			var s2 : DisplayObject = new TestDisplayObject("s2");
			var s3 : DisplayObject = new TestDisplayObject("s3");
			var s4 : DisplayObject = new TestDisplayObject("s4");
			
			StageProxy.root.addChild(s2);
			StageProxy.root.addChild(s4);
			StageProxy.root.addChild(s);
			StageProxy.root.addChild(s3);

			_lc.registerComponent(s, new SimpleAdapter());
			_lc.registerComponent(s2, new SimpleAdapter());
			_lc.registerComponent(s3, new SimpleAdapter());
			_lc.registerComponent(s4, new SimpleAdapter());

			validateLifeCycle([s, s2, s3, s4], [], []);

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [s, s2, s3, s4], []);
			}
		}

		[Test(async)]
		public function testInit_nestedComponents_addedAllAfterRegistration():void {
			/*
			 * 	s
			 * 		s2
			 * 			s4
			 * 		s3
			 */
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			s.addChild(s2);
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			s.addChild(s3);
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			s2.addChild(s4);

			_lc.registerComponent(s, new SimpleAdapter());
			_lc.registerComponent(s2, new SimpleAdapter());
			_lc.registerComponent(s3, new SimpleAdapter());
			_lc.registerComponent(s4, new SimpleAdapter());

			validateLifeCycle([], [], []);

			StageProxy.root.addChild(s);

			validateLifeCycle([s, s2, s4, s3], [], []);

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [s, s2, s4, s3], []);
			}
		}

		[Test(async)]
		public function testInit_nestedComponents_addedAllBeforeRegistration():void {
			/*
			 * 	s
			 * 		s2
			 * 			s4
			 * 		s3
			 */
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			s.addChild(s2);
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			s.addChild(s3);
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			s2.addChild(s4);

			StageProxy.root.addChild(s);

			_lc.registerComponent(s, new SimpleAdapter());
			_lc.registerComponent(s2, new SimpleAdapter());
			_lc.registerComponent(s3, new SimpleAdapter());
			_lc.registerComponent(s4, new SimpleAdapter());

			validateLifeCycle([s, s2, s3, s4], [], []);

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [s, s2, s3, s4], []);
			}
		}

		[Test(async)]
		public function testInit_nestedComponents_addedAtConstructionTime():void {
			/*
			 * 	s
			 * 		s2
			 * 			s4
			 * 		s3
			 */
			var s : TestDisplayObject = new TestDisplayObject("s");
			_lc.registerComponent(s, new SimpleAdapter());
			StageProxy.root.addChild(s);

			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			_lc.registerComponent(s2, new SimpleAdapter());
			s.addChild(s2);

			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			_lc.registerComponent(s3, new SimpleAdapter());
			s.addChild(s3);

			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			_lc.registerComponent(s4, new SimpleAdapter());
			s2.addChild(s4);

			validateLifeCycle([s, s2, s3, s4], [], []);

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [s, s2, s3, s4], []);
			}
		}

		[Test(async)]
		public function testValidateNow():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
		}

		[Test(async)]
		public function testValidateNow_Invalidate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate("test");

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s]);
				validateInvalidProperties(["test"], []);
			}
		}

		[Test(async)]
		public function testValidateNow_Invalidate_ValidateNow():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate("test");
			adapter.validateNow();

			validateLifeCycle([], [], [s]);
			validateInvalidProperties(["test"], []);
		}

		[Test(async)]
		public function testPrepareUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, prepareUpdate, null);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate("test");

			setUpExitFrame(complete);
			
			function prepareUpdate() : void {
				assertTrue(adapter.isInvalid("test"));
				assertFalse(adapter.isInvalid("test2"));
			}

			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s]);
				validateInvalidProperties(["test"], []);
			}
		}

		[Test(async)]
		public function testPrepareUpdate_invalidateAll():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, prepareUpdate, null);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate();

			setUpExitFrame(complete);
			
			function prepareUpdate() : void {
				assertTrue(adapter.isInvalid("test"));
				assertTrue(adapter.isInvalid("test2"));
				assertTrue(adapter.isInvalid("asfd"));
			}

			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s]);
				validateInvalidProperties([Invalidation.ALL_PROPERTIES], []);
			}
		}

		[Test(async)]
		public function testPrepareUpdate_invalidPropertiesCleanedUp():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, prepareUpdate, update);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate("property");
			adapter.invalidate("property2");

			setUpExitFrame(complete);

			function prepareUpdate() : void {
				assertTrue(adapter.isInvalid("property"));
				assertTrue(adapter.isInvalid("property2"));
				assertFalse(adapter.isInvalid("property3"));
			}

			function update() : void {
				assertTrue(adapter.isInvalid("property"));
				assertTrue(adapter.isInvalid("property2"));
				assertFalse(adapter.isInvalid("property3"));
			}

			function complete(event : Event, data : * = null) : void {
				assertFalse(adapter.isInvalid("property"));
				assertFalse(adapter.isInvalid("property2"));
				assertFalse(adapter.isInvalid("property3"));

				validateLifeCycle([], [], [s]);
				validateInvalidProperties(["property", "property2"], []);
			}
		}

		[Test(async)]
		public function testPrepareUpdate_invalidPropertiesCleanedUp2():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, prepareUpdate, update);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate();

			function prepareUpdate() : void {
				assertTrue(adapter.isInvalid("property"));
				assertTrue(adapter.isInvalid("property2"));
			}

			function update() : void {
				assertFalse(adapter.isInvalid("property"));
				assertFalse(adapter.isInvalid("property2"));
			}
		}

		[Test(async)]
		public function testUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, null, update);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate();

			setUpExitFrame(complete);
			
			function update() : void {
				assertTrue(adapter.isInvalid("test"));
				assertFalse(adapter.shouldUpdate("test"));
			}

			function complete(event : Event, data : * = null) : void {
				assertFalse(adapter.isInvalid("test"));
				assertFalse(adapter.shouldUpdate("test"));

				validateLifeCycle([], [], [s]);
				validateInvalidProperties([Invalidation.ALL_PROPERTIES], []);
			}
		}

		[Test(async)]
		public function testUpdate_withUpdateKinds():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, prepareUpdate, update);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate();

			setUpExitFrame(complete);
			
			function prepareUpdate() : void {
				adapter.scheduleUpdate("update");
				adapter.scheduleUpdate("update2");
			}

			function update() : void {
				assertTrue(adapter.shouldUpdate("update"));
				assertTrue(adapter.shouldUpdate("update2"));
				assertFalse(adapter.shouldUpdate("update3"));
			}

			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s]);
				validateInvalidProperties([Invalidation.ALL_PROPERTIES], ["update", "update2"]);
			}
		}

		[Test(async)]
		public function testUpdate_updatedKindsCleanedUp():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, prepareUpdate, update);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate("property");
			adapter.invalidate("property2");

			setUpExitFrame(complete);
			
			function prepareUpdate() : void {
				assertTrue(adapter.isInvalid("property"));
				assertTrue(adapter.isInvalid("property2"));
				assertFalse(adapter.isInvalid("property3"));

				adapter.scheduleUpdate("update");
				adapter.scheduleUpdate("update2");
			}

			function update() : void {
				assertTrue(adapter.isInvalid("property"));
				assertTrue(adapter.isInvalid("property2"));
				assertFalse(adapter.isInvalid("property3"));

				assertTrue(adapter.shouldUpdate("update"));
				assertTrue(adapter.shouldUpdate("update2"));
				assertFalse(adapter.shouldUpdate("update3"));
			}

			function complete(event : Event, data : * = null) : void {
				assertFalse(adapter.isInvalid("property"));
				assertFalse(adapter.isInvalid("property2"));
				assertFalse(adapter.isInvalid("property3"));

				assertFalse(adapter.shouldUpdate("update"));
				assertFalse(adapter.shouldUpdate("update2"));
				assertFalse(adapter.shouldUpdate("update3"));

				validateLifeCycle([], [], [s]);
				validateInvalidProperties(["property", "property2"], ["update", "update2"]);
			}
		}

		[Test(async)]
		public function testInvalidate_inPrepareUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, prepareUpdate, null);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate("property");
			adapter.invalidate("property2");

			setUpExitFrame(complete);
			
			function prepareUpdate() : void {
				if (adapter.prepareUpdateCalls == 1) adapter.invalidate("property3");
			}

			function complete(event : Event, data : * = null) : void {
				assertEquals(2, adapter.prepareUpdateCalls);
				assertEquals(2, adapter.updateCalls);

				validateLifeCycle([], [], [s, s]);
				validateInvalidProperties(["property", "property2", "property3"], []);
			}
		}

		[Test(async)]
		public function testInvalidate_inUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, null, update);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate("property");
			adapter.invalidate("property2");

			setUpExitFrame(complete);
			
			function update() : void {
				if (adapter.updateCalls == 1) adapter.invalidate("property3");
			}

			function complete(event : Event, data : * = null) : void {
				assertEquals(2, adapter.prepareUpdateCalls);
				assertEquals(2, adapter.updateCalls);

				validateLifeCycle([], [], [s, s]);
				validateInvalidProperties(["property", "property2", "property3"], []);
			}
		}

		[Test(async)]
		public function testInvalidateOther_inPrepareUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, prepareUpdate, null);
			_lc.registerComponent(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : SimpleAdapter = new GenericAdapter(null, null, null, null);
			_lc.registerComponent(s2, adapter2);

			adapter.validateNow();
			adapter2.validateNow();

			validateLifeCycle([s, s2], [s, s2], []);
			
			adapter.invalidate("property");
			adapter2.invalidate("property2");

			setUpExitFrame(complete);
			
			function prepareUpdate() : void {
				adapter2.invalidate("property3");
			}

			function complete(event : Event, data : * = null) : void {
				assertEquals(1, adapter.prepareUpdateCalls);
				assertEquals(1, adapter.updateCalls);
				assertEquals(1, adapter2.prepareUpdateCalls);
				assertEquals(1, adapter2.updateCalls);

				validateLifeCycle([], [], [s, s2]);
				validateInvalidProperties(["property", "property2", "property3"], []);
			}
		}

		[Test(async)]
		public function testInvalidateOther_inUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, null, update);
			_lc.registerComponent(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : SimpleAdapter = new GenericAdapter(null, null, null, null);
			_lc.registerComponent(s2, adapter2);

			adapter.validateNow();
			adapter2.validateNow();

			validateLifeCycle([s, s2], [s, s2], []);
			
			adapter.invalidate("property");
			adapter2.invalidate("property2");

			setUpExitFrame(complete);
			
			function update() : void {
				if (adapter.updateCalls == 1) adapter2.invalidate("property3");
			}

			function complete(event : Event, data : * = null) : void {
				assertEquals(1, adapter.prepareUpdateCalls);
				assertEquals(1, adapter.updateCalls);
				assertEquals(1, adapter2.prepareUpdateCalls);
				assertEquals(1, adapter2.updateCalls);

				validateLifeCycle([], [], [s, s2]);
				validateInvalidProperties(["property", "property2", "property3"], []);
			}
		}

		[Test(async)]
		public function testValidateNow_inPrepareUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, prepareUpdate, null);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate("property");
			adapter.invalidate("property2");

			setUpExitFrame(complete);
			
			function prepareUpdate() : void {
				adapter.validateNow();
			}

			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s]);
				validateInvalidProperties(["property", "property2"], []);
			}
		}

		[Test(async)]
		public function testValidateNow_inUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, null, update);
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			
			adapter.invalidate("property");
			adapter.invalidate("property2");

			setUpExitFrame(complete);
			
			function update() : void {
				adapter.validateNow();
			}

			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s]);
				validateInvalidProperties(["property", "property2"], []);
			}
		}

		[Test(async)]
		public function testValidateNowOther_inPrepareUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, prepareUpdate, null);
			_lc.registerComponent(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : SimpleAdapter = new GenericAdapter(null, null, null, null);
			_lc.registerComponent(s2, adapter2);

			adapter.validateNow();
			adapter2.validateNow();

			validateLifeCycle([s, s2], [s, s2], []);
			
			adapter.invalidate("property");
			adapter2.invalidate("property2");

			setUpExitFrame(complete);
			
			function prepareUpdate() : void {
				adapter2.validateNow();
			}

			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s2, s]);
				validateInvalidProperties(["property", "property2"], []);
			}
		}

		[Test(async)]
		public function testValidateNowOther_inUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new GenericAdapter(null, null, null, update);
			_lc.registerComponent(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : SimpleAdapter = new GenericAdapter(null, null, null, null);
			_lc.registerComponent(s2, adapter2);

			adapter.validateNow();
			adapter2.validateNow();

			validateLifeCycle([s, s2], [s, s2], []);
			
			adapter.invalidate("property");
			adapter2.invalidate("property2");

			setUpExitFrame(complete);
			
			function update() : void {
				adapter2.validateNow();
			}

			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s, s2]);
				validateInvalidProperties(["property", "property2"], []);
			}
		}

		[Test(async)]
		public function testAutoUpdateBefore_invalidateOrder1():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s2, adapter2);
			
			adapter.autoUpdateBefore(s2);

			adapter.validateNow();
			adapter2.validateNow();

			validateLifeCycle([s, s2], [s, s2], []);
			
			adapter.invalidate("property");
			adapter2.invalidate("property2");

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s2, s]);
				validateInvalidProperties(["property2", "property"], []);
			}
		}

		[Test(async)]
		public function testAutoUpdateBefore_invalidateOrder2():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s2, adapter2);
			
			adapter.autoUpdateBefore(s2);

			adapter2.validateNow();
			adapter.validateNow();

			validateLifeCycle([s, s2], [s2, s], []);
			
			adapter2.invalidate("property2");
			adapter.invalidate("property");

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s2, s]);
				validateInvalidProperties(["property2", "property"], []);
			}
		}

		[Test(async)]
		public function testAutoUpdateBefore_invalidateInUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : SimpleAdapter = new GenericAdapter(null, null, null, update);
			_lc.registerComponent(s2, adapter2);
			
			adapter.autoUpdateBefore(s2);

			adapter2.validateNow();
			adapter.validateNow();

			validateLifeCycle([s, s2], [s2, s], []);
			
			adapter.invalidate("property");
			adapter2.invalidate("property2");

			setUpExitFrame(complete);
			
			function update() : void {
				adapter.invalidate("property3");
			}
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s2, s]);
				validateInvalidProperties(["property2", "property", "property3"], []);
			}
		}

		[Test(async)]
		public function testAutoUpdateBefore_complexInvalidateInUpdate():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : SimpleAdapter = new GenericAdapter(null, null, null, update);
			_lc.registerComponent(s2, adapter2);
			
			adapter.autoUpdateBefore(s2);

			adapter2.validateNow();
			adapter.validateNow();

			validateLifeCycle([s, s2], [s2, s], []);
			
			adapter.invalidate("property");
			adapter2.invalidate("property2");

			setUpExitFrame(complete);
			
			function update() : void {
				adapter.invalidate("property3");
				if (adapter2.updateCalls == 1) adapter2.invalidate("property4");
			}
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s2, s, s2, s]);
				validateInvalidProperties(["property2", "property", "property3", "property4", "property3"], []);
			}
		}

		[Test(async)]
		public function testRemoveAutoUpdateBefore():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter2 : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s2, adapter2);
			
			adapter.autoUpdateBefore(s2);

			adapter.validateNow();
			adapter2.validateNow();

			validateLifeCycle([s, s2], [s, s2], []);
			
			adapter.removeAutoUpdateBefore(s2);
			
			adapter.invalidate("property");
			adapter2.invalidate("property2");

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], [s, s2]);
				validateInvalidProperties(["property", "property2"], []);
			}
		}
		
		[Test(async)]
		public function testCallbacks():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));

			var adapter : LifeCycleAdapter = new LifeCycleAdapter();
			adapter.initHandler = init;
			adapter.drawHandler = draw;
			adapter.prepareUpdateHandler = prepareUpdate;
			adapter.updateHandler = update;
			adapter.cleanUpHandler = cleanUp;
			
			var calls : Array = new Array();
			_lc.registerComponent(s, adapter);

			adapter.validateNow();
			adapter.invalidate();
			
			setUpExitFrame(complete);
			
			function init(theAdapter : LifeCycleAdapter) : void {
				assertStrictlyEquals(adapter, theAdapter);
				calls.push("init");
			}
			
			function draw(theAdapter : LifeCycleAdapter) : void {
				assertStrictlyEquals(adapter, theAdapter);
				calls.push("draw");
			}
			
			function prepareUpdate(theAdapter : LifeCycleAdapter) : void {
				assertStrictlyEquals(adapter, theAdapter);
				calls.push("prepareUpdate");
			}
			
			function update(theAdapter : LifeCycleAdapter) : void {
				assertStrictlyEquals(adapter, theAdapter);
				calls.push("update");
			}
			
			function cleanUp(theAdapter : LifeCycleAdapter) : void {
				assertStrictlyEquals(adapter, theAdapter);
				calls.push("cleanUp");
			}
			
			function complete(event : Event, data : * = null) : void {
				adapter.cleanUp();
				
				assertTrue(calls, ArrayUtils.arraysEqual(["init", "draw", "prepareUpdate", "update", "cleanUp"], calls));
			}
		}

		[Test(async)]
		public function testCleanUp():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));

			var adapter : SimpleAdapter = new SimpleAdapter();
			
			_lc.registerComponent(s, adapter);
			
			adapter.validateNow();

			validateLifeCycle([s], [s], []);
			validateInvalidProperties([], []);

			adapter.invalidate();
			
			adapter.cleanUp();
			
			assertTrue(ArrayUtils.arraysEqual([s], LifeCycleWatcher.cleanUpCalls));

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				assertTrue(ArrayUtils.arraysEqual([s], LifeCycleWatcher.cleanUpCalls));
				validateLifeCycle([], [], []);
			}
		}

		[Test(async)]
		public function testCleanUp2():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));

			var adapter : SimpleAdapter = new SimpleAdapter();
			
			_lc.registerComponent(s, adapter);
			
			adapter.cleanUp();
			
			validateLifeCycle([s], [], []);
			validateInvalidProperties([], []);

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				validateLifeCycle([], [], []);
				validateInvalidProperties([], []);
			}
		}

	}
}
