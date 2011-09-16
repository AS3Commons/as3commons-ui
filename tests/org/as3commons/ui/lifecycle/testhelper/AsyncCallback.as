package org.as3commons.ui.lifecycle.testhelper {

	import org.flexunit.async.Async;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Jens Struwe 16.09.2011
	 */
	public class AsyncCallback {

		public static function setUpCompleteTimer(testCase : Object, callback : Function = null, data : Object = null, delay : uint = 50) : void {
			var timer : Timer = new Timer(delay, 1);
			timer.addEventListener(
				TimerEvent.TIMER, 
				Async.asyncHandler(testCase, callback, delay * 5, data, function() : void {
					throw new Error("TIMEOUT");
				}),
				false, -10, true
			);
			timer.start();
		}

		public static function setUpRenderTimer(testCase : Object, callback : Function = null, data : Object = null, delay : uint = 50) : void {
			StageProxy.stage.addEventListener(
				Event.RENDER, 
				Async.asyncHandler(testCase, callback, delay * 5, data, function() : void {
					throw new Error("TIMEOUT");
				}),
				false, -10, true
			);
			StageProxy.stage.invalidate();
		}

	}
}
