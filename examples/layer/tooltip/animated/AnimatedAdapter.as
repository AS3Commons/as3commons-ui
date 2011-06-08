package layer.tooltip.animated {
	import layer.tooltip.common.SimpleToolTip;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Cubic;
	import org.as3commons.ui.layer.tooltip.ToolTipAdapter;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class AnimatedAdapter extends ToolTipAdapter {
		private var _tween : GTween;
		private var _delay : uint;
		
		override protected function onToolTip(toolTip : DisplayObject) : void {
			offset = new Point(-5, 5);
			autoHideAfter = 2000;

			_tween = new GTween();
			_tween.target = toolTip;
			_tween.duration = .2;
			_tween.ease = Cubic.easeOut;
			_tween.paused = true;

			toolTip.alpha = 0;
		}

		override protected function onContent(toolTip : DisplayObject, content : *) : void {
			SimpleToolTip(toolTip).text = content;
		}

		override protected function onShow(toolTip : DisplayObject, local : Point) : void {
			SimpleToolTip(toolTip).x = local.x;
			SimpleToolTip(toolTip).y = local.y;
			
			pauseTweens();

			if (toolTip.alpha == 1) {
				startAutoHide();
			} else if (toolTip.alpha == 0) {
				_delay = setTimeout(showTween, 500);
			} else {
				showTween();
			}
		}
		
		override protected function onRemove(toolTip : DisplayObject) : void {
			pauseTweens();
			
			if (toolTip.alpha == 0) {
				commitRemove();
			} else if (toolTip.alpha == 1) {
				_delay = setTimeout(hideTween, 100);
			} else {
				hideTween();
			}
		}
		
		private function showTween() : void {
			_tween.duration = (1 - _layer.alpha) * .2;
			_tween.setValue("alpha", 1);
			_tween.onComplete = function(tween : GTween) : void {
				startAutoHide();
			};
		}

		private function hideTween() : void {
			_tween.duration = (_layer.alpha) * .4;
			_tween.setValue("alpha", 0);
			_tween.onComplete = function(tween : GTween) : void {
				commitRemove();
			};
		}
		
		private function pauseTweens() : void {
			clearTimeout(_delay);
			_tween.paused = true;
			_tween.onComplete = null;
		}
	}
}