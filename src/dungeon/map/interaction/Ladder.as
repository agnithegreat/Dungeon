package dungeon.map.interaction
{
	import dungeon.map.construct.IResizable;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import assets.LadderSegmentUI;
	
	public class Ladder extends InteractiveObject implements IResizable
	{
		public function Ladder($height: int = 100)
		{
			super();
			resize(0, $height);
		}
		
		public function resize($width: int = 0, $height: int = 0):void {
			while (_container.numChildren) {
				_container.removeChildAt(0);
			}
			
			if (!$height) {
				return;
			}
			
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