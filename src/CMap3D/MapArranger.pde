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
