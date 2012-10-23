package  {
	import flash.display.MovieClip;
	import com.seajean.base.RoundImage;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import com.greensock.easing.Strong;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.BlendMode;
	
	public class PhotoSlider extends MovieClip {
		private var curPhoto:BigImage;
		private var nextPhoto:BigImage;
		public var tweening:Boolean=false;
		private var destX:Number=0;
		private var isWaiting:Boolean=false;//加载第一张时淡出效果，设置等待标志
		public var loading:Boolean=false;
		private var isFade:Boolean=false;
		public function PhotoSlider() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void{
			curPhoto=new BigImage();
			curPhoto.iWidth=stage.stageWidth;
			curPhoto.iHeight=stage.stageHeight;
			addChild(curPhoto);
			
			nextPhoto=new BigImage();
			nextPhoto.iWidth=stage.stageWidth;
			nextPhoto.iHeight=stage.stageHeight;
			addChild(nextPhoto);
			
			nextPhoto.x=stage.stageWidth;
			nextPhoto.addEventListener(Event.COMPLETE,go);
			curPhoto.addEventListener(Event.COMPLETE,go);
			
			stage.addEventListener(Event.RESIZE,onResize);
			
		}
		private function onResize(e:Event):void{
			curPhoto.iWidth=stage.stageWidth;
			curPhoto.iHeight=stage.stageHeight;
			nextPhoto.iWidth=stage.stageWidth;
			nextPhoto.iHeight=stage.stageHeight;
			nextPhoto.x=stage.stageWidth;
			curPhoto.redrawFoto();
		}
		private function swap(){
			
			var t:BigImage=nextPhoto;
			nextPhoto=curPhoto;
			curPhoto=t;
			tweening=false;
			this.x=0;
			this.curPhoto.x=0;
			this.nextPhoto.x=stage.stageWidth;
		}
		private function go(e:Event):void{
			loading=false;
			if(!isWaiting){
				if(isFade){
					isFade=false;
					curPhoto.blendMode=BlendMode.ADD;
					TweenLite.to(this.curPhoto,1,{"alpha":0,"onComplete":function(){
								curPhoto.x=nextPhoto.x+stage.stageWidth;
								curPhoto.blendMode=BlendMode.NORMAL;
								curPhoto.alpha=1;
								swap();
								 }});
					return;
				}else{
					TweenLite.to(this.curPhoto,1,{"alpha":1});
					return;
				}
			}
			isWaiting=false;
			curPhoto.alpha=1;
			TweenLite.to(this,0.7,{"x":destX,"onComplete":swap,"ease":Strong.easeInOut});
		}
		public function prev(src:String):void{
			if(tweening||loading) return;
			tweening=true;
			nextPhoto.x=curPhoto.x-stage.stageWidth;
			destX=x+stage.stageWidth;
			nextPhoto.loadImage(src);
			isWaiting=true;
		}
		public function next(src:String):void{
			if(tweening||loading) return;
			tweening=true;
			nextPhoto.x=curPhoto.x+stage.stageWidth;
			isWaiting=true;
			nextPhoto.loadImage(src);
			destX=x-stage.stageWidth;
		}
		public function load(src){
			if(loading) return;
			curPhoto.removeImage();
			curPhoto.alpha=0;
			curPhoto.loadImage(src);
			isWaiting=false;
			loading=true;
		}
		public function fade(src:String):void{
			if(tweening||loading) return;
			tweening=true;
			nextPhoto.x=curPhoto.x;
			if(this.getChildIndex(nextPhoto)>this.getChildIndex(curPhoto)){
				this.swapChildren(nextPhoto,curPhoto);
			}
			
			isWaiting=false;
			this.isFade=true;
			nextPhoto.loadImage(src);
			nextPhoto.alpha=1;
			//destX=x-stage.stageWidth;
		}
		public function clear():void{
			this.curPhoto.removeImage();
			this.nextPhoto.removeImage();
		}
	}
}
