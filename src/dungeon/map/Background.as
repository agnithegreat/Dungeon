package dungeon.map
{
	import assets.BackgroundSegmentUI;
	
	public class Background extends GameObject
	{
		public function Background($width: int, $height: int)
		{
			super();
			
			for (var i: int = 0; i < $width;)
			{
				for (var j: int = 0; j < $height;)
				{
					var segment: BackgroundSegmentUI = new BackgroundSegmentUI();
					_container.addChild(segment);
					segment.x = i;
					segment.y = j;
					j += segment.height;
				}
				i += segment.width;
			}
			
			_container.x = $width-width;
			_container.y = $height-height;
			
			cacheAsBitmap = true;
		}
	}
}