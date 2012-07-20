package dungeon.map.interaction
{
	import dungeon.system.GameSystem;
	import dungeon.map.GameObject;

	public class InteractiveObject extends GameObject
	{
		public function InteractiveObject()
		{
			super();
			
			GameSystem.registerInteractive(this);
		}
		
		public function interact():void {
			
		}
	}
}