package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	
	public class GoFullBtn extends MovieClip {
		
		
		public function GoFullBtn() {
			
			//this.stage.addEventListener(Event.REMOVED,onRemove);
			this.buttonMode=true;
			stop();
			this.addEventListener(MouseEvent.CLICK,onClick);
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void{
			
		}
		private function onRemove(e:Event):void{
			
		}
		private function onClick(e:MouseEvent):void{
			
			if(stage.displayState!=StageDisplayState.FULL_SCREEN) {
				this.stage.displayState=StageDisplayState.FULL_SCREEN;
				this.gotoAndStop(2);
			}else {
				this.stage.displayState=StageDisplayState.NORMAL;
				this.gotoAndStop(1);
			}
		}
	}
	
}
