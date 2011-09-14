package org.as3commons.ui.lifecycle.i10n2.core {

	import org.as3commons.collections.utils.NumericComparator;
	import org.as3commons.ui.lifecycle.i10n2.I10N;
	import org.as3commons.ui.lifecycle.i10n2.II10NAdapter;

	/**
	 * @author Jens Struwe 24.08.2011
	 */
	public class I10NAdapterComparator extends NumericComparator {
		
		public function I10NAdapterComparator(order : String) {
			order = order == I10N.PHASE_ORDER_TOP_DOWN ? NumericComparator.ORDER_ASC : NumericComparator.ORDER_DESC;
			super(order);
		}
		
		override public function compare(item1 : *, item2 : *) : int {
			return super.compare(
				II10NAdapter(item1).nestLevel,
				II10NAdapter(item2).nestLevel
			);
		}

	}
}
