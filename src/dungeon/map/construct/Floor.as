package dungeon.map.construct
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import assets.FloorSegmentUI;
	
	public class Floor extends Platform
	{
		public function Floor($width: int)
		{
			super();
			
			var bg: FloorSegmentUI = new FloorSegmentUI();
			var bmd: BitmapData = new BitmapData(bg.width, bg.height);
			bmd.draw(bg);
			var texture: Texture = Texture.fromBitmapData(bmd);
			texture.repeat = true;
			
			var rx: Number = $width/bg.width;
			var image: Image = new Image(texture);
			image.setTexCoords(1, new Point(rx, 0));
			image.setTexCoords(2, new Point(0, 1));
			image.setTexCoords(3, new Point(rx, 1));
			image.width *= rx;
			
			_container.addChild(image);
		}
	}
}