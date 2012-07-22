package dungeon.utils
{
	import dungeon.system.GameSystem;
	import assets.ShadowKickerTextureUI;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import starling.display.Image;
	import dungeon.events.GameObjectEvent;
	import dungeon.map.GameObject;

	public class ShadowKicker extends Sprite
	{
		protected var _target: GameObject;
		public function get target():GameObject {
			return _target;
		}
		
		protected var _radius: int;
		public function get radius():int {
			return _radius;
		}
		
		private var _scaleOffset: Number;
		private var _scaleSpeed: Number;
		
		public function ShadowKicker($target: GameObject, $radius: int) {
			var bg: ShadowKickerTextureUI = new ShadowKickerTextureUI();
			var bmd: BitmapData = new BitmapData(bg.width, bg.height, true, 0x00000000);
			bmd.draw(bg);
			var texture: Texture = Texture.fromBitmapData(bmd);
			
			var image: Image = new Image(texture);
			image.width = image.height = $radius*2;
			addChild(image);
			
			_target = $target;
			_target.addEventListener(GameObjectEvent.OBJECT_MOVE, handleMove);
			_target.addEventListener(GameObjectEvent.OBJECT_DESTROY, handleDestroy);
			_radius = $radius;
			
			pivotX = pivotY = $radius;
			
			handleMove(null);
			
			_scaleOffset = Math.random()*100;
			_scaleSpeed = Math.random()*0.01+0.005;
			GameSystem.addEventListener(GameObjectEvent.TICK, handleTick);
		}

		protected function handleTick(e : GameObjectEvent) : void {
			var date: Date = new Date();
			var mod: int = _scaleOffset+date.getTime()*_scaleSpeed;
			scaleX = 1+Math.sin(mod)*0.05;
			scaleY = 1+Math.sin(mod)*0.05;
		}
		
		private function handleMove(e: GameObjectEvent):void {
			x = _target.center.x;
			y = _target.center.y;
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