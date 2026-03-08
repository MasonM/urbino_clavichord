/*
 * 15th-Century Clavichord 3D Model
 * Based on dimensions from "The Urbino Clavichord Revisited" (Pierre Verbeek)
 *
 * All dimensions are in millimeters (mm).
 * Render with OpenSCAD (F5 for preview, F6 to render).
 */

// --- Variables & Dimensions ---

num_keys = 47;
num_strings = 34;
num_tuning_pins = 36;

// Case Dimensions (mm-R)
c_length = 1005;
c_width = 216;
c_height = 82;
wall_th = 12;
right_edge = c_length - wall_th;

// Internal Component Dimensions
rack_th = 13;
rack_height = 30;
wrestplank_height = 35;
hitchpin_block_th = 12;
hitchpin_block_height = 35;
bridge_length = 98;
bridge_height = 22;
bridge_top_width = 1;
bridge_bottom_width = 15;
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
    383,    // ab
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
slot_width = 1.5;

// Keyboard Dimensions
nat_width = 25.3;
nat_height = 10;
sharp_width = 14.0;
sharp_length = 45;
sharp_height = nat_height + 5;
kb_protrusion = 81.5;  // Projection length of naturals outside the case
kb_start = [122, -kb_protrusion, c_height - nat_height - 16];
kb_length = c_length - kb_start.x - 149;
tangent_height = 8;
key_lever_top_y = c_width - wall_th - hitchpin_block_th - 2;

// --- Colors ---

col_wood_dark = [0.35, 0.20, 0.10];
col_wood_light = [0.80, 0.65, 0.40];
col_wood_med = [0.55, 0.35, 0.15];
col_key_lever = [0.9, 0.9, 0.9];
col_natural = [0.90, 0.88, 0.80]; // Bone/boxwood finish
col_sharp = [0.15, 0.15, 0.15];   // Dark tortoise shell / ebony
col_brass = [0.85, 0.75, 0.30];
col_string = [0.90, 0.90, 0.90];

// -- Helper functions ---

function string_offset_y(string_idx) = key_lever_top_y - 2 - (string_idx*1.3) - floor(string_idx/4) * 3 - (string_idx > 1 ? 3 : 0);
function tuning_pin_offset_x(string_idx) = c_length - wall_th - 20 -(string_idx%4)*2;

// https://oeis.org/A057356
function key_string_index(key_idx) = num_strings - 1 - 2*(key_idx < 5 ? key_idx : floor(2*(key_idx-1)/7) + 4);
// https://oeis.org/A366701
function nat_index(key_idx) = key_idx > 1 ? (round((key_idx + 8) * log(3/2)/log(2)) - 4) : key_idx;
function slot_position(key_idx) = right_edge - slot_positions_right[key_idx];
function is_sharp(key_idx) = key_idx > 0 && key_idx < num_keys-1 && nat_index(key_idx) == nat_index(key_idx-1);
function nat_offset_x(key_idx) = kb_start.x + nat_index(key_idx) * nat_width;

// Debugging: dump out values of each function for every key/string
module debug() {
    for (key_idx=[0:num_keys-1]) {
        echo(key_idx=key_idx,
            nat_index=nat_index(key_idx),
            is_sharp=is_sharp(key_idx),
            slot_position=slot_position(key_idx),
            key_string_index=key_string_index(key_idx),
            key_string_offset=string_offset_y(key_string_index(key_idx))
        );
    }

    for (string_idx=[0:num_strings-1]) {
        echo(string_idx=string_idx,
            string_offset_y=string_offset_y(string_idx),
            tuning_pin_offset_x=tuning_pin_offset_x(string_idx)
        );
    }
}

debug();

// --- Modules ---

module clavichord_case() {
    color(col_wood_med)
    difference() {
        // Main outer block
        cube([c_length, c_width, c_height]);

        // Hollow interior
        translate([wall_th, wall_th, wall_th])
            cube([c_length - 2*wall_th, c_width - 2*wall_th, c_height]);

        // Keyboard cutout in the front wall
        translate([kb_start.x, -1, kb_start.z])
            cube([kb_length, wall_th + 2, 12]);
    }
}

module hitchpins() {
    for(string_idx=[0:num_strings-1])
        translate([wall_th+5, string_offset_y(string_idx), c_height - 10])
            color(col_brass)
            cylinder(h=5, r=1, $fn=12);
}

module hitchpin_block() {
    translate([wall_th, wall_th, c_height - hitchpin_block_height - 10])
        color(col_wood_dark)
        cube([hitchpin_block_th, c_width - 2*wall_th, hitchpin_block_height]);
}

module rack_slot_cutouts() {
    for(x=slot_positions_right)
        translate([right_edge - x - 0.25, -1, 0])
            cube([slot_width, rack_th - 2, rack_height+1]);
}

module rack() {
    translate([0, c_width - wall_th - rack_th, c_height - rack_height - 12])
        color(col_wood_dark)
        difference() {
            translate([wall_th + hitchpin_block_th, 0, 0])
                cube([kb_length + kb_start.x, rack_th, rack_height]);
            rack_slot_cutouts();
        }
}

module soundboard() {
    translate([800, wall_th, 50])
        color(col_wood_light)
        cube([c_length - wall_th - (kb_start.x + kb_length) + 26, c_width - 2* wall_th, 3]);
}

module bridge() {
    translate([c_length - wall_th - 81, c_width - wall_th - 95, 53])
        rotate([90, 0, 90])
        color(col_wood_dark)
        intersection() {
            linear_extrude(100) bridge_2d();
            bridge_taper();
        }
}

module bridge_2d() {
    difference() {
        square([bridge_length, bridge_height]);
        translate([-12, 5, 0]) circle(bridge_height);
        translate([30, 0, 0]) circle(9);
        translate([45, 7, 0]) circle(10);
        translate([60, 0, 0]) circle(9);
        translate([98+5, 5, 0]) circle(bridge_height);
    };
}

// Long trapezoid to intersect with the bridge so it tapers to top
module bridge_taper() {
    translate([c_length/2, bridge_height, bridge_bottom_width/2])
    rotate([180, 90, 0])
    linear_extrude(c_length)
        polygon([
            [-bridge_top_width/2, 0],
            [-bridge_bottom_width/2, bridge_height+1],
            [bridge_bottom_width/2, bridge_height+1],
            [bridge_top_width/2, 0],
        ]);
}

module strings() {
    for(string_idx=[0:num_strings-1])
        translate([wall_th + 5, string_offset_y(string_idx), 76])
            rotate([0, 90, 0])
            color(col_string)
            cylinder(h=tuning_pin_offset_x(string_idx) - wall_th - 5, r=0.4, $fn=10);
}


module wrestplank() {
    translate([c_length - wall_th - 30, wall_th, 27])
        color(col_wood_dark)
        cube([30, c_width - 2*wall_th, wrestplank_height]);
}

module tuning_pins() {
    for(string_idx=[0:num_tuning_pins-1])
        translate([tuning_pin_offset_x(string_idx), string_offset_y(string_idx), 27 + wrestplank_height])
            color(col_brass)
            cylinder(h=15, r=1, $fn=12);
}

module key_lever_2d(key_idx) {
    top_width = 10;
    bottom_width = (is_sharp(key_idx) ? sharp_width : nat_width) - 4;
    top = [
        slot_position(key_idx) - top_width/2,
        key_lever_top_y
    ];
    bottom = [
        nat_offset_x(key_idx) + (is_sharp(key_idx) ? nat_width - sharp_width/2 : 0),
        kb_start.y + (is_sharp(key_idx) ? 45 : 0)
    ];
    offset_y = string_offset_y(key_string_index(key_idx));
    first_bend_offset_y = 38 + key_idx * 7;
    difference() {
        polygon([
           // Bottom to first bend
           bottom,
           [bottom.x, first_bend_offset_y],
           // Second bend to top
           [top.x, offset_y],
           top,
           // Top to second bend
           [top.x + top_width, top.y],
           [top.x + top_width, offset_y],
           // Second bend to first bend
           [bottom.x + bottom_width, first_bend_offset_y + 6],
           [bottom.x + bottom_width, bottom.y],
        ]);
        if(is_sharp(key_idx+1)) offset(delta=1) key_lever_2d(key_idx+1);
        if(is_sharp(key_idx-1)) offset(delta=1) key_lever_2d(key_idx-1);
    }
}

module key_lever_3d(key_idx) {
    color(col_key_lever) {
        linear_extrude(nat_height) key_lever_2d(key_idx);
        // Small extrusion to fit in slot (is this right?)
        translate([slot_position(key_idx), key_lever_top_y, 2]) cube([1, 7, 5]);
    }
    tangent(key_idx);
}

module natural_key_top(key_idx) {
    translate([nat_offset_x(key_idx) - 1, kb_start.y - 1, nat_height])
        color(col_natural)
        linear_extrude(2)
            square([nat_width - 1, -kb_start.y + 1]);
}

module natural_key(key_idx) {
    key_lever_3d(key_idx);
    natural_key_top(key_idx);
}

module sharp_key_top(key_idx) {
    translate([nat_offset_x(key_idx) + nat_width - sharp_width/2, -45, 5])
        color(col_sharp)
        cube([sharp_width, sharp_length, sharp_height]);
}

module sharp_key(key_idx) {
    // Sharp key (Accidentals)
    // Note pattern for F major scale start: F(0), G(1), A(2), B(3), C(4), D(5), E(6)
    // Standard keyboard sharps are between: F-G, G-A, A-B, C-D, D-E
    key_lever_3d(key_idx);
    sharp_key_top(key_idx);
}

module tangent(key_idx) {
    translate([slot_position(key_idx), string_offset_y(key_string_index(key_idx)) - 1, nat_height])
        color(col_brass)
        cube([1.5, 3, tangent_height]);
}

module keyboard() {
    translate([0, 0, kb_start.z])
       for(key_idx=[0:num_keys - 1])
            if (is_sharp(key_idx))
                sharp_key(key_idx);
            else
                natural_key(key_idx);
}

module internal_components() {
    hitchpin_block();
    hitchpins();
    rack();

    soundboard();
    bridge();
    strings();

    wrestplank();
    tuning_pins();
}

module assembly() {
    clavichord_case();
    keyboard();
    internal_components();
}

assembly();
