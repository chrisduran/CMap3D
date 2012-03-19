/**
 * controlP5numberbox by andreas schlegel <br />
 * an example to show how to use a numberbox to control<br />
 * variables and events.<br />
 * click a numberbox and move mouse up and down while pressing <br />
 * the mousebutton to change values.<br />
 * for further information and questions about controlP5 first<br />
 * take a look at the documentation, the examples, or the <br />
 * website at http://www.sojamo.de/controlP5<br />
 */

import controlP5.*;

ControlP5 controlP5;

public int myColorRect = 200;

public int myColorBackground = 100;


void setup() {
  size(400,400);
  frameRate(25);
  controlP5 = new ControlP5(this);
  controlP5.addNumberbox("numberbox1",myColorRect,100,160,100,14).setId(1);
  controlP5.addNumberbox("numberbox2",myColorBackground,100,200,100,14).setId(2);
  controlP5.addSlider("slider1",100,200,100,100,250,100,14).setId(3);
  controlP5.addTextfield("text1",100,290,100,20).setId(4);
}

void draw() {
  background(myColorBackground);
  fill(myColorRect);
  rect(0,0,width,100);
}


void controlEvent(ControlEvent theEvent) {
  println("got a control event from controller with id "+theEvent.controller().id());
  switch(theEvent.controller().id()) {
    case(1):
    myColorRect = (int)(theEvent.controller().value());
    break;
    case(2):
    myColorBackground = (int)(theEvent.controller().value());
    break;  
  }
}
