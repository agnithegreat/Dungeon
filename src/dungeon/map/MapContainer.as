package dungeon.map {
	import dungeon.personage.Player;
	import starling.display.Sprite;
	
	/**
	 * @author agnithegreat
	 */
	public class MapContainer extends Sprite {
		
		private var _container: Sprite;
		private var _player: Player;
		
		public function MapContainer() {
			_container = new Sprite();
			addChild(_container);
		}
		
		public function init($map: Vector.<GameObject>):void {
			var len: int = $map.length;
			for (var i : int = 0; i < len; i++) {
				var object: GameObject = $map[i];
				
				if (object is Player) {
					if (!_player) {
						_player = object as Player;
						_player.init();
					}
					_container.addChild(_player);
				} else {
					_container.addChild(object);
					object.init();
				}
			}
		}
	}
}
