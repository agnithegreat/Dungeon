package dungeon.map.construct
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import assets.WallSegmentUI;
	
	public class Wall extends Platform
	{
		public function Wall($height: int, $isLeftSided: Boolean)
		{
			super();
			
			var bg: WallSegmentUI = new WallSegmentUI();
			var bmd: BitmapData = new BitmapData(bg.width, bg.height);
			bmd.draw(bg);
			var texture: Texture = Texture.fromBitmapData(bmd);
			texture.repeat = true;
			
			var ry: Number = $height/bg.height;
			var image: Image = new Image(texture);
			image.setTexCoords(1, new Point(1, 0));
			image.setTexCoords(2, new Point(0, ry));
			image.setTexCoords(3, new Point(1, ry));
			image.scaleX = $isLeftSided ? 1 : -1;
			image.height *= ry;
			
			_container.addChild(image);
		}
	}
}