package dungeon.utils
{
	import dungeon.map.construct.Background;
	import dungeon.system.GameSystem;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;

	public class ShadowContainer
	{
		private var _container: Sprite;
		
		private var _texture: RenderTexture;
		
		private var _rooms: Dictionary;
		private var _openedRooms: Sprite;
		
		private var _kickersContainer: Sprite;
		
		public function ShadowContainer($container: Sprite, $rect: Rectangle)
		{
			_container = $container;
			
			_texture = new RenderTexture($rect.width, $rect.height);
			
			var shadow: Image = new Image(_texture);
			shadow.alpha = 0.99;
			_container.addChild(shadow);
			
			_rooms = new Dictionary();
			
			_openedRooms = new Sprite();
			
			_kickersContainer = new Sprite();
			_kickersContainer.blendMode = BlendMode.ERASE;
			
			_container.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		public function addShadow($id: String, $rect: Rectangle):void {
			var quad: Quad = new Quad($rect.width, $rect.height, 0x000000);
			quad.x = $rect.x;
			quad.y = $rect.y;
			
			_rooms[$id] = quad;
			_openedRooms.addChild(quad);
			
			changeRoom($id);
		}
		
		public function closeRoom($id: String):void {
			_rooms[$id].visible = false;
		}
		public function openRoom($id: String):void {
			_rooms[$id].visible = true;
		}
		
		public function changeRoom($id: String):void {
			for (var i:int = 0; i < _kickersContainer.numChildren; i++) {
				var kicker: ShadowKicker = _kickersContainer.getChildAt(i) as ShadowKicker;
				
				var rooms: Array = GameSystem.checkRooms(kicker.target);
				
				var room: Quad = rooms.length>0 ? _rooms[rooms[0].id] : _rooms[$id];
				if (!kicker.isGlobal) {
					kicker.doMask(room.getBounds(_openedRooms));
				}
			}
		}
		
		public function addShadowKicker($kicker: ShadowKicker):void {
			_kickersContainer.addChild($kicker);
		}

		private function handleEnterFrame(e : Event) : void {
			_texture.clear();
			_texture.draw(_openedRooms);
			_texture.draw(_kickersContainer);
		}
	}
}