package dungeon.map.interaction
{
	import dungeon.system.GameSystem;
	import dungeon.map.GameObject;

	public class InteractiveObject extends GameObject
	{
		override public function addToGameSystem():void {
			GameSystem.registerInteractive(this);
		}
		
		override public function removeFromGameSystem():void {
			GameSystem.clearInteractive(this);
		}
		
		public function interact():void {
			
		}
	}
}