package dungeon.map.interaction
{
	import dungeon.system.GameSystem;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Torch extends InteractiveObject
	{
		protected var _torch: MovieClip;
		
		protected var _lighted: Boolean;
		
		public function Torch()
		{
			super();
			
		}
		
		override public function interact():void
		{
			if (_lighted) {
				return;
			}
			_torch.torch.cacheAsBitmap = true;
			
			_torch.fire.light();
			GameSystem.addShadowKicker(this, 120);
			_lighted = true;
			dispatchMove();
			
			GameSystem.clearInteractive(this);
		}
	}
}