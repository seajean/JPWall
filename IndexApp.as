package  {
	
	import flash.display.MovieClip;
	import com.flashandmath.dg.GUI.MovingClouds;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.media.Sound;
	
	
	public class IndexApp extends MovieClip {
		
		private var cloud:MovingClouds;
		
		private var logo:Logo;
		public function IndexApp() {
			
			
			
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdd);
			var s:Sound=new BgMusic();
			
			var b:GoFullBtn=new GoFullBtn();
			// constructor code
		}
	
		private function onAdd(e:Event):void{
			//new StageScaleMode
			//new StageAlign
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			cloud=new MovingClouds(stage.stageWidth,stage.stageHeight,3,6,false);
			addChild(cloud);
			
			logo=new Logo();
			addChild(logo);
			
			logo.x=(stage.stageWidth-logo.width)>>1;
			logo.y=(stage.stageHeight-logo.height)>>1;
		}
	}
	
}
