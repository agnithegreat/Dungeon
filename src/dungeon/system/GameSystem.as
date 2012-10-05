package dungeon.system
{
	import dungeon.events.GameObjectEvent;
	import dungeon.map.DefaultMap;
	import dungeon.map.GameObject;
	import dungeon.map.construct.Background;
	import dungeon.map.construct.Platform;
	import dungeon.map.interaction.InteractiveObject;
	import dungeon.personage.Personage;
	import dungeon.personage.Player;
	import dungeon.utils.ShadowContainer;
	import dungeon.utils.ShadowKicker;
	import dungeon.utils.construct.RoomConstructor;
	
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class GameSystem
	{
		public static var GRAVITY: Number = -0.5;
		
		
		// -- EventDispatcher --
		private static var _timer: Timer;
		private static var _eventDispatcher: EventDispatcher;
		public static function addEventListener($event: String, $callback: Function):void {
			_eventDispatcher.addEventListener($event, $callback);
		}
		private static function dispatchEvent($event: Event):void {
			_eventDispatcher.dispatchEvent($event);
		}
		// -- EventDispatcher --
		
		
		public static function init($view: Sprite):void {
			_eventDispatcher = new EventDispatcher();
			
			_map = new DefaultMap();
			initModel();
			initView($view);
			
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			_timer.start();
		}
		
		private static function handleTimer(e: TimerEvent):void {
			dispatchEvent(new GameObjectEvent(GameObjectEvent.TICK));
		}
		
		
		
		private static var _world: GameObjectSection;
		private static function initModel():void {
			_world = GameObjectSection.createWorld();
			for (var i : int = 0; i < 2; i++) {
				var location: GameObjectSection = GameObjectSection.createLocation();
				location.init(new Rectangle(0, 0, _map.mapWidth, _map.mapHeight));
				_world.addSection(location);
				for (var j : int = 0; j < 4; j++) {
					var floor: GameObjectSection = GameObjectSection.createLevel();
					floor.init(new Rectangle(0, j*_map.floorHeight, _map.mapWidth, _map.floorHeight));
					location.addSection(floor);
					for (var k : int = 0; k < 3; k++) {
						if (Math.random()>0.3) {
							var room: GameObjectSection = GameObjectSection.createRoom();
							room.init(new Rectangle(k*_map.mapWidth/3, j*_map.floorHeight,_map.mapWidth/3, _map.floorHeight));
							RoomConstructor.constructRoom(room);
							floor.addSection(room);
						}
					}
				}
			}
		}
		
		
		// -- view --
		private static var _screen: GameScreen;
		private static var _map: DefaultMap;
		public static function get map():DefaultMap {
			return _map;
		}
		
		private static function initView($view: Sprite):void {
			_screen = new GameScreen();
			$view.addChild(_screen);
			
			_shadow = new ShadowContainer(_screen, new Rectangle(0, 0, _map.mapWidth, _map.mapHeight));
			
			_screen.addChildAt(_map, 0);
			
			var player: Player = new Player();
			player.x = _map.mapWidth/20;
			player.y = _map.mapHeight/8;
			
			_map.init(_world.getSection(GameObjectSection.LOCATION+0), player);
			
			_screen.lockOnObject(player);
		}
		
		private static var _shadow: ShadowContainer;
		public static function addShadowKicker($kicker: ShadowKicker):void {
			if (_shadow) {
				_shadow.addShadowKicker($kicker);
			}
		}
		// -- view --
		
		
		private static var _currentRoom: Background;
		private static var _rooms: Dictionary = new Dictionary();
		public static function registerRoom($room: Background):void {
			_rooms[$room.id] = $room;
			if (_shadow) {
				_shadow.addShadow($room.id, $room.getBounds(_screen));
			}
		}
		public static function checkRooms($object: DisplayObject):Array {
			var collisions: Array = [];
			for each (var room: Background in _rooms) {
				if (room.hitTestObject($object)) {
					collisions.push(room);
				}
			}
			return collisions;
		}
		public static function changeRoom($id: String):void {
			if (_shadow) {
				var room: Background = _rooms[$id];
				if (!room.appeared) {
					_shadow.openRoom($id);
					
					for each (var platform: Platform in _platforms) {
						if (platform.parentId == room.id) {
							platform.appear();
						}
					}
				}
				if (_currentRoom != room) {
					_currentRoom = room;
					_shadow.changeRoom($id);
				}
			}
		}
		
		private static var _platforms: Dictionary = new Dictionary();
		public static function registerPlatform($platform: Platform):void
		{
			_platforms[$platform.id] = $platform;
		}
		public static function clearPlatform($platform: Platform):void
		{
			delete _platforms[$platform.id];
		}
		public static function checkCollisions($object: DisplayObject):Array {
			var collisions: Array = [];
			for each (var platform: Platform in _platforms) {
				if (platform.hitTestObject($object)) {
					collisions.push(platform);
				}
			}
			return collisions;
		}
		
		private static var _interactive: Dictionary = new Dictionary();
		public static function registerInteractive($interactive: InteractiveObject):void
		{
			_interactive[$interactive.id] = $interactive;
		}
		public static function clearInteractive($interactive: InteractiveObject):void
		{
			delete _interactive[$interactive.id];
		}
		public static function checkInteraction($object: DisplayObject):Array {
			var interaction: Array = [];
			for each (var interactive: InteractiveObject in _interactive) {
				if (interactive.hitTestObject($object)) {
					interaction.push(interactive);
				}
			}
			return interaction;
		}
		
		private static var _personages: Dictionary = new Dictionary();
		public static function registerPersonage($personage: Personage):void
		{
			_personages[$personage.id] = $personage;
		}
		public static function clearPersonage($personage: Personage):void
		{
			delete _personages[$personage.id];
		}
		public static function checkPersonageHit($object: DisplayObject):Array {
			var personages: Array = [];
			for each (var personage: Personage in _personages) {
				if (personage!=$object && personage.hitTestObject($object)) {
					personages.push(personage);
				}
			}
			return personages;
		}
	}
}