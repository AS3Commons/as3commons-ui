package layer.placement.common {

	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.skins.ButtonSkin;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;
	import com.sibirjak.asdpcbeta.radiobutton.RadioButton;

	import org.as3commons.ui.layer.placement.PlacementRules;
	import org.as3commons.ui.layout.shortcut.hlayout;
	import org.as3commons.ui.layout.shortcut.vgroup;

	public class BoxControls extends ControlPanelBase {
		[Embed(source="assets/placement.png")]
		private var _placement : Class;
		[Embed(source="assets/placement_selected.png")]
		private var _placementSelected : Class;
		private var _box : Box;

		public function BoxControls(
			box : Box, labelText : String,
			anchorCallback : Function, sizeCallback : Function
		) {
			setSize(50, 140);
			_box = box;
			
			vgroup(
				"gap", 4,
				
				headline(labelText),
				
				sliderWithLabel({
					width: 46,
					minValue: 40,
					maxValue: 120,
					value: _box.width,
					snapInterval: 10,
					change: function(width : uint) : void {
						_box.width = width;
						sizeCallback();
					}
				}),
			
				sliderWithLabel({
					width: 46,
					minValue: 40,
					maxValue: 120,
					value: _box.height,
					snapInterval: 10,
					change: function(height : uint) : void {
						_box.height = height;
						sizeCallback();
					}
				}),
			
				hlayout(
					"maxItemsPerRow", 3,
					
					radioGroup(
						"placement",
						function(placement : uint) : void {
							anchorCallback(placement);
						}
					),
	
					anchorButton(PlacementRules.TOP_LEFT, true),
					anchorButton(PlacementRules.TOP, false),
					anchorButton(PlacementRules.TOP_RIGHT, true),
					anchorButton(PlacementRules.LEFT, true),
					anchorButton(PlacementRules.CENTER, true),
					anchorButton(PlacementRules.RIGHT, true),
					anchorButton(PlacementRules.BOTTOM_LEFT, true),
					anchorButton(PlacementRules.BOTTOM, true),
					anchorButton(PlacementRules.BOTTOM_RIGHT, true)
					
				)
			).layout(this);
		}

		private function anchorButton(value : uint, selected : Boolean) : RadioButton {
			var button : RadioButton = radioButton({
				group: "placement",
				value: value,
				selected: selected,
				diff: 0
			});
			button.setSize(16, 16);
			button.setStyles([
				Button.style.upSkin, ButtonSkin,

				Button.style.upIconSkin, _placement,
				Button.style.overIconSkin, _placement,
				Button.style.downIconSkin, _placement,
				Button.style.selectedUpIconSkin, _placementSelected,
				Button.style.selectedOverIconSkin, _placementSelected,
				Button.style.selectedDownIconSkin, _placementSelected,
				
				ButtonSkin.style_border, false,
				ButtonSkin.style_cornerRadius, 0
			]);

			button.setStyle(CheckBox.style_buttonWidth, button.width);
			button.setStyle(CheckBox.style_buttonHeight, button.height);

			return button;
		}
	}
}