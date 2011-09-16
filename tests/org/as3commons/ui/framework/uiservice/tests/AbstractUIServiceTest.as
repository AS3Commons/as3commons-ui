package org.as3commons.ui.framework.uiservice.tests {

	import org.as3commons.ui.framework.core.as3commons_ui;
	import org.as3commons.ui.framework.uiservice.AbstractUIService;
	import org.as3commons.ui.framework.uiservice.errors.AdapterAlreadyRegisteredError;
	import org.as3commons.ui.framework.uiservice.errors.AdapterNotRegisteredError;
	import org.as3commons.ui.framework.uiservice.errors.ObjectAlreadyRegisteredError;
	import org.as3commons.ui.framework.uiservice.errors.ServiceNotStartedError;
	import org.as3commons.ui.framework.uiservice.testhelper.TestAdapter;
	import org.as3commons.ui.framework.uiservice.testhelper.TestService;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	use namespace as3commons_ui;

	/**
	 * @author Jens Struwe 15.09.2011
	 */
	public class AbstractUIServiceTest {

		private var _service : TestService;

		[Before]
		public function setUp() : void {
			_service = new TestService();
		}

		[After]
		public function tearDown() : void {
			_service.cleanUp();
		}

		[Test]
		public function test_instantiated() : void {
			assertTrue(_service is AbstractUIService);
		}

		[Test]
		public function test_start() : void {
			assertEquals(0, _service.numSetUpCalls);

			_service.start();

			assertEquals(1, _service.numSetUpCalls);
		}

		[Test]
		public function test_start_multipleTimes() : void {
			assertEquals(0, _service.numSetUpCalls);

			_service.start();

			assertEquals(1, _service.numSetUpCalls);

			_service.start();

			assertEquals(1, _service.numSetUpCalls);

			_service.start();

			assertEquals(1, _service.numSetUpCalls);
		}

		[Test]
		public function test_register() : void {
			_service.start();

			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var adapter : TestAdapter = new TestAdapter();
			
			assertEquals(0, adapter.numSetUpCalls);
			assertNull(adapter.displayObject);
			assertFalse(_service.hasAdapter_internal(s));

			_service.registerDisplayObject(s, adapter);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(s, adapter.displayObject);
			assertTrue(_service.hasAdapter_internal(s));
		}

		[Test]
		public function test_register_beforeStartThrowsError() : void {
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var adapter : TestAdapter = new TestAdapter();
			
			var errorThrown : Error;
			try {
				_service.registerDisplayObject(s, adapter);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is ServiceNotStartedError);

			assertEquals(0, adapter.numSetUpCalls);
			assertNull(adapter.displayObject);
			assertFalse(_service.hasAdapter_internal(s));
		}

		[Test]
		public function test_register_sharedAdapterThrowsError() : void {
			_service.start();

			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var adapter : TestAdapter = new TestAdapter();
			_service.registerDisplayObject(s, adapter);

			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			
			var errorThrown : Error;
			try {
				_service.registerDisplayObject(s2, adapter);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterAlreadyRegisteredError);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(s, adapter.displayObject);
			assertTrue(_service.hasAdapter_internal(s));
		}

		[Test]
		public function test_register_twiceThrowsError():void {
			_service.start();

			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var adapter : TestAdapter = new TestAdapter();
			_service.registerDisplayObject(s, adapter);
			
			var adapter2 : TestAdapter = new TestAdapter();

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(s, adapter.displayObject);
			assertTrue(_service.hasAdapter_internal(s));

			assertEquals(0, adapter2.numSetUpCalls);
			assertNull(adapter2.displayObject);

			var errorThrown : Error;
			try {
				_service.registerDisplayObject(s, adapter2);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is ObjectAlreadyRegisteredError);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(s, adapter.displayObject);
			assertTrue(_service.hasAdapter_internal(s));

			assertEquals(0, adapter2.numSetUpCalls);
			assertNull(adapter2.displayObject);
		}

		[Test]
		public function test_unregister() : void {
			_service.start();

			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var adapter : TestAdapter = new TestAdapter();
			
			_service.registerDisplayObject(s, adapter);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(0, adapter.numCleanUpCalls);
			assertEquals(s, adapter.displayObject);
			assertTrue(_service.hasAdapter_internal(s));
			
			_service.unregisterDisplayObject(s);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(1, adapter.numCleanUpCalls);
			assertNull(adapter.displayObject);
			assertFalse(_service.hasAdapter_internal(s));
		}

		[Test]
		public function test_unregister_notRegisteredThrowsError():void {
			_service.start();

			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			
			var errorThrown : Error;
			try {
				_service.unregisterDisplayObject(s);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);

			assertFalse(_service.hasAdapter_internal(s));
		}

		[Test]
		public function test_unregister_twiceThrowsError() : void {
			_service.start();

			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var adapter : TestAdapter = new TestAdapter();
			
			_service.registerDisplayObject(s, adapter);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(0, adapter.numCleanUpCalls);
			assertEquals(s, adapter.displayObject);
			assertTrue(_service.hasAdapter_internal(s));
			
			_service.unregisterDisplayObject(s);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(1, adapter.numCleanUpCalls);
			assertNull(adapter.displayObject);
			assertFalse(_service.hasAdapter_internal(s));
			
			var errorThrown : Error;
			try {
				_service.unregisterDisplayObject(s);
			} catch (e : Error) {
				errorThrown = e;
			}
			
			assertNotNull(errorThrown);
			assertTrue(errorThrown is AdapterNotRegisteredError);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(1, adapter.numCleanUpCalls);
			assertNull(adapter.displayObject);
			assertFalse(_service.hasAdapter_internal(s));
		}

		[Test]
		public function test_cleanUp() : void {
			_service.start();

			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var adapter : TestAdapter = new TestAdapter();
			_service.registerDisplayObject(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			var adapter2 : TestAdapter = new TestAdapter();
			_service.registerDisplayObject(s2, adapter2);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(0, adapter.numCleanUpCalls);
			assertEquals(s, adapter.displayObject);
			assertTrue(_service.hasAdapter_internal(s));
			
			assertEquals(1, adapter2.numSetUpCalls);
			assertEquals(0, adapter2.numCleanUpCalls);
			assertEquals(s2, adapter2.displayObject);
			assertTrue(_service.hasAdapter_internal(s2));
			
			_service.cleanUp();
			
			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(1, adapter.numCleanUpCalls);
			assertNull(adapter.displayObject);
			assertFalse(_service.hasAdapter_internal(s));

			assertEquals(1, adapter2.numSetUpCalls);
			assertEquals(1, adapter2.numCleanUpCalls);
			assertNull(adapter2.displayObject);
			assertFalse(_service.hasAdapter_internal(s2));
		}

		[Test]
		public function test_cleanUp_multipleTimes() : void {
			_service.start();

			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var adapter : TestAdapter = new TestAdapter();
			_service.registerDisplayObject(s, adapter);
			
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			var adapter2 : TestAdapter = new TestAdapter();
			_service.registerDisplayObject(s2, adapter2);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(0, adapter.numCleanUpCalls);
			assertEquals(s, adapter.displayObject);
			assertTrue(_service.hasAdapter_internal(s));
			
			assertEquals(1, adapter2.numSetUpCalls);
			assertEquals(0, adapter2.numCleanUpCalls);
			assertEquals(s2, adapter2.displayObject);
			assertTrue(_service.hasAdapter_internal(s2));
			
			assertEquals(0, _service.numCleanUpCalls);

			_service.cleanUp();
			
			assertEquals(1, _service.numCleanUpCalls);
			
			_service.cleanUp();

			assertEquals(1, _service.numCleanUpCalls);

			_service.cleanUp();
			
			assertEquals(1, _service.numCleanUpCalls);

			assertEquals(1, adapter.numSetUpCalls);
			assertEquals(1, adapter.numCleanUpCalls);
			assertNull(adapter.displayObject);
			assertFalse(_service.hasAdapter_internal(s));

			assertEquals(1, adapter2.numSetUpCalls);
			assertEquals(1, adapter2.numCleanUpCalls);
			assertNull(adapter2.displayObject);
			assertFalse(_service.hasAdapter_internal(s2));
		}

	}
}
