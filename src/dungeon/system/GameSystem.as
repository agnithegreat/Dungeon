package dungeon.system
{
	import dungeon.personage.Player;
	import flash.geom.Rectangle;
	import dungeon.map.DefaultMap;
	import dungeon.utils.construct.RoomConstructor;
	import dungeon.events.GameObjectEvent;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import dungeon.utils.ShadowKicker;
	import dungeon.personage.Personage;
	import dungeon.map.interaction.InteractiveObject;
	import starling.display.DisplayObject;
	import dungeon.map.construct.Platform;
	import dungeon.map.GameObject;
	import dungeon.utils.ShadowContainer;
	
	import starling.display.Sprite;

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
			
			_shadow = ShadowContainer.applyShadow(_screen);
			
			_screen.addChildAt(_map, 0);
			
			var player: Player = new Player();
			player.x = _map.mapWidth/2;
			player.y = _map.mapHeight/6;
			
			_map.init(_world.getSection(GameObjectSection.LOCATION+0), player);
			
			_screen.lockOnObject(player);
		}
		
		private static var _shadow: ShadowContainer;
		public static function addShadowKicker($object: GameObject, $radius: int):void {
			_shadow.addShadowKicker(new ShadowKicker($object, $radius));
		}
		// -- view --
		
		
		
		
		
		
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
	}
}