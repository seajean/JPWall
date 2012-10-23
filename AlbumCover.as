package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
		import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import com.seajean.view.visual.Grider;
	import com.seajean.net.RemoteLoader;
	import flash.events.MouseEvent;
	import com.charis.view.AlbumSelectPanel;
	import com.greensock.TweenLite;
	import com.charis.data.OneAlbumData;
	import com.charis.constant.CharisConstant;
	import flash.events.KeyboardEvent;
	
	public class AlbumCover extends MovieClip {
		private var  patternImage:PhotoSlider;
		private var pattern:Sprite;
		private var grider:Grider;
		private var topBanner:TopBanner;
		
		private var prevBtn:ArrowBtn;
		private var nextBtn:ArrowBtn;
		
		
		private var ctrlPanel:MovieClip;
		
		var photoVector:Vector.<PhotoVo>;
		
		var _vo:PhotoVo;
		
		private var albumPanel:AlbumSelectPanel;
		
		private var albumNavBtn:AlbumNavBtn;
		
		private var albumVector:Vector.<OneAlbumData>;
		
		private var curIndex:int;
		public function AlbumCover() {
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			
			
			 patternImage=new PhotoSlider();
			addChild( patternImage);
			// patternImage.addEventListener(Event.COMPLETE,onImageLoaded);
			patternImage.load("22.jpg");
			
			pattern=new Sprite();
			pattern.graphics.beginBitmapFill(new CoverData(),null,true);
			pattern.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			pattern.graphics.endFill();
			//pattern.alpha=0.5;
			addChild(pattern);
			
			
			
			grider=new Grider();
			addChild(grider);
			
			
			albumVector=new Vector.<OneAlbumData>;
			//pattern.visible=false;
			this.addEventListener(Event.ADDED_TO_STAGE,init);
			
			
		}
		private function onAlbumClick(e:PhotoEvent):void{
			var data:OneAlbumData=e.data as OneAlbumData;
			this.photoVector=data.photos;
			_vo=photoVector[0];
			this.curIndex=0;
			patternImage.fade(photoVector[0].src);
			
		}
		private function init(e:Event):void{
			
			topBanner=new TopBanner();
			addChild(topBanner);
			topBanner.y=80;
			topBanner.x=stage.stageWidth-topBanner.width;
			
			grider.redraw();
			
			
			//==================================
			//CTRL面板
			//===================================
			ctrlPanel=new MovieClip();
			
			prevBtn=new ArrowBtn();
			nextBtn=new ArrowBtn();
			prevBtn.rotation=180;
			ctrlPanel.addChild(prevBtn);
			
			
			ctrlPanel.addChild(nextBtn);
			
		
			
			prevBtn.buttonMode=true;
			nextBtn.buttonMode=true;
			
			
			albumNavBtn=new AlbumNavBtn();
			albumNavBtn.buttonMode=true;
			
			ctrlPanel.addChild(albumNavBtn);
			
			addChild(ctrlPanel);
			
			
			albumPanel=new AlbumSelectPanel();
			addChild(albumPanel);
			albumPanel.addEventListener(CharisConstant.PHOTO_ALBUM_CLICK,onAlbumClick);
			
			resetPos();
			//ctrlPanel.visible=false;
			
			nextBtn.addEventListener(MouseEvent.CLICK,onNext);
			prevBtn.addEventListener(MouseEvent.CLICK,onPrev);
			albumNavBtn.addEventListener(MouseEvent.CLICK,onAlbumNavClick);
			
			stage.addEventListener(Event.RESIZE,onResize);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyPress);
			//var c:RemoteLoader
			RemoteLoader.notifyer.addEventListener(PhotoEvent.LOAD_PHOTO_XML_SECCESS,onPhotoXmlLoaded);
			RemoteLoader.loadData("http://www.xlfront.com/charis.php",{"t":new Date().getTime()},"GET",PhotoEvent.LOAD_PHOTO_XML_SECCESS);
		}
		private function onKeyPress(e:KeyboardEvent):void{
			switch(e.keyCode){
				case 39:
					onNext();
				break;
				case 37:
					onPrev();
				break;
			}
		}
		
		private function onPhotoXmlLoaded(e:PhotoEvent):void{
			var xml:XML=new XML(e.data);
			photoVector=new Vector.<PhotoVo>;
			var pIndex:int=0;
			for(var index:String in xml.album){
				var album=xml.album[index];
				var albumData:OneAlbumData=new OneAlbumData();
				albumData.id=xml.album[index].@name;
				albumData.title=xml.album[index].@name;
				var pv=new Vector.<PhotoVo>();
				for(var i in album.img){
					var vo:PhotoVo=new PhotoVo();
					vo.src=album.img[i].@src;
					
					vo.thumb=album.img[i].@thumb;
					vo.desc=album.img[i].@desc;
					vo.index=uint(pIndex);
					pv.push(vo);
					photoVector.push(vo);
					pIndex++;
				}
				albumData.photos=pv;
				
				albumVector.push(albumData);
			}
			this.albumPanel.albumData=albumVector;
		}
		private function onResize(e:Event):void{
			
			
			 pattern.graphics.clear();
			 pattern.graphics.beginBitmapFill(new CoverData(),null,true);
			 pattern.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			 pattern.graphics.endFill();
			 
			 grider.redraw();
			 
			 
			resetPos();
			
		}
		private function onAlbumNavClick(e:MouseEvent):void{
			albumPanel.x=e.currentTarget.x-40;
			albumPanel.y=e.currentTarget.y-albumPanel.showHeight;
			
			if(albumPanel.isShow){
				albumPanel.hideBack();
			}else{
				albumPanel.showOut();
			}
		}
		private function onPrev(e:MouseEvent=null):void{
			if(patternImage.loading||patternImage.tweening) return;
			//TweenLite.to(photoDesc,0.3,{"y":stage.stageHeight+30,"ease":Strong.easeIn,"onComplete":function(){
						//var index=_vo?_vo.index-1:photoVector.length-1;
						
						curIndex--;
						if(curIndex<0){
							curIndex=photoVector.length-1;
						}
						
						_vo=photoVector[curIndex];
						//trace(index)
						patternImage.prev(photoVector[curIndex].src);
						//prevBtn.showLoading();
			// }});
		}
		
		private function onNext(e:MouseEvent=null):void{
			if(patternImage.loading||patternImage.tweening) return;
			//if(patternImage.loading||patternImage.tweening) return;
				//TweenLite.to(photoDesc,0.3,{"y":stage.stageHeight+30,"ease":Strong.easeIn,"onComplete":function(){
				curIndex++;
				
				if(curIndex>=photoVector.length) curIndex=0;
			
				
				_vo=photoVector[curIndex];
				patternImage.next(photoVector[curIndex].src);
				//nextBtn.showLoading();
			// }});
		}
		
		private function resetPos():void{
			
			topBanner.y=80;
			topBanner.x=stage.stageWidth-topBanner.width;
			
			
			
			nextBtn.x=stage.stageWidth-55;
			//nextBtn.y=stage.stageHeight/2-40;
			
			
			albumNavBtn.x=stage.stageWidth-95;
			albumNavBtn.y=stage.stageHeight-55;
			
			prevBtn.x=stage.stageWidth-100;
			prevBtn.y=stage.stageHeight-20;
			nextBtn.y=stage.stageHeight-55;
		}
	}
	
}
