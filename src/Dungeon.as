package
{
	import dungeon.system.GameSystem;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import utils.FPSCounter;
	
	public class Dungeon extends Sprite
	{
		public function Dungeon()
		{
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		private function handleAddedToStage(e: Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 40;
			
			var view: Sprite = new Sprite();
			addChild(view);
			GameSystem.init(view);
			
			addChild(new FPSCounter(0,0,0x000000,true,0xFFFFFF));
		}
	}
}