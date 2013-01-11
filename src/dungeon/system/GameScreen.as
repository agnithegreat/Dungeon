package dungeon.system {
	import dungeon.map.GameObject;
	import starling.core.Starling;
	import starling.core.RenderSupport;
	import dungeon.events.GameObjectEvent;
	import flash.geom.Rectangle;
	import starling.display.Sprite;

	/**
	 * @author agnithegreat
	 */
	public class GameScreen extends Sprite {
		
		public static var screenWidth: int = 768;
		public static var screenHeight: int = 512;
		
		private var _lockedObject: GameObject;
		
		public function GameScreen() {
		}
		
		public function lockOnObject($object: GameObject):void {
			if (_lockedObject) {
				_lockedObject.removeEventListener(GameObjectEvent.OBJECT_MOVE, handleScroll);
			}
			
			_lockedObject = $object;
			if (_lockedObject) {
				_lockedObject.addEventListener(GameObjectEvent.OBJECT_MOVE, handleScroll);
			}
		}
		
		private function handleScroll(e: GameObjectEvent):void {
			var target: GameObject = _lockedObject ? _lockedObject : new GameObject();
			x = screenWidth/2 - target.x;
			x = Math.min(0, Math.max(x, -(GameSystem.map.mapWidth-screenWidth)));
			y = screenHeight/2 - target.y;
			y = Math.min(0, Math.max(y, -(GameSystem.map.mapHeight-screenHeight)));
		}
		
		private var _scrollRect: Rectangle;
		public override function render(support:RenderSupport, alpha:Number):void {
			support.finishQuadBatch();
			
			if (!_scrollRect) {
				_scrollRect = new Rectangle(0,0,screenWidth,screenHeight);
			}
			
			Starling.context.setScissorRectangle(_scrollRect);
			super.render(support,alpha);
			support.finishQuadBatch();
			Starling.context.setScissorRectangle(null);
		}
	}
}
