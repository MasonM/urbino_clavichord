// Simple diagram of a clavichord action for educational purposes, showing the
// key levever, balance rail, tangent, bridge, and string.
// Each part ("key lever", "balance rail", "tangent", "bridge", and "string") has a text label next to it.

include <BOSL2/std.scad>

/* [Number of keys/strings/pins] */
// Number of keys
num_keys = 1;
// Number of strings
num_strings = 1;

/* [Slot Positions and Sounding Lengths] */
// Array of the format [slot_position, sounding_length], indexed by key_idx, both relative to the bridge.
// e.g. 11th entry is [564.5, 565], which says the slot for the f# key is 564.5mm to the left of the bridge, and the sounding length is 565mm.
note_slot_position_and_sounding_length = [
    [237.0, 237.0], // F
];

/* [Case Dimensions (mm-R)] */
// Case length
c_length = 405;
// Case width
c_width = 216;
// Case height
c_height = 82;
// Wall thickness
wall_th = 12;
right_edge_x = c_length - wall_th;

/* [Internal Component Dimensions (mm-R)] */
// Hitchpin block thickness (?)
hitchpin_block_th = 13;
// Hitchpin block height (?)
hitchpin_block_height = 60;
// Rack thickness
rack_th = 13;
// Rack width (?)
rack_width = 836;
// Rack height (?)
rack_height = 30;
// Rack starting position (XYZ) (?)
rack_pos = [
    wall_th + hitchpin_block_th,
    c_width - wall_th - rack_th,
    c_height - rack_height - wall_th
];
// Balance rail height (?)
balance_rail_height = 30;
// Balance rail depth (?)
balance_rail_depth = 20;
// Slot width (?)
slot_width = 1.5;

/* [Soundbox Dimensions (mm-R)] */
// Bridge width
bridge_width = 98;
// Bridge height
bridge_height = 22;
// Bridge top depth (?)
bridge_top_depth = 1;
// Bridge bottom depth
bridge_bottom_depth = 10;
// Soundboard height (?)
soundboard_height = 3;
// Soundboard position
soundboard_pos = [
    wall_th + hitchpin_block_th + 150,
    wall_th,
    50
];
// Bridge position
bridge_pos = [
    right_edge_x - 201,
    c_width - wall_th - rack_th - 82,
    soundboard_pos.z + soundboard_height
];
// Mousehole height (?)
mousehole_height = 100;
// Mousehole radius (?)
mousehole_radius = 30;

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
// Key top height (?)
key_top_height = 2;
// Sharp key width
sharp_width = 14.3;
// Sharp key depth
sharp_depth = 41.2;
// Sharp key height
sharp_height = 4.9;
// Tangent striking width (?)
tangent_width = 3;
// Tangent depth (?)
tangent_depth = 1;
// Tangent height (?)
tangent_height = 8;
// Rack tongue width (?)
rack_tongue_width = 1;
// Rack tongue depth (?)
rack_tongue_depth = 7;
// Rack tongue height (?)
rack_tongue_height = 5;
// Keyboard start position
kb_pos = [
    122,
    -nat_depth,
    c_height - nat_height - 16
];
// Keyboard total length
kb_length = key_x(num_keys + 1) - kb_pos.x;
// y coordinate of top of each key lever (?)
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
// Iron
col_iron = [0.37, 0.4, 0.41];

/* [Advanced] */
$fn = 16;
// Debugging: dump out values of each function for every key/string
debug_mode = false;

// -- Helper functions ---

// Return y position for given string.
// Group strings in groups of 4, except bottom 2 and top 4.
function string_y(string_idx) =
    key_lever_top_y
    - 2
    - (string_idx*1.5)
    - floor(string_idx/4) * 1.5
    - (string_idx > 1 ? 3 : 0);

// Return x position for the tuning pin connected to the given string
function tuning_pin_x(string_idx) =
    right_edge_x
    - 170
    - (string_idx % 4) * 5;

// Return x position for the hitch pin connected to the given string
function hitch_pin_x(string_idx) = -60;

// Return string_idx of the first string that the tangent for the given key should strike.
// https://oeis.org/A057356
function key_string_idx(key_idx) =
    num_strings - 1
    - 2*(
        key_idx < 5
        ? key_idx
        : floor(2*(key_idx-1)/7) + 4
    );

// Return index of the closest (to the left) natural key for the given key
// https://oeis.org/A366701
function nat_idx(key_idx) = key_idx > 1
    ? (
        round(
            (key_idx)
            * log(3/2)/log(2)
        )
    )
    : key_idx;

// Return x position of slot for given key
function slot_x(key_idx) = bridge_pos.x - note_slot_position_and_sounding_length[key_idx][0];

// Return x position of tangent for given key
function tangent_x(key_idx) = bridge_pos.x - note_slot_position_and_sounding_length[key_idx][1] + tangent_depth/2;

// Return true if given key is a sharp, false if not
function is_sharp(key_idx) =
    key_idx > 0
    && key_idx < num_keys-1
    && nat_idx(key_idx) == nat_idx(key_idx-1);

// Return x position for the given key
function key_x(key_idx) =
    kb_pos.x
    + nat_idx(key_idx) * nat_width
    + (is_sharp(key_idx) ? nat_width - floor(sharp_width/2) : 0);

// --- Modules ---

module case() {
    color(col_wood_med)
    difference() {
        // Main outer block
        cube([c_length, c_width, c_height]);

        // Hollow interior
        translate([wall_th, wall_th, wall_th])
            cube([
                c_length - 2*wall_th,
                c_width - 2*wall_th,
                c_height
            ]);

        // Keyboard cutout in the front wall
        translate([kb_pos.x, -1, kb_pos.z])
            cube([
                kb_length,
                wall_th + 2,
                nat_height + key_top_height
            ]);
    }
}

module hitchpins() {
    for (string_idx=[0:num_strings-1])
        translate([
            hitch_pin_x(string_idx),
            string_y(string_idx),
            c_height - 10
        ])
            color(col_iron)
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
            translate([slot_x(key_idx) - rack_pos.x - slot_width/2, -1, 0])
                cube([slot_width, rack_th - 2, rack_height+1]);
}

module rack_block() {
    translate(rack_pos)
        cube([rack_width, rack_th, rack_height]);
}

module rack() {
    color(col_wood_dark)
    difference() {
        rack_block();
        rack_slot_cutouts();
    }
}

module balance_rail() {
    translate([
        kb_pos.x,
        wall_th,
        kb_pos.z - balance_rail_height - 1
    ])
        color(col_wood_dark)
        cube([kb_length, balance_rail_depth, balance_rail_height]);

    for(key_idx=[0:num_keys - 1])
        balance_pin(key_idx, balance_pin_radius);
}

module bridge() {
    translate(bridge_pos)
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
            hitch_pin_x(string_idx),
            string_y(string_idx),
            soundboard_pos.z + soundboard_height + bridge_height + string_radius
        ])
            rotate([0, 90, 0])
            color(col_string)
            cylinder(
                h=tuning_pin_x(string_idx) - hitch_pin_x(string_idx),
                r=string_radius
            );
}

module balance_pin(key_idx, radius) {
    translate([
        key_x(key_idx) + floor((is_sharp(key_idx) ? sharp_width : nat_width)/2) - 1,
        wall_th + 4 + (is_sharp(key_idx) ? 10 : 0),
        kb_pos.z - 1
    ])
        color(col_iron)
        cylinder(h=balance_pin_height, r=radius);
}

module tangent(key_idx) {
    translate([
        tangent_x(key_idx),
        string_y(key_string_idx(key_idx)) - tangent_width / 4,
        kb_pos.z + nat_height
    ])
        color(col_brass)
        rotate([0, 0, 90])
        // This clavichord uses staple-like tangents
        difference() {
            cube([tangent_width, tangent_depth, tangent_height]);
        }

}

module rack_tongue(key_idx) {
    translate([
        slot_x(key_idx) - rack_tongue_width/2,
        key_lever_top_y,
        kb_pos.z + 2
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
        kb_pos.y + (is_sharp(key_idx) ? 45 : 0)
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
        translate([0, 0, kb_pos.z])
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
        kb_pos.y - 1,
        kb_pos.z + nat_height
    ])
        color(col_natural)
        linear_extrude(key_top_height)
            square([nat_width - 1, -kb_pos.y + 1]);
}

module key(key_idx) {
    difference() {
        key_lever_3d(key_idx);
        balance_pin(key_idx, balance_pin_radius + 0.5);
    }
    natural_key_top(key_idx);
}

// Draw a text label in the YZ plane (facing +X) with the text baseline running
// along the +Y axis. An arrow is drawn from just below the text down to the
// anchor point on the element being labeled.
module label(str, label_pos, anchor, size=8, halign="center") {
    color([0, 0, 0]) {
        translate(label_pos)
            rotate([90, 0, 90])
            linear_extrude(0.5)
                text(str, size=size, halign=halign, valign="center",
                    font="Liberation Sans");

        // Arrow tail starts just below the text and goes to the anchor.
        arrow_start = label_pos - [0, 0, size];
        stroke([arrow_start, anchor], width=1.2,
               endcap1="butt", endcap2="arrow2");
    }
}

module labels() {
    key_string_y = string_y(key_string_idx(0));
    lever_mid_x  = key_x(0) + nat_width/2;

    // Key lever - label above the front of the lever
    label("key lever",
        label_pos=[lever_mid_x-45, 60, c_height + 55],
        anchor=[lever_mid_x-45, 60, kb_pos.z + nat_height]);

    // Balance pin - label above the pin/rail
    label("balance pin",
        label_pos=[lever_mid_x, wall_th + 4, c_height + 20],
        anchor=[lever_mid_x, wall_th + 4, kb_pos.z + 15 ]);

    // Tangent - label above the tangent
    label("tangent",
        label_pos=[tangent_x(0) + tangent_width/2, key_string_y - 25, c_height + 20],
        anchor=[tangent_x(0) + tangent_width/2, key_string_y,
                kb_pos.z + nat_height + tangent_height]);

    // String - label above the string, between tangent and bridge
    label("string",
        label_pos=[(tangent_x(0) + bridge_pos.x) / 2, key_string_y, c_height + 30],
        anchor=[(tangent_x(0) + bridge_pos.x) / 2, key_string_y,
                soundboard_pos.z + soundboard_height + bridge_height + 2*string_radius]);

    // Bridge - label above the bridge where the string crosses it
    label("bridge",
        label_pos=[bridge_pos.x, key_string_y-50, c_height + 55],
        anchor=[bridge_pos.x, key_string_y-50, bridge_pos.z + bridge_height]);
}

module assembly() {
    key(0);
    balance_rail();
    bridge();
    strings();
    labels();
}

//projection(cut=false) rotate([0, 90, 0]) 
assembly();
