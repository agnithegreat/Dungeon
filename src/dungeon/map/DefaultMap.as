package dungeon.map {
	import dungeon.map.interaction.Ladder;
	import dungeon.map.interaction.WallTorch;
	import dungeon.map.construct.Wall;
	import dungeon.map.construct.Floor;
	import dungeon.map.interaction.FrontTorch;
	import dungeon.map.construct.Background;
	import dungeon.personage.Player;
	import dungeon.system.GameObjectSection;
	
	import flash.net.SharedObject;
	import flash.utils.getDefinitionByName;
	
	import starling.display.Sprite;
	
	public class DefaultMap extends Sprite {
		
		private static var background: Background;
		private static var floor: Floor;
		private static var wall: Wall;
		private static var frontTorch: FrontTorch;
		private static var wallTorch: WallTorch;
		private static var ladder: Ladder;
		
		private static var defaultMap: Array = [{"id":"dungeon.map.construct::Background10","x":0,"h":400,"y":0,"parentId":null,"className":"dungeon.map.construct::Background","w":640},{"id":"dungeon.map.interaction::FrontTorch30","x":320,"h":20,"y":288,"parentId":null,"className":"dungeon.map.interaction::FrontTorch","w":10},{"id":"dungeon.map.interaction::Ladder16","x":256,"h":112,"y":272,"parentId":null,"className":"dungeon.map.interaction::Ladder","w":16},{"id":"dungeon.map.interaction::FrontTorch28","x":144,"h":20,"y":192,"parentId":null,"className":"dungeon.map.interaction::FrontTorch","w":10},{"id":"dungeon.map.interaction::FrontTorch31","x":448,"h":20,"y":384,"parentId":null,"className":"dungeon.map.interaction::FrontTorch","w":10},{"id":"dungeon.map.interaction::FrontTorch29","x":448,"h":20,"y":192,"parentId":null,"className":"dungeon.map.interaction::FrontTorch","w":10},{"id":"dungeon.map.interaction::FrontTorch32","x":144,"h":20,"y":384,"parentId":null,"className":"dungeon.map.interaction::FrontTorch","w":10},{"id":"dungeon.map.interaction::Ladder18","x":256,"h":112,"y":80,"parentId":null,"className":"dungeon.map.interaction::Ladder","w":16},{"id":"dungeon.map.interaction::Ladder17","x":512,"h":112,"y":176,"parentId":null,"className":"dungeon.map.interaction::Ladder","w":16},{"id":"dungeon.map.interaction::FrontTorch33","x":320,"h":20,"y":96,"parentId":null,"className":"dungeon.map.interaction::FrontTorch","w":10},{"id":"dungeon.personage::Player27","x":80,"h":30,"y":64,"parentId":null,"className":"dungeon.personage::Player","w":20},{"id":"dungeon.map.construct::Wall20","x":800,"h":80,"y":144,"parentId":null,"className":"dungeon.map.construct::Wall","w":16},{"id":"dungeon.map.construct::Wall21","x":48,"h":80,"y":208,"parentId":null,"className":"dungeon.map.construct::Wall","w":16},{"id":"dungeon.map.construct::Wall22","x":48,"h":80,"y":304,"parentId":null,"className":"dungeon.map.construct::Wall","w":16},{"id":"dungeon.map.construct::Wall26","x":832,"h":80,"y":144,"parentId":null,"className":"dungeon.map.construct::Wall","w":16},{"id":"dungeon.map.construct::Wall19","x":48,"h":80,"y":16,"parentId":null,"className":"dungeon.map.construct::Wall","w":16},{"id":"dungeon.map.construct::Wall24","x":816,"h":80,"y":144,"parentId":null,"className":"dungeon.map.construct::Wall","w":16},{"id":"dungeon.map.construct::Wall23","x":576,"h":80,"y":16,"parentId":null,"className":"dungeon.map.construct::Wall","w":16},{"id":"dungeon.map.construct::Wall25","x":576,"h":80,"y":208,"parentId":null,"className":"dungeon.map.construct::Wall","w":16},{"id":"dungeon.map.construct::Floor12","x":0,"h":16,"y":96,"parentId":null,"className":"dungeon.map.construct::Floor","w":640},{"id":"dungeon.map.construct::Floor15","x":0,"h":16,"y":384,"parentId":null,"className":"dungeon.map.construct::Floor","w":640},{"id":"dungeon.map.construct::Floor14","x":0,"h":16,"y":288,"parentId":null,"className":"dungeon.map.construct::Floor","w":640},{"id":"dungeon.map.construct::Floor11","x":0,"h":16,"y":0,"parentId":null,"className":"dungeon.map.construct::Floor","w":640},{"id":"dungeon.map.construct::Floor13","x":0,"h":16,"y":192,"parentId":null,"className":"dungeon.map.construct::Floor","w":640}];
		
		// not used yet
		private var _location: GameObjectSection;
		
		private var _player: Player;
		public function get player():Player {
			return _player;
		}
		
		public function init($location: GameObjectSection):void {
			_location = $location;
			
			var objects: Vector.<GameObject> = importDefaultMap();
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
		
		private static function sort($1: GameObject, $2: GameObject):int {
			if ($1.z>$2.z) {
				return 1;
			}
			if ($1.z<$2.z) {
				return -1;
			}
			return 0;
		}
		
		public static function importDefaultMap(): Vector.<GameObject> {
			var map: Vector.<GameObject> = new Vector.<GameObject>();
			for (var i:int = 0; i < defaultMap.length; i++) {
				var object: Object = defaultMap[i];
				var GameObjectClass: Class = getDefinitionByName(object.className) as Class;
				var obj: GameObject = new GameObjectClass();
				obj.setData(object);
				map.push(obj);
			}
			map = map.sort(sort);
			return map;
		}
		
		public static function importMap(): Vector.<GameObject> {
			var so: SharedObject = SharedObject.getLocal("dungeons", "/");
			var map: Vector.<GameObject> = new Vector.<GameObject>();
			if (!so.data.map) {
				return map;
			}
			for (var i:int = 0; i < so.data.map.length; i++) {
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