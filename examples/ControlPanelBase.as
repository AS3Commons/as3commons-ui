package {

	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.core.IView;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.core.constants.Position;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.textfield.TextInput;
	import com.sibirjak.asdpc.textfield.TextInputEvent;
	import com.sibirjak.asdpcbeta.checkbox.CheckBox;
	import com.sibirjak.asdpcbeta.colorpicker.ColorPicker;
	import com.sibirjak.asdpcbeta.layout.AbstractLayout;
	import com.sibirjak.asdpcbeta.layout.HLayout;
	import com.sibirjak.asdpcbeta.layout.VLayout;
	import com.sibirjak.asdpcbeta.radiobutton.RadioButton;
	import com.sibirjak.asdpcbeta.radiobutton.RadioGroup;
	import com.sibirjak.asdpcbeta.slider.Slider;

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.ui.layout.HGroup;
	import org.as3commons.ui.layout.shortcut.display;
	import org.as3commons.ui.layout.shortcut.hgroup;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ControlPanelBase extends View {
		protected var _view : IView;
		protected var _radioGroups : LinkedMap;
		private var _viewIDs : LinkedMap;
		private const LABEL_SIZE : uint = 80;
		protected const DOCUMENT : String = "document";

		public function ControlPanelBase() {
			_radioGroups = new LinkedMap();
			_viewIDs = new LinkedMap();
		}

		public function get view() : IView {
			return _view;
		}

		public function set view(view : IView) : void {
			_view = view;
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
		protected function getView(id : String) : View {
			return _viewIDs.itemFor(id);
		}

		protected function getRadioGroup(name : String) : RadioGroup {
			return _radioGroups.itemFor(name)[0];
		}

		/*
		 * Factories
		 */
		protected function vLayout(...args) : VLayout {
			var vLayout : VLayout = new VLayout();
			vLayout.setStyle(AbstractLayout.style.itemPadding, 6);

			for (var i : int = 0; i < args["length"]; i++) {
				// id
				if (args[i] is String) {
					_viewIDs.add(args[i], vLayout);
				}
				// visible component
				if (args[i] is DisplayObject) vLayout.addChild(args[i]);
			}
			return vLayout;
		}

		protected function hLayout(...args) : HLayout {
			var hLayout : HLayout = new HLayout();
			hLayout.setStyle(AbstractLayout.style.itemPadding, 4);

			for (var i : int = 0; i < args["length"]; i++) {
				// id
				if (args[i] is String) {
					_viewIDs.add(args[i], hLayout);
				}
				// visible component
				if (args[i] is DisplayObject) hLayout.addChild(args[i]);
			}
			return hLayout;
		}

		protected function document(...args) : VLayout {
			var layout : VLayout = vLayout.apply(null, args);

			_viewIDs.add(DOCUMENT, layout);

			return layout;
		}

		protected function colorPicker(properties : Object) : ColorPicker {
			var colorPicker : ColorPicker = new ColorPicker();
			with (colorPicker) {
				setSize(16, 16);
				selectedColor = properties["color"];
				toolTip = properties["tip"];

				bindProperty(ColorPicker.BINDABLE_PROPERTY_SELECTED_COLOR, properties["change"]);
			}

			register(colorPicker, properties);

			return colorPicker;
		}

		protected function headline(labelText : String, diff : int = 0) : Label {
			var label : Label = new Label();
			label.setSize(_width + diff, 18);
			with (label) {
				text = labelText.toUpperCase();
				setStyle(Label.style.bold, true);
				setStyle(Label.style.size, 11);
			}
			return label;
		}

		protected function labelButton(properties : Object) : Button {
			properties["w"] = 60;
			properties["h"] = 20;
			return button(properties);
		}

		protected function  button(properties : Object) : Button {
			var button : Button = new Button();
			
			var bWidth : uint = properties["w"] ? properties["w"] : 14;
			var bHeight : uint = properties["h"] ? properties["h"] : 14;
			
			button.autoRepeat = properties["autorepeat"];
			
			with (button) {
				setSize(bWidth, bHeight);
				toggle = properties["toggle"];
				selected = properties["selected"];
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
				toolTip = properties["tip"];
				selectedToolTip = properties["selectedTip"];

				if (properties["change"]) button.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, properties["change"]);
			}

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

			register(button, properties);

			return button;
		}

		protected function textInput(properties : Object) : TextInput {
			var textInput : TextInput = new TextInput();

			with (textInput) {
				setSize(LABEL_SIZE + properties["diff"], 18);
				text = properties["text"];

				setStyles([Label.style.verticalAlign, Position.MIDDLE, Label.style.size, 10, TextInput.style.maxChars, 0 + properties["maxchars"]]);
			}

			textInput.addEventListener(TextInputEvent.CHANGED, function(event : Event) : void {
				properties["change"](textInput.text);
			});

			register(textInput, properties);

			return textInput;
		}

		protected function label(labelText : String, diff : int = 0, id : String = "", background : Boolean = false) : Label {
			var label : Label = new Label();
			with (label) {
				setSize(LABEL_SIZE + diff, 18);
				text = labelText;

				setStyles([Label.style.verticalAlign, Position.MIDDLE, Label.style.size, 10]);

				if (background) {
					setStyles([Label.style.background, true, Label.style.backgroundColor, 0xFFFFFF]);
				}
			}

			register(label, {id:id});

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
			with (slider) {
				setSize(properties["width"], 16);

				value = properties["value"];
				minValue = properties["minValue"];
				maxValue = properties["maxValue"];
				snapInterval = properties["snapInterval"];

				bindProperty(Slider.BINDABLE_PROPERTY_VALUE, label, "text");
				bindProperty(Slider.BINDABLE_PROPERTY_VALUE, properties["change"]);
			}

			register(slider, properties);

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

			with (radioButton) {
				setSize(buttonWidth, 18);

				setStyle(CheckBox.style_buttonWidth, 14);
				setStyle(CheckBox.style_buttonHeight, 14);

				if (properties["labelPosition"]) {
					setStyle(CheckBox.style_labelPosition, properties["labelPosition"]);
				}

				radioButton.label = properties["label"];
				// label = properties causes confusion with this.label()
				icon = properties["icon"];

				value = properties["value"];
				selected = properties["selected"];
				toolTip = properties["tip"];
			}

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

			checkBox.label = properties["label"]; // label = properties causes confusion with this.label()
			checkBox.selectedLabel = properties["selectedlabel"]; // label = properties causes confusion with this.label()
			checkBox.icon = properties["icon"];

			checkBox.toolTip = properties["tip"];
			checkBox.selectedToolTip = properties["selectedTip"];
			
			if (properties["change"]) checkBox.bindProperty(Button.BINDABLE_PROPERTY_SELECTED, properties["change"]);
			if (properties["enabled"] != null) checkBox.enabled = properties["enabled"];
			
			return checkBox;
		}
		
		/*
		 * Private
		 */
		private function register(view : DisplayObject, properties : Object) : void {
			if (properties["id"]) {
				_viewIDs.add(properties["id"], view);
			}
		}
	}
}
