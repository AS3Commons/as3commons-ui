package layer.placement.common {
	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;
	import com.sibirjak.asdpcbeta.radiobutton.RadioButton;
	import org.as3commons.ui.layer.placement.PlacementAnchor;
	import org.as3commons.ui.layout.VGroup;
	import org.as3commons.ui.layout.shortcut.hlayout;
	import org.as3commons.ui.layout.shortcut.vgroup;
	import flash.events.Event;

	public class BoxAnchorControls extends ControlPanelBase {
		[Embed(source="assets/placement.png")]
		private var _placement : Class;
		[Embed(source="assets/placement_selected.png")]
		private var _placementSelected : Class;

		public function BoxAnchorControls() {
			var v : VGroup = vgroup(
				"gap", 4,
				hlayout(
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
				)
			);
			v.layout(this);
			setSize(v.visibleRect.width, v.visibleRect.height);
		}
		
		public function get placementAnchor() : uint {
			return getRadioGroup("placement").selectedValue;
		}

		private function anchorButton(value : uint) : RadioButton {
			var radio : RadioButton = radioButton({
				group: "placement",
				value: value,
				selected: value == PlacementAnchor.TOP_LEFT,
				diff: 0
			});
			radio.setSize(16, 16);
			radio.setStyles([
				Button.style.upSkin, ButtonSkin,
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