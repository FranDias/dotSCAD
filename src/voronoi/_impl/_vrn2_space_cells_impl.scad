use <../../ptf/ptf_rotate.scad>;

_noise_table = [0.592157, 0.627451, 0.537255, 0.356863, 0.352941, 0.0588235, 0.513725, 0.0509804, 0.788235, 0.372549, 0.376471, 0.207843, 0.760784, 0.913725, 0.027451, 0.882353, 0.54902, 0.141176, 0.403922, 0.117647, 0.270588, 0.556863, 0.0313725, 0.388235, 0.145098, 0.941176, 0.0823529, 0.0392157, 0.0901961, 0.745098, 0.0235294, 0.580392, 0.968627, 0.470588, 0.917647, 0.294118, 0, 0.101961, 0.772549, 0.243137, 0.368627, 0.988235, 0.858824, 0.796078, 0.458824, 0.137255, 0.0431373, 0.12549, 0.223529, 0.694118, 0.129412, 0.345098, 0.929412, 0.584314, 0.219608, 0.341176, 0.682353, 0.0784314, 0.490196, 0.533333, 0.670588, 0.658824, 0.266667, 0.686275, 0.290196, 0.647059, 0.278431, 0.52549, 0.545098, 0.188235, 0.105882, 0.65098, 0.301961, 0.572549, 0.619608, 0.905882, 0.32549, 0.435294, 0.898039, 0.478431, 0.235294, 0.827451, 0.521569, 0.901961, 0.862745, 0.411765, 0.360784, 0.160784, 0.215686, 0.180392, 0.960784, 0.156863, 0.956863, 0.4, 0.560784, 0.211765, 0.254902, 0.0980392, 0.247059, 0.631373, 0.00392157, 0.847059, 0.313725, 0.286275, 0.819608, 0.298039, 0.517647, 0.733333, 0.815686, 0.34902, 0.0705882, 0.662745, 0.784314, 0.768627, 0.529412, 0.509804, 0.454902, 0.737255, 0.623529, 0.337255, 0.643137, 0.392157, 0.427451, 0.776471, 0.678431, 0.729412, 0.0117647, 0.25098, 0.203922, 0.85098, 0.886275, 0.980392, 0.486275, 0.482353, 0.0196078, 0.792157, 0.14902, 0.576471, 0.462745, 0.494118, 1, 0.321569, 0.333333, 0.831373, 0.811765, 0.807843, 0.231373, 0.890196, 0.184314, 0.0627451, 0.227451, 0.0666667, 0.713725, 0.741176, 0.109804, 0.164706, 0.87451, 0.717647, 0.666667, 0.835294, 0.466667, 0.972549, 0.596078, 0.00784314, 0.172549, 0.603922, 0.639216, 0.27451, 0.866667, 0.6, 0.396078, 0.607843, 0.654902, 0.168627, 0.67451, 0.0352941, 0.505882, 0.0862745, 0.152941, 0.992157, 0.0745098, 0.384314, 0.423529, 0.431373, 0.309804, 0.443137, 0.878431, 0.909804, 0.698039, 0.72549, 0.439216, 0.407843, 0.854902, 0.964706, 0.380392, 0.894118, 0.984314, 0.133333, 0.94902, 0.756863, 0.933333, 0.823529, 0.564706, 0.0470588, 0.74902, 0.701961, 0.635294, 0.945098, 0.317647, 0.2, 0.568627, 0.921569, 0.976471, 0.054902, 0.937255, 0.419608, 0.192157, 0.752941, 0.839216, 0.121569, 0.709804, 0.780392, 0.415686, 0.615686, 0.721569, 0.329412, 0.8, 0.690196, 0.45098, 0.47451, 0.196078, 0.176471, 0.498039, 0.0156863, 0.588235, 0.996078, 0.541176, 0.92549, 0.803922, 0.364706, 0.870588, 0.447059, 0.262745, 0.113725, 0.0941176, 0.282353, 0.952941, 0.552941, 0.501961, 0.764706, 0.305882, 0.258824, 0.843137, 0.239216, 0.611765, 0.705882];

function _lookup_noise_table(i) = _noise_table[i % 256];

function cell_pt(fcord, grid_w, seed, x, y, gw, gh) = 
    let(
        nx = fcord.x + x,
        ny = fcord.y + y,
        sd_x = nx < 0 ? nx + gw : 
                nx >= gw ? nx % gw : nx,
        sd_y = ny < 0 ? ny + gh : 
                ny >= gh ? ny % gh : ny,                 
        sd_base = abs(sd_x + sd_y * grid_w),
        sd1 = _lookup_noise_table(seed + sd_base),
        sd2 = _lookup_noise_table(sd1 * 255 + sd_base)
    )
    [(nx + sd1) * grid_w, (ny + sd2) * grid_w];

// 21-nearest-neighbor 
function _neighbors(fcord, seed, grid_w, gw, gh) = 
    let(range = [-1:1])
    concat(
        [for(y = range, x = range) cell_pt(fcord, grid_w, seed, x, y, gw, gh)],
        [for(x = range) cell_pt(fcord, grid_w, seed, x, -2, gw, gh)],
        [for(x = range) cell_pt(fcord, grid_w, seed, x, 2, gw, gh)],
        [for(y = range) cell_pt(fcord, grid_w, seed, -2, y, gw, gh)],
        [for(y = range) cell_pt(fcord, grid_w, seed, 2, y, gw, gh)]
    );

function _cells_lt_before_intersection(shape, size, points, pt, half_region_size) =
    [
        for(p = points)
            let(
                v = p - pt,
                offset = (pt + p) / 2 - v / norm(v) * half_region_size,
                a = atan2(v[1], v[0])            
            )
            [
                for(sp = shape)
                     ptf_rotate(sp, a) + offset
            ]
    ];
