package dungeon.map.construct
{
	import dungeon.map.GameObject;
	
	import flash.geom.Rectangle;

	public class Room extends GameObject implements IResizable
	{
		private var _bg: Background;
		private var _floor: Floor;
		private var _ceil: Floor;
		private var _wallLeft: Wall;
		private var _wallRight: Wall;
		
		public function get parts():Vector.<GameObject> {
			var pts: Vector.<GameObject> = new Vector.<GameObject>();
			pts.push(_bg, _floor,_ceil, _wallLeft, _wallRight);
			return pts;
		}
		
		private var _size: Rectangle;
		
		public function Room($width: int = 100, $height: int = 100)
		{
			_size = new Rectangle();
			
			_bg = new Background();
			addChild(_bg);
			
			_wallLeft = new Wall();
			addChild(_wallLeft);
			
			_wallRight = new Wall(0, true);
			addChild(_wallRight);
			
			_ceil = new Floor();
			addChild(_ceil);
			
			_floor = new Floor();
			addChild(_floor);
			
			resize($width, $height);
		}
		
		public function resize($width: int = 0, $height: int = 0):void {
			_size.width = $width;
			_size.height = $height;
			
			_bg.resize(_size.width, _size.height);
			_floor.resize(_size.width);
			_ceil.resize(_size.width);
			_wallLeft.resize(0,_size.height);
			_wallRight.resize(0, _size.height);
			
			_floor.y = _size.height-_floor.height;
			_wallRight.x = _size.width-_wallRight.width;
		}
	}
}