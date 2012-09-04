package dungeon.map
{
	import dungeon.personage.Player;
	import dungeon.system.GameObjectSection;
	import starling.display.Sprite;
	
	public class DefaultMap extends Sprite
	{
		public var mapWidth: int = 768;
		public var mapHeight: int = 512;
		public var floorHeight: int = 128;
		
		private var _location: GameObjectSection;
		private var _player: Player;
		
		public function init($location: GameObjectSection, $player: Player):void {
			_location = $location;
			_player = $player;
			
			var objects: Vector.<GameObject> = getAll();
			var len: int = objects.length;
			for (var i : int = 0; i < len; i++) {
				var object: GameObject = objects[i];
				addChild(object);
				object.init();
			}
		}
		
		public function getAll():Vector.<GameObject> {
			var stor: Vector.<GameObject> = new Vector.<GameObject>();
			stor = stor.concat(_location.storage);
			stor.push(_player);
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
	}
}