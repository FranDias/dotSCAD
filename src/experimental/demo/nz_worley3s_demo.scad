use <experimental/nz_worley3s.scad>;

size = [20, 20, 20];
dim = 5;
dist = "euclidean"; // [euclidean, manhattan, chebyshev] 
seed = 5;

points = [
    for(z = [0:size[2] - 1]) 
        for(y = [0:size[1] - 1]) 
            for(x = [0:size[0] - 1]) 
                [x, y, z]
];
        
noises = nz_worley3s(size, points, seed, dim, dist);

max_dist = max(noises);

for(i = [0:len(noises) - 1]) {
    c = noises[i] / max_dist;
    color([c, c, c, c])
    translate(points[i])
        cube(1);
}