/*
 * 15th-Century Clavichord 3D Model
 * Based on dimensions from "The Urbino Clavichord Revisited" (Pierre Verbeek)
 * 
 * All dimensions are in millimeters (mm).
 * Render with OpenSCAD (F5 for preview, F6 to render).
 */

// --- Variables & Dimensions ---

// Case Dimensions (mm-R)
c_length = 1005;
c_width = 216;
c_height = 82;
wall_th = 12;
rack_th = 13;
rack_height = 30;
wrestplank_height = 35;
hitchpin_th = 12;

// Keyboard Dimensions
kb_start_x = 122;
kb_length = c_length - kb_start_x - 149;
kb_protrusion = 81.5;  // Projection length of naturals outside the case
num_naturals = 29;     // Keyboard extends from F to f3
nat_width = 25.3;
nat_height = 10;
sharp_width = 14.0;
sharp_length = 45;
sharp_height = nat_height + 5;
tangent_height = 8;

// --- Colors ---
col_wood_dark = [0.35, 0.20, 0.10];
col_wood_light = [0.80, 0.65, 0.40];
col_wood_med = [0.55, 0.35, 0.15];
col_key_lever = [0.9, 0.9, 0.9];
col_natural = [0.90, 0.88, 0.80]; // Bone/boxwood finish
col_sharp = [0.15, 0.15, 0.15];   // Dark tortoise shell / ebony
col_brass = [0.85, 0.75, 0.30];
col_string = [0.90, 0.90, 0.90];

bridge_width = 98;
key_lever_top_y = c_width - wall_th - hitchpin_th - 2;
num_keys = 47;
num_strings = 34;

function string_offset_y(i) = key_lever_top_y - 2 - (i*1.3) - floor(i/4) * 3 - (i > 1 ? 3 : 0);
// https://oeis.org/A057356
function key_string_index(i) = (i < 5 ? i : floor(2*(i-1)/7) + 4);

// https://oeis.org/A366701
function nat_index(i) = i > 1 ? (round((i + 8) * log(3/2)/log(2)) - 4) : i;
slot_positions_right = [
    938,    // F
    927,    // G
    916.5,  // A
    902.5,  // Bb
    888.5,  // B
    875.5,  // c
    836,    // c#
    788,    // d
    774,    // eb
    731,    // e
    699,    // f
    665.5,  // f#
    655,    // g
    627,    // ab
    593,    // a
    582,    // bb
    549,    // b
    528.5,  // c1
    506,    // c#1
    495.5,  // d1
    474,    // eb1
    449.5,  // e1
    437.5,  // f1
    420.5,  // f#1
    398,    // g1
    383,    // abs
    371,    // a
    357.5,  // bb
    342.5,  // b
    328.5,  // c1
    317.5,  // c#1
    302.5,  // d1
    291,    // eb1
    280,    // e1
    270.5,  // f1
    262,    // f#2
    251,    // g2
    241.5,  // ab2
    232,    // a2
    226.5,  // bb2
    217,    // b2
    210.5,  // c3
    203,    // c#3
    199,    // d3
    192.5,  // eb3
    186,    // e3
    180.5,  // f3
];
right_edge = c_length - wall_th;
function slot_position(i) = right_edge - slot_positions_right[i];

function is_sharp(i) = i > 0 && i < num_keys-1 && nat_index(i) == nat_index(i-1);
function nat_offset_x(i) = kb_start_x + nat_index(i) * nat_width;
    
// --- Modules ---

module clavichord_case() {
    color(col_wood_med)
    difference() {
        // Main outer block
        cube([c_length, c_width, c_height]);
        
        // Hollow interior
        translate([wall_th, wall_th, wall_th]) {
            cube([c_length - 2*wall_th, c_width - 2*wall_th, c_height]);
        }
            
        // Keyboard cutout in the front wall
        translate([kb_start_x, -1, c_height-nat_height-16]) {
            cube([kb_length, wall_th + 2, 12]);
        }
    }
}

module nat_key_top(i) {
    color(col_natural) 
        translate([nat_offset_x(i) - 1, -kb_protrusion - 1, nat_height])
            linear_extrude(2)
                square([nat_width - 1, kb_protrusion + 1]);
}

module nat_key(i) {
     union() {
        key_lever_3d(i);
        nat_key_top(i);
    }
}

module key_lever_2d(i) {
    top_width = 10;
    bottom_width = (is_sharp(i) ? sharp_width : nat_width) - 4;
    top = [
        slot_position(i) - top_width/2,
        key_lever_top_y
    ];
    bottom = [
        nat_offset_x(i) + (is_sharp(i) ? nat_width - sharp_width/2 : 0), 
        -kb_protrusion + (is_sharp(i) ? 45 : 0)
    ];
    echo("i=", i, "string_index=",key_string_index(i),"offset=",string_offset_y(key_string_index(i))*2);
    offset_y = string_offset_y(key_string_index(i));
    difference() {
        polygon([
           bottom,
           [bottom.x, 38 + ((i % 12) * 7)],
           [top.x, offset_y],
           top,
           [top.x + top_width, top.y],
           [top.x + top_width, offset_y],
           [bottom.x + bottom_width, 43 + i * 7],
           [bottom.x + bottom_width, bottom.y],
        ]);
        if(is_sharp(i+1)) offset(delta=1) key_lever_2d(i+1);
        if(is_sharp(i-1)) offset(delta=1) key_lever_2d(i-1);
    }
}

module key_lever_3d(i) {
    color(col_key_lever) linear_extrude(nat_height) key_lever_2d(i);
}

module sharp_key_top(i) {
    color(col_sharp)
        translate([nat_offset_x(i) + nat_width - sharp_width/2, -45, 5])
            cube([sharp_width, sharp_length, sharp_height]);
}

module sharp_key(i) {
    // Sharp key (Accidentals)
    // Note pattern for F major scale start: F(0), G(1), A(2), B(3), C(4), D(5), E(6)
    // Standard keyboard sharps are between: F-G, G-A, A-B, C-D, D-E
    union() {
        key_lever_3d(i);
        sharp_key_top(i);
    } 
}

module tangent(i) {
    translate([slot_position(i), string_offset_y(key_string_index(i)), nat_height])
        color(col_brass)
        cube([1.5, 4, tangent_height]);
}

module keyboard() {    
    translate([0, 0, c_height-nat_height-16]) {
       for(i=[0:num_keys - 1]) {   
            if (is_sharp(i)) sharp_key(i); else nat_key(i);
            tangent(i);
       }
    }
}

module hitchpin_block() {
    translate([wall_th, wall_th, 12])
        color(col_wood_dark)
        cube([hitchpin_th, c_width - 2*wall_th, 35]);
}

module rack_slots() {
    for(x=slot_positions_right) {
        translate([right_edge-x, -1, 0]) 
            cube([1, rack_th - 2, rack_height+1]);
    }
}

module rack() {
    translate([0, c_width - wall_th - rack_th, c_height - rack_height - 12]) {
        color(col_wood_dark) difference() {
            translate([wall_th + hitchpin_th, 0, 0])            
                cube([kb_length + kb_start_x, rack_th, rack_height]);
            rack_slots();
        }
    }
}

module soundboard() {
    translate([800, wall_th, 50])
        color(col_wood_light)
        cube([c_length - wall_th - (kb_start_x + kb_length), c_width - 2* wall_th, 3]);
}


module bridge() {
    translate([c_length - wall_th - 81, c_width - wall_th - 95, 53])
        rotate([90, 0, 90])
        color(col_wood_dark) 
        linear_extrude(3) bridge_2d();
}

module bridge_2d() {
    difference() {
        square([bridge_width, 22]);
        translate([-12, 5, 0]) circle(22);
        translate([30, 0, 0]) circle(9);
        translate([45, 7, 0]) circle(10);
        translate([60, 0, 0]) circle(9);
        translate([98+5, 5, 0]) circle(22);
        
    };
}

module strings() {
    for(i=[0:num_strings-1]) {
        translate([wall_th + 15, string_offset_y(i), 76])
            rotate([0, 90, 0])
            color(col_string)
            cylinder(h=c_length - 2*wall_th - 50, r=0.4, $fn=10);
    }    
}


module wrestplank() {
    translate([c_length - wall_th - 60, wall_th, 27])
        color(col_wood_dark)
        cube([60, c_width - 2*wall_th, wrestplank_height]);
}

module tuning_pins() {
    translate([c_length - wall_th - 60, string_offset_y(0), 27 + wrestplank_height])
        for(row=[0:8]) {
            for(col=[0:4]) {
                translate([col*4, -row*9, 0])
                    color(col_brass)
                    cylinder(h=15, r=1, $fn=12);
        }
    }
}

module internal_components() {
    soundboard();
    hitchpin_block();
    rack();
    bridge();
    wrestplank();
    tuning_pins();
    strings();
}

module assembly() {
    clavichord_case();
    keyboard();
    internal_components();
}

assembly();