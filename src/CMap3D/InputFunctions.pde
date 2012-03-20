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
