package dungeon.utils
{
	import starling.display.Quad;
	import dungeon.map.DefaultStarlingMap;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.display.Image;
	import starling.display.BlendMode;
	import starling.display.Sprite;

	public class ShadowContainer
	{
		public static function applyShadow($container: Sprite):ShadowContainer {
			return new ShadowContainer($container);
		}
		
		private var _container: Sprite;
		
		private var _texture: RenderTexture;
		
		private var _quad: Quad;
		
		private var _shadow: Image;
		private var _kickersContainer: Sprite;
		
		public function ShadowContainer($container: Sprite)
		{
			_container = $container;
			
			_texture = new RenderTexture(DefaultStarlingMap.mapWidth, DefaultStarlingMap.mapHeight);
						
			_shadow = new Image(_texture);
			_shadow.alpha = 0.90;
			_container.addChild(_shadow);
			
			_quad = new Quad(DefaultStarlingMap.mapWidth, DefaultStarlingMap.mapHeight, 0x000000);
			
			_kickersContainer = new Sprite();
			_kickersContainer.blendMode = BlendMode.ERASE;
			
			_container.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		public function addShadowKicker($kicker: ShadowKicker):void {
			_kickersContainer.addChild($kicker);
		}

		private function handleEnterFrame(e : Event) : void {
			_texture.clear();
			_texture.draw(_quad);
			_texture.draw(_kickersContainer);
		}
	}
}