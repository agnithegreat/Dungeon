package dungeon.events
{
	import starling.events.Event;
	
	public class GameObjectEvent extends Event
	{
		public static const TICK: String = "tick_GameObjectEvent";
		
		public static const OBJECT_MOVE: String = "object_move_GameObjectEvent";
		public static const OBJECT_STUCK_X: String = "object_stuck_x_GameObjectEvent";
		public static const OBJECT_STUCK_Y: String = "object_stuck_y_GameObjectEvent";
		public static const OBJECT_DESTROY: String = "object_destroy_GameObjectEvent";
		
		public function GameObjectEvent($type:String, $data: Object = null, $bubbles:Boolean=false)
		{
			super($type, $bubbles, $data);
		}
		
		public function clone():Event {
			return new GameObjectEvent(type, data, bubbles);
		}
	}
}