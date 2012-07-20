package dungeon.system
{
	import dungeon.map.DefaultMap;
	import dungeon.map.GameObject;
	import dungeon.map.interaction.InteractiveObject;
	import dungeon.map.construct.Platform;
	import dungeon.personage.Personage;
	import dungeon.utils.ShadowContainer;
	import dungeon.utils.ShadowKicker;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class GameSystem
	{
		public static var GRAVITY: Number = -0.5;
		
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
		
		private static var _view: Sprite;
		private static var _map: DefaultMap;
		private static var _shadow: ShadowContainer;
		public static function addShadowKicker($object: GameObject, $radius: int):void {
			_shadow.addShadowKicker(new ShadowKicker($object, $radius));
		}
		
		public static function init($view: Sprite):void {
			_view = $view;
			
			_shadow = ShadowContainer.applyShadow(_view);
			
			_map = new DefaultMap();
			_view.addChildAt(_map, 0);
			_map.init();
		}
	}
}