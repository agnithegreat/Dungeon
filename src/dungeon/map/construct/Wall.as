package dungeon.map.construct
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import assets.WallSegmentUI;
	
	public class Wall extends Platform
	{
		private var _leftSided: Boolean;
		
		override public function get z():uint {
			return 0xA0001;
		}
		
		public function Wall($height: int = 100, $isLeftSided: Boolean = true)
		{
			_leftSided = $isLeftSided;
			super(0, $height);
		}
		
		override public function resize($width: int = 0, $height: int = 0):void {
			while (_container.numChildren) {
				_container.removeChildAt(0);
			}
			
			if (!$height) {
				return;
			}
			
			_width = $width;
			_height = $height;
			
			var bg: WallSegmentUI = new WallSegmentUI();
			var bmd: BitmapData = new BitmapData(bg.width, bg.height);
			bmd.draw(bg);
			var texture: Texture = Texture.fromBitmapData(bmd);
			texture.repeat = true;
			
			var ry: Number = _height/bg.height;
			var image: Image = new Image(texture);
			image.setTexCoords(1, new Point(1, 0));
			image.setTexCoords(2, new Point(0, ry));
			image.setTexCoords(3, new Point(1, ry));
			image.scaleX = _leftSided ? 1 : -1;
			image.height *= ry;
			
			_container.addChild(image);
		}
	}
}