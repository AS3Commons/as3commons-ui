package org.as3commons.ui.lifecycle.i10n.core.tests {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.lifecycle.i10n.I10N;
	import org.as3commons.ui.lifecycle.i10n.testhelper.I10NCallbackWatcher;
	import org.as3commons.ui.lifecycle.i10n.testhelper.TestI10NAdapter;
	import org.as3commons.ui.lifecycle.testhelper.AsyncCallback;
	import org.as3commons.ui.testhelper.TestDisplayObject;
	import org.flexunit.asserts.assertTrue;



	/**
	 * @author Jens Struwe 14.09.2011
	 */
	public class I10NPhaseTest {

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

		[Test(async)]
		public function test_order() : void {
			_i10n.addPhase("phase1", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("phase2", I10N.PHASE_ORDER_BOTTOM_UP);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			
			var s2 : DisplayObject = Sprite(s).addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("phase1");
			adapter2.invalidate("phase2");

			setUpCompleteTimer(complete);

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(log, ArrayUtils.arraysEqual([
					s, "phase1",
					s2, "phase1",
					s2, "phase2",
					s, "phase2"
				], log));
			}

		}

		[Test(async)]
		public function test_order_changedInValidate() : void {
			_i10n.addPhase("phase1", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("phase2", I10N.PHASE_ORDER_BOTTOM_UP);
			_i10n.addPhase("phase3", I10N.PHASE_ORDER_TOP_DOWN);
			_i10n.addPhase("phase4", I10N.PHASE_ORDER_BOTTOM_UP);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			adapter.invalidate("phase4");
			
			var s2 : DisplayObject = Sprite(s).addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter2.validateFunction = validate2;
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("phase1");
			adapter2.invalidate("phase2");
			adapter2.invalidate("phase3");
			adapter2.invalidate("phase4");

			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				if (phaseName == "phase2" && !adapter.validateCountForPhase(phaseName)) {
					StageProxy.root.addChild(s2);
					Sprite(s2).addChild(s);
				}
			}

			function validate2(phaseName : String) : void {
				if (phaseName == "phase3" && !adapter.validateCountForPhase(phaseName)) {
					StageProxy.root.addChild(s);
					Sprite(s).addChild(s2);
				}
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(log, ArrayUtils.arraysEqual([
					s, "phase1", // top down
					s2, "phase1",

					s2, "phase2", // bottom up
					s, "phase2", // here the switch
					s, "phase2", // scheduled again

					s2, "phase3", // top down reverse, here the switch
					s, "phase3",
					s2, "phase3", // scheduled again

					s2, "phase4", // bottom up
					s, "phase4"
				], log));
			}

		}

		[Test(async)]
		public function test_loopback_item() : void {
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
			
			var s2 : DisplayObject = Sprite(s).addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter2.validateFunction = validate2;
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("phase1");
			adapter2.invalidate("phase2");
			adapter2.invalidate("phase3");

			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				if (!adapter.validateCountForPhase(phaseName)) {
					invalidateObjects();
				}
			}

			function validate2(phaseName : String) : void {
				if (!adapter2.validateCountForPhase(phaseName)) {
					invalidateObjects();
				}
			}

			function invalidateObjects() : void {
				adapter.invalidate("phase1");
				adapter.invalidate("phase2");
				adapter.invalidate("phase3");

				adapter2.invalidate("phase1");
				adapter2.invalidate("phase2");
				adapter2.invalidate("phase3");
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(log, ArrayUtils.arraysEqual([
					s, "phase1", // reinvalidates s for phase 1
					s, "phase1",
					s2, "phase1", // reinvalidates s and s2 for phase 1
					s, "phase1",
					s2, "phase1",
					
					s, "phase2", // reinvalidates s and s2 for phase 1 and s for phase 2
					s, "phase1",
					s2, "phase1",
					s, "phase2",
					s2, "phase2", // reinvalidates s and s2 for phase 1 and phase 2
					s, "phase1",
					s2, "phase1",
					s, "phase2",
					s2, "phase2",
					
					s, "phase3", // reinvalidates s for all phases and s2 for phases 1 + 2 
					s, "phase1",
					s2, "phase1",
					s, "phase2",
					s2, "phase2",
					s, "phase3",
					s2, "phase3", // reinvalidates s and s2 for all phases
					s, "phase1",
					s2, "phase1",
					s, "phase2",
					s2, "phase2",
					s, "phase3",
					s2, "phase3"
				], log));
			}

		}

		[Test(async)]
		public function test_loopback_phase() : void {
			_i10n.addPhase("phase1", I10N.PHASE_ORDER_TOP_DOWN, I10N.PHASE_LOOPBACK_AFTER_PHASE);
			_i10n.addPhase("phase2", I10N.PHASE_ORDER_TOP_DOWN, I10N.PHASE_LOOPBACK_AFTER_PHASE);
			_i10n.addPhase("phase3", I10N.PHASE_ORDER_TOP_DOWN, I10N.PHASE_LOOPBACK_AFTER_PHASE);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			
			var s2 : DisplayObject = Sprite(s).addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter2.validateFunction = validate2;
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("phase1");
			adapter2.invalidate("phase2");
			adapter2.invalidate("phase3");

			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				if (!adapter.validateCountForPhase(phaseName)) {
					invalidateObjects();
				}
			}

			function validate2(phaseName : String) : void {
				if (!adapter2.validateCountForPhase(phaseName)) {
					invalidateObjects();
				}
			}

			function invalidateObjects() : void {
				adapter.invalidate("phase1");
				adapter.invalidate("phase2");
				adapter.invalidate("phase3");

				adapter2.invalidate("phase1");
				adapter2.invalidate("phase2");
				adapter2.invalidate("phase3");
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(log, ArrayUtils.arraysEqual([
					s, "phase1", // reinvalidates s for phase 1
					s, "phase1",
					s2, "phase1", // reinvalidates s and s2 for phase 1
					s, "phase1",
					s2, "phase1",
					
					s, "phase2", // reinvalidates s and s2 for phase 1 and s for phase 2
					s, "phase2",
					s2, "phase2", // reinvalidates s and s2 for phase 1 and phase 2
					s, "phase2",
					s2, "phase2",

					s, "phase1",
					s2, "phase1",
					
					s, "phase3", // reinvalidates s for all phases and s2 for phases 1 + 2
					s, "phase3",
					s2, "phase3", // reinvalidates s and s2 for all phases
					s, "phase3",
					s2, "phase3",

					s, "phase1",
					s2, "phase1",

					s, "phase2",
					s2, "phase2"
				], log));
			}

		}

		[Test(async)]
		public function test_loopback_none() : void {
			_i10n.addPhase("phase1", I10N.PHASE_ORDER_TOP_DOWN, I10N.PHASE_LOOPBACK_NONE);
			_i10n.addPhase("phase2", I10N.PHASE_ORDER_TOP_DOWN, I10N.PHASE_LOOPBACK_NONE);
			_i10n.addPhase("phase3", I10N.PHASE_ORDER_TOP_DOWN, I10N.PHASE_LOOPBACK_NONE);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			
			var s2 : DisplayObject = Sprite(s).addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter2.validateFunction = validate2;
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("phase1");
			adapter2.invalidate("phase2");
			adapter2.invalidate("phase3");

			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				if (!adapter.validateCountForPhase(phaseName)) {
					invalidateObjects();
				}
			}

			function validate2(phaseName : String) : void {
				if (!adapter2.validateCountForPhase(phaseName)) {
					invalidateObjects();
				}
			}

			function invalidateObjects() : void {
				adapter.invalidate("phase1");
				adapter.invalidate("phase2");
				adapter.invalidate("phase3");

				adapter2.invalidate("phase1");
				adapter2.invalidate("phase2");
				adapter2.invalidate("phase3");
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(log, ArrayUtils.arraysEqual([
					s, "phase1", // reinvalidates s for phase 1
					s, "phase1",
					s2, "phase1", // reinvalidates s and s2 for phase 1
					s, "phase1",
					s2, "phase1",
					
					s, "phase2", // reinvalidates s and s2 for phase 1 and s for phase 2
					s, "phase2",
					s2, "phase2", // reinvalidates s and s2 for phase 1 and phase 2
					s, "phase2",
					s2, "phase2",

					s, "phase3", // reinvalidates s for all phases and s2 for phases 1 + 2
					s, "phase3",
					s2, "phase3", // reinvalidates s and s2 for all phases
					s, "phase3",
					s2, "phase3",

					s, "phase1",
					s2, "phase1",

					s, "phase2",
					s2, "phase2"
				], log));
			}

		}

		[Test(async)]
		public function test_loopback_mixed() : void {
			_i10n.addPhase("phase1", I10N.PHASE_ORDER_TOP_DOWN, I10N.PHASE_LOOPBACK_NONE);
			_i10n.addPhase("phase2", I10N.PHASE_ORDER_TOP_DOWN, I10N.PHASE_LOOPBACK_AFTER_PHASE);
			_i10n.addPhase("phase3", I10N.PHASE_ORDER_TOP_DOWN, I10N.PHASE_LOOPBACK_AFTER_ITEM);
			_i10n.start();

			var s : DisplayObject = StageProxy.root.addChild(new TestDisplayObject("s"));
			var adapter : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter.validateFunction = validate;
			_i10n.registerDisplayObject(s, adapter);
			adapter.invalidate("phase1");
			adapter.invalidate("phase2");
			adapter.invalidate("phase3");
			
			var s2 : DisplayObject = Sprite(s).addChild(new TestDisplayObject("s2"));
			var adapter2 : TestI10NAdapter = new TestI10NAdapter(_watcher);
			adapter2.validateFunction = validate2;
			_i10n.registerDisplayObject(s2, adapter2);
			adapter2.invalidate("phase1");
			adapter2.invalidate("phase2");
			adapter2.invalidate("phase3");

			setUpCompleteTimer(complete);

			function validate(phaseName : String) : void {
				if (!adapter.validateCountForPhase(phaseName)) {
					invalidateObjects();
				}
			}

			function validate2(phaseName : String) : void {
				if (!adapter2.validateCountForPhase(phaseName)) {
					invalidateObjects();
				}
			}

			function invalidateObjects() : void {
				adapter.invalidate("phase1");
				adapter.invalidate("phase2");
				adapter.invalidate("phase3");

				adapter2.invalidate("phase1");
				adapter2.invalidate("phase2");
				adapter2.invalidate("phase3");
			}

			function complete(event : Event, data : * = null) : void {
				var log : Array = _watcher.validateLog;
				assertTrue(log, ArrayUtils.arraysEqual([
					s, "phase1", // reinvalidates s for phase 1
					s, "phase1",
					s2, "phase1", // reinvalidates s and s2 for phase 1
					s, "phase1",
					s2, "phase1",
					
					s, "phase2", // reinvalidates s and s2 for phase 1 and s for phase 2
					s, "phase2",
					s2, "phase2", // reinvalidates s and s2 for phase 1 and phase 2
					s, "phase2",
					s2, "phase2",

					s, "phase1",
					s2, "phase1",
					
					s, "phase3", // reinvalidates s for all phases and s2 for phases 1 + 2 
					s, "phase1",
					s2, "phase1",
					s, "phase2",
					s2, "phase2",
					s, "phase3",
					s2, "phase3", // reinvalidates s and s2 for all phases
					s, "phase1",
					s2, "phase1",
					s, "phase2",
					s2, "phase2",
					s, "phase3",
					s2, "phase3"
				], log));
			}

		}

	}
}
