package editor.parts {
	import dungeon.map.GameObject;
	import starling.display.Sprite;

	/**
	 * @author agnithegreat
	 */
	public class PartTile extends Sprite {
		
		public static var tileWidth: int = 100;
		public static var tileHeight: int = 100;
		
		private var ObjectClass: Class;
		private var _object: GameObject;
		
		public function PartTile($ObjClass: Class) {
			ObjectClass = $ObjClass;
			
			_object = getObject();
			_object.x = (tileWidth-_object.width)/2;
			_object.y = (tileHeight-_object.height)/2;
			addChild(_object);
			
			_object.init();
		}
		
		public function getObject():GameObject {
			return new ObjectClass();
		}
	}
}
