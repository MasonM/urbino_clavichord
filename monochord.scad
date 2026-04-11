c_inner_length = 644;
c_inner_width = 138;
c_height = 69;
wall_th = 10;

num_keys = 20;
key_width = 20.7;
key_depth = 30;
key_height = 10;
kb_length = 414;
kb_pos = [
    wall_th + (c_inner_length - kb_length) / 2,
    key_depth,
    c_height - key_height - 16
];

/* [Internal Component Dimensions (mm-R)] */
// Rack thickness (?)
rack_th = 13;
// Rack width (?)
rack_width = 450;
// Rack height (?)
rack_height = 30;
// Rack starting position (XYZ) (?)
rack_pos = [
    0,
    wall_th + c_inner_width - rack_th,
    c_height - rack_height - wall_th
];

// Hitchpin block thickness (?)
hitchpin_block_th = 13;
// Hitchpin block height (?)
hitchpin_block_height = 60;
// Hitchpin height (?)
hitchpin_height = 5;
// Hitchpin radius (?)
hitchpin_radius = 1;
// Slot width (?)
slot_width = 1.5;

// Wrestplank width (?)
wrestplank_width = 20;
// Wrestplank height (?)
wrestplank_height = 20;
// Wrestplank position (?)
wrestplank_pos = [
    wall_th + c_inner_length - wrestplank_width,
    wall_th,
    27
];
// Soundboard width (?)
soundboard_width = 190;
// Soundboard depth (?)
soundboard_depth = c_inner_width;
// Soundboard height (?)
soundboard_height = 3;
// Soundboard position
soundboard_pos = [
    c_inner_length - wrestplank_width - soundboard_width,
    wall_th,
    50
];
key_frequencies = [
    97.99886,   // G2
    110,        // A2
    123.4708,   // B2
    130.8128,   // C3
    146.8324,   // D3
    164.8138,   // E3
    174.6141,   // F3
    195.9977,   // G3
    220,        // A3
    233.0819,   // Bb3
    233.0819,   // B3
    261.6256,   // C4
    293.6648,   // D4
    329.6276,   // E4
    349.2282,   // F4
    391.9954,   // G4
    440,        // A4
    466.1638,   // Bb4
    493.8833,   // B4
    523.2511,   // C5
    587.3295,   // D5
    659.2551,   // E5
];
key_semitones = [
    0, // G
    2, // A
    2, // B
    1, // C
    2, // D
    2, // E
    1, // F
    2, // G
    2, // A
    1, // Bb
    1, // B
    1, // C
    2, // D
    2, // E
    1, // F
    2, // G
    2, // A
    1, // Bb
    1, // B
    1, // C
    2, // D
    2, // E
];
debug_mode = true;
vibrating_string_length = 506;

string_diameter = 0.5;
string_tension = 6.772;
// Brass
string_density = 8600;

col_wood_med = [0.55, 0.35, 0.15];
col_wood_dark = [0.35, 0.20, 0.10];

function sounding_length(key_idx) = key_idx == 0 ? vibrating_string_length : ((key_frequencies[0] * vibrating_string_length)/key_frequencies[key_idx]);

function frequency(sounding_length) = (1/(sounding_length*string_diameter)) * sqrt(string_tension/(PI*string_density));

function slot_x(key_idx) = key_idx == 0 ? (vibrating_string_length + 5) : slot_x(key_idx - 1) * (8/9)^key_semitones[key_idx];

if (debug_mode) {
    for (key_idx=[0:num_keys-1]) {
        echo(key_idx=key_idx,
            slot_x=slot_x(key_idx),
            sounding_length=sounding_length(key_idx)
        );
    }
}

module case() {
    color(col_wood_med)
    difference() {
        // Main outer block
        cube([c_inner_length + 2*wall_th, c_inner_width + 2*wall_th, c_height]);

        // Hollow interior
        translate([wall_th, wall_th, wall_th])
            cube([c_inner_length, c_inner_width, c_height]);

        // Keyboard cutout in the front wall
        translate([kb_pos.x, -1, kb_pos.z])
            cube([kb_length, wall_th + 2, 12]);
    }
}

module rack_slot_cutouts() {
   for (key_idx=[0:num_keys - 1])
        translate(rack_pos)
            translate([vibrating_string_length  - sounding_length(key_idx) - slot_width/2, -1, 0])
                cube([slot_width, rack_th - 2, rack_height+1]);
}

module rack_block() {
    translate(rack_pos)
        translate([wall_th + hitchpin_block_th, 0, 0])
            cube([rack_width, rack_th, rack_height]);
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
            c_inner_width,
            hitchpin_block_height
        ]);
}

module rack() {
    color(col_wood_dark)
    difference() {
        rack_block();
        rack_slot_cutouts();
    }
}

module wrestplank() {
    translate(wrestplank_pos)
        color(col_wood_dark)
        cube([wrestplank_width, c_inner_width, wrestplank_height]);
}

module assembly() {
case();
hitchpin_block();
rack();
wrestplank();
}

assembly();
