package dungeon.map.construct
{
	import dungeon.system.GameSystem;
	import dungeon.map.GameObject;

	public class Platform extends GameObject
	{
		public function Platform()
		{
			super();
			
			GameSystem.registerPlatform(this);
		}
	}
}