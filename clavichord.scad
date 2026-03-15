/*
 * 3D model of the clavichord depicted in the 1479 intarsia from the Studiolo of Ducal Palace at Urbino.
 * Based on dimensions from "The Urbino Clavichord Revisited" by Pierre Verbeek.
 *
 * © 2026 by Mason Malone. Repository: https://github.com/MasonM/urbino_clavichord/
 * Licensed under CC BY 4.0. To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
 *
 * Render with OpenSCAD (F5 for preview, F6 to render).
 */

// --- Variables & Dimensions ---

// All dimensions are in millimeters (mm).
// A "(?)" indicates the value was guesstimated and should not be treated as exact

/* [Toggle Visibility] */
// Show case
show_case = true;
// Show internal components
show_internals = true;
// Show soundboard/bridge
show_soundbox = true;
// Show keyboard
show_keyboard = true;
// Show strings
show_strings = true;

/* [Number of keys/strings/pins] */
// Number of keys
num_keys = 47;
// Number of strings
num_strings = 34;
// Number of tuning pins
num_tuning_pins = 36;

/* [Case Dimensions (mm-R)] */
// Case length
c_length = 1005;
// Case width
c_width = 216;
// Case height
c_height = 82;
// Wall thickness
wall_th = 12;
right_edge = c_length - wall_th;

/* [Internal Component Dimensions (mm-R)] */
// Rack thickness
rack_th = 13;
// Rack width (?)
rack_width = 836;
// Rack height (?)
rack_height = 30;
// Rack starting position (XYZ) (?)
rack_pos = [
    0,
    c_width - wall_th - rack_th,
    c_height - rack_height - wall_th
];
// Backrail thickness (?)
backrail_th = 30;
// Backrail height (?)
backrail_height = 42;
// Balance rail height (?)
balance_rail_height = 30;
// Balance rail depth (?)
balance_rail_depth = 20;
// Wrestplank width (?)
wrestplank_width = 30;
// Wrestplank height (?)
wrestplank_height = 30;
// Hitchpin block thickness (?)
hitchpin_block_th = 13;
// Hitchpin block height (?)
hitchpin_block_height = 60;
// Slot positions from right edge of case
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
// Slot width (?)
slot_width = 1.5;

/* [Soundbox Dimensions (mm-R)] */
// Bridge width
bridge_width = 98;
// Bridge height
bridge_height = 22;
// Bridge top depth (?)
bridge_top_depth = 1;
// Bridge bottom depth (?)
bridge_bottom_depth = 15;
// Soundboard width (?)
soundboard_width = 190;
// Soundboard depth (?)
soundboard_depth = 192;
// Soundboard height (?)
soundboard_height = 3;
// Soundboard position
soundboard_pos = [
    right_edge - wrestplank_width - soundboard_width,
    wall_th,
    50
];
// Mousehole height (?)
mousehole_height = 100;
// Mousehole radius (?)
mousehole_radius = 30;
// Belly rail width (?)
belly_rail_width = 10;
// Belly rail depth (?)
belly_rail_depth = 162;
// Belly rail height (?)
belly_rail_height = 43;

/* [String/Pin Dimensions (mm-R)] */
// Hitchpin height (?)
hitchpin_height = 5;
// Hitchpin radius (?)
hitchpin_radius = 1;
// Balance pin height (?)
balance_pin_height = 15;
// Balance pin radius (?)
balance_pin_radius = 1;
// Tuning pin height (?)
tuning_pin_height = 23;
// Tuning pin radius (?)
tuning_pin_radius = 1.5;
// String radius (?)
string_radius = 0.4;

/* [Keyboard Dimensions (mm-R)] */
// Natural key width
nat_width = 25.3;
// Natural key depth
nat_depth = 81.5;
// Natural key height
nat_height = 10;
// Sharp key width
sharp_width = 14.3;
// Sharp key depth
sharp_depth = 41.2;
// Sharp key height
sharp_height = 15;
// Tangent striking width (?)
tangent_width = 3;
// Tangent depth (?)
tangent_depth = 1;
// Tangent height (?)
tangent_height = 5;
// Rack tongue width (?)
rack_tongue_width = 1;
// Rack tongue depth (?)
rack_tongue_depth = 7;
// Rack tongue height (?)
rack_tongue_height = 5;

kb_start = [
    122,
    -nat_depth,
    c_height - nat_height - 16
];
// Keyboard total length
kb_length = 734;
key_lever_top_y = c_width - wall_th - rack_th - 1;

/* [Colors (RGB)] */
// Dark wood
col_wood_dark = [0.35, 0.20, 0.10];
// Light wood
col_wood_light = [0.80, 0.65, 0.40];
// Medium wood
col_wood_med = [0.55, 0.35, 0.15];
// Key lever
col_key_lever = [0.9, 0.9, 0.9];
// Natural key top
col_natural = [0.90, 0.88, 0.80];
// Sharp key top
col_sharp = [0.15, 0.15, 0.15];
// Brass
col_brass = [0.85, 0.75, 0.30];
// String
col_string = [0.90, 0.90, 0.90];

/* [Advanced] */
$fn = 16;
debug_mode = false;

// -- Helper functions ---

// Return y position for given string.
// Group strings in groups of 4, except bottom 2 and top 4.
function string_y(string_idx) = key_lever_top_y - 2 - (string_idx*1.3) - floor(string_idx/4) * 3 - (string_idx > 1 ? 3 : 0);

// Return x position for the tuning pin connected to the given string
function tuning_pin_x(string_idx) = right_edge - 7 -(string_idx%4)*5;

// Return string_idx of the first string that the tangent for the given key should strike.
// https://oeis.org/A057356
function key_string_idx(key_idx) = num_strings - 1 - 2*(key_idx < 5 ? key_idx : floor(2*(key_idx-1)/7) + 4);

// Return index of the closest (to the left) natural key for the given key
// https://oeis.org/A366701
function nat_idx(key_idx) = key_idx > 1 ? (round((key_idx + 8) * log(3/2)/log(2)) - 4) : key_idx;

// Return x position of slot for given key
function slot_x(key_idx) = right_edge - slot_positions_right[key_idx];

// Return true if given key is a sharp, false if not
function is_sharp(key_idx) = key_idx > 0 && key_idx < num_keys-1 && nat_idx(key_idx) == nat_idx(key_idx-1);

// Return x position for the given key
function key_x(key_idx) = kb_start.x + nat_idx(key_idx) * nat_width + (is_sharp(key_idx) ? nat_width - floor(sharp_width/2) : 0);

// Debugging: dump out values of each function for every key/string
if (debug_mode) {
    for (key_idx=[0:num_keys-1]) {
        echo(key_idx=key_idx,
            nat_idx=nat_idx(key_idx),
            is_sharp=is_sharp(key_idx),
            key_x=key_x(key_idx),
            slot_x=slot_x(key_idx),
            key_string_idx=key_string_idx(key_idx),
            key_string_y=string_y(key_string_idx(key_idx))
        );
    }

    for (string_idx=[0:num_strings-1]) {
        echo(string_idx=string_idx,
            string_y=string_y(string_idx),
            tuning_pin_x=tuning_pin_x(string_idx)
        );
    }
}

// --- Modules ---

module case() {
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
    for (string_idx=[0:num_strings-1])
        translate([
            wall_th+5,
            string_y(string_idx),
            c_height - 10
        ])
            color(col_brass)
            cylinder(h=hitchpin_height, r=hitchpin_radius);
}

module hitchpin_block() {
    translate([
        wall_th,
        wall_th,
        c_height - hitchpin_block_height - 10
    ])
        color(col_wood_dark)
        cube([
            hitchpin_block_th,
            c_width - 2*wall_th,
            hitchpin_block_height
        ]);
}

module rack_slot_cutouts() {
   for (key_idx=[0:num_keys - 1])
        translate(rack_pos)
            translate([slot_x(key_idx) - slot_width/2, -1, 0])
                cube([slot_width, rack_th - 2, rack_height+1]);
}

module rack_block() {
    translate(rack_pos)
        translate([wall_th + hitchpin_block_th, 0, 0])
            cube([rack_width, rack_th, rack_height]);
}

module rack() {
    color(col_wood_dark)
    difference() {
        rack_block();
        rack_slot_cutouts();
    }
}

module backrail() {
    translate([
        wall_th + hitchpin_block_th,
        c_width - wall_th - backrail_th,
        wall_th
    ])
        color(col_wood_dark)
        cube([rack_width, backrail_th, backrail_height]);
}

module balance_rail() {
    translate([
        kb_start.x,
        wall_th,
        kb_start.z - balance_rail_height - 1
    ])
        color(col_wood_dark)
        cube([kb_length, balance_rail_depth, balance_rail_height]);

    for(key_idx=[0:num_keys - 1])
        balance_pin(key_idx, balance_pin_radius);
}

module belly_rail() {
    translate([
        soundboard_pos.x - belly_rail_width,
        soundboard_pos.y,
        wall_th
    ])
        color(col_wood_dark)
        difference() {
            cube([belly_rail_width, belly_rail_depth, belly_rail_height]);
            // Oblong cylinder to create a hole
            rotate([0, 90, 0])
                translate([-20, (belly_rail_depth / 2), -15])
                    scale([1,4,1])
                        cylinder(h=100, r=10);
        }
}

module soundboard() {
    color(col_wood_light)
    difference() {
        translate(soundboard_pos)
            cube([soundboard_width, soundboard_depth, soundboard_height]);
        // Cylinder to cut out a mousehole
        translate([right_edge - 150, 120, 0])
            cylinder(h=mousehole_height, r=mousehole_radius);
        backrail();
        rack_block();
        balance_rail();
    };
}

module bridge() {
    translate([
        right_edge - 101,
        c_width - wall_th - 95,
        soundboard_pos.z + soundboard_height
    ])
        rotate([90, 0, 90])
        color(col_wood_dark)
        intersection() {
            linear_extrude(100)
                bridge_2d();
            bridge_taper();
        }
}

module bridge_2d() {
    difference() {
        square([bridge_width, bridge_height]);
        translate([-12, 5, 0])
            circle(bridge_height);
        translate([30, 0, 0])
            circle(9);
        translate([45, 7, 0])
            circle(10);
        translate([60, 0, 0])
            circle(9);
        translate([bridge_width+5, 5, 0])
            circle(bridge_height);
    };
}

// Long trapezoid to intersect with the bridge so it tapers to top
module bridge_taper() {
    translate([
        c_length/2,
        bridge_height,
        bridge_bottom_depth/2
    ])
        rotate([180, 90, 0])
        linear_extrude(c_length)
            polygon([
                [-bridge_top_depth/2, 0],
                [-bridge_bottom_depth/2, bridge_height+1],
                [bridge_bottom_depth/2, bridge_height+1],
                [bridge_top_depth/2, 0],
            ]);
    }

module strings() {
    for (string_idx=[0:num_strings-1])
        translate([
            wall_th + 5,
            string_y(string_idx),
            soundboard_pos.z + soundboard_height + bridge_height + string_radius
        ])
            rotate([0, 90, 0])
            color(col_string)
            cylinder(h=tuning_pin_x(string_idx) - wall_th - 5, r=string_radius);
}

module wrestplank() {
    translate([right_edge - 30, wall_th, 27])
        color(col_wood_dark)
        cube([wrestplank_width, c_width - 2*wall_th, wrestplank_height]);
}

module tuning_pins() {
    for(string_idx=[0:num_tuning_pins-1])
        translate([
            tuning_pin_x(string_idx),
            string_y(string_idx),
            27 + wrestplank_height
        ])
            color(col_brass)
            cylinder(h=tuning_pin_height, r=tuning_pin_radius);
}

module balance_pin(key_idx, radius) {
    translate([
        key_x(key_idx) + floor((is_sharp(key_idx) ? sharp_width : nat_width)/2) - 1,
        wall_th + 4 + (is_sharp(key_idx) ? 10 : 0),
        kb_start.z - 1
    ])
        color(col_brass)
        cylinder(h=balance_pin_height, r=radius);
}

module tangent(key_idx) {
    translate([
        slot_x(key_idx) + tangent_depth/2,
        string_y(key_string_idx(key_idx)) - tangent_width / 4,
        kb_start.z + nat_height
    ])
        color(col_brass)
        rotate([0, 0, 90])
        // This clavichord uses staple-like tangents
        difference() {
            cube([tangent_width, tangent_depth, tangent_height]);
            translate([0.5, 0, 0])
                cube([
                    tangent_width - 1,
                    tangent_depth + 5,
                    tangent_height - 0.5
                ]);
        }

}

module rack_tongue(key_idx) {
    translate([
        slot_x(key_idx) - rack_tongue_width/2,
        key_lever_top_y,
        kb_start.z + 2
    ])
        cube([rack_tongue_width, rack_tongue_depth, rack_tongue_height]);
}

// 2d polygon for the key lever, which will be extruded.
// This is a mess because I couldn't figue out an underlying pattern in how the keys are cranked.
module key_lever_2d(key_idx) {
    top_width = key_idx > 38 ? 5 : 10;
    bottom_width = (is_sharp(key_idx) ? sharp_width : nat_width) - 3;
    top = [
        slot_x(key_idx) - top_width/2,
        key_lever_top_y
    ];
    bottom = [
        key_x(key_idx),
        kb_start.y + (is_sharp(key_idx) ? 45 : 0)
    ];
    second_bend_y = string_y(key_string_idx(key_idx)) - 10;
    first_bend_y = wall_th + 10 + (key_idx < 9 ? key_idx * 10 : max(80 - ((key_idx-10)*5), 0));

    polygon([
       // Bottom to first bend
       bottom,
       [bottom.x, first_bend_y],
       // Second bend to top
       [top.x, second_bend_y],
       top,
       // Top to second bend
       [top.x + top_width, top.y],
       [top.x + top_width, second_bend_y],
       // Second bend to first bend
       [bottom.x + bottom_width, first_bend_y + (key_idx < 9 ? 6 : -6)],
       [bottom.x + bottom_width, bottom.y],
    ]);
}

module key_lever_3d(key_idx) {
    color(col_key_lever) {
        rack_tongue(key_idx);
        translate([0, 0, kb_start.z])
            linear_extrude(nat_height)
                difference() {
                    key_lever_2d(key_idx);
                    // Subtract neighboring keys so they don't overlap
                    if (!is_sharp(key_idx)) {
                        if(key_idx > 0) offset(delta=1) key_lever_2d(key_idx-1);
                        if (key_idx < num_keys - 1) offset(delta=1) key_lever_2d(key_idx+1);
                    }
                };
    }
    tangent(key_idx);
}

module natural_key_top(key_idx) {
    translate([
        key_x(key_idx) - 1,
        kb_start.y - 1,
        kb_start.z + nat_height
    ])
        color(col_natural)
        linear_extrude(2)
            square([nat_width - 1, -kb_start.y + 1]);
}

module sharp_key_top(key_idx) {
    translate([
        key_x(key_idx),
        -sharp_depth,
        kb_start.z + 5
    ])
        color(col_sharp)
        cube([sharp_width, sharp_depth, sharp_height]);
}

module key(key_idx) {
    difference() {
        key_lever_3d(key_idx);
        balance_pin(key_idx, balance_pin_radius + 0.5);
    }
    if (is_sharp(key_idx))
        sharp_key_top(key_idx);
    else
        natural_key_top(key_idx);
}

module keyboard() {
   for (key_idx=[0:num_keys - 1])
       key(key_idx);
}

module internal_components() {
    hitchpin_block();
    hitchpins();
    balance_rail();
    rack();
    backrail();
    wrestplank();
    tuning_pins();
}

module soundbox() {
    bridge();
    soundboard();
    belly_rail();
}

module assembly() {
    if (show_case) case();
    if (show_keyboard) keyboard();
    if (show_internals) internal_components();
    if (show_soundbox) soundbox();
    if (show_strings) strings();
}

assembly();