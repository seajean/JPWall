package  {
	
	import flash.display.MovieClip;
	import com.seajean.base.Loading;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	
	
	public class NavBtn extends MovieClip {
		
		private var loading:Loading;
		public function NavBtn() {
			loading=new Loading(30,30,0xFFFFFF);
			addChild(loading);
			loading.visible=false;
			this.alpha=0.3;
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			// constructor code
		}
		private function onMouseOver(e:MouseEvent):void{
			TweenLite.to(this,0.3,{"alpha":1});
		}
		private function onMouseOut(e:MouseEvent):void{
			TweenLite.to(this,0.3,{"alpha":0.3});
		}
		public function showLoading():void{
			this.arrow.visible=false;
			this.loading.visible=true;
			this.buttonMode=false;
			bg.visible=false;
		}
		public function showArrow():void{
			arrow.visible=true;
			loading.visible=false;
			this.buttonMode=true;
			bg.visible=true;
		}
	}
	
}
