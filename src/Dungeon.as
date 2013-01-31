package {
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(frameRate='60')]
	public class Dungeon extends Sprite {
		
		private var _starling: Starling;
		
		public function Dungeon() {
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}

		private function handleAddedToStage(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			Starling.handleLostContext = true;
			_starling = new Starling(Game, stage, new Rectangle(0, 0, 640, 480), null, "auto", "baseline");
			_starling.showStats = true;
			_starling.start();
		}
	}
}