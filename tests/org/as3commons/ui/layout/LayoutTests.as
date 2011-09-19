package org.as3commons.ui.layout {

	import org.as3commons.ui.layout.framework.core.tests.AbstractLayoutTest;
	import org.as3commons.ui.layout.tests.DisplayTest;
	import org.as3commons.ui.layout.tests.HLayoutTest;

	/**
	 * @author Jens Struwe 19.09.2011
	 */

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]	
	public class LayoutTests {

		public var abstractLayoutTest : AbstractLayoutTest;
		public var hLayoutTest : HLayoutTest;
		public var displayTest : DisplayTest;

	}
}
