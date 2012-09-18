package dungeon.map
{
	import dungeon.events.GameObjectEvent;
	import dungeon.system.GameSystem;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class GameObject extends Sprite
	{
		protected var _x: Number;
		override public function set x($x: Number):void {
			_x = $x;
			super.x = _x;
			dispatchMove();
		}
		protected var _y: Number;
		override public function set y($y: Number):void {
			_y = $y;
			super.y = _y;
			dispatchMove();
		}
		
		// z-index for sorting on stage
		public function get z():uint {
			return 0;
		}
		
		protected var _container: Sprite;
		public function get container():Sprite {
			return _container;
		}
		
		protected var _center: Point;
		public function get center():Point {
			if (!_center) {
				var rect: Rectangle = getBounds(this);
				_center = new Point(rect.x+rect.width/2, rect.y+rect.height/2);
			}
			return _center.add(new Point(x,y));
		}
		
		public function GameObject()
		{
			_container = new Sprite();
			addChild(_container);
		}
		
		public function init():void {
			addToGameSystem();
			
			GameSystem.addEventListener(GameObjectEvent.TICK, handleTick);
		}
		
		protected function addToGameSystem():void {
			
		}
		
		protected function removeFromGameSystem():void {
			
		}

		protected function handleTick(e : GameObjectEvent) : void {
		}
		
		public function dispatchMove():void {
			dispatchEvent(new GameObjectEvent(GameObjectEvent.OBJECT_MOVE));
		}
		
		public function hitTestObject($obj: DisplayObject):Boolean {
			return bounds.intersects($obj.bounds);
		}
		
		public function destroy():void {
			removeFromGameSystem();
		}
	}
}