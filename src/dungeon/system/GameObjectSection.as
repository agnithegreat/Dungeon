package dungeon.system {
	import dungeon.personage.Personage;
	import dungeon.map.interaction.InteractiveObject;
	import starling.display.DisplayObject;
	import dungeon.map.construct.Platform;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import dungeon.map.GameObject;

	public class GameObjectSection {
		
		public static const WORLD: String = "WORLD_SECTION";
		public static const LOCATION: String = "LOCATION_SECTION";
		public static const FLOOR: String = "FLOOR_SECTION";
		public static const ROOM: String = "ROOM_SECTION";
		
		private static var _world : GameObjectSection;
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
		
		private static var _platforms: Array = [];
		public static function registerPlatform($platform: Platform):void
		{
			_platforms.push($platform);
		}
		public static function clearPlatform($platform: Platform):void
		{
			for (var i: int = 0; i < _platforms.length; i++) {
				var platform: Platform = _platforms[i];
				if (platform==$platform) {
					_platforms.splice(i,1);
					return;
				}
			}
		}
		public static function checkCollisions($object: DisplayObject):Array {
			var collisions: Array = [];
			for (var i: int = 0; i < _platforms.length; i++) {
				var platform: Platform = _platforms[i];
				if (platform.hitTestObject($object)) {
					collisions.push(platform);
				}
			}
			return collisions;
		}
		
		private static var _interactive: Array = [];
		public static function registerInteractive($interactive: InteractiveObject):void
		{
			_interactive.push($interactive);
		}
		public static function clearInteractive($interactive: InteractiveObject):void
		{
			for (var i: int = 0; i < _interactive.length; i++) {
				var interactive: InteractiveObject = _interactive[i];
				if (interactive==$interactive) {
					_interactive.splice(i,1);
					return;
				}
			}
		}
		public static function checkInteraction($object: DisplayObject):Array {
			var interaction: Array = [];
			for (var i: int = 0; i < _interactive.length; i++) {
				var interactive: InteractiveObject = _interactive[i];
				if (interactive.hitTestObject($object)) {
					interaction.push(interactive);
				}
			}
			return interaction;
		}
		
		private static var _personages: Array = [];
		public static function registerPersonage($personage: Personage):void
		{
			_personages.push($personage);
		}
		public static function clearPersonage($personage: Personage):void
		{
			for (var i: int = 0; i < _personages.length; i++) {
				var personage: Personage = _personages[i];
				if (personage==$personage) {
					_personages.splice(i,1);
					return;
				}
			}
		}
		public static function checkPersonageHit($object: DisplayObject):Array {
			var personages: Array = [];
			for (var i: int = 0; i < _personages.length; i++) {
				var personage: Personage = _personages[i];
				if (personage!=$object && personage.hitTestObject($object)) {
					personages.push(personage);
				}
			}
			return personages;
		}
		
		
		protected var _id: String;
		public function get id():String {
			return _id;
		}
		
		private var _bounds : Rectangle;
		public function get bounds():Rectangle {
			return _bounds;
		}
		
		protected var _sections : Dictionary;
		
		protected var _storage : Vector.<GameObject>;
		public function get storage():Vector.<GameObject> {
			var stor: Vector.<GameObject> = new Vector.<GameObject>();
			for each (var section : GameObjectSection in _sections) {
				stor = stor.concat(section.storage);
			}
			stor = stor.concat(_storage);
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

		public function GameObjectSection($id: String) {
			_id = $id;
			
			_sections = new Dictionary();
			_storage = new Vector.<GameObject>();
		}
		
		public function init($bounds: Rectangle):void {
			_bounds = $bounds;
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