package editor.parts {
	import dungeon.events.GameObjectEvent;
	import starling.events.TouchPhase;
	import starling.events.TouchEvent;
	import starling.display.Sprite;

	/**
	 * @author agnithegreat
	 */
	public class PartsPanel extends Sprite {
		
		private var _parts: Vector.<PartTile>;
		
		public function PartsPanel() {
			_parts = new Vector.<PartTile>();
		}
		
		public function addPart($part: PartTile):void {
			_parts.push($part);
			$part.addEventListener(TouchEvent.TOUCH, handleCreatePart);
			showParts();
		}
		
		private function showParts():void {
			for (var i : int = 0; i < _parts.length; i++) {
				var part: PartTile = _parts[i];
				addChild(part);
				part.y = i*PartTile.tileHeight;
			}
		}

		private function handleCreatePart(e : TouchEvent) : void {
			if (e.touches[0].phase == TouchPhase.BEGAN) {
				dispatchEvent(new GameObjectEvent(GameObjectEvent.OBJECT_CREATE, (e.currentTarget as PartTile).getObject()));
			}
		}
	}
}
