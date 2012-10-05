package dungeon.map.interaction
{
	import dungeon.map.GameObject;
	import dungeon.system.GameSystem;

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