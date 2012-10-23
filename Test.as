package
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Transform;
    
    public class Test extends Sprite
    {
        public function Test()
        {
             var myMatrix:Matrix = new Matrix();
             trace(myMatrix.toString());  // (a=1, b=0, c=0, d=1, tx=0, ty=0)
             
             myMatrix.createBox(2, 2, 0, 50, -100);
             trace(myMatrix.toString());  
             // (a=0.7071067811865476, b=1.414213562373095, c=-0.7071067811865475, 
             //  d=1.4142135623730951, tx=100, ty=200)
             
             var rectangleShape:Shape = createRectangle(100, 300, 0xFF0000);   
             addChild(rectangleShape);
              
             var rectangleTrans:Transform = new Transform(rectangleShape);
             rectangleTrans.matrix = myMatrix;
        }
        
        public function createRectangle(w:Number, h:Number, color:Number):Shape 
        {
            var rect:Shape = new Shape();
            rect.graphics.beginFill(color);
            rect.graphics.drawRect(0, 0, w, h);
            //addChild(rect);
            return rect;
        }
    }
}