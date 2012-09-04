package dungeon.map.construct
{
	import dungeon.system.GameSystem;

	public class Platform extends Resizable
	{
		override public function get z():uint {
			return 0xA0000;
		}
		
		public function Platform($width: int = 0, $height: int = 0) {
			super($width, $height);
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