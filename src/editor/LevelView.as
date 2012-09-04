package editor {
	import starling.events.TouchPhase;
	import starling.events.TouchEvent;
	import editor.tools.ResizingUtil;
	import starling.display.Quad;
	import dungeon.map.GameObject;
	import flash.utils.Dictionary;
	import starling.display.Sprite;

	/**
	 * @author agnithegreat
	 */
	public class LevelView extends Sprite {
		
		private var _objects: Dictionary;
		
		private var _bg: Quad;
		
		private var _resizing: ResizingUtil;
		
		public function LevelView() {
			_objects = new Dictionary();
			
			_bg = new Quad(1024, 768, 0);
			addChild(_bg);
			
			_resizing = new ResizingUtil();
			_bg.addEventListener(TouchEvent.TOUCH, handleSelect);
		}
		
		public function addObject($id: String, $obj: GameObject):void {
			_objects[$id] = $obj;
			$obj.addEventListener(TouchEvent.TOUCH, handleSelect);
			addChild($obj);
		}

		private function handleSelect(e : TouchEvent) : void {
			if (e.touches[0].phase==TouchPhase.BEGAN) {
				if (_resizing.target==e.currentTarget) {
					return;
				}
				
				_resizing.free();
				
				if (e.currentTarget is GameObject) {
					_resizing.edit(e.currentTarget as GameObject);
					e.stopImmediatePropagation();
				}
			}
		}
	}
}
