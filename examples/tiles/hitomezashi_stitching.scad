use <line2d.scad>;
use <experimental/tile_hitomezashi.scad>;
use <select.scad>;

size = [50, 25];
tile_width = 5;
line_width = 1;

for(tile = tile_hitomezashi(size)) {
    x = tile[0];
	y = tile[1];
	i = tile[2];

	translate([x, y] * tile_width) 
	select(i) {
		tile00(tile_width, line_width);
		tile01(tile_width, line_width);
		tile02(tile_width, line_width);
		tile03(tile_width, line_width);
	};
}

module tile00(tile_width, line_width) {
    // nope
}

// _ 
module tile01(tile_width, line_width) {
    line2d([0, 0], [tile_width, 0], line_width);
}

// |_
module tile02(tile_width, line_width) {
   line2d([0, 0], [0, tile_width], line_width);
}

// |
module tile03(tile_width, line_width) {
	line2d([0, 0], [0, tile_width], line_width);
	line2d([0, 0], [tile_width, 0], line_width);
}