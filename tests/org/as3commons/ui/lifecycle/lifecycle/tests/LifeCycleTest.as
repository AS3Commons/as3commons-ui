package org.as3commons.ui.lifecycle.lifecycle.tests {

	import org.flexunit.asserts.assertNull;
	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.lifecycle.i10n.testhelper.TestDisplayObject;
	import org.as3commons.ui.lifecycle.lifecycle.LifeCycle;
	import org.as3commons.ui.lifecycle.lifecycle.testhelper.LifeCycleWatcher;
	import org.as3commons.ui.lifecycle.lifecycle.testhelper.SimpleAdapter;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Jens Struwe 27.05.2011
	 */
	public class LifeCycleTest {
		
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

		[Test]
		public function testInstantiated():void {
			assertTrue(_lc is LifeCycle);
		}

		[Test]
		public function testRegister_sharedAdapterThrowsError():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var s2 : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s2"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			var errorThrown : Error;
			try {
				_lc.registerComponent(s2, adapter);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(String(errorThrown.message).indexOf("reuse") > - 1);
		}

		[Test]
		public function testRegister_componentTwiceThrowsError():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			var adapter2 : SimpleAdapter = new SimpleAdapter();
			var errorThrown : Error;
			try {
				_lc.registerComponent(s, adapter2);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(String(errorThrown.message).indexOf("register") > - 1);
		}

		[Test(async)]
		public function testUnregister():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			var adapter2 : SimpleAdapter = new SimpleAdapter();
			var errorThrown : Error;
			try {
				_lc.registerComponent(s, adapter2);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(String(errorThrown.message).indexOf("register") > - 1);
			
			_lc.unregisterComponent(s);

			errorThrown = null;
			try {
				_lc.registerComponent(s, adapter2);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNull(errorThrown);

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				assertEquals(2, LifeCycleWatcher.initCalls.length);
				assertEquals(1, LifeCycleWatcher.drawCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s], LifeCycleWatcher.initCalls));
				assertTrue(ArrayUtils.arraysEqual([s], LifeCycleWatcher.drawCalls));
			}
		}

		[Test(async)]
		public function testUnregisterAllComponents():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			var adapter2 : SimpleAdapter = new SimpleAdapter();
			var errorThrown : Error;
			try {
				_lc.registerComponent(s, adapter2);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(String(errorThrown.message).indexOf("register") > - 1);
			
			_lc.unregisterAllComponents();

			errorThrown = null;
			try {
				_lc.registerComponent(s, adapter2);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNull(errorThrown);

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				assertEquals(2, LifeCycleWatcher.initCalls.length);
				assertEquals(1, LifeCycleWatcher.drawCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s], LifeCycleWatcher.initCalls));
				assertTrue(ArrayUtils.arraysEqual([s], LifeCycleWatcher.drawCalls));
			}
		}

		[Test(async)]
		public function testCleanUp():void {
			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : SimpleAdapter = new SimpleAdapter();
			_lc.registerComponent(s, adapter);
			
			var adapter2 : SimpleAdapter = new SimpleAdapter();
			var errorThrown : Error;
			try {
				_lc.registerComponent(s, adapter2);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(String(errorThrown.message).indexOf("register") > - 1);
			
			_lc.cleanUp();

			errorThrown = null;
			try {
				_lc.registerComponent(s, adapter2);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNull(errorThrown);

			setUpExitFrame(complete);
			
			function complete(event : Event, data : * = null) : void {
				assertEquals(2, LifeCycleWatcher.initCalls.length);
				assertEquals(0, LifeCycleWatcher.drawCalls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s], LifeCycleWatcher.initCalls));
				assertTrue(ArrayUtils.arraysEqual([], LifeCycleWatcher.drawCalls));
			}
		}


	}
}
