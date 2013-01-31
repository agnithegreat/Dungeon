package dungeon.utils {
    import starling.events.Event;
    import starling.display.Sprite;
    import flash.utils.getTimer;
 
    public class FPSCounter {
		
        private var _last:uint = getTimer();
        private var _ticks:uint = 0;
		
		private var _fps: int = 60;
		public function get fps():int {
			return _fps;
		}
 
        public function FPSCounter(stage: Sprite) {
            stage.addEventListener(Event.ENTER_FRAME, tick);
        }
 
        public function tick(evt:Event):void {
            _ticks++;
            var now:uint = getTimer();
            var delta:uint = now - _last;
            if (delta >= 1000) {
                _fps = _ticks / delta * 1000;
            }
        }
    }
}
