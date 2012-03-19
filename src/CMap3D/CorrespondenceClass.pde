class CorrespondenceClass {
  
  int classCodeCounter, classCount;
  boolean visiblity;
  HashMap classCodes = new HashMap();
  HashMap classVisiblity = new HashMap();
  String [][] corresStorage;
  
  
  public CorrespondenceClass(String [] mapIDs) {
    
    classCount = Utility.pascal(mapIDs.length, 2);
    //println(classCount+"");
    classCodeCounter = 0;
    corresStorage = new String[classCount][0];
    
    //Assigns the mapping relationship for each Correspondence Class.
    //This is stored as both MapID1:MapID2 & MapID2:MapID1 for faster
    //lookup.
    
    if (mapIDs.length == 2) {
      classCodes.put(mapIDs[0]+":"+mapIDs[1],classCodeCounter+"");
      classCodes.put(mapIDs[1]+":"+mapIDs[0],classCodeCounter+"");
      classVisiblity.put(classCodeCounter+"","true");
      classCodeCounter++;
    } else {
    
      for (int i = 1; i < mapIDs.length; i++) {
      
        for (int j = i-1; j > -1; j--) {
          classCodes.put(mapIDs[i]+":"+mapIDs[j],classCodeCounter+"");
          classCodes.put(mapIDs[j]+":"+mapIDs[i],classCodeCounter+"");
          classVisiblity.put(classCodeCounter+"","true");
          classCodeCounter++;
        }
    
      }
    }
    
  }
  
  String getClass (String mapID1, String mapID2) {
    return (String)(classCodes.get(mapID1+":"+mapID2));
  }
  
  void addCorrespondence (String mapID1, String mapID2, String fID1, String fID2) {
    String [] thisIn = {fID1, fID2};
    int classCode = int(getClass(mapID1,mapID2));
    corresStorage[classCode] = concat(corresStorage[classCode],thisIn);
    
  }
  
  String [] getCorrespondenceList (String classCode) {
    return corresStorage[int(classCode)];
  }
  
  boolean getVisible (String classCode) {
    return boolean( (String)(classVisiblity.get(classCode)) );
  }
  
  void setVisible (String classCode, boolean visible) {
    if (visible) classVisiblity.put(classCode+"","true");
    if (!visible) classVisiblity.put(classCode+"","false");
  }
}
