package org.as3commons.ui.lifecycle.i10n.core {

	import org.as3commons.collections.SortedSet;
	import org.as3commons.collections.framework.ISortedSet;
	import org.as3commons.ui.lifecycle.i10n.I10NAdapter;

	/**
	 * Invalidation phase.
	 * 
	 * @author Jens Struwe 09.09.2011
	 */
	public class I10NPhase {

		private var _name : String;
		private var _loopback : String;

		private var _queue : ISortedSet;

		/**
		 * I10NPhase constructor.
		 * 
		 * @param name Name of the phase.
		 * @param order Order of processing (<code>I10N.PHASE_ORDER_TOP_DOWN</code> or <code>I10N.PHASE_ORDER_BOTTOM_UP</code>).
		 * @param loopback Property indicates when the validation cycle should rewind to the first phase.  
		 */
		public function I10NPhase(name : String, order : String, loopback : String) {
			_name = name;
			_loopback = loopback;

			_queue = new SortedSet(new I10NAdapterComparator(order));
		}
		
		/*
		 * Public
		 */

		/**
		 * Name of the phase.
		 */
		public function get name() : String {
			return _name;
		}

		/**
		 * Loopback configuration.
		 */
		public function get loopback() : String {
			return _loopback;
		}

		/**
		 * Schedules an item to be validated within this phase.
		 * 
		 * @param adapter The adapter to validate later.
		 */
		public function enqueue(adapter : I10NAdapter) : void {
			_queue.add(adapter);
		}

		/**
		 * Removes and returns the next item from the phase.
		 * 
		 * @return The next adapter to be processed.
		 */
		public function dequeue() : I10NAdapter {
			return _queue.removeFirst();
		}

		/**
		 * Removes the given item from the phase..
		 * 
		 * @param adapter The adapter to remove.
		 */
		public function remove(adapter : I10NAdapter) : void {
			_queue.remove(adapter);
		}

		/**
		 * Number of items added to the phase.
		 */
		public function get size() : uint {
			return _queue.size;
		}

	}
}
