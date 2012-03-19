

class CMap {

  String mapName;
  float start;
  float stop;
  String units;
  boolean reference;  //to implement
  boolean isVisible;
  boolean isReversed;
  
  //from CMAP3D
  
  float arrangeX, arrangeZ; //for arranging the maps around the world centre.. always zero displacement on the Y axis at the centre
  //float topX, topY, topZ, botX, botY, botZ; //absolute model coords of the top and bottom of the lines
  float distance; //distance from the camera, centre point
  float topX, topY, botX, botY;  //screen coords of the top and bottom of the camera
  
  //derived
  String [] ranged;
  String [] singular;
  
  public CMap (String tmapName, float tstart, float tstop, String tunits) {
    mapName = tmapName;
    start = tstart;
    stop = tstop;
    units = tunits;
    isVisible = true;
    isReversed = false;
    ranged = new String[0];
    singular = new String[0];
  }
  
  void  addType (String inType, boolean inIsRanged) {
    if (inIsRanged) {
      ranged = append(ranged,inType);
    } else {
      singular = append(singular,inType);
    }
  }
  
}
 
class Feature {
  
  String featureName, featureUnit, featureType;
  float start, stop;
  float x, y;
  float endX, endY;
  float startOffset, stopOffset;
  int tier;
  boolean visible, hasCorrespondence, hasRange;
  
  public Feature (String fName, float fStart, float fStop, float mapStart, float mapStop, String fUnit, String fType) {
    featureName = fName;
    featureUnit = fUnit;
    featureType = fType;
    visible = true;
    hasCorrespondence = false;
    start = fStart;
    stop = fStop;
    startOffset = (fStart-mapStart) / (mapStop-mapStart);
    stopOffset = (fStop-fStart) / (mapStop-mapStart);
    hasRange = (start!=stop);
    tier = 0;
  } 
  
  public Feature (String fName, float fStart, float fStop, float mapStart, float mapStop, String fUnit, String fType, int track) {
    featureName = fName;
    featureUnit = fUnit;
    featureType = fType;
    visible = true;
    hasCorrespondence = false;
    start = fStart;
    stop = fStop;
    startOffset = (fStart-mapStart) / (mapStop-mapStart);
    stopOffset = (fStop-fStart) / (mapStop-mapStart);
    hasRange = (start!=stop);
    tier = track;
  } 
}

class Track {
  
  int depth;
  boolean isExpanded;
  boolean isVisible;
  
  public Track (int inDepth) {
    depth = inDepth;
    isExpanded = true;
    isVisible = true;
  }
}
