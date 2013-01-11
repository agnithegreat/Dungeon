package dungeon.map
{
	import dungeon.events.GameObjectEvent;
	import dungeon.map.construct.IResizable;
	import dungeon.system.GameSystem;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class GameObject extends Sprite
	{
		private static var instCount: int = 0;
		
		protected var _x: Number;
		override public function set x($x: Number):void {
			_x = $x;
			super.x = _x;
			dispatchMove();
		}
		protected var _y: Number;
		override public function set y($y: Number):void {
			_y = $y;
			super.y = _y;
			dispatchMove();
		}
		
		// z-index for sorting on stage
		public function get z():uint {
			return 0;
		}
		
		protected var _id: String;
		public function get id():String {
			return _id;
		}
		
		protected var _parent: String;
		public function get parentId():String {
			return _parent;
		}
		public function set parentId(pid:String):void {
			_parent = pid;
		}
		
		protected var _container: Sprite;
		public function get container():Sprite {
			return _container;
		}
		
		protected var _appeared: Boolean = false;
		public function get appeared():Boolean {
			return _appeared;
		}
		
		protected var _center: Point;
		public function get center():Point {
			if (!_center) {
				var rect: Rectangle = getBounds(this);
				_center = new Point(rect.x+rect.width/2, rect.y+rect.height/2);
			}
			return _center.add(new Point(x,y));
		}
		
		public function GameObject()
		{
			instCount++;
			
			_container = new Sprite();
			addChild(_container);
			
			_id = getQualifiedClassName(this)+instCount;
		}
		
		public function appear():void {
			_appeared = true;
			visible = true;
		}
		
		public function hide():void {
			_appeared = false;
			visible = false;
		}
		
		public function init():void {
			parseFromObject();
			
			addToGameSystem();
			
			GameSystem.addEventListener(GameObjectEvent.TICK, handleTick);
		}
		
		protected function addToGameSystem():void {
			
		}
		
		protected function removeFromGameSystem():void {
			
		}

		protected function handleTick(e : GameObjectEvent) : void {
		}
		
		public function dispatchMove():void {
			dispatchEvent(new GameObjectEvent(GameObjectEvent.OBJECT_MOVE));
		}
		
		public function hitTestObject($obj: DisplayObject):Boolean {
			return bounds.intersects($obj.bounds);
		}
		
		public function destroy():void {
			removeFromGameSystem();
		}
		
		
		private var _data: Object;
		public function getData():Object {
			_data = {};
			_data.id = id;
			_data.parentId = parentId;
			_data.className = getQualifiedClassName(this);
			_data.x = x;
			_data.y = y;
			_data.w = width;
			_data.h = height;
			return _data;
		}
		
		public function setData($data:Object):void {
			_data = $data;
		}
		
		public function parseFromObject():void {
			if (!_data) {
				return;
			}
			
			_id = _data.id;
			_parent = _data.parentId;
			x = _data.x;
			y = _data.y;
			if (this is IResizable) {
				(this as IResizable).resize(_data.w, _data.h);
			}
		}
	}
}