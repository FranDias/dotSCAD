/**
* tri_circumcenter.scad
*
* @copyright Justin Lin, 2021
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib3x-tri_circumcenter.html
*
**/

function tri_circumcenter(shape_pts) =
   let(
      p0 = shape_pts[0],
      p1 = shape_pts[1],
      p2 = shape_pts[2],
      v0 = p1 - p0,
      d0 = (p1 + p0) / 2 * v0,
      v1 = p2 - p1,  
      d1 = (p2 + p1) / 2 * v1,
      det = -cross(v0 , v1)
   )
   det == 0 ? undef : [
       (d1 * v0.y - d0 * v1.y) / det,
       (d0 * v1.x - d1 * v0.x) / det
   ];