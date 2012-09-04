package editor.tools {
	import dungeon.map.GameObject;
	import dungeon.map.construct.Resizable;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * @author agnithegreat
	 */
	public class ResizingUtil extends Sprite {
		
		public static var border: int = 5;
		public static var manualDelta: int = 2;
		
		private var _bounds: Rectangle;
		
		private var _target: GameObject;
		public function get target():GameObject {
			return _target;
		}
		public function get resizable():Resizable {
			return _target as Resizable;
		}
		
		private var _objectContainer: Sprite;
		private var _bordersContainer: Sprite;
		
		private var _parent: DisplayObjectContainer;
		private var _position: Point;
		
		private var _topBorder: Quad;
		private var _bottomBorder: Quad;
		private var _leftBorder: Quad;
		private var _rightBorder: Quad;
		private var _screen: Quad;
		
		private var _moveCache: Point;
		
		private var _ctrlState: Boolean;
		private var _pushed: Dictionary;
		
		private var _resizingPanel: ResizingPanel;
		
		public function ResizingUtil() {
			_objectContainer = new Sprite();
			addChild(_objectContainer);
			
			_bordersContainer = new Sprite();
			_bordersContainer.alpha = 0.6;
			addChild(_bordersContainer);
			
			_resizingPanel = new ResizingPanel();
			_resizingPanel.x = 1024;
			
			createControls();
		}
		
		private function createControls():void {
			_bounds = new Rectangle(0,0,border,border);
			
			_screen = new Quad(_bounds.width, _bounds.height, 0xFF0000);
			_screen.addEventListener(TouchEvent.TOUCH, handleDrag);
			_screen.alpha = 0.1;
			_bordersContainer.addChild(_screen);
			
			_topBorder = new Quad(_bounds.width, border, 0xFF0000);
			_topBorder.addEventListener(TouchEvent.TOUCH, handleDragUp);
			_topBorder.y = -border/2;
			_bordersContainer.addChild(_topBorder);
			
			_bottomBorder = new Quad(_bounds.width, border, 0xFF0000);
			_bottomBorder.addEventListener(TouchEvent.TOUCH, handleDragDown);
			_bottomBorder.y = _bounds.height-border/2;
			_bordersContainer.addChild(_bottomBorder);
			
			_leftBorder = new Quad(border, _bounds.height, 0xFF0000);
			_leftBorder.addEventListener(TouchEvent.TOUCH, handleDragLeft);
			_leftBorder.x = -border/2;
			_bordersContainer.addChild(_leftBorder);
			
			_rightBorder = new Quad(border, _bounds.height, 0xFF0000);
			_rightBorder.addEventListener(TouchEvent.TOUCH, handleDragRight);
			_rightBorder.x = _bounds.width-border/2;
			_bordersContainer.addChild(_rightBorder);
		}
		
		public function edit($target: GameObject):void {
			Starling.current.nativeOverlay.addChild(_resizingPanel);
			_resizingPanel.addEventListener(ResizingPanel.UPDATE, handleResize);
			
			_parent = $target.parent;
			_position = new Point($target.x, $target.y);
			
			_target = $target;
			_target.x = 0;
			_target.y = 0;
			_objectContainer.addChild(_target);
			resize(_target.width, _target.height, false);
			
			_parent.addChild(this);
			
			addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			_pushed = new Dictionary();
		}
		
		protected function handleResize(e:Event):void
		{
			var data: Object = _resizingPanel.getData();
			move(data.x, data.y);
			resize(data.w, data.h);
		}
		
		private function handleKeyDown(e: KeyboardEvent):void {
/*			if (_pushed[e.keyCode]) {
				return;
			}*/
			_pushed[e.keyCode] = true;
			switch (e.keyCode) {
				case Keyboard.CONTROL:
					_ctrlState = true;
					break;
				case Keyboard.LEFT:
					move(_bounds.x-manualDelta, _bounds.y);
					if (_ctrlState) {
						resize(_bounds.width+manualDelta, _bounds.height);
					}
					break;
				case Keyboard.RIGHT:
					if (_ctrlState) {
						resize(_bounds.width+manualDelta, _bounds.height);
					} else {
						move(_bounds.x+manualDelta, _bounds.y);
					}
					break;
				case Keyboard.UP:
					move(_bounds.x, _bounds.y-manualDelta);
					if (_ctrlState) {
						resize(_bounds.width, _bounds.height+manualDelta);
					}
					break;
				case Keyboard.DOWN:
					if (_ctrlState) {
						resize(_bounds.width, _bounds.height+manualDelta);
					} else {
						move(_bounds.x, _bounds.y+manualDelta);
					}
					break;
			}
		}
		private function handleKeyUp(e: KeyboardEvent):void {
			delete _pushed[e.keyCode];
			
			switch (e.keyCode) {
				case Keyboard.CONTROL:
					_ctrlState = false;
					break;
			}
		}
		
		public function move($x: int, $y: int):void {
			if (!_bounds) {
				_bounds = new Rectangle();
			}
			
			_bounds.x = $x;
			_bounds.y = $y;
			
			x = int(_position.x+_bounds.x);
			y = int(_position.y+_bounds.y);
			
			_resizingPanel.updateInfo(_bounds);
		}
		
		public function resize($width: int, $height: int, $update: Boolean = true):void {
			if (!_bounds) {
				_bounds = new Rectangle();
			}
			
			$width = Math.max($width, border*2);
			$height = Math.max($height, border*2);
			
			_bounds.width = $width;
			_bounds.height = $height;
			
			if ($update && resizable) {
				resizable.resize(_bounds.width, _bounds.height);
			}
			
			_bounds.width = resizable.width;
			_bounds.height = resizable.height;
			
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
				_target.x = x;
				_target.y = y;
			}
			_parent = null;
			_position = null;
			_target = null;
			_bounds = null;
			
			removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			_pushed = null;
			
			if (_resizingPanel.parent) {
				_resizingPanel.removeEventListener(ResizingPanel.UPDATE, handleResize);
				Starling.current.nativeOverlay.removeChild(_resizingPanel);
			}
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
			var newMove: Point = new Point(e.touches[0].globalX, e.touches[0].globalY);
			switch (e.touches[0].phase) {
				case TouchPhase.BEGAN:
					_moveCache = newMove;
					break;
				case TouchPhase.MOVED:
					move(_bounds.x+newMove.x-_moveCache.x, _bounds.y+newMove.y-_moveCache.y);
					_moveCache = newMove;
					break;
				case TouchPhase.ENDED:
					_moveCache = null;
					break;
			}
		}
		private function handleDragUp(e : TouchEvent) : void {
			var newMove: Point = new Point(e.touches[0].globalX, e.touches[0].globalY);
			switch (e.touches[0].phase) {
				case TouchPhase.BEGAN:
					_moveCache = newMove;
					break;
				case TouchPhase.MOVED:
					move(_bounds.x, _bounds.y+newMove.y-_moveCache.y);
					resize(_bounds.width, _bounds.height-newMove.y+_moveCache.y);
					_moveCache = newMove;
					break;
				case TouchPhase.ENDED:
					_moveCache = null;
					break;
			}
		}
		private function handleDragDown(e : TouchEvent) : void {
			var newMove: Point = new Point(e.touches[0].globalX, e.touches[0].globalY);
			switch (e.touches[0].phase) {
				case TouchPhase.BEGAN:
					_moveCache = newMove;
					break;
				case TouchPhase.MOVED:
					resize(_bounds.width, _bounds.height+newMove.y-_moveCache.y);
					_moveCache = newMove;
					break;
				case TouchPhase.ENDED:
					_moveCache = null;
					break;
			}
		}
		private function handleDragLeft(e : TouchEvent) : void {
			var newMove: Point = new Point(e.touches[0].globalX, e.touches[0].globalY);
			switch (e.touches[0].phase) {
				case TouchPhase.BEGAN:
					_moveCache = newMove;
					break;
				case TouchPhase.MOVED:
					move(_bounds.x+newMove.x-_moveCache.x, _bounds.y);
					resize(_bounds.width-newMove.x+_moveCache.x, _bounds.height);
					_moveCache = newMove;
					break;
				case TouchPhase.ENDED:
					_moveCache = null;
					break;
			}
		}
		private function handleDragRight(e : TouchEvent) : void {
			var newMove: Point = new Point(e.touches[0].globalX, e.touches[0].globalY);
			switch (e.touches[0].phase) {
				case TouchPhase.BEGAN:
					_moveCache = newMove;
					break;
				case TouchPhase.MOVED:
					resize(_bounds.width+newMove.x-_moveCache.x, _bounds.height);
					_moveCache = newMove;
					break;
				case TouchPhase.ENDED:
					_moveCache = null;
					break;
			}
		}
	}
}
