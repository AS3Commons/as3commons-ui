package org.as3commons.ui.lifecycle.tests {

	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.lifecycle.render.AllSelector;
	import org.as3commons.ui.lifecycle.render.RenderManager;
	import org.as3commons.ui.lifecycle.testhelper.TestRenderProcessor;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class RenderManagerTest {

		protected var _timer : Timer;
		protected var _rm : RenderManager;
		protected var _processor : TestRenderProcessor;

		protected function setUpTimer(numFrames : uint, callback : Function, data : Object) : void {
			_timer = new Timer(0, 1);
			_timer.addEventListener(
				TimerEvent.TIMER_COMPLETE, 
				Async.asyncHandler(this, callback, numFrames * 100, data),
				false, 0, true
			);
			_timer.start();			
		}
		
		protected function setUpManager(configure : Boolean = true) : void {
			_rm = new RenderManager();
			_rm.stage = StageProxy.stage;
			_processor = new TestRenderProcessor();
			if (configure) _rm.configureProcessor(new AllSelector(), _processor);
		}
		
		[After]
		protected function tearDown() : void {
			if (_timer) _timer.stop();
			_timer = null;
			
			_rm = null;
			_processor = null;
			
			StageProxy.cleanUpRoot();
		}

		[Test]
		public function testInit():void {
			var rm : RenderManager = new RenderManager();
			assertTrue(rm is RenderManager);
		}

		[Test]
		public function errorWhenInvalidateBeforeStageSetup():void {
			var rm : RenderManager = new RenderManager();
			
			var error : Error;
			
			try {
				var s1 : Sprite = new Sprite();
				rm.invalidate(s1);
			} catch (e : Error) {
				error = e;
			}
			
			assertNotNull(error);
		}

		[Test(async)]
		public function testSimpleInvocation():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s);
			
			setUpTimer(1, complete, _processor);
			
			function complete(event : TimerEvent, processor : TestRenderProcessor) : void {
				assertEquals(1, processor.calls.length);
				assertTrue(ArrayUtils.arraysEqual([s], processor.calls));
			}
		}

		[Test(async)]
		public function testProcessorWithoutRegistrationNotInvoked():void {
			setUpManager(false);
			// NOT invoked: rm.configureProcessor(new AllSelector(), processor);
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			_rm.invalidate(s);
			
			setUpTimer(1, complete, _processor);
			
			function complete(event : TimerEvent, processor : TestRenderProcessor) : void {
				assertEquals(0, processor.calls.length);
				assertTrue(ArrayUtils.arraysEqual([], processor.calls));
			}
		}

		[Test(async)]
		public function testRenderOrderSameAsInvocation():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s);
			_rm.invalidate(s2);
			
			setUpTimer(1, complete, _processor);
			
			function complete(event : TimerEvent, processor : TestRenderProcessor) : void {
				assertEquals(2, processor.calls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s2], processor.calls));
			}
		}

		[Test(async)]
		public function testRenderOrderSameAsInvocation2():void {
			setUpManager();
			
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s2);
			_rm.invalidate(s);
			
			setUpTimer(1, complete, _processor);
			
			function complete(event : TimerEvent, processor : TestRenderProcessor) : void {
				assertEquals(2, processor.calls.length);
				assertTrue(ArrayUtils.arraysEqual([s2, s], processor.calls));
			}
			
		}

		[Test(async)]
		public function testRenderOrderSameAsInvocation3():void {
			setUpManager();
			
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s);
			_rm.invalidate(s2);
			
			setUpTimer(1, complete, _processor);
			
			function complete(event : TimerEvent, processor : TestRenderProcessor) : void {
				assertEquals(2, processor.calls.length);
				assertTrue(ArrayUtils.arraysEqual([s, s2], processor.calls));
			}
			
		}

		[Test(async)]
		public function testRenderOrderSameAsInvocation4():void {
			setUpManager();
			
			var s2 : DisplayObject = StageProxy.root.addChild(new Sprite());
			var s : DisplayObject = StageProxy.root.addChild(new Sprite());

			_rm.invalidate(s2);
			_rm.invalidate(s);
			
			setUpTimer(1, complete, _processor);
			
			function complete(event : TimerEvent, processor : TestRenderProcessor) : void {
				assertEquals(2, processor.calls.length);
				assertTrue(ArrayUtils.arraysEqual([s2, s], processor.calls));
			}
		}

	}
}
