package layer.placement.common {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;
	import com.sibirjak.asdpcbeta.radiobutton.RadioButton;
	import common.ControlPanelBase;
	import flash.events.Event;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layout.HLayout;
	import org.as3commons.ui.layout.shortcut.hlayout;

	public class BoxAnchorControls extends ControlPanelBase {
		[Embed(source="assets/placement.png")]
		private var _placement : Class;
		[Embed(source="assets/placement_selected.png")]
		private var _placementSelected : Class;
		private var _buttonSize : uint = 18;
		private var _defaultAnchor : uint;

		public function BoxAnchorControls(color : uint, alpha : Number, anchor : uint) {
			_defaultAnchor = anchor;
			
			var h : HLayout = hlayout(
				"maxItemsPerRow", 3,
				radioGroup(
					"placement",
					function(placementAnchor : uint) : void {
						dispatchEvent(new Event("anchor", true));
					}
				),
				anchorButton(PlacementAnchor.TOP_LEFT),
				anchorButton(PlacementAnchor.TOP),
				anchorButton(PlacementAnchor.TOP_RIGHT),
				anchorButton(PlacementAnchor.LEFT),
				anchorButton(PlacementAnchor.CENTER),
				anchorButton(PlacementAnchor.RIGHT),
				anchorButton(PlacementAnchor.BOTTOM_LEFT),
				anchorButton(PlacementAnchor.BOTTOM),
				anchorButton(PlacementAnchor.BOTTOM_RIGHT)
			);
			h.layout(this);
			setSize(h.visibleRect.width, h.visibleRect.height);

			with (graphics) {
				beginFill(color, alpha);
				drawRect(_buttonSize/2, _buttonSize/2, _width - _buttonSize, _height - _buttonSize);
			}
		}
		
		public function get placementAnchor() : uint {
			return getRadioGroup("placement").selectedValue;
		}

		private function anchorButton(value : uint) : RadioButton {
			var radio : RadioButton = radioButton({
				group: "placement",
				value: value,
				selected: value == _defaultAnchor,
				diff: 0
			});
			radio.setSize(_buttonSize, _buttonSize);
			radio.setStyles([
				Button.style.upSkin, null,
				Button.style.upIconSkin, _placement,
				Button.style.overIconSkin, _placement,
				Button.style.downIconSkin, _placement,
				Button.style.selectedUpIconSkin, _placementSelected,
				Button.style.selectedOverIconSkin, _placementSelected,
				Button.style.selectedDownIconSkin, _placementSelected,
				
				ButtonSkin.style_border, false,
				ButtonSkin.style_cornerRadius, 0,
				
				CheckBox.style_buttonWidth, radio.width,
				CheckBox.style_buttonHeight, radio.height
			]);
			return radio;
		}
	}
}