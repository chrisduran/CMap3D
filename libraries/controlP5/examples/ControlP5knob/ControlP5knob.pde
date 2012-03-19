import controlP5.*;


ControlP5 controlP5;

int myColorBackground = color(0,0,0);

int knobValue = 100;

Knob myKnobA;

Knob myKnobB;

void setup() {
  size(400,400);
  smooth();
  controlP5 = new ControlP5(this);
  myKnobA = controlP5.addKnob("knob",100,200,128,100,160,40);
  myKnobB = controlP5.addKnob("knobValues",0,255,128,100,240,40);
}

void draw() {
  background(myColorBackground);
  fill(knobValue);
  rect(0,0,width,100);
}


void knob(int theValue) {
  myColorBackground = color(theValue);
  println("a knob event. setting background to "+theValue);
  myKnobB.setValue(theValue);
}


void keyPressed() {
  myKnobA.setValue(150);
}
