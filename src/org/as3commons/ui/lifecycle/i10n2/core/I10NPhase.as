package org.as3commons.ui.lifecycle.i10n2.core {

	import org.as3commons.collections.SortedSet;
	import org.as3commons.collections.framework.ISortedSet;
	import org.as3commons.ui.lifecycle.i10n2.I10NAdapter;

	/**
	 * @author Jens Struwe 09.09.2011
	 */
	public class I10NPhase {

		private var _name : String;
		private var _loopback : String;
		private var _queue : ISortedSet;

		public function I10NPhase(name : String, order : String, loopback : String) {
			_name = name;
			_loopback = loopback;

			_queue = new SortedSet(new I10NAdapterComparator(order));
		}
		
		/*
		 * Public
		 */

		public function get name() : String {
			return _name;
		}

		public function get loopback() : String {
			return _loopback;
		}

		public function enqueue(adapter : I10NAdapter) : void {
			_queue.add(adapter);
		}

		public function dequeue() : I10NAdapter {
			return _queue.removeFirst();
		}

		public function remove(adapter : I10NAdapter) : void {
			_queue.remove(adapter);
		}

		public function get size() : uint {
			return _queue.size;
		}

	}
}
