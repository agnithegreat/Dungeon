package dungeon.map.interaction
{
	import effects.Fire;
	
	import dungeon.system.GameSystem;
	
	public class Torch extends InteractiveObject
	{
		protected var _fire: Fire;
		
		protected var _lighted: Boolean;
		
		public function Torch($lighted: Boolean = false)
		{
			super();
			
			_lighted = $lighted;
			
			_fire = new Fire();
			_fire.pivotX = _fire.width/2;
			_fire.pivotY = _fire.height;
		}
		
		override public function init():void {
			super.init();
			if (_lighted) {
				interact();
			}
		}
		
		override public function interact():void
		{
			_container.addChildAt(_fire, 0);
			_fire.activate();
			
			GameSystem.addShadowKicker(this, 100);
			_lighted = true;
			dispatchMove();
			
			GameSystem.clearInteractive(this);
		}
		
		override public function destroy():void {
			super.destroy();
			
			_container.removeChild(_fire);
			_fire.deactivate();
		}
	}
}