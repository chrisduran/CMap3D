import controlP5.*;

ControlP5 controlP5;

Textlabel myBigTextlabel;
Textlabel mySmallTextlabel;
boolean isDrawLabel = true;

void setup() {
  size(400,400);
  frameRate(30);
  controlP5 = new ControlP5(this);

  mySmallTextlabel = controlP5.addTextlabel("label","A SINGLE TESTLABEL.",20,134);
  mySmallTextlabel.setColorValue(0xffcccccc);
  
  myBigTextlabel = new Textlabel(this,"a single textlabel.",20,20,400,200,0xff999999,ControlP5.synt24);
  myBigTextlabel.setLetterSpacing(2);
  myBigTextlabel.setWidth(width);
}



void draw() {
  background(0);
  if(keyPressed && key==' ') {
    // change the display area of a textlabel.
    myBigTextlabel.setWidth(mouseX);
    myBigTextlabel.setHeight(mouseY);
  }
  if(isDrawLabel) {
    myBigTextlabel.draw(this); 
  }
}


void keyPressed() {
  if(key=='t') {
    if(isDrawLabel) {
      println("adding myBigTextlabel to the drawable list of tab 'default'.\n"+
      "myBigTextlabel.draw(this); in draw() is not required anymore.");
      controlP5.tab("default").addDrawable(myBigTextlabel);
      isDrawLabel = false;
    }
  }
}

