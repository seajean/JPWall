package  {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import com.seajean.view.loader.ProgressBar;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.flashandmath.dg.GUI.MovingClouds;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class PhotoAlbumLoader extends MovieClip {
		
		private  var loader:Loader;
		private  var ui:ProgressBar;
		private var state:String;
		private var cloud:MovingClouds;
		
		private var logo:*;
		private var album:*;
		
		private var fullBtn:*;
		
		private static const WELCOME_LOADING:String="welcome_loding";
		private static const ALBUM_LOADING:String="album_loding";
		private static const BG_REMOVING:String="bg_removing";
		import flash.utils.setTimeout;
		public function PhotoAlbumLoader() {
			// constructor code
			
			
			
			//blueBg=new BlueBg();
			//addChild(blueBg);
			
			
			
			
			/*
			//blueBg.x=(stage.stageWidth-800)>>1;
			//blueBg.y=(stage.stageHeight-600)>>1
			
			
			
			*/
			
			
			this.addEventListener(Event.ADDED_TO_STAGE,init);
			
			
			
		}
		
		private function init(e:Event=null):void{
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			
			setTimeout( start,100);
		}
		private function start():void{
			var wd=int(stage.stageWidth/3);
			var ht=int(stage.stageHeight/3);
		
			cloud=new MovingClouds(wd,ht,3,6,true,0x66ccff);
				
			addChild(cloud);
			cloud.width=stage.stageWidth*(1.6);
			cloud.height=stage.stageHeight*1.6;
			ui=new ProgressBar();
			addChild(ui);
			ui.x=stage.stageWidth/2-90;
			ui.y=stage.stageHeight/2-10;
				
			this.addEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.addEventListener(Event.RESIZE,onResize);
			
			this.loadSWF('./index.swf',onComplete);
			state= PhotoAlbumLoader.WELCOME_LOADING;
			this.addEventListener(Event.ENTER_FRAME,onCloudEnterFrame);
		}
		
		
		public static function getClass(clsName:String):Class
		{
			try
			{
				return ApplicationDomain.currentDomain.getDefinition(clsName) as Class;
			}
			catch (p_e:ReferenceError)
			{
				//trace("定义 " + clsName + " 不存在");
				return null;
			}
			return null;
		}
		private function onComplete(e:Event):void{
			var cls:Class=getClass("Logo");
			
			var sound:Class=getClass("BgMusic");
			
			var full:Class=getClass("GoFullBtn");
			fullBtn=new full();
			
			addChild(fullBtn);
			
			fullBtn.x=stage.stageWidth-43;
			fullBtn.y=stage.stageHeight-43;
			//trace(cls)
			if(cls){
				logo=new cls();
				centerMC(logo);
				var music=new sound();
				music.play(0,999);
				logo.addEventListener("ENTER",onEnter);
				//this.
			}
		}
		
		private function onAlbumLoaded(e:Event):void{
			var cls:Class=getClass("PhotoGrider");
			if(cls){
				album=new cls();
			}
		}
		
		private function onEnter(e:Event):void{
			addChild(ui);
			ui.init();
			this.removeChild(logo);
			state=ALBUM_LOADING;
			loadSWF("./testPro.swf",onAlbumLoaded);
		}
		private function centerMC(mc:DisplayObject):void{
			mc.x=(stage.stageWidth-mc.width)>>1;
			mc.y=(stage.stageHeight-mc.height)>>1;
		}
		private function loadSWF(src:String,callback:Function=null):void{
			var context:LoaderContext = new LoaderContext () ;
       			context .applicationDomain= ApplicationDomain . currentDomain ;
				loader=new Loader();
				loader.load(new URLRequest(src),context);
				if(callback!=null) loader.contentLoaderInfo.addEventListener(Event.COMPLETE,callback);
				
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onResize(e:Event=null):void
		{
			
			if(ui){
				ui.x=stage.stageWidth/2-90;
				ui.y=stage.stageHeight/2-10;
			}
			
			resetCloud();
			if(logo) centerMC(logo);
			//bg.reDraw(stage.stageWidth,stage.stageHeight);		
			//grider.redraw();
			
			fullBtn.x=stage.stageWidth-43;
			fullBtn.y=stage.stageHeight-43;
		}
		private function resetCloud(){
			cloud.width=stage.stageWidth*(1.6);
			cloud.height=stage.stageHeight*1.6;
		}
		
		private function onCloudEnterFrame(e:Event):void{
			if(cloud){
				cloud.step();
			}
		}
		
		private function onEnterFrame(e:Event){
			switch(this.state){
				case WELCOME_LOADING:
				 if(ui.stage){
					if(!loader)  return;
					var	b=Math.floor(loader.contentLoaderInfo.bytesLoaded/loader.contentLoaderInfo.bytesTotal*100)/100;
					ui.step(b);
				 }else{
					// onComplete();
						addChild(logo);
						removeEventListener(Event.ENTER_FRAME,onEnterFrame);
						state="1";
				 }
				break;
				case ALBUM_LOADING:
				 if(ui.stage){
					if(!loader)  return;
					var	b2=Math.floor(loader.contentLoaderInfo.bytesLoaded/loader.contentLoaderInfo.bytesTotal*100)/100;
					ui.step(b2);
				 }else{
					 state=BG_REMOVING;
				 }
				 break;
				 
				 case BG_REMOVING:
				  removeEventListener(Event.ENTER_FRAME, onCloudEnterFrame);
				  
				  addChild(album);
						this.swapChildren(fullBtn,this.getChildAt(this.numChildren-1));
					
					/*
				 	cloud.alpha-=0.02;
					if(cloud.alpha<=0.2){
						addChild(album);
						this.swapChildren(fullBtn,this.getChildAt(this.numChildren-1));
					}else if(cloud.alpha<=0){
						
						removeChild(cloud);
						
						stage.removeEventListener(Event.RESIZE,onResize);
						*/
						 state="1";
						 removeEventListener(Event.ENTER_FRAME,onEnterFrame);
					//}
				 break;
			}
		}
	}
	
}
