package dungeon.map.interaction
{
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import assets.WallTorchUI;
	
	public class WallTorch extends Torch
	{
		public function WallTorch($isLeftSided : Boolean, $lighted : Boolean = false) {
			super($lighted);
			
			var bg: WallTorchUI = new WallTorchUI();
			var bmd: BitmapData = new BitmapData(bg.width, bg.height, true, 0x00000000);
			bmd.draw(bg);
			var texture: Texture = Texture.fromBitmapData(bmd);
			
			var image: Image = new Image(texture);
			_container.scaleX = $isLeftSided ? 1 : -1;
			_container.addChild(image);
			image.pivotY = 44;
			
			_fire.x = 10;
			_fire.y = -40;
		}
	}
}