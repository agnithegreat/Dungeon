package dungeon.system
{
	import dungeon.map.GameObject;

	public class GameObjectStorage
	{
		private var _storage: Vector.<GameObject>;
		private var _sections: Object = {};
		
		public function GameObjectStorage()
		{
			_storage = new Vector.<GameObject>();
		}
	}
}