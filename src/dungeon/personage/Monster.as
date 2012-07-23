package dungeon.personage
{
	import dungeon.events.GameObjectEvent;
	import assets.MonsterUI;
	
	import dungeon.system.GameSystem;

	public class Monster extends Personage
	{
		private static var speed: Number = 2;
		private static var walkRange: int = -1;
		
		private var _startX: int;
		
		public function Monster()
		{
			super(MonsterUI);
		}
		
		override public function init():void {
			super.init();
			
			_startX = x;
			_speedX = speed;
			
			if (Math.random()>0.5) {
				turn(!_side);
			}
			
			addEventListener(GameObjectEvent.OBJECT_STUCK_X, handleStuckX);
		}

		private function handleStuckX(e: GameObjectEvent) : void {
			turn(!_side);
		}
		
		override protected function handleTick(e: GameObjectEvent):void {
			if (walkRange>=0 && Math.abs(x+_speedX-_startX)>walkRange/2) {
				turn(!_side);
			}
			
			move();
			
			var hits: Array = GameSystem.checkPersonageHit(this);
			for (var i: int = 0; i < hits.length; i++) {
				var hit: Personage = hits[i];
				hit.doDamage();
			}
			
			animation();
		}
		
		override public function turn($left: Boolean):void {
			_speedX *= -1;
			super.turn($left);
		}
		
		private function animation():void {
			var date: Date = new Date();
			var mod: Number = date.getTime()/100;
			_personage.scaleX = 1+Math.sin(mod)*0.15+0.15;
//			_personage.scaleY = 1+Math.cos(mod)*0.1-0.1;
		}
	}
}