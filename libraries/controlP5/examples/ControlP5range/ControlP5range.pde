import controlP5.*;

// range controller by andreas schlegel, 08.02.2009
// note that this controller is currently experimental.
// what doesnt work:
// (1) variables can't be assigned to the range controller
// (2) extremely fast drag-mouse movements will be result
// in inaccurate changes in min and max values.
// the right caption label is not properly aligned to the right
// (3) caption labels show decimal points even if the values should
// only be ints (this is obsolete after the first change of the range controller).


ControlP5 controlP5;

int myColorBackground = color(0,0,0);

int colorMin = 100;
int colorMax = 100;
void setup() {
  size(400,400);
  controlP5 = new ControlP5(this);
  controlP5.addRange("rangeController",0,255,128,150,100,160,100,12);
 
}

void draw() {
  background(colorMin);
  fill(colorMax);
  rect(0,0,width,100);
}

void controlEvent(ControlEvent theControlEvent) {
  if(theControlEvent.controller().name().equals("rangeController")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    println(theControlEvent.controller().arrayValue());
    colorMin = int(theControlEvent.controller().arrayValue()[0]);
    colorMax = int(theControlEvent.controller().arrayValue()[1]);
  }
}
