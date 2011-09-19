package org.as3commons.ui.layout.framework.core.tests {

	import org.as3commons.collections.utils.ArrayUtils;
	import org.as3commons.ui.layout.Display;
	import org.as3commons.ui.layout.HGroup;
	import org.as3commons.ui.layout.framework.core.AbstractLayout;
	import org.as3commons.ui.layout.shortcut.display;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import org.as3commons.ui.layout.testhelper.LayoutValidator;
	import org.as3commons.ui.layout.testhelper.TestBox;
	import org.as3commons.ui.testhelper.TestDisplayObject;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Jens Struwe 19.09.2011
	 */
	public class AbstractLayoutTest {

		private var _layout : AbstractLayout;

		[Before]
		public function setUp() : void {
			_layout = new AbstractLayout();
		}

		[After]
		public function tearDown() : void {
			_layout = null;

			StageProxy.cleanUpRoot();
		}
		
		[Test]
		public function test_add() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			
			_layout.add(s);
			_layout.add(s2);
			_layout.add(s3);
			
			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItems([s, s2, s3], _layout));
		}

		[Test]
		public function test_addFirst() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			
			_layout.add(s);
			_layout.addFirst(s2);
			_layout.add(s3);
			_layout.addFirst(s4);
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItems([s4, s2, s, s3], _layout));
		}

		[Test]
		public function test_add_nested() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");

			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h : HGroup = hgroup(s4, s5, s6);
			
			_layout.add(s);
			_layout.add(s2);
			_layout.add(h);
			_layout.add(s3);
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
					h, s4, s5, s6,
				s3
			], _layout));
		}

		[Test]
		public function test_add_twice() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			
			_layout.add(s);
			_layout.add(s2);
			_layout.add(s);
			_layout.add(s2);
			
			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItems([s, s2], _layout));
		}

		[Test]
		public function test_add_twice2() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			
			_layout.add(s);
			_layout.add(s2);
			_layout.add(s2);
			_layout.add(s);
			
			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItems([s, s2], _layout));
		}

		[Test]
		public function test_add_args() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			
			_layout.add(s, s2, s3);
			
			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItems([s, s2, s3], _layout));
		}

		[Test]
		public function test_addFirst_args() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			
			_layout.add(s);
			_layout.addFirst(s2, s3);
			_layout.add(s4);
			_layout.addFirst(s5, s6);
			
			assertEquals(6, _layout.numItems);
			assertTrue(LayoutValidator.validateItems([s5, s6, s2, s3, s, s4], _layout));
		}

		[Test]
		public function test_add_args_array() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			
			_layout.add(s, [s2, s3]);
			
			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItems([s, s2, s3], _layout));
		}

		[Test]
		public function test_add_args_nested() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");

			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h : HGroup = hgroup(s4, s5, s6);
			
			_layout.add(s, s2, h, s3);
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItems([s, s2, h, s3], _layout));
		}

		[Test]
		public function test_add_args_nested2() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");

			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h : HGroup = hgroup(s4, s5, s6);
			
			_layout.add(s, s2, h, s3);
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
				h, s4, s5, s6,
				s3
			], _layout));
		}

		[Test]
		public function test_getLayoutItem() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			
			_layout.add(s, s2, s3);
			
			assertEquals(s, Display(_layout.getLayoutItem(s)).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem(s2)).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem(s3)).displayObject);
			assertNull(_layout.getLayoutItem(new Sprite()));
		}

		[Test]
		public function test_getLayoutItem_byId() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			
			_layout.add(
				display("id", "s_id", s),
				display("id", "s2_id", s2), 
				display("id", "s3_id", s3)
			);
			
			assertEquals(s, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);
			assertNull(_layout.getLayoutItem("s4_id"));
		}

		[Test]
		public function test_getLayoutItem_byId_nested() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h : HGroup = hgroup(
				display("id", "s4_id", s4),
				display("id", "s5_id", s5), 
				display("id", "s6_id", s6)
			);
			h.id = "h_id";

			_layout.add(
				display("id", "s_id", s),
				display("id", "s2_id", s2), 
				h,
				display("id", "s3_id", s3)
			);
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
				h, s4, s5, s6,
				s3
			], _layout));

			assertEquals(s, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);
			assertEquals(s5, Display(_layout.getLayoutItem("s5_id")).displayObject);
			assertEquals(s6, Display(_layout.getLayoutItem("s6_id")).displayObject);
			assertEquals(h, _layout.getLayoutItem("h_id"));
			assertNull(_layout.getLayoutItem("s7_id"));
		}

		[Test]
		public function test_getLayoutItem_byId_nested_selector() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			var h : HGroup = hgroup(
				display("id", "s_id", s),
				display("id", "s2_id", s2), 
				display("id", "s3_id", s3)
			);
			h.id = "h_id";
			
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h2 : HGroup = hgroup(
				display("id", "s4_id", s4),
				display("id", "s5_id", s5), 
				display("id", "s6_id", s6)
			);
			h2.id = "h2_id";

			_layout.add(
				h,
				h2
			);
			
			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				h, s, s2, s3,
				h2, s4, s5, s6
			], _layout));

			assertEquals(s, Display(_layout.getLayoutItem("h_id", "s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("h_id", "s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("h_id", "s3_id")).displayObject);
			assertEquals(h, _layout.getLayoutItem("h_id"));

			assertEquals(s4, Display(_layout.getLayoutItem("h2_id", "s4_id")).displayObject);
			assertEquals(s5, Display(_layout.getLayoutItem("h2_id", "s5_id")).displayObject);
			assertEquals(s6, Display(_layout.getLayoutItem("h2_id", "s6_id")).displayObject);
			assertEquals(h2, _layout.getLayoutItem("h2_id"));

			assertNull(_layout.getLayoutItem("h_id", "s4_id"));
			assertNull(_layout.getLayoutItem("h2_id", "s_id"));
			assertNull(_layout.getLayoutItem("s7_id"));
		}

		[Test]
		public function test_getLayoutItem_nested() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");

			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h : HGroup = hgroup(s4, s5, s6);
			
			_layout.add(s, s2, h, s3);
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
				h, s4, s5, s6,
				s3
			], _layout));
			
			assertEquals(s, Display(_layout.getLayoutItem(s)).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem(s2)).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem(s3)).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem(s4)).displayObject);
			assertEquals(s5, Display(_layout.getLayoutItem(s5)).displayObject);
			assertEquals(s6, Display(_layout.getLayoutItem(s6)).displayObject);
			assertEquals(h, _layout.getLayoutItem(h));

			assertNull(_layout.getLayoutItem(new Sprite()));
		}

		[Test]
		public function test_getLayoutItem_byId_nested_selector2() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			var h : HGroup = hgroup(
				display("id", "s_id", s),
				display("id", "s2_id", s2), 
				display("id", "s3_id", s3)
			);
			h.id = "h_id";
			
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h2 : HGroup = hgroup(
				display("id", "s_id", s4),
				display("id", "s2_id", s5), 
				display("id", "s3_id", s6)
			);
			h2.id = "h2_id";

			_layout.add(
				h,
				h2
			);
			
			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				h, s, s2, s3,
				h2, s4, s5, s6
			], _layout));

			assertEquals(s, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);

			assertEquals(s, Display(_layout.getLayoutItem("h_id", "s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("h_id", "s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("h_id", "s3_id")).displayObject);
			assertEquals(h, _layout.getLayoutItem("h_id"));

			assertEquals(s4, Display(_layout.getLayoutItem("h2_id", "s_id")).displayObject);
			assertEquals(s5, Display(_layout.getLayoutItem("h2_id", "s2_id")).displayObject);
			assertEquals(s6, Display(_layout.getLayoutItem("h2_id", "s3_id")).displayObject);
			assertEquals(h2, _layout.getLayoutItem("h2_id"));

			assertNull(_layout.getLayoutItem("h_id", "s4_id"));
			assertNull(_layout.getLayoutItem("h2_id", "s4_id"));
			assertNull(_layout.getLayoutItem("s7_id"));
		}

		[Test]
		public function test_getDisplayObject() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			
			_layout.add(s, s2, s3);
			
			assertEquals(s, _layout.getDisplayObject(s));
			assertEquals(s2, _layout.getDisplayObject(s2));
			assertEquals(s3, _layout.getDisplayObject(s3));
			assertNull(_layout.getDisplayObject(new Sprite()));
		}

		[Test]
		public function test_getDisplayObject_nested() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");

			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h : HGroup = hgroup(s4, s5, s6);
			
			_layout.add(s, s2, h, s3);
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
				h, s4, s5, s6,
				s3
			], _layout));
			
			assertEquals(s, _layout.getDisplayObject(s));
			assertEquals(s2, _layout.getDisplayObject(s2));
			assertEquals(s3, _layout.getDisplayObject(s3));
			assertEquals(s4, _layout.getDisplayObject(s4));
			assertEquals(s5, _layout.getDisplayObject(s5));
			assertEquals(s6, _layout.getDisplayObject(s6));

			assertNull(_layout.getDisplayObject(new Sprite()));
			assertNull(_layout.getDisplayObject(h));
		}

		[Test]
		public function test_remove() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			
			_layout.add(
				display("id", "s_id", s),
				display("id", "s2_id", s2), 
				display("id", "s3_id", s3),
				display("id", "s4_id", s4),
				display("id", "s5_id", s5)
			);
			
			assertEquals(5, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2, s3, s4, s5
			], _layout));

			_layout.remove(s);
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s2, s3, s4, s5
			], _layout));

			assertNull(_layout.getDisplayObject(s));
			assertNull(_layout.getDisplayObject("s_id"));
			assertNull(_layout.getLayoutItem(s));
			assertNull(_layout.getLayoutItem("s_id"));

			assertEquals(s2, _layout.getDisplayObject(s2));
			assertEquals(s2, _layout.getDisplayObject("s2_id"));
			assertEquals(s2, Display(_layout.getLayoutItem(s2)).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);

			assertEquals(s3, _layout.getDisplayObject(s3));
			assertEquals(s3, _layout.getDisplayObject("s3_id"));
			assertEquals(s3, Display(_layout.getLayoutItem(s3)).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);

			assertEquals(s4, _layout.getDisplayObject(s4));
			assertEquals(s4, _layout.getDisplayObject("s4_id"));
			assertEquals(s4, Display(_layout.getLayoutItem(s4)).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);

			assertEquals(s5, _layout.getDisplayObject(s5));
			assertEquals(s5, _layout.getDisplayObject("s5_id"));
			assertEquals(s5, Display(_layout.getLayoutItem(s5)).displayObject);
			assertEquals(s5, Display(_layout.getLayoutItem("s5_id")).displayObject);

			_layout.remove(s5);
			
			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s2, s3, s4
			], _layout));

			assertNull(_layout.getDisplayObject(s));
			assertNull(_layout.getDisplayObject("s_id"));
			assertNull(_layout.getLayoutItem(s));
			assertNull(_layout.getLayoutItem("s_id"));

			assertEquals(s2, _layout.getDisplayObject(s2));
			assertEquals(s2, _layout.getDisplayObject("s2_id"));
			assertEquals(s2, Display(_layout.getLayoutItem(s2)).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);

			assertEquals(s3, _layout.getDisplayObject(s3));
			assertEquals(s3, _layout.getDisplayObject("s3_id"));
			assertEquals(s3, Display(_layout.getLayoutItem(s3)).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);

			assertEquals(s4, _layout.getDisplayObject(s4));
			assertEquals(s4, _layout.getDisplayObject("s4_id"));
			assertEquals(s4, Display(_layout.getLayoutItem(s4)).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);

			assertNull(_layout.getDisplayObject(s5));
			assertNull(_layout.getDisplayObject("s5_id"));
			assertNull(_layout.getLayoutItem(s5));
			assertNull(_layout.getLayoutItem("s5_id"));

			_layout.remove(s3);
			
			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s2, s4
			], _layout));

			assertNull(_layout.getDisplayObject(s));
			assertNull(_layout.getDisplayObject("s_id"));
			assertNull(_layout.getLayoutItem(s));
			assertNull(_layout.getLayoutItem("s_id"));

			assertEquals(s2, _layout.getDisplayObject(s2));
			assertEquals(s2, _layout.getDisplayObject("s2_id"));
			assertEquals(s2, Display(_layout.getLayoutItem(s2)).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);

			assertNull(_layout.getDisplayObject(s3));
			assertNull(_layout.getDisplayObject("s3_id"));
			assertNull(_layout.getLayoutItem(s3));
			assertNull(_layout.getLayoutItem("s3_id"));

			assertEquals(s4, _layout.getDisplayObject(s4));
			assertEquals(s4, _layout.getDisplayObject("s4_id"));
			assertEquals(s4, Display(_layout.getLayoutItem(s4)).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);

			assertNull(_layout.getDisplayObject(s5));
			assertNull(_layout.getDisplayObject("s5_id"));
			assertNull(_layout.getLayoutItem(s5));
			assertNull(_layout.getLayoutItem("s5_id"));
		}

		[Test]
		public function test_remove_wrong() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			
			_layout.add(
				display("id", "s_id", s),
				display("id", "s2_id", s2), 
				display("id", "s3_id", s3)
			);
			
			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2, s3
			], _layout));

			_layout.remove(new Sprite());

			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2, s3
			], _layout));

			_layout.remove("s4_id");

			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2, s3
			], _layout));
		}
			
		[Test]
		public function test_remove_byId() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			
			_layout.add(
				display("id", "s_id", s),
				display("id", "s2_id", s2), 
				display("id", "s3_id", s3),
				display("id", "s4_id", s4),
				display("id", "s5_id", s5)
			);
			
			assertEquals(5, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2, s3, s4, s5
			], _layout));

			_layout.remove("s_id");
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s2, s3, s4, s5
			], _layout));

			assertNull(_layout.getDisplayObject(s));
			assertNull(_layout.getDisplayObject("s_id"));
			assertNull(_layout.getLayoutItem(s));
			assertNull(_layout.getLayoutItem("s_id"));

			assertEquals(s2, _layout.getDisplayObject(s2));
			assertEquals(s2, _layout.getDisplayObject("s2_id"));
			assertEquals(s2, Display(_layout.getLayoutItem(s2)).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);

			assertEquals(s3, _layout.getDisplayObject(s3));
			assertEquals(s3, _layout.getDisplayObject("s3_id"));
			assertEquals(s3, Display(_layout.getLayoutItem(s3)).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);

			assertEquals(s4, _layout.getDisplayObject(s4));
			assertEquals(s4, _layout.getDisplayObject("s4_id"));
			assertEquals(s4, Display(_layout.getLayoutItem(s4)).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);

			assertEquals(s5, _layout.getDisplayObject(s5));
			assertEquals(s5, _layout.getDisplayObject("s5_id"));
			assertEquals(s5, Display(_layout.getLayoutItem(s5)).displayObject);
			assertEquals(s5, Display(_layout.getLayoutItem("s5_id")).displayObject);

			_layout.remove("s5_id");
			
			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s2, s3, s4
			], _layout));

			assertNull(_layout.getDisplayObject(s));
			assertNull(_layout.getDisplayObject("s_id"));
			assertNull(_layout.getLayoutItem(s));
			assertNull(_layout.getLayoutItem("s_id"));

			assertEquals(s2, _layout.getDisplayObject(s2));
			assertEquals(s2, _layout.getDisplayObject("s2_id"));
			assertEquals(s2, Display(_layout.getLayoutItem(s2)).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);

			assertEquals(s3, _layout.getDisplayObject(s3));
			assertEquals(s3, _layout.getDisplayObject("s3_id"));
			assertEquals(s3, Display(_layout.getLayoutItem(s3)).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);

			assertEquals(s4, _layout.getDisplayObject(s4));
			assertEquals(s4, _layout.getDisplayObject("s4_id"));
			assertEquals(s4, Display(_layout.getLayoutItem(s4)).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);

			assertNull(_layout.getDisplayObject(s5));
			assertNull(_layout.getDisplayObject("s5_id"));
			assertNull(_layout.getLayoutItem(s5));
			assertNull(_layout.getLayoutItem("s5_id"));

			_layout.remove("s3_id");
			
			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s2, s4
			], _layout));

			assertNull(_layout.getDisplayObject(s));
			assertNull(_layout.getDisplayObject("s_id"));
			assertNull(_layout.getLayoutItem(s));
			assertNull(_layout.getLayoutItem("s_id"));

			assertEquals(s2, _layout.getDisplayObject(s2));
			assertEquals(s2, _layout.getDisplayObject("s2_id"));
			assertEquals(s2, Display(_layout.getLayoutItem(s2)).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);

			assertNull(_layout.getDisplayObject(s3));
			assertNull(_layout.getDisplayObject("s3_id"));
			assertNull(_layout.getLayoutItem(s3));
			assertNull(_layout.getLayoutItem("s3_id"));

			assertEquals(s4, _layout.getDisplayObject(s4));
			assertEquals(s4, _layout.getDisplayObject("s4_id"));
			assertEquals(s4, Display(_layout.getLayoutItem(s4)).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);

			assertNull(_layout.getDisplayObject(s5));
			assertNull(_layout.getDisplayObject("s5_id"));
			assertNull(_layout.getLayoutItem(s5));
			assertNull(_layout.getLayoutItem("s5_id"));
		}

		[Test]
		public function test_remove_nested() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h : HGroup = hgroup(
				display("id", "s4_id", s4),
				display("id", "s5_id", s5), 
				display("id", "s6_id", s6)
			);
			h.id = "h_id";

			_layout.add(
				display("id", "s_id", s),
				display("id", "s2_id", s2), 
				h,
				display("id", "s3_id", s3)
			);
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
				h, s4, s5, s6,
				s3
			], _layout));

			assertEquals(s, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);
			assertEquals(s5, Display(_layout.getLayoutItem("s5_id")).displayObject);
			assertEquals(s6, Display(_layout.getLayoutItem("s6_id")).displayObject);
			
			// nothing happens to later children
			_layout.remove(s4);
			_layout.remove(s5);
			_layout.remove(s6);

			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
				h, s4, s5, s6,
				s3
			], _layout));

			assertEquals(s, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);
			assertEquals(s5, Display(_layout.getLayoutItem("s5_id")).displayObject);
			assertEquals(s6, Display(_layout.getLayoutItem("s6_id")).displayObject);

			h.remove(s4);

			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
				h, s5, s6,
				s3
			], _layout));

			assertNull(_layout.getDisplayObject(s4));
			assertNull(_layout.getDisplayObject("s4_id"));
			assertNull(_layout.getLayoutItem(s4));
			assertNull(_layout.getLayoutItem("s4_id"));

			_layout.remove(h);

			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2, s3
			], _layout));

			assertEquals(s, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);

			assertNull(_layout.getLayoutItem(h));
			assertNull(_layout.getLayoutItem("h_id"));

			assertNull(_layout.getDisplayObject(s5));
			assertNull(_layout.getDisplayObject("s5_id"));
			assertNull(_layout.getLayoutItem(s5));
			assertNull(_layout.getLayoutItem("s5_id"));

			assertNull(_layout.getDisplayObject(s6));
			assertNull(_layout.getDisplayObject("s6_id"));
			assertNull(_layout.getLayoutItem(s6));
			assertNull(_layout.getLayoutItem("s6_id"));
		}

		[Test]
		public function test_remove_byId_nested() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h : HGroup = hgroup(
				display("id", "s4_id", s4),
				display("id", "s5_id", s5), 
				display("id", "s6_id", s6)
			);
			h.id = "h_id";

			_layout.add(
				display("id", "s_id", s),
				display("id", "s2_id", s2), 
				h,
				display("id", "s3_id", s3)
			);
			
			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
				h, s4, s5, s6,
				s3
			], _layout));

			assertEquals(s, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);
			assertEquals(s5, Display(_layout.getLayoutItem("s5_id")).displayObject);
			assertEquals(s6, Display(_layout.getLayoutItem("s6_id")).displayObject);
			
			// nothing happens to later children
			_layout.remove("s4_id");
			_layout.remove("s5_id");
			_layout.remove("s6_id");

			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
				h, s4, s5, s6,
				s3
			], _layout));

			assertEquals(s, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);
			assertEquals(s4, Display(_layout.getLayoutItem("s4_id")).displayObject);
			assertEquals(s5, Display(_layout.getLayoutItem("s5_id")).displayObject);
			assertEquals(s6, Display(_layout.getLayoutItem("s6_id")).displayObject);

			h.remove("s4_id");

			assertEquals(4, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2,
				h, s5, s6,
				s3
			], _layout));

			assertNull(_layout.getDisplayObject(s4));
			assertNull(_layout.getDisplayObject("s4_id"));
			assertNull(_layout.getLayoutItem(s4));
			assertNull(_layout.getLayoutItem("s4_id"));

			_layout.remove("h_id");

			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				s, s2, s3
			], _layout));

			assertEquals(s, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);

			assertNull(_layout.getLayoutItem(h));
			assertNull(_layout.getLayoutItem("h_id"));

			assertNull(_layout.getDisplayObject(s5));
			assertNull(_layout.getDisplayObject("s5_id"));
			assertNull(_layout.getLayoutItem(s5));
			assertNull(_layout.getLayoutItem("s5_id"));

			assertNull(_layout.getDisplayObject(s6));
			assertNull(_layout.getDisplayObject("s6_id"));
			assertNull(_layout.getLayoutItem(s6));
			assertNull(_layout.getLayoutItem("s6_id"));
		}

		[Test]
		public function test_remove_byId_nested2() : void {
			var s : TestDisplayObject = new TestDisplayObject("s");
			var s2 : TestDisplayObject = new TestDisplayObject("s2");
			var s3 : TestDisplayObject = new TestDisplayObject("s3");
			var h : HGroup = hgroup(
				display("id", "s_id", s),
				display("id", "s2_id", s2), 
				display("id", "s3_id", s3)
			);
			h.id = "h_id";
			
			var s4 : TestDisplayObject = new TestDisplayObject("s4");
			var s5 : TestDisplayObject = new TestDisplayObject("s5");
			var s6 : TestDisplayObject = new TestDisplayObject("s6");
			var h2 : HGroup = hgroup(
				display("id", "s_id", s4),
				display("id", "s2_id", s5), 
				display("id", "s3_id", s6)
			);
			h2.id = "h2_id";

			_layout.add(
				h,
				h2
			);
			
			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				h, s, s2, s3,
				h2, s4, s5, s6
			], _layout));

			assertEquals(s, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);
			
			// nothing happens to later children
			h.remove("s_id");

			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				h, s2, s3,
				h2, s4, s5, s6
			], _layout));

			assertEquals(s4, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s3, Display(_layout.getLayoutItem("s3_id")).displayObject);

			h.remove("s3_id");

			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				h, s2,
				h2, s4, s5, s6
			], _layout));

			assertEquals(s4, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertEquals(s6, Display(_layout.getLayoutItem("s3_id")).displayObject);

			h2.remove("s3_id");

			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				h, s2,
				h2, s4, s5
			], _layout));

			assertEquals(s4, Display(_layout.getLayoutItem("s_id")).displayObject);
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertNull(_layout.getLayoutItem("s3_id"));

			h2.remove("s_id");

			assertEquals(2, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				h, s2,
				h2, s5
			], _layout));

			assertNull(_layout.getLayoutItem("s_id"));
			assertEquals(s2, Display(_layout.getLayoutItem("s2_id")).displayObject);
			assertNull(_layout.getLayoutItem("s3_id"));

			_layout.remove("h_id");

			assertEquals(1, _layout.numItems);
			assertTrue(LayoutValidator.validateItemsRecursively([
				h2, s5
			], _layout));

			assertEquals(s5, Display(_layout.getLayoutItem("s2_id")).displayObject);

		}
		
		[Test]
		public function test_renderCallback() : void {
			_layout = new HGroup();
			_layout.renderCallback = render;
			
			var s : TestBox = new TestBox(0);
			var s2 : TestBox = new TestBox(0);
			var s3 : TestBox = new TestBox(0);
			_layout.add(s, s2, s3);
			
			assertEquals(3, _layout.numItems);
			assertTrue(LayoutValidator.validateItems([s, s2, s3], _layout));

			var result : Array = new Array();
			
			_layout.layout(StageProxy.root);
			
			assertTrue(result, ArrayUtils.arraysEqual([s, s2, s3], result));
			
			function render(o : DisplayObject, x : int, y : int) : void {
				result.push(o);
			}
		}

		[Test]
		public function test_renderCallback_nested() : void {
			_layout = new HGroup();
			_layout.renderCallback = render;

			var s : TestBox = new TestBox(0);
			var s2 : TestBox = new TestBox(0);
			var s3 : TestBox = new TestBox(0);

			var s4 : TestBox = new TestBox(0);
			var s5 : TestBox = new TestBox(0);
			var s6 : TestBox = new TestBox(0);
			var h : HGroup = hgroup(s4, s5, s6);
			
			_layout.add(s);
			_layout.add(s2);
			_layout.add(h);
			_layout.add(s3);
			
			var result : Array = new Array();
			
			_layout.layout(StageProxy.root);

			assertTrue(ArrayUtils.arraysEqual([s, s2, s4, s5, s6, s3], result));
			
			function render(o : DisplayObject, x : int, y : int) : void {
				result.push(o);
			}
		}

		[Test]
		public function test_renderCallback_nested_relayout() : void {
			_layout = new HGroup();
			_layout.renderCallback = render;

			var s : TestBox = new TestBox(0);
			var s2 : TestBox = new TestBox(0);
			var s3 : TestBox = new TestBox(0);

			var s4 : TestBox = new TestBox(0);
			var s5 : TestBox = new TestBox(0);
			var s6 : TestBox = new TestBox(0);
			var h : HGroup = hgroup(s4, s5, s6);
			
			_layout.add(s);
			_layout.add(s2);
			_layout.add(h);
			_layout.add(s3);
			
			var result : Array = new Array();

			_layout.layout(StageProxy.root);
			
			result = new Array(); // clean up
			
			_layout.layout(StageProxy.root, true);
			
			assertTrue(ArrayUtils.arraysEqual([s, s2, s4, s5, s6, s3], result));
			
			function render(o : DisplayObject, x : int, y : int) : void {
				result.push(o);
			}
		}

		[Test]
		public function test_renderCallback_nested_relayout_inheritance() : void {
			_layout = new HGroup();
			_layout.renderCallback = render;

			var s : TestBox = new TestBox(0);
			var s2 : TestBox = new TestBox(0);
			var s3 : TestBox = new TestBox(0);

			var s4 : TestBox = new TestBox(0);
			var s5 : TestBox = new TestBox(0);
			var s6 : TestBox = new TestBox(0);
			var h : HGroup = hgroup(s4, s5, s6);
			
			_layout.add(s);
			_layout.add(s2);
			_layout.add(h);
			_layout.add(s3);
			
			var result : Array = new Array();

			_layout.layout(StageProxy.root);
			
			result = new Array(); // clean up
			
			h.layout(StageProxy.root, true);
			
			assertTrue(ArrayUtils.arraysEqual([s4, s5, s6], result));
			
			function render(o : DisplayObject, x : int, y : int) : void {
				result.push(o);
			}
		}

		[Test]
		public function test_relayout_nested() : void {
			_layout = new HGroup();

			var s : TestBox = new TestBox(0);
			var s2 : TestBox = new TestBox(0);
			var s3 : TestBox = new TestBox(0);

			var s4 : TestBox = new TestBox(0);
			var s5 : TestBox = new TestBox(0);
			var s6 : TestBox = new TestBox(0);
			var h : HGroup = hgroup(s4, s5, s6);
			
			_layout.add(s);
			_layout.add(s2);
			_layout.add(h);
			_layout.add(s3);
			
			_layout.layout(StageProxy.root);

			assertTrue(h.contentRect.equals(new Rectangle(20, 0, 30, 10)));
			assertTrue(h.visibleRect.equals(new Rectangle(20, 0, 30, 10)));
			assertTrue(h.position.equals(new Point(20, 0)));

			h.layout(StageProxy.root, true);

			assertTrue(h.contentRect.equals(new Rectangle(20, 0, 30, 10)));
			assertTrue(h.visibleRect.equals(new Rectangle(20, 0, 30, 10)));
			assertTrue(h.position.equals(new Point(20, 0)));

			h.layout(StageProxy.root);

			assertTrue(h.contentRect.equals(new Rectangle(0, 0, 30, 10)));
			assertTrue(h.visibleRect.equals(new Rectangle(0, 0, 30, 10)));
			assertTrue(h.position.equals(new Point(0, 0)));
		}

	}
}
