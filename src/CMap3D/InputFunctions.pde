void mousePressed() {
  xPressed = mouseX;
  yPressed = mouseY;
  if (focusedFeatures.size() > 0) {
    for (int m = 0; m < focusedFeatures.size(); m++) {
      link(repositoryList[currentRepository][5]+((String)(focusedFeatures.get(m))));
    }
  }
  if (mouseX > engineOffset) cursor(HAND);
  

}

void mouseDragged() {
  if (mouseX > 200 && drawStage == 30) {
  if (pmouseX != 0 && pmouseY != 0) //pmouse default is 0,0 - this stops it going haywire
  {
    if (mouseButton == LEFT) {
    
   if (keyPressed) {
      if (key == CODED) {
        if (keyCode == SHIFT) {
          engineRotation((mouseX-pmouseX)/mouseSensitivity);
          engineIncline((mouseY-pmouseY)/mouseSensitivity);
        }
        }
      } 
      
      else {
          worldObjectMove('h', (mouseX-pmouseX)/mouseSensitivity);
          worldObjectMove('v', (mouseY-pmouseY)/mouseSensitivity);
      }
      

  } else if (mouseButton == RIGHT) {
    engineRotation((mouseX-pmouseX)/mouseSensitivity);
    engineIncline((mouseY-pmouseY)/mouseSensitivity);
  } 
}
  }
}

void keyPressed() {
  if (key == 'r') {
      resetEngine();
  }
}


void mouseReleased() {
  cursor(ARROW);
  clicked = false;
}
