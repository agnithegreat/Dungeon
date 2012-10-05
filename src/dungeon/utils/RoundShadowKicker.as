package dungeon.utils
{
	import assets.ShadowKickerTextureUI;
	
	import dungeon.events.GameObjectEvent;
	import dungeon.map.GameObject;
	import dungeon.system.GameSystem;
	
	import flash.display.BitmapData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class RoundShadowKicker extends ShadowKicker
	{
		protected var _radius: int;
		public function get radius():int {
			return _radius;
		}
		
		private var _scaleOffset: Number;
		private var _scaleSpeed: Number;
		
		public function RoundShadowKicker($target: GameObject, $radius: int, $isGlobal: Boolean = true) {
			_radius = $radius;
			
			super($target, $isGlobal);
			
			pivotX = pivotY = _radius;
			
			_scaleOffset = Math.random()*100;
			_scaleSpeed = Math.random()*0.01+0.005;
			GameSystem.addEventListener(GameObjectEvent.TICK, handleTick);
		}
		
		override protected function createKicker($target: GameObject):void {
			var bg: ShadowKickerTextureUI = new ShadowKickerTextureUI();
			var bmd: BitmapData = new BitmapData(bg.width, bg.height, true, 0x00000000);
			bmd.draw(bg);
			var texture: Texture = Texture.fromBitmapData(bmd);
			
			var image: Image = new Image(texture);
			image.width = image.height = _radius*2;
			addChild(image);
		}

		protected function handleTick(e : GameObjectEvent) : void {
			var date: Date = new Date();
			var mod: int = _scaleOffset+date.getTime()*_scaleSpeed;
			scaleX = 1+Math.sin(mod)*0.05;
			scaleY = 1+Math.sin(mod)*0.05;
		}
	}
}