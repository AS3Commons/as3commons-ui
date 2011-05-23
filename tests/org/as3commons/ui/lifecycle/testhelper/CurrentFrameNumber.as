package org.as3commons.ui.lifecycle.testhelper {

	import flash.events.Event;
	import flash.display.Stage;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class CurrentFrameNumber {
		
		public static var current : uint;
		
		public static function watch(stage : Stage) : void {
			stage.addEventListener(Event.ENTER_FRAME, enterFrame);
		}

		private static function enterFrame(event : Event) : void {
			current++;
		}

	}
}
