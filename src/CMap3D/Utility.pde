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
 
 public static class Utility {
 
  static int fact (int n) {
    if (n <= 1) {
      return 1;
    } else {
      return n * fact(n-1);
    }
  }
 
  static int pascal(int n, int k) {
    return fact(n) / fact(k)/fact(n-k);
  } 
  
}


