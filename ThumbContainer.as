package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import com.seajean.base.RoundImage;
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import com.seajean.base.Loading;
	
	public class ThumbContainer extends MovieClip{
				
		private var posArr:Array;
		
		private var posDictionary:Dictionary;
		private var totalNum:int=0;
		private var square:Number=50;//缩略图的边长
		
		private var horNum:Number=0;
		private var verNum:Number=0;
		private var tip:PhotoTip;
		private var startX:Number;
		private var startY:Number;
		var tid:uint;
		
		private var curIndex:uint=0;
		private var photoData:Vector.<PhotoVo>;
		
		private var position:Vector.<PhotoPosition>;
		private var prevPos:Vector.<PhotoPosition>;
		
		private var loadIndex:int=0;

		public function ThumbContainer() {
			posDictionary=new Dictionary();
			this.addEventListener(Event.ADDED_TO_STAGE,init);
			//this.addEventListener(MouseEvent.CLICK,onClick)
			//this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		
		
		private function init(e:Event):void{
			
			
			
			
			this.stage.addEventListener(Event.RESIZE,onStageResize);
		}
		private function onClick(e:MouseEvent):void{
			//trace(e.target);
		}
		
		public function onStageResize(e:Event=null):void{
			this.clear();
			if(tid) clearTimeout(tid);
			tid=setTimeout(function(){
				resetPos();
			},500);
		}
		private function initPos():void{
			position=PositionUtils.makePosArr(stage,square,5);
		}
		public function resetPos():void{
			initPos();
			//initGrid(this.photoData);
			var i:int=0;
			var len=Math.min(photoData.length,position.length);
			
			for(i=0;i<len;i++){
				var pos=position[i];
				if(i<this.numChildren){
					var foto:PhotoThumb=this.getChildAt(i) as PhotoThumb;
					
					foto.type=pos.type;
					posDictionary[foto]=position[i];
					TweenLite.killTweensOf(foto);
					TweenLite.to(foto,1,{"x":pos.x,"y":pos.y,"ease":Strong.easeOut,"overwrite":1});
				}else{
					addOneThumb(photoData[i],position[i]);
				}
			}
			if(i<numChildren){
				for(;i<numChildren;i++){
					tweenAndRemove(getChildAt(i) as PhotoThumb);
				}
			}
			var firstFoto:PhotoThumb=this.getChildAt(0) as PhotoThumb;
			curIndex=firstFoto.data.index+this.position.length-1;
		}
		public function set data(v:Vector.<PhotoVo>){
			initPos();
			curIndex=0;
			photoData=v;
			initGrid(v);
		}
		
		private function tweenAndRemove(mc:PhotoThumb):void{
			var thumb:PhotoThumb=mc;
			var pos:Point=PositionUtils.randomOutside(stage);
			TweenLite.to(thumb,1,{"x":pos.x,"y":pos.y,"ease":Strong.easeOut,"onComplete":function(){
				thumb.removeEventListener(Event.COMPLETE,onThumbLoaded);
				thumb.removeEventListener(MouseEvent.MOUSE_OVER,onPhotoOver);
				thumb.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
				thumb.parent.removeChild(thumb);
			}});
		}
		public function showNextPage():void{
			if(curIndex>=photoData.length-1) return;
			for(var j=0;j<this.numChildren;j++){
				this.tweenAndRemove(getChildAt(j) as PhotoThumb);
			}
			prevPos=position;
			initPos();
			var index=curIndex++;
			for(var i=0;i<position.length;i++){
				if(index>photoData.length-1) break;
				var pos=position[i];
				addOneThumb(photoData[index],position[i]);
				//trace(photoData[index].index)
				curIndex=photoData[index].index;
				index++;
			}
		}
		public function showPrevPage():void{
			//trace(this.curIndex+"-"+this.position.length)
			if(curIndex-this.position.length<=0){
				return;
			}
			for(var j=0;j<this.numChildren;j++){
				tweenAndRemove(getChildAt(j) as PhotoThumb);
			}
			var startIndex=curIndex-position.length-prevPos.length;
			var index=startIndex<0?0:startIndex;
			position=this.prevPos;
			trace(index+"-"+this.prevPos.length)
			for(var i=0;i<this.prevPos.length;i++){
				var pos=position[i];
				addOneThumb(photoData[index],position[i]);
				curIndex=photoData[index].index;
				index++;
			}
		}
		private function addOneThumb(dt:PhotoVo,pos:PhotoPosition){
			var foto:PhotoThumb=new PhotoThumb();
			foto.data=dt;
			var pos2:Point=PositionUtils.randomOutside(stage);
			foto.x=pos2.x;
			foto.y=pos2.y;
			foto.type=pos.type;
			posDictionary[foto]=pos;
			foto.addEventListener(Event.COMPLETE,onThumbLoaded,false,0,true);
			foto.addEventListener(MouseEvent.MOUSE_OVER,onPhotoOver,false,0,true);
			foto.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
			addChild(foto);
		}
		
		private function initGrid(dt:Vector.<PhotoVo>):void{
			var len=Math.min(dt.length,position.length);
			for(var i:int=0;i<len;i++){
				addOneThumb(dt[i],position[i]);
				curIndex++;
			}
		}
		private function onPhotoOver(e:MouseEvent):void{
			var tar:PhotoThumb=e.currentTarget as PhotoThumb;
			if(!tar.data.desc) return;
			
			dispatchEvent(new PhotoEvent(PhotoEvent.ACTION_THUMB_OVER,tar.data,true,false));
		}
		private function onMouseOut(e:MouseEvent):void{
			var tar:PhotoThumb=e.currentTarget as PhotoThumb;
			this.dispatchEvent(new PhotoEvent(PhotoEvent.ACTION_THUMB_OUT,tar.data,true,false));
		}
		private function onThumbLoaded(e:Event):void{
			var foto:PhotoThumb=e.currentTarget  as PhotoThumb;
			var pos:PhotoPosition=posDictionary[foto];
			if(loadIndex==0) this.dispatchEvent(new Event(PhotoEvent.HIDE_LOADING));
			loadIndex++;
			TweenLite.to(foto,1,{"x":pos.x,"y":pos.y,"ease":Strong.easeOut,"overwrite":1});
		}
		public function clear():void{
			for(var i=0;i<this.numChildren;i++){
				var desX:Number;
				var desY:Number;
				var foto=this.getChildAt(i);
				desY=Math.random()*stage.stageHeight;
				desX=Math.random()*stage.stageWidth;
				var This=this;
				TweenLite.killTweensOf(foto);
				TweenLite.to(foto,0.8,{"x":desX,"y":desY,"ease":Strong.easeOut,"overwrite":1,"onComplete":function(){
							// trace(foto.stage);
							//This.removeChild(foto);
				}});
			}
		}
	}
	
}
