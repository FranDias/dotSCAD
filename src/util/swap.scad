/**
* swap.scad
*
* @copyright Justin Lin, 2021
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib3x-swap.html
*
**/ 

function swap(lt, i, j) =
    i == j ? lt :
    let(
	    leng = len(lt),
		a = min([i, j]),
		b = max([i, j])
	)
	[
        if(a != 0) each [for(idx = [0:a - 1]) lt[idx]],
		lt[b],
		if(b - a != 1) each [for(idx = [a + 1:b - 1]) lt[idx]],
		lt[a],
		if(b != leng - 1) each [for(idx = [b + 1:leng - 1]) lt[idx]]
	];