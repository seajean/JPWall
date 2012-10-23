package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class BottomNavPanel extends MovieClip {
		
		
		public function BottomNavPanel() {
			//this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		public function resize():void{
			bg.width=stage.stageWidth;
			y=stage.stageHeight-this.height+5;
		}
	}
	
}
