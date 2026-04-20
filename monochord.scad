c_inner_length = 644;
c_inner_width = 138;
c_height = 69;
wall_th = 10;

num_keys = 22;
key_width = 20.7;
key_depth = 30;
key_height = 10;
kb_length = 414;
kb_pos = [
    wall_th + (c_inner_length - kb_length) / 2,
    key_depth,
    c_height - key_height - 16
];
nat_width = 17;
nat_depth = 81.5;
nat_height = 10;
sharp_width = 14.3;
sharp_depth = 41.2;
sharp_height = 4.9;

/* [Internal Component Dimensions (mm-R)] */

// Hitchpin block thickness (?)
hitchpin_block_th = 13;
// Hitchpin block height (?)
hitchpin_block_height = 60;
// Hitchpin height (?)
hitchpin_height = 5;
// Hitchpin radius (?)
hitchpin_radius = 1;

// Rack thickness (?)
rack_th = 13;
// Rack width (?)
rack_width = 450;
// Rack height (?)
rack_height = 30;
// Rack starting position (XYZ) (?)
rack_pos = [
    wall_th + hitchpin_block_th,
    wall_th + c_inner_width - rack_th,
    c_height - rack_height - wall_th
];
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
    40
];

// Bridge position
bridge_pos = [
    c_inner_length - 101,
    (c_inner_width / 2) + wall_th,
    soundboard_pos.z + soundboard_height
];
bridge_width = 40;
bridge_height = 22;
bridge_top_depth = 1;
bridge_bottom_depth = 10;

key_octave_and_pitch_class = [
    [2, 7],    // G2
    [2, 9],    // A2
    [2, 11],   // B2
    [3, 0],    // C3
    [3, 2],    // D3
    [3, 4],    // E3
    [3, 5],    // F3
    [3, 7],    // G3
    [3, 9],    // A3
    [3, 10],   // Bb3
    [3, 11],   // B3
    [4, 0],    // C4
    [4, 2],    // D4
    [4, 4],    // E4
    [4, 5],    // F4
    [4, 7],    // G4
    [4, 9],    // A4
    [4, 10],   // Bb4
    [4, 11],   // B4
    [5, 0],    // C5
    [5, 2],    // D5
    [5, 4],    // E5
];

vibrating_string_length_g2 = 506;
frequency_a4 = 440;
key_lever_top_y = c_inner_width - rack_th - 1;
debug_mode = true;

function is_accidental(key_idx) =
    let (pitch_class = key_octave_and_pitch_class[key_idx][1])
    pitch_class == 1 || pitch_class == 3 || pitch_class == 6 || pitch_class == 8;

// Transpose from C4 to A4
function transpose(octave, pitch_class) =
    let (transposed = 12*(octave - 1) + 3 + pitch_class)
    [floor(transposed / 12) - 4, transposed % 12];
    
function key_label(key_idx) = 
    let (
        key = key_octave_and_pitch_class[key_idx],
        pitch_class_to_note = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "Bb", "B"],
    )
    str(pitch_class_to_note[key[1]], key[0]);

function key_frequency(key_idx) = 
    let (
        transposed = transpose(key_octave_and_pitch_class[key_idx][0], key_octave_and_pitch_class[key_idx][1]),
        n = (transposed[1]*7) % 12,
        pythagoreanRatio = (3/2) ^ (n > 6 ? n - 12 : n),
        normalizedRatio = pythagoreanRatio / 2 ^ floor(log(pythagoreanRatio) / log(2)),
    )
    frequency_a4
    * 2^transposed[0]
    * normalizedRatio;

function sounding_length(key_idx) =
    key_frequency(0) * vibrating_string_length_g2 / key_frequency(key_idx);

function slot_x(key_idx) = bridge_pos.x - sounding_length(key_idx);


tangent_top_width = 2.5;
tangent_height = 5;
tangent_depth = 1;
rack_tongue_width = 1;
rack_tongue_depth = 7;
rack_tongue_height = 5;

string_diameter = 0.5;

col_wood_med = [0.55, 0.35, 0.15];
col_wood_dark = [0.35, 0.20, 0.10];
col_brass = [0.85, 0.75, 0.30];
col_key_lever = [0.9, 0.9, 0.9];
col_natural = [0.90, 0.88, 0.80];
col_sharp = [0.15, 0.15, 0.15];

if (debug_mode) {
    for (key_idx=[0:num_keys-1]) {
        echo(key_idx=key_idx,
            key_label=key_label(key_idx),
            sounding_length=sounding_length(key_idx),
            slot_x=slot_x(key_idx),
            transpose=transpose(key_octave_and_pitch_class[key_idx][0], key_octave_and_pitch_class[key_idx][1]),
            key_frequency=key_frequency(key_idx),
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
        translate([
            slot_x(key_idx),
            rack_pos.y,
            rack_pos.z
        ])
            cube([slot_width, rack_th - 2, rack_height+1]);
}

module rack_block() {
    translate(rack_pos)
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

module tangent(key_idx) {
    color(col_brass)
        rotate([90, 0, 90])
        linear_extrude(tangent_depth)
            polygon([
                [-tangent_top_width/4, 0],
                [-tangent_top_width/2, tangent_height],
                [tangent_top_width/2, tangent_height],
                [tangent_top_width/4,0],
            ]);
}

function key_x(key_idx) =
    kb_pos.x
    // TOOD: simplify
    + (key_idx - (key_idx >= 9 ? (key_idx >= 17 ? 2 : 1) : 0)) * nat_width
    + (is_accidental(key_idx) ? nat_width - floor(sharp_width/2) : 0);

module rack_tongue(key_idx) {
    translate([
        slot_x(key_idx) - rack_tongue_width/2,
        key_lever_top_y,
        kb_pos.z + 2
    ])
        cube([rack_tongue_width, rack_tongue_depth, rack_tongue_height]);
}

string_y = key_lever_top_y - 15;

// 2d polygon for the key lever, which will be extruded.
// This is a mess because I couldn't figue out an underlying pattern in how the keys are cranked.
module key_lever_2d(key_idx) {
    top_width = key_idx > 38 ? 5 : 10;
    bottom_width = (is_accidental(key_idx) ? sharp_width : nat_width) - 3;
    top = [
        slot_x(key_idx) - top_width/2,
        key_lever_top_y
    ];
    bottom = [
        key_x(key_idx),
        kb_pos.y + (is_accidental(key_idx) ? 45 : 0)
    ];
    second_bend_y = string_y - 10;
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
                    if (!is_accidental(key_idx)) {
                        if(key_idx > 0) offset(delta=1) key_lever_2d(key_idx-1);
                        if (key_idx < num_keys - 1) offset(delta=1) key_lever_2d(key_idx+1);
                    }
                };
    }
    tangent(key_idx);
}


module key(key_idx) {
    difference() {
        key_lever_3d(key_idx);
        // TODO
        //balance_pin(key_idx, balance_pin_radius + 0.5);
    }
}

module keyboard() {
   for (key_idx=[0:num_keys - 1])
       key(key_idx);
}

module bridge() {
    translate([
        bridge_pos.x,
        bridge_pos.y + bridge_width,
        bridge_pos.z + bridge_height
    ])
        rotate([90, 180, 0])
        color(col_wood_dark)
        linear_extrude(bridge_width)
            polygon([
                [-bridge_top_depth/2, 0],
                [-bridge_bottom_depth/2, bridge_height],
                [bridge_bottom_depth/2, bridge_height],
                [bridge_top_depth/2, 0],
            ]);
    }

module assembly() {
    case();
    hitchpin_block();
    rack();
    wrestplank();
    bridge();
    keyboard();
}

assembly();
