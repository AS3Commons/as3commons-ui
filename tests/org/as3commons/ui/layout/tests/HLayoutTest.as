package org.as3commons.ui.layout.tests {

	import org.as3commons.ui.layout.HLayout;
	import org.as3commons.ui.layout.framework.IHLayout;
	import org.as3commons.ui.layout.testhelper.TestBox;
	import org.flexunit.asserts.assertTrue;

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Jens Struwe 19.09.2011
	 */
	public class HLayoutTest {

		private var _layout : IHLayout;

		[Before]
		public function setUp() : void {
			_layout = new HLayout();
		}

		[After]
		public function tearDown() : void {
			_layout = null;

			StageProxy.cleanUpRoot();
		}
		
		[Test]
		public function test_layout() : void {
			_layout.add(TestBox.create(100, 0));
			_layout.layout(StageProxy.root as Sprite);
			
			assertTrue(_layout.contentRect.equals(new Rectangle(0, 0, 1000, 10)));
			assertTrue(_layout.visibleRect.equals(new Rectangle(0, 0, 1000, 10)));
			assertTrue(_layout.position.equals(new Point(0, 0)));
		}

		[Test]
		public function test_minSize() : void {
			_layout.minWidth = 200;
			_layout.minHeight = 20;
			_layout.add(TestBox.create(10, 0));
			_layout.layout(StageProxy.root as Sprite);
			
			assertTrue(_layout.contentRect.equals(new Rectangle(0, 0, 200, 20)));
			assertTrue(_layout.visibleRect.equals(new Rectangle(0, 0, 100, 10)));
			assertTrue(_layout.position.equals(new Point(0, 0)));
		}

		[Test]
		public function test_layout_maxItemsPerRow() : void {
			_layout.maxItemsPerRow = 10;
			_layout.add(TestBox.create(100, 0));
			_layout.layout(StageProxy.root as Sprite);
			
			assertTrue(_layout.contentRect.equals(new Rectangle(0, 0, 100, 100)));
			assertTrue(_layout.visibleRect.equals(new Rectangle(0, 0, 100, 100)));
			assertTrue(_layout.position.equals(new Point(0, 0)));
		}

		[Test]
		public function test_minSize_maxItemsPerRow() : void {
			_layout.maxItemsPerRow = 25;
			_layout.minWidth = 200;
			_layout.minHeight = 20;
			_layout.add(TestBox.create(100, 0));
			_layout.layout(StageProxy.root as Sprite);
			
			assertTrue(_layout.contentRect.equals(new Rectangle(0, 0, 250, 40)));
			assertTrue(_layout.visibleRect.equals(new Rectangle(0, 0, 250, 40)));
			assertTrue(_layout.position.equals(new Point(0, 0)));
		}

		[Test]
		public function test_layout_maxContentWidth() : void {
			_layout.maxContentWidth = 100;
			_layout.add(TestBox.create(100, 0));
			_layout.layout(StageProxy.root as Sprite);
			
			assertTrue(_layout.contentRect.equals(new Rectangle(0, 0, 100, 100)));
			assertTrue(_layout.visibleRect.equals(new Rectangle(0, 0, 100, 100)));
			assertTrue(_layout.position.equals(new Point(0, 0)));
		}

		[Test]
		public function test_layout_gaps_maxItemsPerRow() : void {
			_layout.maxItemsPerRow = 10;
			_layout.hGap = 10;
			_layout.vGap = 10;
			_layout.add(TestBox.create(100, 0));
			_layout.layout(StageProxy.root as Sprite);
			
			assertTrue(_layout.contentRect.equals(new Rectangle(0, 0, 190, 190)));
			assertTrue(_layout.visibleRect.equals(new Rectangle(0, 0, 190, 190)));
			assertTrue(_layout.position.equals(new Point(0, 0)));
		}

		[Test]
		public function test_layout_gaps_maxContentWidth() : void {
			_layout.maxContentWidth = 100;
			_layout.hGap = 10;
			_layout.vGap = 10;
			_layout.add(TestBox.create(100, 0));
			_layout.layout(StageProxy.root as Sprite);
			
			assertTrue(_layout.contentRect.equals(new Rectangle(0, 0, 90, 390)));
			assertTrue(_layout.visibleRect.equals(new Rectangle(0, 0, 90, 390)));
			assertTrue(_layout.position.equals(new Point(0, 0)));
		}

		[Test]
		public function test_layout_margins() : void {
			_layout.marginX = 10;
			_layout.marginY = 10;
			_layout.add(TestBox.create(100, 0));
			_layout.layout(StageProxy.root as Sprite);
			
			assertTrue(_layout.contentRect.equals(new Rectangle(10, 10, 1000, 10)));
			assertTrue(_layout.visibleRect.equals(new Rectangle(10, 10, 1000, 10)));
			assertTrue(_layout.position.equals(new Point(0, 0)));
		}

		[Test]
		public function test_layout_offsets() : void {
			_layout.offsetX = 10;
			_layout.offsetY = 10;
			_layout.add(TestBox.create(100, 0));
			_layout.layout(StageProxy.root as Sprite);
			
			assertTrue(_layout.contentRect.equals(new Rectangle(10, 10, 1000, 10)));
			assertTrue(_layout.visibleRect.equals(new Rectangle(10, 10, 1000, 10)));
			assertTrue(_layout.position.equals(new Point(0, 0)));
		}

	}
}
