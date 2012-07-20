package dungeon.battle
{
	import assets.FireballUI;
	
	import dungeon.events.GameObjectEvent;
	import dungeon.map.GameObject;
	import dungeon.personage.Personage;
	import dungeon.system.GameSystem;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Fireball extends GameObject
	{
		private static var speed: Number = 5;
		private static var maxRange: int = 200;
		
		private var _fireball: FireballUI;
		
		private var _caster: Personage;
		
		private var _startX: int;
		
		protected var _timer: Timer;
		
		public function Fireball($caster: Personage)
		{
			super();
			
			_caster = $caster;
			
			_fireball = new FireballUI();
			_fireball.fire.scaleX = _fireball.fire.scaleY = 0.25;
			_fireball.fire.light();
			
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		public function init():void {
			_container.addChild(_fireball);
			_startX = x;
			_timer.start();
			GameSystem.addShadowKicker(this, 50);
		}
		
		protected function handleTimer(e: TimerEvent):void {
			move();
		}
		
		public function move():void {
			x -= speed*scaleX;
			
			if (Math.abs(x-_startX)>maxRange) {
				destroy();
				return;
			}
			
			var hits: Array = GameSystem.checkPersonageHit(this);
			for (var i: int = 0; i < hits.length; i++) {
				var hit: Personage = hits[i];
				if (hit!=_caster) {
					hit.doDamage();
					destroy();
					return;
				}
			}
			
			var collisions: Array = GameSystem.checkCollisions(this);
			if (collisions.length>0) {
				destroy();
				return;
			}
		}
		
		private function destroy():void {
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, handleTimer);
			parent.removeChild(this);
			dispatchEvent(new GameObjectEvent(GameObjectEvent.OBJECT_DESTROY));
		}
	}
}