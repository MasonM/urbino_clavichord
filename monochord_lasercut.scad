include <./lasercut/lasercut.scad>;

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
lower_bottom_board_th = wall_th;
inner_bottom_z = lower_bottom_board_th + upper_bottom_board_th;

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

kb_length = inner_length * (4/6);
key_width = kb_length / num_naturals;

// "The length of these keys was again calculated according to Arnaut ( = about
// 40 mm)."

key_depth = inner_width * (2/7);
nat_height = wall_th;
kb_pos = [
    wall_th + inner_length * (1/6),
    -key_depth,
    key_depth
];
kb_end = kb_pos.x + kb_length;
accidental_width = key_width / 2;
accidental_height = nat_height / 2;
accidental_depth = key_depth / 2;
key_clearance = key_width / num_keys;

/* [Tangents] */

tangent_height = 10;
tangent_top_width = tangent_height / 2;
tangent_bottom_width = tangent_top_width / 4;
tangent_depth = wall_th / 10;
tangent_top_string_clearance = wall_th / 10;

/* [Hitchpin Block] */

// Hitchpin block thickness (?)
hitchpin_block_th = wall_th * 2;
// Hitchpin block height (?)
hitchpin_block_height = (height - inner_bottom_z) * (2/3);
// Hitchpin height (?)
hitchpin_height = hitchpin_block_height * (2/3);
// Hitchpin radius (?)
hitchpin_radius = wall_th * (1/14);

/* [Rack] */

// Slot width (?)
slot_width = 3;
// Rack thickness (?)
rack_th = wall_th * 2;
// Rack height (?)
rack_height = hitchpin_block_height;
// Rack starting position (XYZ) (?)
rack_pos = [
    wall_th + hitchpin_block_th,
    wall_th + inner_width - rack_th,
    inner_bottom_z
];
// Rack width (?)
rack_width = (slot_x(num_keys - 1) - rack_pos.x) + slot_width * 2;
guide_pin_height = 2*nat_height;
guide_pin_radius = 1;

/* [Key Levers] */

// "Regarding the inner part of the key, the rear start of the taper is
// at 2/5 of the width ( = 55.2 mm)."

second_bend_y = inner_width * (2/5);
key_lever_side_clearance = slot_width / 6;
rack_tongue_width = slot_width * (2/3);
rack_tongue_depth = rack_th * (2/3);
use_rack_tongue = false;
key_lever_top_y = inner_width + wall_th - (use_rack_tongue ? rack_th : wall_th * (1/3)) - key_lever_side_clearance;

/* [Wrestplank] */

// Wrestplank width (?)
wrestplank_width = wall_th * 2;
// Wrestplank height (?)
wrestplank_height = hitchpin_block_height;
// Wrestplank position (?)
wrestplank_pos = [
    wall_th + inner_length - wrestplank_width,
    wall_th,
    inner_bottom_z
];

// Belly rail thickness (supports front edge of soundboard)
belly_rail_th = wall_th / 2;

/* [Backrail] */

// Backrail thickness (?)
backrail_th = wall_th * 2;
// Backrail height
backrail_height = kb_pos.z - inner_bottom_z;
backrail_pos = [
    rack_pos.x,
    wall_th + inner_width - (use_rack_tongue ? rack_th : 0) - backrail_th,
    wrestplank_pos.z
];

/* [Bridge] */

bridge_width = wall_th * 4;
// Cut from 3/4" stock in US mode; historically ~20 mm on a 69 mm-tall case
bridge_height = height * (2/7);
bridge_top_depth = wall_th * (2/14);
bridge_bottom_depth = wall_th;

/* [Soundboard] */

// Soundboard depth (?)
soundboard_depth = inner_width;
// Soundboard height (?)
soundboard_height = wall_th / 3;
// Width of liners for the soundboard to rest on
soundboard_liner_th = belly_rail_th;
soundboard_pos = [
    rack_pos.x + rack_width,
    inner_width + wall_th,
    // Keep the string (soundboard + bridge + string) just above the tangent
    kb_pos.z + nat_height + tangent_height + tangent_top_string_clearance - (bridge_height + soundboard_height)
];
// Soundboard width (?)
soundboard_width = wrestplank_pos.x - soundboard_pos.x;

/* [String and pins] */

string_radius = 0.4;

// Tuning pin radius (?)
tuning_pin_radius = 1;
tuning_pin_x = wrestplank_pos.x + (wrestplank_width / 2);
tuning_pin_height = height - wrestplank_pos.z - wrestplank_height;

// Balance pin height (?)
balance_pin_height = 20;
// Balance pin radius (?)
balance_pin_radius = tuning_pin_radius;

string_pos = [
    wall_th + (hitchpin_block_th / 2),
    // "Furthermore, the string runs at the location designated by Arnaut for the
    // "first pair of strings" ( = 3/5 of the width = 82.8 mm, and 13.8 mm from the
    // center). Thus, Conrad's requirement that it be placed "beyond the center of
    // the total internal width of the monochord, toward the side away from us" was
    // also fulfilled. (All further details can be seen in Fig. II.)""
    wall_th + inner_width * (3/5),
    soundboard_pos.z + soundboard_height + bridge_height + string_radius,
];

/* [Bridge] */

// Bridge position
bridge_pos = [
    bridge_x,
    string_pos.y - string_radius - bridge_width / 2,
    soundboard_pos.z + soundboard_height
];

// Mousehole radius (?)
mousehole_radius = height * (3/14);

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
    key_x(key_idx) + (is_accidental(key_idx-1) ? accidental_width + key_clearance: 0);

function key_size(key_idx) = [
    (is_accidental(key_idx) ? accidental_width : key_width - key_clearance),
    (is_accidental(key_idx) ? accidental_depth : key_depth),
    nat_height + (is_accidental(key_idx) ? accidental_height : 0)
];

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

function key_lever_bottom_width(key_idx) =
    is_accidental(key_idx)
        ? accidental_width
        : (is_accidental(key_idx - 1) ? accidental_width - key_clearance : key_width) - key_clearance;

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

module side_wall() {
    lasercutoutSquare(
            thickness=wall_th,
            x=height,
            y=inner_width,
            finger_joints=[
                [LEFT, 0, 4],
                [UP, 0, 4],
                [DOWN, 0, 4],
            ],
        );
}

module case() {
    color(col_wood_med) {
        // Lower bottom
        #lasercutoutSquare(
            thickness=wall_th,
            x=inner_length,
            y=inner_width,
            finger_joints=[
                [UP, 1, 15],
                [LEFT, 1, 4],
                [RIGHT, 0, 4],
                [DOWN, 1, 15]
            ],
        );

        // Left wall
        translate([0, 0, wall_th]) rotate([0, 270, 0]) #side_wall();

        // Right wall
        translate([inner_length + wall_th, 0, wall_th]) rotate([0, -90, 0]) #side_wall();

        // Back wall
        translate([0, inner_width + wall_th, wall_th]) rotate([90, 0, 0]) lasercutoutSquare(
            thickness=wall_th,
            x=inner_length,
            y=height,
            finger_joints=[
                [LEFT, 1, 4],
                [RIGHT, 0, 4],
                [DOWN, 1, 15]
            ],
        );

        // Front wall
        points = [
            [0,0],
            [inner_length, 0],
            [inner_length, height],
            [kb_pos.x + kb_length, height],
            [kb_pos.x + kb_length, kb_pos.z],
            [kb_pos.x, kb_pos.z],
            [kb_pos.x, height],
            [0, height],
            [0, 0],
        ];
        translate([0, 0, wall_th]) rotate([90, 0, 0]) lasercutout(
            thickness=wall_th,
            points = points,
            finger_joints=[
                [LEFT, 0, 4],
                [RIGHT, 1, 4],
                [DOWN, 0, 15]
            ],
        );

    }

/*
    color(col_wood_med) {
        // Lower bottom
        translate([wall_th, wall_th, 0]) lasercutoutSquare(thickness = thickness);

        // Upper bottom
        if (!use_us_lumber_dimensions)
            translate([wall_th, wall_th, lower_bottom_board_th])
                *bottom("upper bottom", upper_bottom_board_th);

        // Left wall
        side_wall("left wall");

        // Right wall
        translate([inner_length + wall_th, 0, 0]) side_wall("right wall");

        // Back wall
        translate([wall_th, inner_width + wall_th, 0])
            board("back wall", front_back_wall_size);

        // Front wall
        difference() {
            translate([wall_th, 0, 0])
                board("front wall", front_back_wall_size);
            translate([kb_pos.x, -wall_th, kb_pos.z])
                cube([kb_length, 999, 999]);
            balance_pins();
        }
    }
    */
}
case();