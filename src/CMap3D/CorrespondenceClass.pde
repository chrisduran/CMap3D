/* CMap3D. A 3D Comparative Map Viewer.
 * 
 * A viewer for viewing and comparing genetic(linkage)/physical/sequence maps, using
 * annotations or 'features' (such as SSR/RFLP/SNP/etc markers) to map common aspects
 * between the maps. See (http://www.gmod.org/wiki/index.php/CMap) for details on the
 * original 2D comparative mapping software.
 *
 * Version 0.7
 *
 * This software is available through the following channels:
 * http://chrisduran.co/
 * https://github.com/chrisduran/CMap3D/
 * http://
 *
 * Copyright (c) 2008  Chris Duran
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * https://github.com/chrisduran/CMap3D/blob/master/LICENCE
 *
 * Email: c.duran@uqconnect.edu.au
 * Web: http://chrisduran.co/
 */
 
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
