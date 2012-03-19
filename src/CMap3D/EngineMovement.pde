void resetEngine() {
      anchorX = 0;
    anchorY = 0;
    anchorZ = 0;
    rotation = ROTATION_DEFAULT;
    incline = INCLINE_DEFAULT;
    zoomFactor = ZOOMFACTOR_DEFAULT;
    rotationControl.setValue(rotation);
    inclineControl.setValue(incline);
    zoomControl.setValue(-zoomFactor);
}

void engineRotation(int num) { //+VE|-VE, SIGN GIVES DIRECTION
    rotation += num;
    rotationControl.setValue(359-rotation);
}

void engineIncline(int num) { // +VE|-VE, SIGN GIVES DIRECTION
    incline -= num;
    inclineControl.setValue(incline);
}

void engineZoom(char ezDir, float ezDis) { //+VE FLOAT
    switch(ezDir) {
      case 'i': //ZOOM IN
        zoomFactor += ezDis;
        zoomControl.setValue(-zoomFactor);
        break;
      case 'o': //ZOOM OUT
        zoomFactor -= ezDis;
        zoomControl.setValue(-zoomFactor);
        break;
    }
}

void worldObjectMove(char womDir, int womDis) {
  switch(womDir) {
    case 'h': //HORIZONTAL, SIGN GIVES DIRECTION
      anchorX += womDis*2;
      break;
    case 'v': //VERTICAL, SIGN GIVES DIRECTION
      anchorY += womDis*2;
      break;
  }
}
