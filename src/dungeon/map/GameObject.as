package dungeon.map
{
	import dungeon.events.GameObjectEvent;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
		
		protected var _container: Sprite;
		
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
		
		public function dispatchMove():void {
			dispatchEvent(new GameObjectEvent(GameObjectEvent.OBJECT_MOVE));
		}
	}
}