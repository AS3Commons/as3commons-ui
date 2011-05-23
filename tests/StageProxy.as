package  {

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;

	/**
	 * @author Jens Struwe 23.05.2011
	 */
	public class StageProxy {

		private static var _stage : Stage;
		private static var _root : DisplayObjectContainer;

		public static function get stage() : Stage {
			return _stage;
		}

		public static function set stage(stage : Stage) : void {
			_stage = stage;
			
			_root = _stage.addChild(new Sprite()) as DisplayObjectContainer;
			_root.visible = false;
		}

		public static function get root() : DisplayObjectContainer {
			return _root;
		}
		
		public static function cleanUpRoot() : void {
			while (_root.numChildren) _root.removeChildAt(0);
		}
		
	}
}
