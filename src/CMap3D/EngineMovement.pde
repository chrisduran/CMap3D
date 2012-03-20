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
