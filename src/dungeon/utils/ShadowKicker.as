package dungeon.utils
{
	import assets.ShadowKickerTextureUI;
	
	import dungeon.events.GameObjectEvent;
	import dungeon.map.GameObject;
	import dungeon.system.GameSystem;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;

	public class ShadowKicker extends Sprite
	{
		protected var _target: GameObject;
		public function get target():GameObject {
			return _target;
		}
		
		protected var _global: Boolean;
		public function get isGlobal():Boolean {
			return _global;
		}
		
		protected var _mask: Rectangle;
		
		public function ShadowKicker($target: GameObject, $isGlobal: Boolean = true) {
			_target = $target;
			_target.addEventListener(GameObjectEvent.OBJECT_MOVE, handleMove);
			_target.addEventListener(GameObjectEvent.OBJECT_DESTROY, handleDestroy);
			
			_global = $isGlobal;
			
			createKicker($target);
			
			handleMove(null);
		}
		
		public override function render(support:RenderSupport, alpha:Number):void
		{
			support.finishQuadBatch()
			Starling.context.setScissorRectangle(_mask);
			super.render(support,alpha);
			support.finishQuadBatch()
			Starling.context.setScissorRectangle(null);
		}
		
		public function doMask($rect: Rectangle):void {
			_mask = $rect;
		}
		
		protected function createKicker($target: GameObject):void {
			var texture: RenderTexture = new RenderTexture($target.width, $target.height);
			var image: Image = new Image(texture);
			addChild(image);
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