package editor.tools {
	import dungeon.map.GameObject;
	import dungeon.map.construct.IResizable;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * @author agnithegreat
	 */
	public class ResizingUtil extends Sprite {
		
		public static var border: int = 5;
		
		public static var tileWidth: int = 4;
		public static var tileHeight: int = 4;
		
		private var _bounds: Rectangle;
		
		private var _target: GameObject;
		public function get target():GameObject {
			return _target;
		}
		public function get resizable():IResizable {
			return _target as IResizable;
		}
		
		private var _resizeLayer: Sprite;
		
		private var _objectContainer: Sprite;
		private var _bordersContainer: Sprite;
		
		private var _parent: DisplayObjectContainer;
		private var _position: Point;
		
		private var _topBorder: Quad;
		private var _bottomBorder: Quad;
		private var _leftBorder: Quad;
		private var _rightBorder: Quad;
		private var _screen: Quad;
		
		private var _moveStart: Point;
		
		public function ResizingUtil($resizeLayer: Sprite = null) {
			_resizeLayer = $resizeLayer;
			
			_objectContainer = new Sprite();
			addChild(_objectContainer);
			
			_bordersContainer = new Sprite();
			_bordersContainer.alpha = 0.6;
			addChild(_bordersContainer);
			
			createControls();
		}
		
		private function createControls():void {
			_bounds = new Rectangle(0,0,border,border);
			
			_screen = new Quad(_bounds.width, _bounds.height, 0xFF0000);
			_screen.addEventListener(TouchEvent.TOUCH, handleDrag);
			_screen.alpha = 0.1;
			_bordersContainer.addChild(_screen);
			
			_topBorder = new Quad(_bounds.width, border, 0xFF0000);
			_topBorder.addEventListener(TouchEvent.TOUCH, handleDrag);
			_topBorder.y = -border/2;
			_bordersContainer.addChild(_topBorder);
			
			_bottomBorder = new Quad(_bounds.width, border, 0xFF0000);
			_bottomBorder.addEventListener(TouchEvent.TOUCH, handleDrag);
			_bottomBorder.y = _bounds.height-border/2;
			_bordersContainer.addChild(_bottomBorder);
			
			_leftBorder = new Quad(border, _bounds.height, 0xFF0000);
			_leftBorder.addEventListener(TouchEvent.TOUCH, handleDrag);
			_leftBorder.x = -border/2;
			_bordersContainer.addChild(_leftBorder);
			
			_rightBorder = new Quad(border, _bounds.height, 0xFF0000);
			_rightBorder.addEventListener(TouchEvent.TOUCH, handleDrag);
			_rightBorder.x = _bounds.width-border/2;
			_bordersContainer.addChild(_rightBorder);
		}
		
		public function edit($target: GameObject):void {
			free();
			
			_parent = $target.parent;
			_position = new Point($target.x, $target.y);
			
			_target = $target;
			_target.x = 0;
			_target.y = 0;
			_objectContainer.addChild(_target);
			resize(_target.width, _target.height, false);
			
			if (_resizeLayer) {
				_resizeLayer.addChild(this);
			} else {
				_parent.addChild(this);
			}
		}
		
		public function move($x: int, $y: int):void {
			if (!_bounds) {
				_bounds = new Rectangle();
			}
			
			_bounds.x = Math.round($x/tileWidth)*tileWidth;
			_bounds.y = Math.round($y/tileHeight)*tileHeight;
			
			_target.x = int(_position.x+_bounds.x);
			_target.y = int(_position.y+_bounds.y);
			
			_bordersContainer.x = _target.bounds.x;
			_bordersContainer.y = _target.bounds.y;
		}
		
		public function resize($width: int, $height: int, $update: Boolean = true):void {
			if (!_bounds) {
				_bounds = new Rectangle();
			}
			
			$width = Math.round($width/tileWidth)*tileWidth;
			$height = Math.round($height/tileHeight)*tileHeight;
			
			$width = Math.max($width, border*2);
			$height = Math.max($height, border*2);
			
			_bounds.width = $width;
			_bounds.height = $height;
			
			if ($update && resizable) {
				resizable.resize(_bounds.width, _bounds.height);
			}
			
			_bounds.width = _target.width;
			_bounds.height = _target.height;
			
			move(_bounds.x, _bounds.y);
			
			updateControls();
		}
		
		public function free():void {
			if (parent) {
				parent.removeChild(this);
			}
			if (_target) {
				if (_parent) {
					_parent.addChild(_target);
				}
			}
			_parent = null;
			_position = null;
			_target = null;
			_bounds = null;
		}
		
		private function updateControls():void {
			_screen.width = _bounds.width;
			_screen.height = _bounds.height;
			
			_topBorder.y = -border/2;
			_topBorder.width = _bounds.width;
			_topBorder.height = border;
			
			_bottomBorder.y = _bounds.height-border/2;
			_bottomBorder.width = _bounds.width;
			_bottomBorder.height = border;
			
			_leftBorder.x = -border/2;
			_leftBorder.width = border;
			_leftBorder.height = _bounds.height;
			
			_rightBorder.x = _bounds.width-border/2;
			_rightBorder.width = border;
			_rightBorder.height = _bounds.height;
		}

		private function handleDrag(e : TouchEvent) : void {
			var mouse: Point = new Point(e.touches[0].globalX, e.touches[0].globalY);
			switch (e.touches[0].phase) {
				case TouchPhase.BEGAN:
					_moveStart = mouse;
					break;
				case TouchPhase.MOVED:
					var delta: Point = mouse.subtract(_moveStart);
					
					delta.x = Math.round(delta.x/tileWidth)*tileWidth;
					delta.y = Math.round(delta.y/tileHeight)*tileHeight;
					
					_moveStart.x += delta.x;
					_moveStart.y += delta.y;
				
					switch (e.currentTarget) {
						case _screen:
							move(_bounds.x+delta.x, _bounds.y+delta.y);
							break;
						case _topBorder:
							move(_bounds.x, _bounds.y+delta.y);
							resize(_bounds.width, _bounds.height-delta.y);
							break;
						case _bottomBorder:
							resize(_bounds.width, _bounds.height+delta.y);
							break;
						case _leftBorder:
							move(_bounds.x+delta.x, _bounds.y);
							resize(_bounds.width-delta.x, _bounds.height);
							break;
						case _rightBorder:
							resize(_bounds.width+delta.x, _bounds.height);
							break;
					}
					
					
					break;
				case TouchPhase.ENDED:
					_moveStart = null;
					break;
			}
		}
	}
}
