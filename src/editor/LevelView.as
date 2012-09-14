package editor {
	import dungeon.events.GameObjectEvent;
	import dungeon.map.GameObject;
	import dungeon.map.construct.Room;
	import dungeon.map.interaction.FrontTorch;
	import dungeon.map.interaction.Ladder;
	import dungeon.map.interaction.Torch;
	import dungeon.map.interaction.WallTorch;
	
	import editor.parts.PartTile;
	import editor.parts.PartsPanel;
	import editor.tools.ResizingUtil;
	
	import flash.utils.Dictionary;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * @author agnithegreat
	 */
	public class LevelView extends Sprite {
		
		private var _objects: Dictionary;
		
		private var _bg: Quad;
		
		private var _resizing: ResizingUtil;
		
		private var _partsPanel: PartsPanel;
		
		public function LevelView() {
			_objects = new Dictionary();
			
			_bg = new Quad(1024, 768, 0);
			addChild(_bg);
			
			_resizing = new ResizingUtil();
			_bg.addEventListener(TouchEvent.TOUCH, handleSelect);
			
			_partsPanel = new PartsPanel();
			_partsPanel.addEventListener(GameObjectEvent.OBJECT_CREATE, handleCreatePart);
			_partsPanel.x = 1024;
			addChild(_partsPanel);
			
			_partsPanel.addPart(new PartTile(Room));
			_partsPanel.addPart(new PartTile(FrontTorch));
			_partsPanel.addPart(new PartTile(Ladder));
			_partsPanel.addPart(new PartTile(Torch));
			_partsPanel.addPart(new PartTile(WallTorch));
		}
		
		public function addObject($id: String, $obj: GameObject):void {
			_objects[$id] = $obj;
			$obj.addEventListener(TouchEvent.TOUCH, handleSelect);
			addChild($obj);
		}

		private function handleCreatePart(e : GameObjectEvent) : void {
			addObject("", e.data as GameObject);
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
