package dungeon.map.construct
{
	import dungeon.map.GameObject;
	import assets.BackgroundSegmentUI;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Background extends GameObject implements IResizable
	{
		override public function get z():uint {
			return 0xA0;
		}
		
		public function Background($width: int = 100, $height: int = 100)
		{
			super();
			resize($width, $height);
		}
		
		public function resize($width: int = 0, $height: int = 0):void {
			while (_container.numChildren) {
				_container.removeChildAt(0);
			}
			
			if (!$width || !$height) {
				return;
			}
			
			var bg: BackgroundSegmentUI = new BackgroundSegmentUI();
			var bmd: BitmapData = new BitmapData(bg.width, bg.height);
			bmd.draw(bg);
			var texture: Texture = Texture.fromBitmapData(bmd);
			texture.repeat = true;
			
			var rx: Number = $width/bg.width;
			var ry: Number = $height/bg.height;
			var image: Image = new Image(texture);
			image.setTexCoords(1, new Point(rx, 0));
			image.setTexCoords(2, new Point(0, ry));
			image.setTexCoords(3, new Point(rx, ry));
			image.width *= rx;
			image.height *= ry;
			
			_container.addChild(image);
		}
	}
}