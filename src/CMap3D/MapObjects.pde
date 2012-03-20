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
