package dungeon.map.interaction
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import assets.LadderSegmentUI;
	
	public class Ladder extends InteractiveObject
	{
		public function Ladder($height: int)
		{
			super();
			
			var bg: LadderSegmentUI = new LadderSegmentUI();
			var bmd: BitmapData = new BitmapData(bg.width, bg.height, true, 0x00000000);
			bmd.draw(bg);
			var texture: Texture = Texture.fromBitmapData(bmd);
			texture.repeat = true;
			
			var ry: Number = $height/bg.height;
			var image: Image = new Image(texture);
			image.pivotX = image.width/2;
			image.setTexCoords(1, new Point(1, 0));
			image.setTexCoords(2, new Point(0, ry));
			image.setTexCoords(3, new Point(1, ry));
			image.height *= ry;
			
			_container.addChild(image);
		}
	}
}