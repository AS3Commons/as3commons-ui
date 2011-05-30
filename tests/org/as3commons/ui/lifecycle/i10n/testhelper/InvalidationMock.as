package org.as3commons.ui.lifecycle.i10n.testhelper {

	import org.as3commons.ui.lifecycle.i10n.Invalidation;

	/**
	 * @author Jens Struwe 30.05.2011
	 */
	public class InvalidationMock extends Invalidation {
		
		public function queueKeysToArray() : Array {
			return _queue.keysToArray();
		}

		public function scheduleKeysToArray() : Array {
			return _schedule.keysToArray();
		}
		
	}
}
