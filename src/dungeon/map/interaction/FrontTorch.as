package dungeon.map.interaction
{
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import assets.TorchUI;

	public class FrontTorch extends Torch
	{
		public function FrontTorch($lighted : Boolean = false) {
			super($lighted);
			
			var bg: TorchUI = new TorchUI();
			var bmd: BitmapData = new BitmapData(bg.width, bg.height, true, 0x00000000);
			bmd.draw(bg);
			var texture: Texture = Texture.fromBitmapData(bmd);
			
			var image: Image = new Image(texture);
			_container.addChild(image);
			image.pivotX = image.width/2;
			image.pivotY = 44;
			
			_fire.x = -1;
			_fire.y = -40;
		}
	}
}