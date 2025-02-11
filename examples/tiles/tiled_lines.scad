use <experimental/tile_truchet.scad>;
use <line2d.scad>;

size = [50, 25];
tile_width = 5;
line_width = 1;

for(tile = tile_truchet(size)) {
    x = tile[0];
	y = tile[1];
	i = tile[2];
	
	if(i <= 1) {
	    line2d([x, y] * tile_width , [x + 1, y + 1] * tile_width, width = line_width);
	}
	else {
	    line2d([x + 1, y] * tile_width, [x, y + 1] * tile_width, width = line_width);
	}
}