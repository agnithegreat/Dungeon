package dungeon.system {
	import starling.extensions.lighting.core.ShadowGeometry;
	import starling.extensions.lighting.core.LightBase;
	import starling.extensions.lighting.core.LightLayer;
	import dungeon.events.GameObjectEvent;
	import dungeon.map.DefaultMap;
	import dungeon.map.construct.Platform;
	import dungeon.map.interaction.InteractiveObject;
	import dungeon.personage.Personage;
	import dungeon.utils.construct.RoomConstructor;
	
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class GameSystem {
		public static var GRAVITY: Number = -0.5;
		
		
		// -- EventDispatcher --
		private static var _timer: Timer;
		private static var _eventDispatcher: EventDispatcher = new EventDispatcher();
		public static function addEventListener($event: String, $callback: Function):void {
			_eventDispatcher.addEventListener($event, $callback);
		}
		private static function dispatchEvent($event: Event):void {
			_eventDispatcher.dispatchEvent($event);
		}
		// -- EventDispatcher --
		
		
		public static function init($view: Sprite):void {
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
			
			_shadow = new LightLayer(Dungeon.gameWidth, Dungeon.gameHeight);
			
			_screen.addChildAt(_map, 0);
			_screen.addChild(_shadow);
			
			_map.init(_world.getSection(GameObjectSection.LOCATION+0));
			
//			_screen.lockOnObject(_map.player);
		}
		
		private static var _shadow: LightLayer;
		public static function addLight($light: LightBase):void {
			if (_shadow) {
				_shadow.addLight($light);
			}
		}
		public static function addShadowObject($object: ShadowGeometry):void {
			if (_shadow) {
				_shadow.addShadowGeometry($object);
			}
		}
		// -- view --
		
		private static var _platforms: Dictionary = new Dictionary();
		public static function registerPlatform($platform: Platform):void {
			_platforms[$platform.id] = $platform;
		}
		public static function clearPlatform($platform: Platform):void {
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
		public static function registerInteractive($interactive: InteractiveObject):void {
			_interactive[$interactive.id] = $interactive;
		}
		public static function clearInteractive($interactive: InteractiveObject):void {
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
		public static function registerPersonage($personage: Personage):void {
			_personages[$personage.id] = $personage;
		}
		public static function clearPersonage($personage: Personage):void {
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