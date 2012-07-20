package dungeon.map.interaction
{
	import assets.WallTorchUI;
	
	import dungeon.system.GameSystem;
	
	import flash.display.Sprite;
	
	public class WallTorch extends Torch
	{
		public function WallTorch($isLeftSided: Boolean)
		{
			super();
			
			_torch = new WallTorchUI();
			_container.addChild(_torch);
			_container.scaleX = $isLeftSided ? 1 : -1
		}
	}
}