package dungeon.map
{
	import dungeon.map.construct.Background;
	import dungeon.map.interaction.InteractiveObject;
	import dungeon.personage.Player;
	import dungeon.system.GameObjectSection;
	import dungeon.system.GameSystem;
	import dungeon.utils.ShadowContainer;
	
	import flash.net.SharedObject;
	import flash.utils.getDefinitionByName;
	
	import starling.display.Sprite;
	
	public class DefaultMap extends Sprite
	{
		public var mapWidth: int = 1024;
		public var mapHeight: int = 768;
		public var floorHeight: int = 128;
		
		private var _location: GameObjectSection;
		private var _player: Player;
		
		public function init($location: GameObjectSection, $player: Player):void {
			_location = $location;
			_player = $player;
			
			var objects: Vector.<GameObject> = importMap();
			var len: int = objects.length;
			for (var i : int = 0; i < len; i++) {
				var object: GameObject = objects[i];
				if (!(object is InteractiveObject)) {
					object.hide();
				}
				addChild(object);
				object.init();
				
				if (object is Background) {
					GameSystem.registerRoom(object as Background);
				}
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
		
		public function importMap(): Vector.<GameObject> {
			var so: SharedObject = SharedObject.getLocal("dungeons", "/");
			var map: Vector.<GameObject> = new Vector.<GameObject>();
			for (var i:int = 0; i < so.data.map.length; i++) 
			{
				var object: Object = so.data.map[i];
				var GameObjectClass: Class = getDefinitionByName(object.className) as Class;
				var obj: GameObject = new GameObjectClass();
				obj.setData(object);
				map.push(obj);
			}
			map.push(_player);
			map = map.sort(sort);
			return map;
		}
	}
}