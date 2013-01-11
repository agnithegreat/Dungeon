package dungeon.map.construct
{
	import starling.display.Quad;
	import starling.extensions.lighting.geometry.QuadShadowGeometry;
	import starling.extensions.lighting.core.ShadowGeometry;
	import dungeon.map.GameObject;
	import dungeon.system.GameSystem;

	public class Platform extends GameObject implements IResizable {
		
		private var _shadow: ShadowGeometry;
		
		override public function get z():uint {
			return 0xA0000;
		}
		
		public function Platform($width: int = 0, $height: int = 0) {
			super();
			resize($width, $height);
		}
		
		public function resize($width: int = 0, $height: int = 0):void {
		}
		
		override protected function addToGameSystem():void {
			super.addToGameSystem();
			GameSystem.registerPlatform(this);
			
			var platform: Quad = new Quad(width, height);
			platform.x = x;
			platform.y = y;
			_shadow = new QuadShadowGeometry(platform);
			GameSystem.addShadowObject(_shadow);
		}
		
		override protected function removeFromGameSystem():void {
			super.removeFromGameSystem();
			GameSystem.clearPlatform(this);
		}
	}
}