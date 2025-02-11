/**
* spherical_coordinate.scad
*
* @copyright Justin Lin, 2020
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib3x-spherical_coordinate.html
*
**/ 

function spherical_coordinate(point) = 
    // mathematics [r, theta, phi]
    [
        norm(point), 
        atan2(point.y, point.x), 
        atan2(sqrt(point.x ^ 2 + point.y ^ 2), point.z)
    ];
