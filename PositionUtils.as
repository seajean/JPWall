package  {
	import flash.geom.Point;
	import flash.display.Stage;
	
	public class PositionUtils {
		

		public function PositionUtils() {
			// constructor code
		}
		public static function makePosArr(stage:Stage,square:int,spacing:int):Vector.<PhotoPosition>{  //生成空数组位置
			var boundsX:int=int(stage.stageWidth);
			var boundsY:int=int(stage.stageHeight-45);
			var ipo:IPosition=new IPosition();
			ipo.horNum=Math.floor(boundsX/(square+5));
			ipo.verNum=Math.floor(boundsY/(square+5));
			ipo.length=ipo.horNum*ipo.verNum;
			ipo.square=square;
			ipo.spacing=spacing;
			ipo.startX=((stage.stageWidth-(square+5)*ipo.horNum)+5)/2;
			ipo.startY=((stage.stageHeight-(square+5)*ipo.verNum)+5-45)/2;
			var arr=new Array();
			for(var ii:int=0;ii<ipo.horNum;ii++){
				if(!arr[ii]) arr[ii]=new Array();
				for(var jj:int=0;jj<ipo.verNum;jj++){
					arr[ii][jj]=-1;
				}
			}
			ipo.posArray=arr;
			return  PositionUtils.makePosVector(ipo);
		}
		public static function randomOutside(stage:Stage):Point{
			var desX:Number,desY:Number;
			var iid=Math.random();
			if(iid<0.2){
				desX=stage.stageWidth+150;
				desY=Math.random()*stage.stageHeight;
			}else if(iid<0.5){
				desX=-150;
				desY=Math.random()*stage.stageHeight;
			}else if(iid<0.7){
				desY=stage.stageHeight+150;
				desX=Math.random()*stage.stageWidth;
			}else{
				desY=-150;
				desX=Math.random()*stage.stageWidth;
			}
			return new Point(desX,desY);
		}
		public static function randomInside(stage:Stage):Point{
			var desX:Number,desY:Number;
			desY=Math.random()*stage.stageHeight;
			desX=Math.random()*stage.stageWidth;
			return new Point(desX,desY);
		}
		//========================================
		//return one page abstract position vector
		//========================================
		private static function makePosVector(ipo:IPosition):Vector.<PhotoPosition>{
			var fotoPos:Vector.<PhotoPosition> = new Vector.<PhotoPosition>();
			for(var j:int=0;j<ipo.length;j++){
				var cc:Number=Math.random();
				var type:int;
				if(cc<0.1){
					type=2;
				}else if(cc<0.2){
					type=4;
				}else if(cc<0.3){
					type=3;
				}else{
					type=1;
				}
				var pos:Point=getNextPos(type,ipo.posArray,ipo.verNum,ipo.horNum);
				//trace(pos.x)
				if(pos.x==-1){ //分配不下位置时分配1
					pos=getNextPos(1,ipo.posArray,ipo.verNum,ipo.horNum);
					type=1;
				}
				if(pos.x==-2){//已经摆满
					break;
				}
				var pp:PhotoPosition=new PhotoPosition();
				pp.x=pos.x*(ipo.square+ipo.spacing)+ipo.startX;
				pp.y=pos.y*(ipo.square+ipo.spacing)+ipo.startY;
				pp.type=type;
				
				fotoPos.push(pp);
			}
			return fotoPos;
		}
		//===================================================
		//返回下一个图片位置，当为-1时是排不下，当999时是已经排满
		//===================================================
		private static function getNextPos(type:int,arr:Array,verNum:int,horNum:int):Point{
			var posX:Number,posY:Number;
			outterLoop:for(var jj:int=0;jj<verNum;jj++){
				for(var ii:int=0;ii<horNum;ii++){
					if(arr[ii][jj]==-1){
						posX=ii; //(ii)*(square+5)+startX;
						posY=jj; //(jj)*(square+5)+startY;
						if(type==1){
							arr[ii][jj]=1;
							return new Point(posX,posY);
						}else if(type==2){
							if(!arr[ii+1]||!arr[ii+1][jj+1]){//已经排满;
								return new Point(-1,-1);
							}
							if(arr[ii+1][jj]==-1&&arr[ii+1][jj+1]==-1&&arr[ii][jj+1]==-1){
								arr[ii][jj]=1;
								arr[ii][jj+1]=1;
								arr[ii+1][jj]=1;
								arr[ii+1][jj+1]=1;
								return new Point(posX,posY);
							}else{
								continue;
							}
						}else if(type==3){
							if(!arr[ii+1]||!arr[ii+1][jj]){
								//trace("grid are full#3");
								return new Point(-1,-1);
							}
							if(arr[ii+1][jj]==-1){
								arr[ii][jj]=1;
								arr[ii+1][jj]=1;
								return new Point(posX,posY);
							}else{
								continue;
							}
						}else if(type==4){
							if(!arr[ii]||!arr[ii][jj+1]){
								return new Point(-1,-1);
							}
							if(arr[ii][jj+1]==-1){
								arr[ii][jj]=1;
								arr[ii][jj+1]=1;
								return new Point(posX,posY);
							}else{
								continue;
							}
						}
					}//end of if
				}
			  }
			return new Point(-2,-2);
		}
	}
}
