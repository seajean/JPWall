package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class Logo extends MovieClip {
		
		
		public function Logo() {
			enterBtn.addEventListener(MouseEvent.CLICK,onEnter);
			// constructor code
		}
		
		private function onEnter(e:MouseEvent):void{
			this.dispatchEvent(new Event("ENTER"));
		}
	}
	
}
