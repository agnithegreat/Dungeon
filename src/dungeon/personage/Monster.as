package dungeon.personage
{
	import assets.MonsterUI;
	
	import dungeon.system.GameSystem;
	
	import flash.events.TimerEvent;

	public class Monster extends Personage
	{
		private static var speed: Number = 2;
		private static var walkRange: int = 100;
		
		private var _startX: int;
		
		public function Monster()
		{
			super(MonsterUI);
		}
		
		override public function init():void {
			_startX = x;
			_speedX = speed;
			
			super.init();
		}
		
		override protected function handleTimer(e: TimerEvent):void {
			if (Math.abs(x+_speedX-_startX)>walkRange/2) {
				turn(!_side);
			}
			
			move();
			
			var hits: Array = GameSystem.checkPersonageHit(this);
			for (var i: int = 0; i < hits.length; i++) {
				var hit: Personage = hits[i];
				hit.doDamage();
			}
		}
		
		override public function turn($left: Boolean):void {
			_speedX *= -1;
			super.turn($left);
		}
	}
}