package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flexunit.async.Async;

	public class DummyAsyncTest
	{
		[Test(async)]
		public function pause() : void
		{
			var timer:Timer = new Timer(1,1);
			Async.handleEvent(this, timer, TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			timer.start();
		}
		
		protected function handleTimerComplete(event:TimerEvent, data:Object) : void
		{
			(event.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
		}
	}
}