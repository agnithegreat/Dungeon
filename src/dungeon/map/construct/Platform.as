package dungeon.map.construct
{
	import dungeon.system.GameSystem;
	import dungeon.map.GameObject;

	public class Platform extends GameObject
	{
		override public function addToGameSystem():void {
			GameSystem.registerPlatform(this);
		}
		
		override public function removeFromGameSystem():void {
			GameSystem.clearPlatform(this);
		}
	}
}