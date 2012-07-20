package dungeon.utils
{
	import dungeon.map.DefaultMap;
	
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class ShadowContainer
	{
		public static function applyShadow($container: Sprite):ShadowContainer {
			return new ShadowContainer($container);
		}
		
		private var _container: Sprite;
		
		private var _shadowContainer: Sprite;
		
		private var _shadow: Shape;
		private var _kickersContainer: Sprite;
		
		public function ShadowContainer($container: Sprite)
		{
			_container = $container;
			
			_shadowContainer = new Sprite();
			_shadowContainer.mouseEnabled = _shadowContainer.mouseChildren = false;
			_shadowContainer.blendMode = BlendMode.LAYER;
			_container.addChild(_shadowContainer);
			
			_shadow = new Shape();
			_shadow.graphics.clear();
			_shadow.graphics.beginFill(0, 0.95);
			_shadow.graphics.drawRect(0,0,DefaultMap.mapWidth,DefaultMap.mapHeight);
			_shadowContainer.addChild(_shadow);
			
			_kickersContainer = new Sprite();
			_kickersContainer.blendMode = BlendMode.ERASE;
			_shadowContainer.addChild(_kickersContainer);
		}
		
		public function addShadowKicker($kicker: ShadowKicker):void {
			_kickersContainer.addChild($kicker);
		}
	}
}