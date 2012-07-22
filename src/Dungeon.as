package {
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class Dungeon extends Sprite {
		
		public static var gameWidth: int = 768;
		public static var gameHeight: int = 512;
		
		private var _starling: Starling;
		
		public function Dungeon() {
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}

		private function handleAddedToStage(e : Event) : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			_starling = new Starling(Game, stage, new Rectangle(0,0,gameWidth,gameHeight), stage.stage3Ds[0]);
			_starling.showStats = true;
			_starling.start();
		}
	}
}