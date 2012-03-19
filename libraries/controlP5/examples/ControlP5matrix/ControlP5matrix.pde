import controlP5.*;

ControlP5 controlP5;

int myColorBackground = color(0,0,0);

void setup() {
  size(600,400);
  frameRate(30);
  controlP5 = new ControlP5(this);
  controlP5.addMatrix("someMatrix", 20, 20, 10, 10, 400, 100);
}

void draw() {
  background(myColorBackground);
}



void controlEvent(ControlEvent theEvent) {
  println("## controlEvent / id:"+theEvent.controller().id()+"\n"+
      "name:"+theEvent.controller().name()+"\n"+
      "label:"+theEvent.controller().label()+"\n"+
      "value:"+theEvent.controller().value()+"\n"+
      "matrixValue x:"+Matrix.getX(theEvent.controller().value())+"\n"+
      "matrixValue y:"+Matrix.getY(theEvent.controller().value())+"\n"      
      );
}
