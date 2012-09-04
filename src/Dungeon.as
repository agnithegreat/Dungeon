package {
	import dungeon.system.GameScreen;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class Dungeon extends Sprite {
		
		private var _starling: Starling;
		
		public function Dungeon() {
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}

		private function handleAddedToStage(e : Event) : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			GameScreen.screenWidth = stage.stageWidth;
			GameScreen.screenHeight = stage.stageHeight;
			
			_starling = new Starling(Game, stage, new Rectangle(0,0,GameScreen.screenWidth,GameScreen.screenHeight), stage.stage3Ds[0]);
			_starling.showStats = true;
			_starling.start();
		}
	}
}