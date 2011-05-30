package layout.showcase {

	import layout.showcase.base.ShowcaseConfig;
	import layout.showcase.base.ShowcaseBase;

	import org.as3commons.ui.layout.framework.ILayout;
	import org.as3commons.ui.layout.shortcut.dyntable;
	import org.as3commons.ui.layout.shortcut.hgroup;
	import org.as3commons.ui.layout.shortcut.hlayout;
	import org.as3commons.ui.layout.shortcut.table;
	import org.as3commons.ui.layout.shortcut.vgroup;
	import org.as3commons.ui.layout.shortcut.vlayout;

	/**
	 * @author Jens Struwe 29.03.2011
	 */
	public class LayoutTest extends ShowcaseBase {
		
		private var _layoutType : String;
		
		public function LayoutTest() {
			_layoutType = loaderInfo.parameters["layout"];
//			_layoutType = "hlayout";
			super();
		}
		
		override protected function createLayout() : ILayout {
			switch (_layoutType) {
				case "hgroup":
					return hgroup();
					break;

				case "vgroup":
					return vgroup();
					break;

				case "vlayout":
					return vlayout();
					break;

				case "table":
					return table();
					break;

				case "dyntable":
					return dyntable();
					break;

				case "hlayout":
				default:
					return hlayout();
					break;

			}

			return null;
		}
		
		
		override protected function createShowcaseConfig() : ShowcaseConfig {
			var config : ShowcaseConfig = new ShowcaseConfig();

			switch (_layoutType) {
				case "hgroup":
					config.numBoxes = 8;
					break;

				case "vgroup":
					config.numBoxes = 6;
					break;

				case "vlayout":
					config.maxItems = 6;
					break;

				case "table":
					break;

				case "dyntable":
					config.maxSize = 400;
					break;

				case "hlayout":
				default:
					config.maxItems = 8;
					break;

			}

			return config;
		}

	}
}
