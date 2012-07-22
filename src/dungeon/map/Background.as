package dungeon.map
{
	import flash.geom.Point;
	import starling.display.Image;
	import flash.display.BitmapData;
	import starling.textures.Texture;
	import assets.BackgroundSegmentUI;
	
	public class Background extends GameObject
	{
		public function Background($width: int, $height: int)
		{
			super();
			
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