package org.as3commons.ui.lifecycle {

	import org.as3commons.ui.lifecycle.i10n.tests.I10NAdapterTest;
	import org.as3commons.ui.lifecycle.i10n.tests.I10NTest;
	import org.as3commons.ui.lifecycle.i10n.tests.core.I10NPhaseTest;
	import org.as3commons.ui.lifecycle.lifecycle.tests.LifeCycleAdapterTest;
	import org.as3commons.ui.lifecycle.lifecycle.tests.LifeCycleTest;

	/**
	 * @author Jens Struwe 23.05.2011
	 */

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]	
	public class LifeCycleTests {
		
		public var i10n2Test : I10NTest;
		public var i10n2PhaseTest : I10NPhaseTest;
		public var i10n2AdapterTest : I10NAdapterTest;

		public var lifeCycle2Test : LifeCycleTest;
		public var lifeCycle2AdapterTest : LifeCycleAdapterTest;

	}
}
