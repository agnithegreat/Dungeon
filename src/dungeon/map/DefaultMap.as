package dungeon.map
{
	import dungeon.personage.Player;
	import dungeon.system.GameObjectSection;
	
	import flash.net.SharedObject;
	import flash.utils.getDefinitionByName;
	
	import starling.display.Sprite;
	
	public class DefaultMap extends Sprite
	{
		public var mapWidth: int = 768;
		public var mapHeight: int = 512;
		public var floorHeight: int = 128;
		
		private var _location: GameObjectSection;
		
		private var _player: Player;
		public function get player():Player {
			return _player;
		}
		
		public function init($location: GameObjectSection):void {
			_location = $location;
			
			var objects: Vector.<GameObject> = importMap();
			var len: int = objects.length;
			for (var i : int = 0; i < len; i++) {
				var object: GameObject = objects[i];
				addChild(object);
				object.init();
				
				if (object is Player) {
					_player = object as Player;
				}
			}
		}
		
		public function getAll():Vector.<GameObject> {
			var stor: Vector.<GameObject> = new Vector.<GameObject>();
			stor = stor.concat(_location.storage);
			stor = stor.sort(sort);
			return stor;
		}
		
		private function sort($1: GameObject, $2: GameObject):int {
			if ($1.z>$2.z) {
				return 1;
			}
			if ($1.z<$2.z) {
				return -1;
			}
			return 0;
		}
		
		public function importMap(): Vector.<GameObject> {
			var so: SharedObject = SharedObject.getLocal("dungeons", "/");
			var map: Vector.<GameObject> = new Vector.<GameObject>();
			if (!so.data.map) {
				return map;
			}
			for (var i:int = 0; i < so.data.map.length; i++) 
			{
				var object: Object = so.data.map[i];
				var GameObjectClass: Class = getDefinitionByName(object.className) as Class;
				var obj: GameObject = new GameObjectClass();
				obj.setData(object);
				map.push(obj);
			}
			map = map.sort(sort);
			return map;
		}
	}
}