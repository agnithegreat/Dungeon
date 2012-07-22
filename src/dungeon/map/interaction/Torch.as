package dungeon.map.interaction
{
	import effects.Fire;
	
	import dungeon.system.GameSystem;
	
	public class Torch extends InteractiveObject
	{
		protected var _fire: Fire;
		
		protected var _lighted: Boolean;
		
		public function Torch()
		{
			super();
			
			_fire = new Fire();
			_fire.pivotX = _fire.width/2;
			_fire.pivotY = _fire.height;
		}
		
		override public function interact():void
		{
			if (_lighted) {
				return;
			}
			
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