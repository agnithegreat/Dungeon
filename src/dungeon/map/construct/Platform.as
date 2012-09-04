package dungeon.map.construct
{
	import dungeon.map.GameObject;
	import dungeon.system.GameSystem;

	public class Platform extends GameObject implements IResizable
	{
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
		}
		
		override protected function removeFromGameSystem():void {
			super.removeFromGameSystem();
			GameSystem.clearPlatform(this);
		}
	}
}