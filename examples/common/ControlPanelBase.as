package common{

	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.core.managers.StageProxy;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.textfield.TextInput;
	import com.sibirjak.asdpc.textfield.TextInputEvent;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;
	import com.sibirjak.asdpcbeta.colorpicker.ColorPicker;
	import com.sibirjak.asdpcbeta.radiobutton.RadioButton;
	import com.sibirjak.asdpcbeta.radiobutton.RadioGroup;
	import com.sibirjak.asdpcbeta.slider.Slider;
	import com.sibirjak.asdpcbeta.window.Window;

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.ui.layout.HGroup;
	import org.as3commons.ui.layout.shortcut.display;
	import org.as3commons.ui.layout.shortcut.hgroup;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ControlPanelBase extends View {
		protected var _radioGroups : LinkedMap;
		private const LABEL_SIZE : uint = 80;

		public function ControlPanelBase() {
			if (parent && parent is Stage) {
				com.sibirjak.asdpc.core.managers.StageProxy.stage = parent as Stage;
			}

			_radioGroups = new LinkedMap();
		}

		/*
		 * View life cycle
		 */
		override protected function initialised() : void {
			// create radiogroups

			var iterator : IIterator = _radioGroups.iterator() as IIterator;
			var radioGroupEntry : Array;
			while (iterator.hasNext()) {
				radioGroupEntry = iterator.next();
				RadioGroup(radioGroupEntry[0]).setButtons(radioGroupEntry[1]);
			}
		}

		/*
		 * Protected
		 */
		protected function getRadioGroup(name : String) : RadioGroup {
			return _radioGroups.itemFor(name)[0];
		}

		protected function colorPicker(properties : Object) : ColorPicker {
			var colorPicker : ColorPicker = new ColorPicker();
			colorPicker.setSize(16, 16);
			colorPicker.selectedColor = properties["color"];
			colorPicker.toolTip = properties["tip"];

			colorPicker.bindProperty(ColorPicker.BINDABLE_PROPERTY_SELECTED_COLOR, properties["change"]);

			return colorPicker;
		}

		protected function headline(labelText : String, diff : int = 0) : Label {
			var label : Label = new Label();
			label.setSize(_width + diff, 18);
			label.text = labelText.toUpperCase();
			label.setStyle(Label.style.bold, true);
			label.setStyle(Label.style.size, 11);
			return label;
		}

		protected function labelButton(properties : Object) : Button {
			if (!properties.hasOwnProperty("w")) properties["w"] = 60;
			if (!properties.hasOwnProperty("h")) properties["h"] = 20;
			return button(properties);
		}

		protected function  button(properties : Object) : Button {
			var button : Button = new Button();
			
			var bWidth : uint = properties["w"] ? properties["w"] : 14;
			var bHeight : uint = properties["h"] ? properties["h"] : 14;
			
			button.autoRepeat = properties["autorepeat"];
			
			button.setSize(bWidth, bHeight);
			button.toggle = properties["toggle"];
			button.selected = properties["selected"];
			button.label = properties["label"]; // label = properties causes confusion with this.label()
			button.selectedLabel = properties["selectedlabel"]; // label = properties causes confusion with this.label()
			if (properties["iconSkin"]) {
				button.setStyles([
					Button.style.upIconSkin, properties["iconSkin"],
					Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.selectedUpIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.selectedOverIconSkinName, Button.UP_ICON_SKIN_NAME,
					Button.style.selectedDownIconSkinName, Button.UP_ICON_SKIN_NAME
				]);
			}
			button.toolTip = properties["tip"];
			button.selectedToolTip = properties["selectedTip"];

			if (properties["change"]) button.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, properties["change"]);

			if (properties["click"]) {
				var callBack : Function = properties["click"];
				if (properties["autorepeat"]) {
					button.addEventListener(ButtonEvent.MOUSE_DOWN, function(event : ButtonEvent) : void {
						callBack();
					});
				} else {
					button.addEventListener(ButtonEvent.CLICK, function(event : ButtonEvent) : void {
						callBack();
					});
				}
			}
			
			if (properties["visible"] === false) button.visible = false;
			if (properties["enabled"] === false) button.enabled = false;

			return button;
		}

		protected function textInput(properties : Object) : TextInput {
			var textInput : TextInput = new TextInput();

			textInput.setSize(LABEL_SIZE + properties["diff"], 18);
			textInput.text = properties["text"];

			textInput.setStyles([Label.style.verticalAlign, Position.MIDDLE, Label.style.size, 10, TextInput.style.maxChars, 0 + properties["maxchars"]]);

			textInput.addEventListener(TextInputEvent.CHANGED, function(event : Event) : void {
				properties["change"](textInput.text);
			});

			return textInput;
		}

		protected function label(labelText : String, diff : int = 0, id : String = "", background : Boolean = false) : Label {
			var label : Label = new Label();
			label.setSize(LABEL_SIZE + diff, 18);
			label.text = labelText;

			label.setStyles([Label.style.verticalAlign, Position.MIDDLE, Label.style.size, 10]);

			if (background) {
				label.setStyles([Label.style.background, true, Label.style.backgroundColor, 0xFFFFFF]);
			}

			return label;
		}

		protected function sliderWithLabel(properties : Object) : HGroup {
			if (!properties["labeldiff"]) properties["labeldiff"] = 0;

			var label : Label = new Label();
			label.setSize(25 + properties["labeldiff"], 18);
			label.setStyle(Label.style.verticalAlign, Position.MIDDLE);
			
			if (!properties["snapInterval"]) properties["snapInterval"] = 1;
			if (!properties["width"]) properties["width"] = 100;

			var slider : Slider = new Slider();
			slider.setSize(properties["width"], 16);

			slider.value = properties["value"];
			slider.minValue = properties["minValue"];
			slider.maxValue = properties["maxValue"];
			slider.snapInterval = properties["snapInterval"];

			slider.bindProperty(Slider.BINDABLE_PROPERTY_VALUE, label, "text");
			slider.bindProperty(Slider.BINDABLE_PROPERTY_VALUE, properties["change"]);

			return hgroup("gap", 4, display("id", properties["id"], slider), display("id", properties["labelid"], label));
		}

		protected function radioGroup(name : String, change : Function) : void {
			var radioGroup : RadioGroup = new RadioGroup();
			radioGroup.bindProperty(RadioGroup.BINDABLE_PROPERTY_SELECTED_VALUE, change);
			_radioGroups.add(name, [radioGroup]);
		}

		protected function radioButton(properties : Object) : RadioButton {
			var radioButton : RadioButton = new RadioButton();

			var buttonWidth : uint = 14;
			
			if (properties["label"]) buttonWidth = LABEL_SIZE - 4;
			else if (properties["icon"]) {
				buttonWidth += DisplayObject(properties["icon"]).width;
			}

			if (properties["diff"]) buttonWidth += properties["diff"];

			radioButton.setSize(buttonWidth, 18);

			radioButton.setStyle(CheckBox.style_buttonWidth, 14);
			radioButton.setStyle(CheckBox.style_buttonHeight, 14);

			if (properties["labelPosition"]) {
				radioButton.setStyle(CheckBox.style_labelPosition, properties["labelPosition"]);
			}

			radioButton.label = properties["label"];
			radioButton.icon = properties["icon"];

			radioButton.value = properties["value"];
			radioButton.selected = properties["selected"];
			radioButton.toolTip = properties["tip"];

			var radioGroupEntry : Array = _radioGroups.itemFor(properties["group"]);
			if (!radioGroupEntry[1]) {
				radioGroupEntry[1] = new Array();
			}
			(radioGroupEntry[1] as Array).push(radioButton);

			return radioButton;
		}

		protected function spacer(size : uint = LABEL_SIZE) : DisplayObject {
			var spacer : View = new View();
			spacer.setSize(size, 1);
			return spacer;
		}

		protected function vSpacer(size : uint = 4) : DisplayObject {
			var spacer : View = new View();
			spacer.setSize(1, size);
			return spacer;
		}

		protected function dottedSeparator(size : uint = 0) : View {
			var separator : View = new View();

			var width : uint = size ? size : _width;
			separator.setSize(width, 1);
			dashHorizontal(0, 0, width);

			return separator;

			function dashHorizontal(x : int, y : int, width : int) : void {
				var r1 : Rectangle = new Rectangle(0, 0, 2, 1);
				var r2 : Rectangle = new Rectangle(2, 0, 2, 1);

				var horizontalTile : BitmapData = new BitmapData(4, 1, true);
				horizontalTile.fillRect(r1, (0xFF << 24) + 0xCCCCCC);
				horizontalTile.fillRect(r2, 0x00000000);

				with (separator.graphics) {
					lineStyle();
					beginBitmapFill(horizontalTile, null, true);
					drawRect(x, y, width, 1);
					endFill();
				}
			}
		}

		protected function checkBox(properties : Object) : CheckBox {
			var checkBox : CheckBox = new CheckBox();

			var width : uint = 14;
			if (properties["label"]) width = LABEL_SIZE - 2;
			else if (properties["icon"]) width += DisplayObject(properties["icon"]).width + 9;
			
			if (properties["diff"]) width += properties["diff"];

			checkBox.setSize(width, 18);
			
			checkBox.setStyle(CheckBox.style_buttonWidth, 14);
			checkBox.setStyle(CheckBox.style_buttonHeight, 14);

			if (properties["labelPosition"]) {
				checkBox.setStyle(CheckBox.style_labelPosition, properties["labelPosition"]);
			}
			checkBox.setStyle(CheckBox.style_labelPadding, 4);

			checkBox.selected = properties["selected"];

			checkBox.label = properties["label"];
			checkBox.selectedLabel = properties["selectedlabel"];
			checkBox.icon = properties["icon"];

			checkBox.toolTip = properties["tip"];
			checkBox.selectedToolTip = properties["selectedTip"];
			
			if (properties["change"]) checkBox.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, properties["change"]);
			if (properties["enabled"] != null) checkBox.enabled = properties["enabled"];
			
			return checkBox;
		}
		
		protected function window(properties : Object) : Window {
			var window : Window = new Window();
			
			window.title = properties["title"];
			
			if (properties["minimise"] === false) {
				window.setStyles([
					Window.style.minimiseButton, false,
					Window.style.minimiseOnDoubleClick, false
				]);
			}
			
			if (properties["minimised"] === true) window.minimised = true;
			
			if (properties.hasOwnProperty("w") && properties.hasOwnProperty("h")) {
				window.setSize(properties["w"], properties["h"]);
			}
			
			if (properties.hasOwnProperty("x")) window.x = properties["x"];
			if (properties.hasOwnProperty("y")) window.y = properties["y"];
			
			return window;
		}
		
	}
}
