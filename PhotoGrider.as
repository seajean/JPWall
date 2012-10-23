package  {
	
	import flash.display.MovieClip;
	import com.seajean.base.RoundImage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import com.greensock.TweenLite;

	import flash.filters.DropShadowFilter;
	import com.seajean.visual.BlurExBackGround;
	import com.seajean.base.Loading;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.geom.Point;
	import com.greensock.easing.Strong;
	import com.seajean.net.RemoteLoader;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;	
	import flash.geom.Rectangle;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;

	public class PhotoGrider extends MovieClip {
	
		private var thumbContainer:ThumbContainer;
		var centerX:Number;
		var centerY:Number;
		var bigImage:ScreenImage;
		private var tipContainer:Sprite;
		private var tid:uint;
		private var tip:PhotoTip;
		
		private var startMouseX:Number;
		private var startMouseY:Number;
		
		private var bottomBar:BottomBar;
		
		private var botNav:BottomNavPanel;
		
		private var loading:Loading;
		
		public function PhotoGrider(){
			
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdd);
			
		}
		private function onPhotoXmlLoaded(e:PhotoEvent):void{
			var xml:XML=new XML(e.data);
			var photoVector:Vector.<PhotoVo>=new Vector.<PhotoVo>();
			for(var i in xml.img){
				var vo:PhotoVo=new PhotoVo();
				vo.src=xml.img[i].@src;
				vo.thumb=xml.img[i].@thumb;
				vo.desc=xml.img[i].@desc;
				vo.index=uint(i);
				photoVector.push(vo);
			}
			bigImage.photos=photoVector;
			thumbContainer.data=photoVector;
			
			//botNav.x=0;
			//botNav.y=stage.stageHeight-botNav.height+5;
		}
		private function onStageResize(e:Event=null):void{
			this.centerX=int(stage.stageWidth/2);
			this.centerY=int(stage.stageHeight/2);
			this.bottomBar.x=0;
			this.bottomBar.y=stage.stageHeight-bottomBar.height;
			this.bottomBar.width=stage.stageWidth;
			botNav.resize();
			botNav.y=stage.stageHeight-botNav.height+5;
			
			//trace(int(stage.stageWidth/2)+20)
			loading.x=int(stage.stageWidth/2)+20;
			loading.y=stage.stageHeight/2-25;
		}
		private function onAdd(e:Event):void{
			
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			
			stage.addEventListener(Event.RESIZE,onStageResize);
			
			botNav=new BottomNavPanel();
			addChild(botNav);
			botNav.resize();
			
			
			thumbContainer=new ThumbContainer();
			addChild(thumbContainer);
			
			thumbContainer.addEventListener(PhotoEvent.ACTION_THUMB_CLICK,onThumbClick);
			thumbContainer.addEventListener(PhotoEvent.ACTION_THUMB_OVER,onThumbMouseOver);
			thumbContainer.addEventListener(PhotoEvent.ACTION_THUMB_OUT,onThumbMouseOut);
			
			thumbContainer.addEventListener(PhotoEvent.HIDE_LOADING,onHideLoading);
			
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onThumbMouseDown);
			
			
			tipContainer=new Sprite();
			addChild(tipContainer);
			
			
			bigImage=new ScreenImage();
			addChild(bigImage);
			
			bigImage.addEventListener(PhotoEvent.SHOW_LOADING,onShowLoading);
			bigImage.addEventListener(Event.COMPLETE,onHideLoading);
			
			
			loading=new Loading(0,0,0xFFFFFF);
			addChild(loading);
			
			//loading.visible=false;
			
			
			this.centerX=int(stage.stageWidth/2);
			this.centerY=int(stage.stageHeight/2);
			bottomBar=new BottomBar();
			//addChild(bottomBar);
			onStageResize();
			RemoteLoader.notifyer.addEventListener(PhotoEvent.LOAD_PHOTO_XML_SECCESS,onPhotoXmlLoaded);
			RemoteLoader.loadData("http://www.xlfront.com/photo.php",{"t":new Date().getTime()},"GET",PhotoEvent.LOAD_PHOTO_XML_SECCESS);
		}
		private function onShowLoading(e:Event):void{
			this.loading.visible=true;
		}
		
		private function onHideLoading(e:Event):void{
			this.loading.visible=false;
		}
		
		
		private function onThumbMouseDown(e:MouseEvent){
			//this.thumbContainer.startDrag(false,new Rectangle(0,0,0,100));
			startMouseY=e.stageY
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onThumbMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onThumbMouseUp);
		}
		
		private function  onThumbMouseMove(e:MouseEvent):void{
			var yy=e.stageY
			var dis:Number=yy-this.startMouseY;
			//if(dis<0) return;
			var factor:Number=150/stage.stageHeight;
			thumbContainer.y=int(dis*factor);
		}
		private function onThumbMouseUp(e:MouseEvent):void{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onThumbMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onThumbMouseUp);
			if(Math.abs(thumbContainer.y)>60){
				if(thumbContainer.y>0){
					thumbContainer.showNextPage();
				}else{
					thumbContainer.showPrevPage();
				}
			}
			TweenLite.to(thumbContainer,0.8,{"y":0,"ease":Elastic.easeOut});
		}
		private function onThumbMouseOut(e:PhotoEvent):void{
			if(tid) clearTimeout(tid);
			if(!tip) return;
			TweenLite.killTweensOf(tip);
			TweenLite.to(tip,0.5,{"alpha":0,"onComplete":function(){tip.visible=false;}});
		}
		private function onThumbMouseOver(e:PhotoEvent):void{
			var vo:PhotoVo=e.data as PhotoVo;
			var thumb=vo.target;
			if(tid) clearTimeout(tid);
			tid=setTimeout(function(){
						   
			if(bigImage.data) return;
			if(!tip) {
				tip=new PhotoTip();
				tipContainer.addChild(tip);
			}
			
			tip.data=vo;
			tip.visible=true;
			tip.alpha=0;
			tip.x=thumb.x-tip.width+50;
			var dest:Number;
			var destY:Number;
			if(tip.x<=0) {
				dest=thumb.x;
				tip.arrow.x=23;
			}else{
				dest=thumb.x-tip.width+50;
				tip.arrow.x=168;
			}
			
			if(thumb.y-tip.height-30<0){
				tip.arrow.rotation=180;
				tip.arrow.y=0;
				destY=thumb.y+thumb.height+20;
				
				tip.y=thumb.y+thumb.height+80;
			}else{
				tip.arrow.rotation=0;
				tip.arrow.y=120;
				destY=thumb.y-tip.height;
				tip.y=thumb.y-tip.height-30;
			}
			TweenLite.to(tip,0.2,{"alpha":1,"x": dest,"y":destY});
			},500);
		}
		private function onThumbClick(e:PhotoEvent){
			var vo:PhotoVo=e.data as PhotoVo;
			bigImage.data=vo;
		}
		//===========================
		//求最大公因数
		//===========================
		function gcd(a:int,b:int)
		{
 			var  c:int;
			do{
  				c=a%b;
 				a=b;
 				b=c;
			}while(c);
 			return a;
		}
		//============================
	}
	
}
