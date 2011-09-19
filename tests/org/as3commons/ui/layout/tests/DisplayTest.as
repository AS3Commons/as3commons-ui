package org.as3commons.ui.layout.tests {

	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.layout.Display;
	import org.as3commons.ui.layout.HGroup;
	import org.as3commons.ui.layout.framework.IDisplay;
	import org.as3commons.ui.layout.testhelper.TestBox;
	import org.flexunit.asserts.assertTrue;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Jens Struwe 19.09.2011
	 */
	public class DisplayTest {

		private var _display : IDisplay;

		[Before]
		public function setUp() : void {
			_display = new Display();
			_display.displayObject = new TestBox(0);
		}

		[After]
		public function tearDown() : void {
			_display = null;

			StageProxy.cleanUpRoot();
		}
		
		[Test]
		public function test_display() : void {
			var s : TestBox = new TestBox(0);
			var s2 : TestBox = new TestBox(0);

			var h : HGroup = new HGroup();
			h.add(s, _display, s2);
			h.layout(StageProxy.root);
			
			assertTrue(_display.contentRect, _display.contentRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.visibleRect, _display.visibleRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.position, _display.position.equals(new Point(10, 0)));
		}

		[Test]
		public function test_renderCallback() : void {
			_display.renderCallback = render;

			var s : TestBox = new TestBox(0);
			var s2 : TestBox = new TestBox(0);

			var h : HGroup = new HGroup();
			h.add(s, _display, s2);

			var result : Array = new Array();
			
			h.layout(StageProxy.root);
			
			assertTrue(_display.contentRect, _display.contentRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.visibleRect, _display.visibleRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.position, _display.position.equals(new Point(10, 0)));

			assertTrue(result, ArrayUtils.arraysEqual([_display.displayObject], result));
			
			function render(o : DisplayObject, x : int, y : int) : void {
				result.push(o);
			}
		}

		[Test]
		public function test_excludeFromLayout() : void {
			var s : TestBox = new TestBox(0);
			var s2 : TestBox = new TestBox(0);

			var h : HGroup = new HGroup();
			h.add(s, _display, s2);
			
			_display.excludeFromLayout();

			h.layout(StageProxy.root);
			
			assertTrue(_display.contentRect, _display.contentRect.equals(new Rectangle(0, 0, 0, 0)));
			assertTrue(_display.visibleRect, _display.visibleRect.equals(new Rectangle(0, 0, 0, 0)));
			assertTrue(_display.position, _display.position.equals(new Point(0, 0)));
		}

		[Test]
		public function test_callbacks() : void {
			_display.hideCallback = hide;
			_display.showCallback = show;
			_display.renderCallback = render;

			var s : TestBox = new TestBox(0);
			var s2 : TestBox = new TestBox(0);

			var h : HGroup = new HGroup();
			h.add(s, _display, s2);
			
			// exclude

			_display.excludeFromLayout();
			var resultHide : Array = new Array();
			var resultShow : Array = new Array();
			var resultRender : Array = new Array();
			
			h.layout(StageProxy.root);
			
			assertTrue(_display.contentRect, _display.contentRect.equals(new Rectangle(0, 0, 0, 0)));
			assertTrue(_display.visibleRect, _display.visibleRect.equals(new Rectangle(0, 0, 0, 0)));
			assertTrue(_display.position, _display.position.equals(new Point(0, 0)));

			assertTrue(resultHide, ArrayUtils.arraysEqual([_display.displayObject], resultHide));
			assertTrue(resultShow, ArrayUtils.arraysEqual([], resultShow));
			assertTrue(resultRender, ArrayUtils.arraysEqual([], resultRender));
			
			// include

			resultHide = new Array();
			resultShow = new Array();
			resultRender = new Array();

			_display.includeInLayout();

			h.layout(StageProxy.root);
			
			assertTrue(_display.contentRect, _display.contentRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.visibleRect, _display.visibleRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.position, _display.position.equals(new Point(10, 0)));

			assertTrue(resultHide, ArrayUtils.arraysEqual([], resultHide));
			assertTrue(resultShow, ArrayUtils.arraysEqual([_display.displayObject], resultShow));
			assertTrue(resultRender, ArrayUtils.arraysEqual([_display.displayObject], resultRender));
			
			// relayout

			resultHide = new Array();
			resultShow = new Array();
			resultRender = new Array();

			h.layout(StageProxy.root);
			
			assertTrue(_display.contentRect, _display.contentRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.visibleRect, _display.visibleRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.position, _display.position.equals(new Point(10, 0)));

			assertTrue(resultHide, ArrayUtils.arraysEqual([], resultHide));
			assertTrue(resultShow, ArrayUtils.arraysEqual([], resultShow));
			assertTrue(resultRender, ArrayUtils.arraysEqual([_display.displayObject], resultRender));
			
			// include again (yet included)

			resultHide = new Array();
			resultShow = new Array();
			resultRender = new Array();

			_display.includeInLayout();

			h.layout(StageProxy.root);
			
			assertTrue(_display.contentRect, _display.contentRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.visibleRect, _display.visibleRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.position, _display.position.equals(new Point(10, 0)));

			assertTrue(resultHide, ArrayUtils.arraysEqual([], resultHide));
			assertTrue(resultShow, ArrayUtils.arraysEqual([], resultShow));
			assertTrue(resultRender, ArrayUtils.arraysEqual([_display.displayObject], resultRender));
			
			// exclude again

			resultHide = new Array();
			resultShow = new Array();
			resultRender = new Array();

			_display.excludeFromLayout();

			h.layout(StageProxy.root);
			
			assertTrue(_display.contentRect, _display.contentRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.visibleRect, _display.visibleRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.position, _display.position.equals(new Point(10, 0)));

			assertTrue(resultHide, ArrayUtils.arraysEqual([_display.displayObject], resultHide));
			assertTrue(resultShow, ArrayUtils.arraysEqual([], resultShow));
			assertTrue(resultRender, ArrayUtils.arraysEqual([], resultRender));
			
			// add another in front and relayout

			var s3 : TestBox = new TestBox(0);
			h.addFirst(s3);
			h.layout(StageProxy.root);

			assertTrue(_display.contentRect, _display.contentRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.visibleRect, _display.visibleRect.equals(new Rectangle(10, 0, 10, 10)));
			assertTrue(_display.position, _display.position.equals(new Point(10, 0)));

			assertTrue(resultHide, ArrayUtils.arraysEqual([_display.displayObject], resultHide));
			assertTrue(resultShow, ArrayUtils.arraysEqual([], resultShow));
			assertTrue(resultRender, ArrayUtils.arraysEqual([], resultRender));

			function hide(o : DisplayObject) : void {
				resultHide.push(o);
			}

			function show(o : DisplayObject) : void {
				resultShow.push(o);
			}

			function render(o : DisplayObject, x : int, y : int) : void {
				resultRender.push(o);
			}

		}

	}
}
