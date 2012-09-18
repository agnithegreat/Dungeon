package dungeon.map.construct
{
	import dungeon.map.GameObject;
	
	import flash.geom.Rectangle;

	public class Room extends GameObject implements IResizable
	{
		override public function set x($x: Number):void {
			_bg.x = $x;
			_wallLeft.x = $x;
			_wallRight.x = $x + _size.width-_wallRight.width;
			_ceil.x = $x;
			_floor.x = $x;
			
			super.x = $x;
		}
		override public function set y($y: Number):void {
			_bg.y = $y;
			_wallLeft.y = $y;
			_wallRight.y = $y;
			_ceil.y = $y;
			_floor.y = $y + _size.height-_floor.height;
			
			super.y = $y;
		}
		
		override public function get z():uint {
			return 0xA00000;
		}
		
		private var _bg: Background;
		private var _wallLeft: Wall;
		private var _wallRight: Wall;
		private var _floor: Floor;
		private var _ceil: Floor;
		
		private var _form: Background;
		
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
			
			_form = new Background();
			_form.alpha = 0;
			addChild(_form);
			
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
			
			_form.width = $width;
			_form.height = $height;
		}
	}
}