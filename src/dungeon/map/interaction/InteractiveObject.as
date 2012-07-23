package dungeon.map.interaction
{
	import dungeon.system.GameSystem;
	import dungeon.map.GameObject;

	public class InteractiveObject extends GameObject
	{
		override public function get z():uint {
			return 0xA00;
		}
		
		override protected function addToGameSystem():void {
			super.addToGameSystem();
			GameSystem.registerInteractive(this);
		}
		
		override protected function removeFromGameSystem():void {
			super.removeFromGameSystem();
			GameSystem.clearInteractive(this);
		}
		
		public function interact():void {
			
		}
	}
}