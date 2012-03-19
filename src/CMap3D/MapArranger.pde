class MapArranger {
  
  int mapCount;
  int radius;
  int [] x;
  int [] z;
  float theta;
  float offset;
  boolean spoked;
  
  public MapArranger(int count, boolean isSpoked) {
    radius = 200;
    spoked = isSpoked;
    calculatePositions(count);
  }
  
  void calculatePositions(int count) {
    mapCount = count;
    x = new int[mapCount];
    z = new int[mapCount];
    theta = radians(360.0/mapCount);
    offset = radians((360.0/mapCount)/2);
    if (mapCount == 1) {
      x[0] = 0;
      z[0] = 0;
    } else {
    for (int step = 0; step < mapCount; step++) {
      x[step] = int(radius*sin(theta*step+offset));
      z[step] = int(radius*cos(theta*step+offset));
    }
    }
  }
  
}
