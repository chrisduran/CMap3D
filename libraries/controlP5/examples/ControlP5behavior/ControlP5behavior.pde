import controlP5.*;


ControlP5 controlP5;

int myColorBackground = color(0,0,0);

int sliderValue = 100;

void setup() {
  size(400,400);
  frameRate(30);
  controlP5 = new ControlP5(this);
  controlP5.addSlider("sliderValue",0,255,128,100,200,10,100);
  controlP5.addSlider("slider",100,200,128,100,160,100,10);
  controlP5.controller("slider").setBehavior(new SineBehavior());
  controlP5.addBang("bang",40,10,40,40);
  controlP5.controller("bang").setBehavior(new TimedEvent());
}

void draw() {
  background(myColorBackground);
  fill(sliderValue);
  rect(0,0,width,100);
}

void slider(float theColor) {
  myColorBackground = color(theColor);
  println("a slider event. setting background to "+theColor);
  //controlP5.controller("sliderValue").setValue(theColor);
}

void controlEvent(ControlEvent theControlEvent) {
  if(theControlEvent.isController()) {
    println("controller : "+theControlEvent.controller().id());
  }
}


class SineBehavior extends ControlBehavior {
  float a = 0;
  
  public void update() {
    a += 0.1;
    setValue(sin(a)*50  + 150);
  }
}


class TimedEvent extends ControlBehavior {
  
  long myTime;
  
  int interval = 200;
  
  public TimedEvent() {
    reset();
  }
  
  void reset() {
    myTime = millis() + interval;
  }
  
  public void update() {
    if(millis()>myTime) {
      setValue(1);
      reset();
    }
  }
  
}

