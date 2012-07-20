package dungeon.map.interaction
{
	import assets.LadderSegmentUI;
	
	public class Ladder extends InteractiveObject
	{
		public function Ladder($height: int)
		{
			super();
			
			for (var i: int = 0; i < $height;)
			{
				var segment: LadderSegmentUI = new LadderSegmentUI();
				_container.addChild(segment);
				segment.y = i;
				i += segment.height;
			}
			
			_container.y = $height-height;
		}
	}
}