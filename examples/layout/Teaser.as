package layout {

	import layout.common.box.Box;

	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;

	import org.as3commons.ui.layout.HGroup;
	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.shortcut.cellconfig;
	import org.as3commons.ui.layout.shortcut.dyntable;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import org.as3commons.ui.layout.shortcut.hlayout;
	import org.as3commons.ui.layout.shortcut.table;
	import org.as3commons.ui.layout.shortcut.vgroup;
	import org.as3commons.ui.layout.shortcut.vlayout;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	public class Teaser extends ControlPanelBase {
		
		private var _container : Sprite;
		private var _tweens : Dictionary;
		
		public function Teaser() {
			_tweens = new Dictionary();
			_container = new Sprite();
			_container.visible = false;
			for (var i : uint; i < 54; i++) {
				_container.addChild(new Box(true, 20, 40));
			}
			addChild(_container);
			
			var mask : Sprite = new Sprite();
			with (mask.graphics) {
				beginFill(0);
				drawRect(0, 0, 500, 280);
			}
			addChild(mask);
			
			_container.mask = mask;
			
			var h : HGroup = hgroup(
				radioGroup("layouts", layoutChange),
				
				radioButton({
					diff: -10,
					group: "layouts",
					value: hgroup("gap", 3, "vAlign", "middle"),
					label: "HGroup"
				}),
			
				radioButton({
					diff: -6,
					group: "layouts",
					value: hlayout("maxContentWidth", 500, "hGap", 3, "vGap", 3, "vAlign", "middle"),
					selected: true,
					label: "HLayout"
				}),
			
				radioButton({
					diff: -10,
					group: "layouts",
					value: vgroup("gap", 3, "hAlign", "center"),
					label: "VGroup"
				}),
			
				radioButton({
					diff: -6,
					group: "layouts",
					value: vlayout("maxContentHeight", 250, "hGap", 3, "vGap", 3, "hAlign", "center"),
					label: "VLayout"
				}),
			
				radioButton({
					diff: -16,
					group: "layouts",
					value: table(
						"numColumns", 10, "hGap", 3, "vGap", 3,
						cellconfig("hAlign", "center", "vAlign", "middle")
					),
					label: "Table"
				}),
			
				radioButton({
					diff: -6,
					group: "layouts",
					value: dyntable(
						"maxContentWidth", 500, "hGap", 3, "vGap", 3,
						cellconfig("hAlign", "center", "vAlign", "middle")
					),
					label: "DynTable"
				})

			);
			
			
			h.layout(this);
		}
		
		private function layoutChange(l : ILayout) : void {
			_container.visible = true;
			l.marginY = 30;
			l.renderCallback = renderCallback;
			l.addAll(_container);
			l.layout(_container);
		}

		private function renderCallback(o : DisplayObject, x : int, y : int) : void {
			tween(o, {"x": x, "y": y});
		}

		private function tween(o : DisplayObject, v : Object, d : Number = 0) : void {
			var tween : GTween = getTween(o);
			tween.delay = d;
			tween.setValues(v);
		}

		private function getTween(o : DisplayObject) : GTween {
			var tween : GTween = _tweens[o];
			if (!tween) {
				tween = new GTween();
				tween.ease = Sine.easeOut;
				tween.target = o;
				tween.duration = .2;
				tween.onComplete = function(tween : GTween) : void {
					delete _tweens[tween.target];
				};
				_tweens[o] = tween;
			}
			return tween;
		}
	}
}
