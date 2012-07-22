package dungeon.system {
	import flash.utils.Dictionary;
	import dungeon.map.GameObject;

	public class GameObjectSection extends GameObject {
		
		public static const WORLD: String = "WORLD_SECTION";
		public static const LOCATION: String = "LOCATION_SECTION";
		public static const FLOOR: String = "FLOOR_SECTION";
		public static const ROOM: String = "ROOM_SECTION";
		
		private static var _world: GameObjectSection;
		public static function createWorld():GameObjectSection {
			if (!_world) {
				_world = new GameObjectSection(WORLD);
			}
			return _world;
		}
		
		private static var _locations: Vector.<GameObjectSection> = new Vector.<GameObjectSection>();
		public static function createLocation():GameObjectSection {
			var location: GameObjectSection = new GameObjectSection(LOCATION+_locations.length);
			_locations.push(location);
			return location;
		}
		
		private static var _floors: Vector.<GameObjectSection> = new Vector.<GameObjectSection>();
		public static function createLevel():GameObjectSection {
			var floor: GameObjectSection = new GameObjectSection(FLOOR+_floors.length);
			_floors.push(floor);
			return floor;
		}
		
		private static var _rooms: Vector.<GameObjectSection> = new Vector.<GameObjectSection>();
		public static function createRoom():GameObjectSection {
			var room: GameObjectSection = new GameObjectSection(ROOM+_rooms.length);
			_rooms.push(room);
			return room;
		}
		
		
		protected var _id: String;
		public function get id():String {
			return _id;
		}
		
		protected var _sections : Dictionary;
		
		protected var _storage : Vector.<GameObject>;
		public function get storage():Vector.<GameObject> {
			var stor: Vector.<GameObject> = new Vector.<GameObject>();
			for each (var section : GameObjectSection in _sections) {
				stor = stor.concat(section.storage);
			}
			stor = stor.concat(_storage);
			return stor;
		}

		public function GameObjectSection($id: String) {
			_id = $id;
			
			_sections = new Dictionary();
			_storage = new Vector.<GameObject>();
		}
		
		public function addSection($section: GameObjectSection):void {
			_sections[$section.id] = $section;
		}
		
		public function getSection($id: String):GameObjectSection {
			return _sections[$id];
		}
		
		public function addObject($object: GameObject):void {
			_storage.push($object);
		}
	}
}