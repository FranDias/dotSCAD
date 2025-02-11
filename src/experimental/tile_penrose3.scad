use <ptf/ptf_rotate.scad>;
use <hull_polyline2d.scad>;

function _subdivide(triangles) = 
	[
		for(tri = triangles)
		let(
			type = tri[0],
			a = tri[1],
			b = tri[2],
			c = tri[3]
		)
		each (type == "OBTUSE" ? _sub_obtuse(a, b, c) : _sub_acute(a, b, c))
	];

function _sub_acute(a, b, c) =
	let(
		PHI = 1.618033988749895,
		p = a + (b - a) / PHI
	)
	[["ACUTE", c, p, b], ["OBTUSE", p, c, a]];	
	
function _sub_obtuse(a, b, c) =
	let(
		PHI = 1.618033988749895,
		r = b + (c - b) / PHI
	) 
	[["OBTUSE", r, c, a], each _sub_acute(b, a, r)];

function _penrose3(triangles, n, i = 0) = 
	i == n ? triangles :
			_penrose3(_subdivide(triangles), n, i+ 1);
			
function tri2tile(type, tri) =
    let(
	    c = (tri[1] + tri[2]) / 2,
		v = c - tri[0],
		m = c + v
	)
	[[type, tri[0], tri[1], tri[2]], [type, m, tri[1], tri[2]]];
			
function tile_penrose3(n, triangles) = 
    let(
		fn = 10,
		a = 720 / fn,
		shape_tri0 = [[1, 0], [1, 0] + ptf_rotate([-1, 0], -180 + a), [0, 0]],
		tris = _penrose3(
		    is_undef(triangles) ? [
				for(i = [0:fn / 2 - 1]) 
				let(t = [for(p = shape_tri0) ptf_rotate(p, i * a)])
					each tri2tile("OBTUSE", [t[0], t[1], t[2]])
		    ] :
            [for(tri = triangles) each tri2tile(tri[0], [tri[1][1], tri[1][2], tri[1][0]])],
		    n
		)
	)
    [for(t = tris) [t[0], [t[3], t[1], t[2]]]];

module draw(tris, radius) {
	for(t = tris) {
		color(t[0] == "OBTUSE" ? "white" : "black")
		linear_extrude(.5)
			polygon(t[1] * radius);
		linear_extrude(1)
		    hull_polyline2d(t[1] * radius, .1);
	}
}

radius = 10;
$fn = 12;

draw(tile_penrose3(5, [
    ["OBTUSE", [ptf_rotate([2, 0], 108), [0, 0], [2, 0]]]
]), radius);

translate([40, 0])
    draw(tile_penrose3(0), radius);

translate([80, 0])
    draw(tile_penrose3(1), radius);

translate([0, -40])
    draw(tile_penrose3(2), radius);

translate([40, -40])
    draw(tile_penrose3(3), radius);

translate([80, -40])
    draw(tile_penrose3(4), radius);