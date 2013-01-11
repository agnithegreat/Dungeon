package dungeon.map.interaction
{
	import dungeon.utils.FlickeringLight;
	import dungeon.system.GameSystem;
	
	import effects.Fire;
	
	public class Torch extends InteractiveObject
	{
		protected var _fire: Fire;
		
		protected var _lighted: Boolean;
		
		private var _light: FlickeringLight;
		
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
			
			_light = new FlickeringLight(x, y-height, 100, 0xFFFF99);
			GameSystem.addLight(_light.light);
			_light.start();
			
			GameSystem.clearInteractive(this);
		}
		
		override public function destroy():void {
			super.destroy();
			
			_container.removeChild(_fire);
			_fire.deactivate();
		}
	}
}