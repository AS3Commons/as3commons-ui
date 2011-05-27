package org.as3commons.ui.lifecycle {

	import org.as3commons.ui.lifecycle.i10n.tests.InvalidationTest;
	import org.as3commons.ui.lifecycle.lifecycle.tests.LifeCycleAdapterTest;
	import org.as3commons.ui.lifecycle.lifecycle.tests.LifeCycleTest;

	/**
	 * @author Jens Struwe 23.05.2011
	 */

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]	
	public class LifeCycleTests {
		
		public var i10nTest : InvalidationTest;
		public var lifeCycleTest : LifeCycleTest;
		public var lifeCycleAdapterTest : LifeCycleAdapterTest;
		
	}
}
