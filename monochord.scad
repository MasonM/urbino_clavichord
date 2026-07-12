/**
 * Model of a 15th-century keyed monochord described by Conrad von Zabern in
 * "Novellus musicae artis tractatus", and expounded on by Karl-Werner Gümpel in
 * "Das Tastenmonochord Conrads von Zabern".
 *
 * All quotes taken from "Das Tastenmonochord Conrads von Zabern", translated
 * from German using DeepL.
 */

/* [Visibility Toggles] */
show_case = true;
show_hitchpin_block = true;
show_wrestplank = true;
show_rack = true;
show_backrail = true;

show_keyboard = true;
show_key_labels = true;
show_balance_pins = true;
show_tangents = true;

show_tuning_pin = true;
show_hitchpin = true;
show_string = true;

show_bridge = true;
show_soundboard = true;
show_soundboard_liner = true;
show_belly_rail = true;

/* [Main Dimensions] */
// "The internal length used for our reconstruction is 644 mm (the external
// length is 664 mm), which was determined by adopting a multiple of the number
// 14, as used by Arnaut for dividing the length, resulting in a 1:3 ratio
// consistent with the master's diagram (Plate IX). Of course, this choice of
// size is only one of many possible options."

inner_length = 644;

// "The length-width-height ratio (width = 3/14 of the length = 138 mm; height
// or "altitudo tota" = 1/2 of the width = 69 mm) was also adopted from Arnaut.
// The width was not reduced, since—apart from Conrad's note that the monochord
// body should be made "in the manner of a clavichord body, with similar length,
// depth, and, if desired, also width"—retaining the full width, due to the
// unrestricted soundboard, has a positive effect on the instrument's fullness
// of sound."

inner_width = inner_length * (3/14);
height = inner_width / 2;
wall_th = 10;

// "Likewise, the starting and ending points for measurement, the bridge, and
// the sound hole were placed as follows: the starting point of measurement and
// the bridge (terminus a quo mensurationis and stephanus = terminus ad quem
// mensurationis) at 1/14 and 6/7 of the length (46 and 552 mm). The vibrating
// string length for '-ut is thus 506 mm."

vibrating_string_length_g2 = inner_length * (11/14);
bridge_x = inner_length * (6/7);

// "Furthermore, we learn from Arnaut that the distance between the upper and
// lower bottoms (“distantia inter duos fundos”) is 1/6 of the width (= 1/28 of
// the length = 23 mm)."

upper_bottom_board_th = inner_width / 6;
inner_bottom_z = wall_th + upper_bottom_board_th;

/* [Keyboard] */

// "The keys, that is, the wooden levers which are to touch or strike the
// string, should number twenty, plus two for B-flat. In the part where they
// extend outside the monochord’s body, all should be of equal width and
// completely solid, like the first and last keys of a typical clavichord,
// except for the two keys placed immediately under the second and third C. Each
// key representing B-natural should, in its front or middle part, contain and
// admit the B-flat key as a small or semitone key."

key_octave_and_pitch_class = [
    [2, 7],  // G2
    [2, 9],  // A2
    [2, 11], // B2
    [3, 0],  // C3
    [3, 2],  // D3
    [3, 4],  // E3
    [3, 5],  // F3
    [3, 7],  // G3
    [3, 9],  // A3
    [3, 10], // Bb3
    [3, 11], // B3
    [4, 0],  // C4
    [4, 2],  // D4
    [4, 4],  // E4
    [4, 5],  // F4
    [4, 7],  // G4
    [4, 9],  // A4
    [4, 10], // Bb4
    [4, 11], // B4
    [5, 0],  // C5
    [5, 2],  // D5
    [5, 4],  // E5
];
num_keys = len(key_octave_and_pitch_class);
cumsum_accidentals = [for (
    a=0, i=0;
    i < num_keys;
    i = i + 1, a = a + (is_accidental(i) ? 1 : 0)
) a];
num_naturals = num_keys - cumsum_accidentals[num_keys - 1];

// "To conclude regarding the construction of the keys: According to Conrad's
// specifications, the outer surfaces of the "first ... and last ... keys" each
// begin at a distance from the ends that is a little more than one-sixth of the
// total length ( = 115 mm). By evenly dividing the remaining space ( = 414 mm),
// a theoretical width of 20.7 mm could be achieved for each of the twenty
// "lower keys," while in practice the width was just under 20 mm. (For the
// width of the two "upper keys," the "half-width of a key" was used.)""

kb_length = 414;
key_width = kb_length / num_naturals;

// "The length of these keys was again calculated according to Arnaut ( = about
// 40 mm)."

key_depth = 40;
nat_height = 6;
kb_pos = [
    wall_th + 115,
    -key_depth,
    height - nat_height - 16
];
kb_end = kb_pos.x + kb_length;
accidental_width = key_width / 2;
accidental_height = nat_height / 2;
accidental_depth = key_depth / 2;

/* [Tangents] */

tangent_top_width = 4;
tangent_height = 10;
tangent_depth = 1;

/* [Hitchpin Block] */

// Hitchpin block thickness (?)
hitchpin_block_th = 13;
// Hitchpin block height (?)
hitchpin_block_height = 25;
// Hitchpin height (?)
hitchpin_height = 20;
// Hitchpin radius (?)
hitchpin_radius = 1;

/* [Backrail] */

// Backrail thickness (?)
backrail_th = 15;
// Backrail height
backrail_height = kb_pos.z - inner_bottom_z;

/* [Rack] */

// Slot width (?)
slot_width = 3;
// Rack thickness (?)
rack_th = 13;
rack_top_clearance = 5;
// Rack height (?)
rack_height = height - inner_bottom_z - rack_top_clearance;
// Rack starting position (XYZ) (?)
rack_pos = [
    wall_th + hitchpin_block_th,
    wall_th + inner_width - rack_th,
    inner_bottom_z
];
// Rack width (?)
rack_width = (slot_x(num_keys - 1) - rack_pos.x) + slot_width + 5;

/* [Key Levers] */

// "Regarding the inner part of the key, the rear start of the taper is
// at 2/5 of the width ( = 55.2 mm)."

second_bend_y = inner_width * (2/5);
key_lever_top_y = inner_width + wall_th - rack_th - 1;
key_lever_side_clearance = 0.5;
rack_tongue_width = slot_width - 1;
rack_tongue_depth = 7;

/* [Wrestplank] */

// Wrestplank width (?)
wrestplank_width = 10;
// Wrestplank height (?)
wrestplank_height = 20;
// Wrestplank position (?)
wrestplank_pos = [
    wall_th + inner_length - wrestplank_width,
    wall_th,
    inner_bottom_z
];

// Belly rail thickness (supports front edge of soundboard)
belly_rail_th = 12;

/* [String and pins] */

string_radius = 0.4;
string_x = wall_th + (hitchpin_block_th / 2);

// "Furthermore, the string runs at the location designated by Arnaut for the
// "first pair of strings" ( = 3/5 of the width = 82.8 mm, and 13.8 mm from the
// center). Thus, Conrad's requirement that it be placed "beyond the center of
// the total internal width of the monochord, toward the side away from us" was
// also fulfilled. (All further details can be seen in Fig. II.)""

string_y = wall_th + inner_width * (3/5);

// Tuning pin radius (?)
tuning_pin_radius = 1.5;
tuning_pin_x = wrestplank_pos.x + (wrestplank_width / 2);
tuning_pin_height = height - wrestplank_pos.z - wrestplank_height + 5;

// Balance pin height (?)
balance_pin_height = nat_height + 10;
// Balance pin radius (?)
balance_pin_radius = 1;

/* [Soundboard] */

soundboard_clearance = 1;
soundboard_pos = [
    rack_pos.x + rack_width +  soundboard_clearance,
    inner_width + wall_th,
    40
];
// Soundboard width (?)
soundboard_width = wrestplank_pos.x - soundboard_pos.x;
// Soundboard depth (?)
soundboard_depth = inner_width;
// Soundboard height (?)
soundboard_height = 3;
// Width of liners for the soundboard to rest on
soundboard_liner_th = 5;

/* [Bridge] */

// Bridge position
bridge_width = 40;
bridge_height = 22;
bridge_top_depth = 1;
bridge_bottom_depth = 10;
bridge_pos = [
    bridge_x,
    string_y - string_radius - bridge_width / 2,
    soundboard_pos.z + soundboard_height
];

// Mousehole radius (?)
mousehole_radius = 15;

// "In contrast, the center of the sound hole (foramen
// rotundum pro resonantia) is at 506 mm (11/14 of the length)."
mousehole_pos = [
    (inner_length * (11/14)) + mousehole_radius,
    bridge_pos.y + mousehole_radius,
    0
];

/* [Colors] */
col_wood_med = [0.55, 0.35, 0.15];
col_wood_dark = [0.35, 0.20, 0.10];
col_wood_light = [0.80, 0.65, 0.40];
col_brass = [0.85, 0.75, 0.30];
col_key_lever = [0.90, 0.88, 0.80];
col_natural = [0.9, 0.9, 0.9];
col_iron = [0.37, 0.4, 0.41];

/* [Advanced] */
debug_mode = false;
$fn = 16;

function is_accidental(key_idx) =
    let (
        pitch_class = key_octave_and_pitch_class[key_idx][1],
        pitch_class_accidentals = [false, true, false, true, false, false, true, false, true, false, true, false]
    )
    pitch_class_accidentals[pitch_class];

function key_x(key_idx) =
    kb_pos.x
    + (key_idx - (key_idx > 0 ? cumsum_accidentals[key_idx - 1] : 0)) * key_width;

function key_lever_x(key_idx) =
    key_x(key_idx) + (is_accidental(key_idx-1) ? accidental_width + 1: 0);

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

function key_frequency(key_idx, reference_frequency_a4=1) =
    let (
        transposed = transpose(key_octave_and_pitch_class[key_idx][0], key_octave_and_pitch_class[key_idx][1]),
        n = (transposed[1]*7) % 12,
        pythagoreanRatio = (3/2) ^ (n > 6 ? n - 12 : n),
        normalizedRatio = pythagoreanRatio / 2 ^ floor(log(pythagoreanRatio) / log(2)),
    )
    reference_frequency_a4
    * 2^transposed[0]
    * normalizedRatio;

function sounding_length(key_idx) =
    key_frequency(0) * vibrating_string_length_g2 / key_frequency(key_idx);

function slot_x(key_idx) = bridge_x - sounding_length(key_idx);

// Return x position of tangent for given key
function tangent_x(key_idx) = slot_x(key_idx) + tangent_depth/2;

function key_lever_top_width(key_idx) =
    let (
        cur_tangent_x = tangent_x(key_idx),
        left_tangent_x = key_idx == 0 ? -999 : tangent_x(key_idx-1),
        right_tangent_x = key_idx == num_keys - 1 ? 999 : tangent_x(key_idx+1),
        distance_from_left = cur_tangent_x - left_tangent_x,
        distance_from_right = right_tangent_x - cur_tangent_x
    )
    min(distance_from_left, distance_from_right, key_width) - key_lever_side_clearance;

if (debug_mode) {
    for (key_idx=[0:num_keys-1]) {
        echo(key_idx=key_idx,
            cumsum_accidentals=cumsum_accidentals[key_idx],
            is_accidental=is_accidental(key_idx),
            key_label=key_label(key_idx),
            sounding_length=sounding_length(key_idx),
            key_frequency=key_frequency(key_idx, 440),
            slot_x=slot_x(key_idx),
            transpose=transpose(key_octave_and_pitch_class[key_idx][0], key_octave_and_pitch_class[key_idx][1]),
        );
    }
}

module bottom(thickness) {
    cube([inner_length, inner_width, thickness]);
}

module side_wall() {
    cube([wall_th, inner_width + 2*wall_th, height]);
}

module back_wall() {
    cube([inner_length, wall_th, height]);
}

module case() {
    color(col_wood_med) {
        // Lower bottom
        translate([wall_th, wall_th, 0]) bottom(wall_th);

        // Upper bottom
        translate([wall_th, wall_th, wall_th]) bottom(upper_bottom_board_th);

        // Left wall
        side_wall();

        // Right wall
        translate([inner_length + wall_th, 0, 0]) side_wall();

        translate([wall_th, inner_width + wall_th, 0]) back_wall();

        // Front wall
        difference() {
            translate([wall_th, 0, 0])
                back_wall();
            translate([kb_pos.x, -1, kb_pos.z])
                cube([kb_length, wall_th + 2, 112]);
            balance_pins();
        }
    }
}

module rack_slot_cutouts() {
   for (key_idx=[0:num_keys - 1])
        translate([
            slot_x(key_idx) - (slot_width) / 2,
            rack_pos.y,
            rack_pos.z
        ])
            cube([slot_width, rack_tongue_depth, rack_height+1]);
}

module rack_block() {
    translate(rack_pos)
        cube([rack_width, rack_th, rack_height]);
}

module hitchpin_block() {
    color(col_wood_dark)
    difference() {
        translate([
            wall_th,
            wall_th,
            wrestplank_pos.z,
        ])
            cube([
                hitchpin_block_th,
                inner_width,
                hitchpin_block_height
            ]);
        hitchpin();
    }
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
        rack_pos.x,
        inner_width - backrail_th,
        wrestplank_pos.z
    ])
        color(col_wood_dark)
        cube([rack_width, backrail_th, backrail_height]);
}

module wrestplank() {
    color(col_wood_dark)
    difference() {
        translate(wrestplank_pos)
            cube([wrestplank_width, inner_width, wrestplank_height]);
        tuning_pin();
    }
}

module tangent(key_idx) {
    translate([
        tangent_x(key_idx),
        string_y,
        kb_pos.z + nat_height
    ])
        color(col_brass)
        rotate([90, 0, -90])
        linear_extrude(tangent_depth)
            polygon([
                [-tangent_top_width/4, 0],
                [-tangent_top_width/2, tangent_height],
                [tangent_top_width/2, tangent_height],
                [tangent_top_width/4,0],
            ]);
}

module rack_tongue(key_idx) {
    translate([
        slot_x(key_idx) - (rack_tongue_width) / 2,
        key_lever_top_y,
        kb_pos.z
    ])
        cube([rack_tongue_width, rack_tongue_depth, nat_height]);
}

module key_lever_2d(key_idx) {
    top_width = key_lever_top_width(key_idx);
    bottom_width = is_accidental(key_idx)
        ? accidental_width
        : (is_accidental(key_idx - 1) ? accidental_width - 1 : key_width) - 1;
    first_bend_y = wall_th;
    top = [
        slot_x(key_idx) - top_width/2,
        key_lever_top_y
    ];
    bottom = [
        key_lever_x(key_idx),
        kb_pos.y + key_depth
    ];

    polygon([
       bottom,
       [bottom.x, first_bend_y],
       [top.x, second_bend_y],
       top,
       // Top to second bend
       [top.x + top_width, top.y],
       [top.x + top_width, second_bend_y],
       [bottom.x + bottom_width, first_bend_y],
       [bottom.x + bottom_width, bottom.y],
    ]);
}

module key_lever_3d(key_idx) {
    color(col_key_lever) {
        rack_tongue(key_idx);
        translate([0, 0, kb_pos.z])
            linear_extrude(nat_height)
                key_lever_2d(key_idx);
    }
}

module key(key_idx, offset_delta=0) {
    translate([
        key_x(key_idx),
        kb_pos.y + (is_accidental(key_idx) ? accidental_depth : 0),
        kb_pos.z
    ])
        color(col_natural)
        linear_extrude(nat_height + (is_accidental(key_idx) ? accidental_height : 0))
            offset(delta=offset_delta)
            square([
                (is_accidental(key_idx) ? accidental_width : key_width - 1),
                (is_accidental(key_idx) ? accidental_depth : key_depth),
            ]);
}

module balance_pin(key_idx, radius) {
    translate([
        (key_lever_x(key_idx) + key_lever_x(key_idx+1)) / 2 - 1,
        wall_th / 2,
        kb_pos.z - 5
    ])
        color(col_iron)
        cylinder(h=balance_pin_height, r=radius);
}

module balance_pins() {
    for (key_idx=[0:num_keys - 1])
        balance_pin(key_idx, balance_pin_radius);
}

module tangents() {
    for (key_idx=[0:num_keys - 1])
        tangent(key_idx);
}

module key_labels() {
    for (key_idx=[0:num_keys - 1])
        translate([
            key_x(key_idx) + 2,
            (is_accidental(key_idx) ? -accidental_depth : -key_depth) + 5,
            kb_pos.z + nat_height + (is_accidental(key_idx) ? accidental_height  : 0)
        ])
            color("black")
                linear_extrude(1)
                text(text=key_label(key_idx), size=is_accidental(key_idx) ? 3 : 7);
}

module keyboard() {
    for (key_idx=[0:num_keys - 1]) {
        difference() {
            key(key_idx);
            key(key_idx - 1, 1);
        }
        difference() {
            key_lever_3d(key_idx);
            balance_pin(key_idx, balance_pin_radius + 0.5);
        }
    }
}

module string() {
    translate([
        string_x,
        string_y,
        soundboard_pos.z + soundboard_height + bridge_height + string_radius,
    ])
        rotate([0, 90, 0])
        color(col_brass)
        cylinder(
            h=tuning_pin_x - string_x,
            r=string_radius
        );
}

module hitchpin() {
    translate([
        string_x,
        string_y,
        wrestplank_pos.z + wrestplank_height - 5
    ])
        color(col_iron)
        cylinder(h=hitchpin_height, r=hitchpin_radius);
}

module tuning_pin() {
    translate([
        tuning_pin_x,
        string_y,
        wrestplank_pos.z + wrestplank_height - 5
    ])
        color(col_iron)
        cylinder(h=tuning_pin_height, r=tuning_pin_radius);
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

module soundboard() {
    color(col_wood_light)
    difference() {
        translate([0, 0, soundboard_pos.z]) {
            linear_extrude(soundboard_height)
                polygon([
                    [soundboard_pos.x, soundboard_pos.y],
                    [soundboard_pos.x + soundboard_width, soundboard_pos.y],
                    [soundboard_pos.x + soundboard_width, wall_th],
                    [kb_end + soundboard_clearance, wall_th],
                    [soundboard_pos.x, second_bend_y],
                    [soundboard_pos.x, soundboard_pos.y],
                ]);
        }
        soundboard_mousehole();
    };
}

// Cylinder to cut out a mousehole
module soundboard_mousehole() {
    translate(mousehole_pos)
        cylinder(h=100, r=mousehole_radius);
}

// Belly rail: supports the front edge of the soundboard, following its
// angled outline, plus a ledge along the wrestplank for the rear edge.
module belly_rail() {
    color(col_wood_med) {
        // Rail under the soundboard's front edge
        translate([0, 0, inner_bottom_z])
            linear_extrude(soundboard_pos.z - inner_bottom_z)
                polygon([
                    [soundboard_pos.x, soundboard_pos.y],
                    [soundboard_pos.x, second_bend_y],
                    [kb_end + soundboard_clearance, wall_th],
                    [kb_end + soundboard_clearance + belly_rail_th, wall_th],
                    [soundboard_pos.x + belly_rail_th, second_bend_y],
                    [soundboard_pos.x + belly_rail_th, soundboard_pos.y],
                ]);
    }
}

module soundboard_liner() {
    color(col_wood_med)
        translate([0, wall_th, inner_bottom_z]) {
            // Liner along the front wall supporting the soundboard's front edge
            translate([kb_end + belly_rail_th, 0, 0])
                cube([
                    wrestplank_pos.x - soundboard_liner_th - kb_end - belly_rail_th,
                    soundboard_liner_th,
                    soundboard_pos.z - inner_bottom_z
                ]);

            // Liner along the wrestplank face supporting the soundboard's right edge
            translate([wrestplank_pos.x - soundboard_liner_th, 0, 0])
                cube([
                    soundboard_liner_th,
                    inner_width,
                    soundboard_pos.z - inner_bottom_z
                ]);

            // Liner along the back wall for supporting the soundboard's rear edge
            translate([
                soundboard_pos.x + belly_rail_th,
                inner_width - soundboard_liner_th,
                0
            ])
                cube([
                    wrestplank_pos.x - soundboard_pos.x - soundboard_liner_th - belly_rail_th,
                    soundboard_liner_th,
                    soundboard_pos.z - inner_bottom_z
                ]);

        }
}

module assembly() {
    if (show_case) case();
    if (show_rack) rack();
    if (show_backrail) backrail();
    if (show_bridge) bridge();
    if (show_keyboard) keyboard();
    if (show_key_labels) key_labels();
    if (show_balance_pins) balance_pins();
    if (show_tangents) tangents();
    if (show_wrestplank) wrestplank();
    if (show_tuning_pin) tuning_pin();
    if (show_hitchpin_block) hitchpin_block();
    if (show_hitchpin) hitchpin();
    if (show_string) string();
    if (show_soundboard) soundboard();
    if (show_belly_rail) belly_rail();
    if (show_soundboard_liner) soundboard_liner();
}

assembly();
