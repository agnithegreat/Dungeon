package editor.tools
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	
	public class ResizingPanel extends Sprite
	{
		public static const UPDATE: String = "update_ResizingPanel";
		
		private var _fields: Dictionary;
		
		public function ResizingPanel()
		{
			super();
			
			graphics.lineStyle(2);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0,0,130,120);
			
			_fields = new Dictionary();
			addField("x", 5);
			addField("y", 35);
			addField("w", 65);
			addField("h", 95);
		}
		
		private function addField($id: String, $y: int):void {
			var name: TextField = new TextField();
			name.x = 5;
			name.y = $y;
			name.width = 20;
			name.height = 20;
			name.text = $id+":";
			addChild(name);
			
			var input: TextField = new TextField();
			input.type = TextFieldType.INPUT;
			input.border = true;
			input.background = true;
			input.backgroundColor = 0xFFFFFF;
			input.addEventListener(Event.CHANGE, handleChange);
			input.x = 25;
			input.y = $y;
			input.width = 100;
			input.height = 20;
			addChild(input);
			_fields[$id] = input;
		}
		
		protected function handleChange(e:Event):void
		{
			dispatchEvent(new Event(UPDATE));
		}
		
		public function updateInfo($bounds: Rectangle):void {
			_fields["x"].text = String($bounds.x);
			_fields["y"].text = String($bounds.y);
			_fields["w"].text = String($bounds.width);
			_fields["h"].text = String($bounds.height);
		}
		
		public function getData():Object {
			return {
				x: _fields["x"].text,
				y: _fields["y"].text,
				w: _fields["w"].text,
				h: _fields["h"].text
			}
		}
	}
}