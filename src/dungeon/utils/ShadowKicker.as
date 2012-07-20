package dungeon.utils
{
	import dungeon.events.GameObjectEvent;
	import dungeon.map.GameObject;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;

	public class ShadowKicker extends Shape
	{
		protected var _target: GameObject;
		public function get target():GameObject {
			return _target;
		}
		
		protected var _radius: int;
		public function get radius():int {
			return _radius;
		}
		
		public function ShadowKicker($target: GameObject, $radius: int) {
			_target = $target;
			_target.addEventListener(GameObjectEvent.OBJECT_MOVE, handleMove);
			_target.addEventListener(GameObjectEvent.OBJECT_DESTROY, handleDestroy);
			_radius = $radius;
			
			draw();
			handleMove(null);
		}
		
		public function draw():void {
			graphics.clear();
			var m:Matrix = new Matrix();
			m.createGradientBox(_radius*2, _radius*2);
			graphics.beginGradientFill(
				GradientType.RADIAL,
				[0x0000ff, 0x12f691, 0x101274],
				[1, 0.3, 0],
				[0, 127, 255],
				m
			);
			graphics.drawCircle(_radius, _radius, _radius);
			graphics.endFill();
		}
		
		private function handleMove(e: GameObjectEvent):void {
			x = _target.center.x-_radius;
			y = _target.center.y-_radius;
		}
		
		private function handleDestroy(e: GameObjectEvent):void {
			if (_target) {
				_target.removeEventListener(GameObjectEvent.OBJECT_MOVE, handleMove);
				_target.removeEventListener(GameObjectEvent.OBJECT_DESTROY, handleDestroy);
			}
			_target = null;
			
			if (parent) {
				parent.removeChild(this);
			}
		}
	}
}