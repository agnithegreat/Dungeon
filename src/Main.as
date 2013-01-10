package {
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.display.Sprite;

	import starling.core.Starling;

	public class Main extends Sprite {
		public function Main() {
			if (stage) {
				handleAddedToStage();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			}
		}

		private function handleAddedToStage(event : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			Starling.handleLostContext = true;
			var starling : Starling = new Starling(Game, stage);
			starling.showStats = true;
			starling.start();
		}
	}
}
