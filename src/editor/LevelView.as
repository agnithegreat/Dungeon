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
	
	import flash.net.SharedObject;
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
		
		private var _partsLayer: Sprite;
		private var _resizeLayer: Sprite;
		private var _resizing: ResizingUtil;
		
		private var _partsPanel: PartsPanel;
		
		public function LevelView() {
			_objects = new Dictionary();
			
			_bg = new Quad(1024, 768, 0);
			addChild(_bg);
			
			_partsLayer = new Sprite();
			addChild(_partsLayer);
			
			_resizeLayer = new Sprite();
			addChild(_resizeLayer);
			
			_resizing = new ResizingUtil(_resizeLayer);
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
		
		public function addObject($obj: GameObject):void {
			var id: String = (Math.random()*100000).toString(36);
			_objects[id] = $obj;
			$obj.addEventListener(TouchEvent.TOUCH, handleSelect);
			_partsLayer.addChild($obj);
			
			updateChildrenOrder();
			
			_resizing.edit($obj);
			
			_resizing.move(_bg.width/2, _bg.height/2);
		}

		private function handleCreatePart(e : GameObjectEvent) : void {
			addObject(e.data as GameObject);
		}

		private function handleSelect(e : TouchEvent) : void {
			updateChildrenOrder();
			
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
		
		private function updateChildrenOrder():void {
			var stor: Vector.<GameObject> = new Vector.<GameObject>();
			for each (var obj:GameObject in _objects) 
			{
				stor.push(obj);
				if (obj is Room) {
					var parts: Vector.<GameObject> = (obj as Room).parts;
					stor = stor.concat(parts);
				}
			}
			stor = stor.sort(sort);
			export(stor);
			
			for (var i: int = 0; i < stor.length; i++) 
			{
				_partsLayer.addChild(stor[i]);
			}
			
		}
		
		private function sort($1: GameObject, $2: GameObject):int {
			if ($1.z>$2.z) {
				return 1;
			}
			if ($1.z<$2.z) {
				return -1;
			}
			return 0;
		}
		
		public function export($parts: Vector.<GameObject>):void {
			var so: SharedObject = SharedObject.getLocal("dungeons", "/");
			var map: Array = [];
			for (var i:int = 0; i < $parts.length; i++) 
			{
				if (!($parts[i] as Room)) {
					map.push($parts[i].getData());
				}
			}
			so.data.map = map;
		}
	}
}
