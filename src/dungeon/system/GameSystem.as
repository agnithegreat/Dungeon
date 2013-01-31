package dungeon.system {
	import dungeon.map.MapContainer;
	import dungeon.utils.FPSCounter;
	import starling.core.Starling;
	import nape.util.ShapeDebug;
	import nape.geom.Vec2;
	import nape.space.Space;
	
	import starling.extensions.lighting.core.ShadowGeometry;
	import starling.extensions.lighting.core.LightBase;
	import starling.extensions.lighting.core.LightLayer;
	
	import dungeon.events.GameObjectEvent;
	import dungeon.map.DefaultMap;
	import dungeon.map.construct.Platform;
	import dungeon.map.interaction.InteractiveObject;
	import dungeon.personage.Personage;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class GameSystem {
		
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
		
		
		private static var _fps: FPSCounter;
		public static function get delay():Number {
			return 30/_fps.fps;
		}
		
		
		public static function init($view: Sprite):void {
			_fps = new FPSCounter($view);
			
			initPhysics();
			
			_map = new MapContainer();
			initView($view);
			
			_timer = new Timer(1000/60);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			_timer.start();
		}
		
		private static function handleTimer(e: TimerEvent):void {
//			_debug.clear();
			_physics.step(delay, 10000, 10000);
//			_debug.draw(_physics);
//			_debug.flush();
			
			dispatchEvent(new GameObjectEvent(GameObjectEvent.TICK, _timer.delay));
		}
		
		
		private static var _physics: Space;
		private static var _debug: ShapeDebug;
		public static function get world():Space {
			return _physics;
		}
		public static function initPhysics():void {
			_physics = new Space(new Vec2(0, 1));
			
			_debug = new ShapeDebug(GameScreen.screenWidth, GameScreen.screenHeight, 0x000000);
			Starling.current.nativeOverlay.addChild(_debug.display);
		}
		
		// -- view --
		private static var _screen: GameScreen;
		private static var _map: MapContainer;
		public static function get map():MapContainer {
			return _map;
		}
		
		private static function initView($view: Sprite):void {
			_screen = new GameScreen();
			$view.addChild(_screen);
			
			_screen.addChild(_map);
			
			_shadow = new LightLayer(GameScreen.screenWidth, GameScreen.screenHeight);
			_screen.addChild(_shadow);
			
			_map.init(DefaultMap.importDefaultMap());
		}
		
		private static var _shadow: LightLayer;
		public static function addLight($light: LightBase):void {
			if (_shadow) {
				_shadow.addLight($light);
			}
		}
		public static function addShadowGeometry($object: ShadowGeometry):void {
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