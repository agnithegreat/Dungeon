package dungeon.map.interaction
{
	import assets.TorchUI;

	public class FrontTorch extends Torch
	{
		public function FrontTorch()
		{
			super();
			
			_torch = new TorchUI();
			_container.addChild(_torch);
		}
	}
}