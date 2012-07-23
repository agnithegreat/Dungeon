package dungeon.map
{
	import dungeon.personage.Player;
	import dungeon.system.GameObjectSection;
	import starling.display.Sprite;
	
	public class DefaultMap extends Sprite
	{
		private var _location: GameObjectSection;
		private var _player: Player;
//		private var _currentRoom
		
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
/*		
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
*/
	}
}