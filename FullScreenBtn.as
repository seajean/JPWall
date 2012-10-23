package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.StageDisplayState;
	
	
	public class FullScreenBtn extends MovieClip {
		
		
		public function FullScreenBtn() {
			this.buttonMode=true;
			stop();
			
			//trace("ook")
			this.addEventListener(MouseEvent.CLICK,onClick);
			// constructor code
		}
		private function onClick(e:MouseEvent):void{
			
			//trace("ok")
			if(stage.displayState!=StageDisplayState.FULL_SCREEN) {
				this.stage.displayState=StageDisplayState.FULL_SCREEN;
				this.gotoAndStop(2);
			}else {
				this.stage.displayState=StageDisplayState.NORMAL;
				this.gotoAndStop(2);
			}
		}
	}
	
}
