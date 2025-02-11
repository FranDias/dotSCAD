/**
* shape_pie.scad
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib3x-shape_pie.html
*
**/

use <__comm__/__frags.scad>;
use <__comm__/__ra_to_xy.scad>;

function shape_pie(radius, angle) =
    let(
        a_step = 360 / __frags(radius),
        leng = radius * cos(a_step / 2),
        angles = is_num(angle) ? [0, angle] : angle,
        m = floor(angles[0] / a_step) + 1,
        n = floor(angles[1] / a_step),
        edge_r_begin = leng / cos((m - 0.5) * a_step - angles[0]),
        edge_r_end = leng / cos((n + 0.5) * a_step - angles[1]),
        shape_pts = [
            [0, 0], 
            __ra_to_xy(edge_r_begin, angles[0]), 
            if(m <= n) each [
                for(i = m; i <= n; i = i + 1)
                let(a = a_step * i) 
                __ra_to_xy(radius, a)
            ],
            if(angles[1] != a_step * n) __ra_to_xy(edge_r_end, angles[1])
        ]
    ) shape_pts;