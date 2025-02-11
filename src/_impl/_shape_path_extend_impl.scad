use <../__comm__/__to3d.scad>;
use <../ptf/ptf_rotate.scad>;
use <../util/reverse.scad>;

function __polytransversals(transversals) =
    let(
        leng_trs = len(transversals),
        leng_tr = len(transversals[0]),
        lefts = [
            for(i = 1; i < leng_trs - 1; i = i + 1)
                let(tr = transversals[leng_trs - i])
                    tr[0]
        ],
        rights = [
            for(i = 1; i < leng_trs - 1; i = i + 1)
                let(tr = transversals[i])
                    tr[leng_tr - 1]
        ]
    ) concat(
        transversals[0], 
        rights, 
        reverse(transversals[leng_trs - 1]), 
        lefts
    );

function _shape_path_extend_az(p1, p2) = 
    let(
        x1 = p1[0],
        y1 = p1[1],
        x2 = p2[0],
        y2 = p2[1]
    ) -90 + atan2((y2 - y1), (x2 - x1));

function _shape_path_first_stroke(stroke_pts, path_pts) =
    let(
        p1 = path_pts[0],
        p2 = path_pts[1],
        a = _shape_path_extend_az(p1, p2)
    )
    [
        for(p = stroke_pts)
            ptf_rotate(p, a) + p1
    ];    

function _shape_path_extend_stroke(stroke_pts, p1, p2, scale_step, i) =
    let(
        leng = norm(__to3d(p2) - __to3d(p1)),
        a = _shape_path_extend_az(p1, p2)
    )
    [
        for(p = stroke_pts)
            ptf_rotate(p * (1 + scale_step * i) + [0, leng], a) + p1
    ];
    
function _shape_path_extend_inner(stroke_pts, path_pts, leng_path_pts, scale_step) =
    [
        for(i = 1; i < leng_path_pts; i = i + 1)
            _shape_path_extend_stroke(
                stroke_pts, 
                path_pts[i - 1], 
                path_pts[i ], 
                scale_step, 
                i 
            )
    ];

function _shape_path_extend_impl(stroke_pts, path_pts, scale, closed) =
    let(
        leng_path_pts = len(path_pts),
        scale_step = (scale - 1) / (leng_path_pts - 1),
        strokes = _shape_path_extend_inner(stroke_pts, path_pts, leng_path_pts, scale_step)        
    )
    closed && path_pts[0] == path_pts[leng_path_pts - 1] ? 
        __polytransversals(concat(strokes, [strokes[0]])) : 
        __polytransversals(
            [_shape_path_first_stroke(stroke_pts, path_pts), each strokes]
        );
        
