package dungeon.map.construct
{
	import dungeon.system.GameSystem;
	import dungeon.map.GameObject;

	public class Platform extends GameObject
	{
		override public function get z():uint {
			return 0xA0000;
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