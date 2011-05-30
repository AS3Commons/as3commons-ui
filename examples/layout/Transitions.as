package layout {
	import layout.common.box.Box;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	import org.as3commons.ui.layout.HGroup;
	import org.as3commons.ui.layout.shortcut.*;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	public class Transitions extends ControlPanelBase {
		private var _layout : HGroup;
		private var _tweens : Dictionary;
		
		public function Transitions() {
			_tweens = new Dictionary();
			
			_layout = hgroup(
				"gap", 20,
				vgroup(
					"gap", 5,
					hgroup(
						Box.create(6)
					),
					hgroup(
						"id", "row2",
						Box.create(6)
					),
					hgroup(
						"id", "row3",
						Box.create(6)
					)
				),
				
				checkBox({
					label: "show",
					selectedlabel: "hide",
					selected: true,
					change: includeExclude
				})
			);
			_layout.layout(this);
			
			_layout.getLayoutItem("row2").showCallback = showRow2;
			_layout.getLayoutItem("row2").hideCallback = hideRow2;
		}
		
		private function includeExclude(selected : Boolean) : void {
			if (selected) {
				_layout.getLayoutItem("row2").includeInLayout();
				_layout.getLayoutItem("row3").renderCallback = row3MoveDown;
			} else {
				_layout.getLayoutItem("row2").excludeFromLayout();
				_layout.getLayoutItem("row3").renderCallback = row3MoveUp;
			}
			_layout.layout(this);
		}
		
		private function hideRow2(o : DisplayObject) : void {
			tween(o, {alpha: 0});
		}

		private function showRow2(o : DisplayObject) : void {
			tween(o, {alpha: 1}, .3);
		}

		private function row3MoveDown(o : DisplayObject, x : int, y : int) : void {
			tween(o, {"x": x, "y": y});
		}

		private function row3MoveUp(o : DisplayObject, x : int, y : int) : void {
			tween(o, {"x": x, "y": y}, .3);
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