use <ellipse_extrude.scad>;
use <curve.scad>;
use <sweep.scad>;
use <rails2sections.scad>;
use <shape_trapezium.scad>;
use <ptf/ptf_rotate.scad>;

module dragon_head() {
    module hair() {
        for(i = [16:36]) {
            rotate(i * 10 + rands(0, 5, 1, i)[0]) 
            translate([0, -13, 0]) 
            rotate([8 + rands(0, 2, 1, i)[0], 0, 0]) 
            linear_extrude(12 + rands(0, 5, 1, i)[0], scale = 0.05, twist = 50 - rands(0, 100, 1, seed = i)[0]) 
            translate([0, 10, 0]) 
                circle(3, $fn = 5);    
        }       

        for(i = [0:35]) {
            rotate(i * 12 + rands(0, 5, 1, i)[0]) 
            translate([0, -11.5, 0]) 
            rotate([4 + rands(0, 2, 1, i)[0], 0, 0]) 
            linear_extrude(14 + rands(0, 5, 1, i)[0], scale = 0.05, twist = 50 - rands(0, 100, 1, seed = i + 1)[0]) 
            translate([0, 10, 0]) 
                circle(3.5, $fn = 6);    
        }
        
        for(i = [0:35]) {
            rotate(i * 10) 
            translate([0, -10, 0]) 
            rotate([2, 0, 0]) 
            linear_extrude(16 + rands(0, 5, 1, i)[0], scale = 0.05, twist = 50 - rands(0, 100, 1, seed = i + 2)[0]) 
            translate([0, 10, 0]) 
                circle(3.5, $fn = 5);    
        }         
    }
    
    module one_horn() {        
        translate([-9, -4, -2]) 
        rotate([45, -25, 0]) 
        linear_extrude(27.5, scale = 0.1, twist = -90) 
        translate([7.5, 0, 0]) 
            circle(3, $fn = 4);    
    }
    
    module mouth() {
        path1 = curve(0.4, [[0, -8, -1], [0, -11, .25], [0, -12, 5], [0, -9, 5], [0, -4, 6], [0, -0.5, 8], [0, 5, 6.5], [0, 8, 6], [0, 12, 1], [0, 16, 0]]);
        path2 = [for(p = path1) ptf_rotate(p, [0, -12, 0]) * 0.9 + [-2, 0, 0]];
        path3 = [for(i = [0:len(path1) - 1]) [-i / 6 - 1.5, i / 1.65 - 9, 0]];
        path4 = [for(p = path3) [-p[0], p[1], p[2]]];
        path5 = [for(p = path2) [-p[0], p[1], p[2]]];

        translate([0, 0, -2]) 
        rotate([90, 0, -90]) 
            sweep(rails2sections([path1, path2, path3, path4, path5]));

        translate([0, 0, -3.25]) 
        rotate([90, 0, -90]) 
            ellipse_extrude(5.5, slices = 2) 
                polygon(
                    shape_trapezium([5, 18], 
                    h = 20,
                    corner_r = 2, $fn = 4)
                );    

        scale([1.5, 1, 1])
        intersection() {       
            mirror([1, 0, 0]) 
            translate([0, 0, -2.25]) 
            rotate([85, 0, -90])
            ellipse_extrude(4, slices = 2) 
                polygon(
                    shape_trapezium([5, 18], 
                    h = 20,
                    corner_r = 2, $fn = 5)
                );       

            
            jpath1 = curve(0.4, [[-10, 16], [0, 8], [4, 5],  [3, 0], [2, -5], [2, -10], [0, -13.5], [-3, -14]]);
            rotate([90, -4, 0])
            linear_extrude(25, center = true)
                polygon(jpath1);
        }
    
        translate([0, -2.5, -11])
        rotate([0, 95, 0])
        linear_extrude(1.4, scale = 0.1)
        translate([.4, 0, 0])
            circle(.5, $fn = 6);

        translate([0, 2.5, -11])
        rotate([0, 95, 0])
        linear_extrude(1.5, scale = 0.1)
        translate([.4, 0, 0])
            circle(.5, $fn = 6);
    }
    
    module one_eye() {
        translate([-5, 2.5, -2]) 
        rotate([-5, -8, -10]) 
        scale([1, 1, 1.75]) 
            sphere(1.75, $fn = 6);      

        translate([-5.1, 3.75, -2.25]) 
        rotate([-25, 0, 75]) 
            sphere(0.65, $fn = 6);                      
    }
    
    module one_beard() {
        translate([-10, -12, -10])
        rotate(180) 
        linear_extrude(8, scale = 0.15, twist = 35) 
        translate([-9, -10, 0]) 
            circle(1, $fn = 8);    
    }
    // mouth();
    rotate([0, 15, 0]) 
    translate([0, 0, -25 / 2]) 
    scale(1.15) {
        scale([0.8, 0.9, 1]) hair();

        translate([0, 0, 2]) 
        {
            rotate(-90) {
                    one_horn();
                    mirror([-1, 0, 0]) one_horn();       
            }
            
            mouth();

            one_eye();
            mirror([0, 1, 0]) one_eye();
            
            one_beard();
            mirror([0, 1, 0]) one_beard();
        }        
    }
}