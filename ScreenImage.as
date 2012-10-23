package 
{
	import flash.display.MovieClip;
	import com.seajean.base.RoundImage;
	import flash.events.Event;
	import com.seajean.base.Loading;
	import com.seajean.visual.BlurExBackGround;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import com.seajean.base.RoundRec;
	import flash.geom.Rectangle;
	import com.greensock.easing.Strong;

	public class ScreenImage extends MovieClip
	{
		//private var bg:BlurExBackGround;
		//private var loading:Loading;
		private var prevBtn:NavBtn;
		private var nextBtn:NavBtn;
		private var bigImage:PhotoSlider;
		private var cover:Sprite
		private var closeBtn:CloseBtn;
		private var ctrlPanel:MovieClip;
		
		private var aniBg:RoundRec;
		private var _vo:PhotoVo;
		private var _datas:Vector.<PhotoVo>;
		private var photoDesc:PhotoDesc;
		
		private var showed:Boolean;
		public function ScreenImage()
		{
			
			aniBg=new RoundRec(64,48,15,0x000000,1);
			aniBg.visible=false;
			aniBg.alpha=0;
			var rec:Rectangle=new Rectangle(15,15,34,18);
			aniBg.scale9Grid=rec;
			addChild(aniBg);
			
			
			showed=false;
			
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void{
			
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			//bg=new BlurExBackGround(stage,stage.stageWidth,stage.stageHeight);
			//addChild(bg);
			bigImage=new PhotoSlider();
			addChild(bigImage);
			
			
			cover=new Sprite();
			cover.graphics.beginBitmapFill(new CoverData(),null,true);
			cover.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			cover.graphics.endFill();
			cover.alpha=0.5;
			addChild(cover);
			cover.visible=false;
			
			bigImage.addEventListener(Event.COMPLETE,onImageLoaded);
			
			//==================================
			//CTRL面板
			//===================================
			ctrlPanel=new MovieClip();
			
			prevBtn=new NavBtn();
			nextBtn=new NavBtn();
			prevBtn.rotation=180;
			ctrlPanel.addChild(prevBtn);
			
			
			ctrlPanel.addChild(nextBtn);
			closeBtn=new CloseBtn();
			ctrlPanel.addChild(closeBtn);
			
			prevBtn.y=stage.stageHeight/2+40;
			prevBtn.x=100;
			nextBtn.x=stage.stageWidth-100;
			nextBtn.y=stage.stageHeight/2-20;
			closeBtn.x=stage.stageWidth-30;
			closeBtn.y=-20;
			
			prevBtn.buttonMode=true;
			nextBtn.buttonMode=true;
			closeBtn.buttonMode=true;
			
			addChild(ctrlPanel);
			ctrlPanel.visible=false;
			
			
		
			//====================================
			
			
			//trace("ook")
			
			nextBtn.addEventListener(MouseEvent.CLICK,onNext);
			prevBtn.addEventListener(MouseEvent.CLICK,onPrev);
			
			closeBtn.addEventListener(MouseEvent.CLICK,onClose);
			
			stage.addEventListener(Event.RESIZE,onResize);
			
			
			photoDesc=new PhotoDesc();
			photoDesc.y=stage.stageHeight;
			photoDesc.x=0;
			photoDesc.bg.width=stage.stageWidth;
			addChild(photoDesc);
		}
		
		private function onResize(e:Event):void{
			cover.graphics.clear();
			cover.graphics.beginBitmapFill(new CoverData(),null,true);
			cover.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			cover.graphics.endFill();
			
			
			prevBtn.y=stage.stageHeight/2+40;
			prevBtn.x=100;
			nextBtn.x=stage.stageWidth-100;
			nextBtn.y=stage.stageHeight/2-20;
			closeBtn.x=stage.stageWidth-30;
			closeBtn.y=-20;
			
			photoDesc.y=stage.stageHeight+5;
			photoDesc.x=0;
			photoDesc.bg.width=stage.stageWidth;
			
			//photoDesc.y=0;
			//photoDesc.x=stage.stageWidth;
			//photoDesc.visible=false;
			//addChild(photoDesc);
			
			if(this.showed){
				this.showDesc();
			}
			
			
		}
		
		private function onClose(e:MouseEvent):void{
			this.clear();
			
		}
		
		private function hideDesc(cb:Function=null):void{
			//var callBack=cb;
			TweenLite.to(photoDesc,0.5,{"y":stage.stageHeight+30,"onComplete":function(){
						
						 }});
		}
		
		private function showDesc(){
			//photoDesc.alpha=0;
			
			if(!_vo.desc) return;
			photoDesc.x=0;
			//photoDesc.y=stage.stageHeight-200-Math.random()*100;
			photoDesc.data=_vo;
			TweenLite.to(photoDesc,0.5,{"y":stage.stageHeight-photoDesc.height+5});
		}
		
		private function onPrev(e:MouseEvent):void{
			if(bigImage.loading||bigImage.tweening) return;
			TweenLite.to(photoDesc,0.3,{"y":stage.stageHeight+30,"ease":Strong.easeIn,"onComplete":function(){
						var index=_vo.index-1;
						if(index<0) index=_datas.length-1;
						_vo=_datas[index];
						bigImage.prev(_datas[index].src);
						prevBtn.showLoading();
			 }});
		}
		
		private function onNext(e:MouseEvent):void{
			if(bigImage.loading||bigImage.tweening) return;
			if(bigImage.loading||bigImage.tweening) return;
				TweenLite.to(photoDesc,0.3,{"y":stage.stageHeight+30,"ease":Strong.easeIn,"onComplete":function(){
				var index=_vo.index+1;
				if(index==_datas.length) index=0;
				_vo=_datas[index];
				bigImage.next(_datas[index].src);
				nextBtn.showLoading();
			 }});
		}
		private function onImageClick(e:MouseEvent):void{
			bigImage.clear();
			//bg.clear();
		}
		private function onImageLoaded(e:Event){
			cover.visible=true;
			ctrlPanel.visible=true;
			nextBtn.showArrow();
			prevBtn.showArrow();
			showDesc();
		}
		
		private function hideBack():void{
			ctrlPanel.visible=false;
			var thumb:PhotoThumb=_vo.target;
			showed=false;
			TweenLite.to(aniBg,0.3,{"width":thumb.width,"height":thumb.height,"x":thumb.x,"y":thumb.y,alpha:0.1,onComplete:function(){
					aniBg.visible=false;
					_vo=null;
					//state=PhotoBox.STATE_INIT;
			}});
		}
		public function set photos(vos:Vector.<PhotoVo>):void{
			_datas=vos;
		}
		
		public function get data():PhotoVo{
			return this._vo;
		}
		public function set data(vo:PhotoVo):void{
			aniBg.visible=true;
			var thumb=vo.src;
			aniBg.x=vo.target.x;
			aniBg.y=vo.target.y;
			aniBg.width=vo.target.width;
			aniBg.height=vo.target.height;
			_vo=vo;
			TweenLite.to(aniBg,0.1,{alpha:0.2,"onComplete":function(){
						showed=true;
					 TweenLite.to(aniBg,0.2,{"width":stage.stageWidth+20,"height":stage.stageHeight+20,"x":-10,"y":-10,onComplete:function(){
									bigImage.load(thumb);
									//TweenLite.to(bg,0.5,{alpha:1,ease:Bounce.easeOut});
						}});
			  }});
			  
			this.dispatchEvent(new Event(PhotoEvent.SHOW_LOADING));
		}
		private function clear():void{
			bigImage.clear();
			//bg.clear();
			cover.visible=false;
			hideBack();
			this.photoDesc.y=stage.stageHeight+30;
			
		}
	}
}