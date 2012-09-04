package editor {
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import starling.core.Starling;
	import flash.display.Sprite;
	
	/**
	 * @author agnithegreat
	 */
	public class LevelEditorTool extends Sprite {
		
		private var _starling: Starling;
		
		public function LevelEditorTool() {
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}

		private function handleAddedToStage(e : Event) : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			_starling = new Starling(LevelEditor, stage, new Rectangle(0,0,stage.stageWidth, stage.stageHeight), stage.stage3Ds[0]);
			_starling.showStats = true;
			_starling.start();
		}
	}
}
