package org.as3commons.ui.lifecycle.i10n.core {

	import org.as3commons.collections.utils.NumericComparator;
	import org.as3commons.ui.lifecycle.i10n.I10N;
	import org.as3commons.ui.lifecycle.i10n.II10NAdapter;

	/**
	 * Comparator to compare the nest level of invalidation adapters.
	 * 
	 * @author Jens Struwe 24.08.2011
	 */
	public class I10NAdapterComparator extends NumericComparator {
		
		/**
		 * I10NAdapterComparator constructor.
		 * 
		 * @param order The phase order (bottom-up or top-down).
		 */
		public function I10NAdapterComparator(order : String) {
			order = order == I10N.PHASE_ORDER_TOP_DOWN ? NumericComparator.ORDER_ASC : NumericComparator.ORDER_DESC;
			super(order);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function compare(item1 : *, item2 : *) : int {
			return super.compare(
				II10NAdapter(item1).nestLevel,
				II10NAdapter(item2).nestLevel
			);
		}

	}
}
