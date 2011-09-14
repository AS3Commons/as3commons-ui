package org.as3commons.ui.lifecycle.i10n2.testhelper {

	import org.flexunit.async.Async;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Jens Struwe 14.09.2011
	 */
	public class I10NTestBase {

		protected function setUpCompleteTimer(callback : Function = null, data : Object = null, delay : uint = 100) : void {
			var timer : Timer = new Timer(delay, 1);
			timer.addEventListener(
				TimerEvent.TIMER, 
				Async.asyncHandler(this, callback, delay * 5, data, function() : void {
					throw new Error("TIMEOUT");
				}),
				false, -10, true
			);
			timer.start();
		}

	}
}
