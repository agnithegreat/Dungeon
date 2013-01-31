package dungeon.map.construct {
	import nape.dynamics.InteractionFilter;
	import nape.callbacks.CbType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import starling.display.Quad;
	import starling.extensions.lighting.geometry.QuadShadowGeometry;
	import starling.extensions.lighting.core.ShadowGeometry;
	import dungeon.map.GameObject;
	import dungeon.system.GameSystem;

	public class Platform extends GameObject implements IResizable {
		
		public static const PLATFORM: CbType = new CbType();
		public static const PLATFORM_FILTER: InteractionFilter = new InteractionFilter(0x0010, ~0x0010);
		
		private var _shadow: ShadowGeometry;
		
		override public function get z():uint {
			return 0xA0000;
		}
		
		public function Platform($width: int = 0, $height: int = 0) {
			super();
			resize($width, $height);
		}
		
		override protected function initBody():void {
			super.initBody();
			
			_body.cbType = PLATFORM;
			
			_shape = new Polygon(Polygon.box(width, height), new Material(0, 100, 100, 100, 0), PLATFORM_FILTER);
			_shape.body = _body;
		}
		
		public function resize($width: int = 0, $height: int = 0):void {
		}
		
		override protected function addToGameSystem():void {
			super.addToGameSystem();
			GameSystem.registerPlatform(this);
			
			var platform: Quad = new Quad(width-12, height-12);
			platform.x = x+6;
			platform.y = y+6;
			_shadow = new QuadShadowGeometry(platform);
			GameSystem.addShadowGeometry(_shadow);
		}
		
		override protected function removeFromGameSystem():void {
			super.removeFromGameSystem();
			GameSystem.clearPlatform(this);
		}
	}
}