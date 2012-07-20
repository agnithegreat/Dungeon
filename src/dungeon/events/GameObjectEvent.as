package dungeon.events
{
	import flash.events.Event;
	
	public class GameObjectEvent extends Event
	{
		public static const OBJECT_MOVE: String = "object_move_GameObjectEvent";
		public static const OBJECT_DESTROY: String = "object_destroy_GameObjectEvent";
		
		public var data: Object
		public function GameObjectEvent($type:String, $data: Object = null, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			data = $data;
			super($type, $bubbles, $cancelable);
		}
		
		override public function clone():Event {
			return new GameObjectEvent(type, data, bubbles, cancelable);
		}
	}
}