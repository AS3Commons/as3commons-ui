package org.as3commons.ui.lifecycle {

	import org.as3commons.ui.lifecycle.i10n.core.tests.I10NPhaseTest;
	import org.as3commons.ui.lifecycle.i10n.tests.I10NAdapterTest;
	import org.as3commons.ui.lifecycle.i10n.tests.I10NTest;
	import org.as3commons.ui.lifecycle.lifecycle.tests.LifeCycleAdapterTest;
	import org.as3commons.ui.lifecycle.lifecycle.tests.LifeCycleTest;

	/**
	 * @author Jens Struwe 23.05.2011
	 */

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]	
	public class LifeCycleTests {
		
		public var i10nTest : I10NTest;
		public var i10nPhaseTest : I10NPhaseTest;
		public var i10nAdapterTest : I10NAdapterTest;

		public var lifeCycleTest : LifeCycleTest;
		public var lifeCycleAdapterTest : LifeCycleAdapterTest;

	}
}
