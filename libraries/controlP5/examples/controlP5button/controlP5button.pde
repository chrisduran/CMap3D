import controlP5.*;

ControlP5 controlP5;

int myColorBackground = color(0,0,0);

int buttonValue = 1;

void setup() {
  size(400,400);
  controlP5 = new ControlP5(this);
  controlP5.addButton("button",10,100,160,80,20).setId(1);
  controlP5.addButton("buttonValue",4,100,190,80,20).setId(2);
}
  
void draw() {
  background(buttonValue*10);
}

void controlEvent(ControlEvent theEvent) {
  println(theEvent.controller().id());
}


void button(float theValue) {
  println("a button event. "+theValue);
}
