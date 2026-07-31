include <./lasercut/lasercut.scad>;

/* [Visibility Toggles] */
show_case = true;
show_hitchpin_block = true;
show_wrestplank = true;
show_rack = true;
show_backrail = true;

show_keyboard = true;
show_balance_rail = true;

show_bridge = true;
show_soundboard = true;
show_belly_rail = true;

/* [Visibility Toggles (nonfunctional)] */

show_balance_pins = true;
show_key_labels = true;
show_tangents = true;
show_tuning_pin = true;
show_hitchpin = true;
show_string = true;

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
wall_th = 6;

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
inner_bottom_z = lower_bottom_board_th/*+ upper_bottom_board_th*/;

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
tangent_mortise_radius = 3 / 2;

/* [Hitchpin Block] */

// Hitchpin block thickness (?)
hitchpin_block_th = wall_th;
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
    wall_th,
    inner_width - rack_th,
    kb_pos.z
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
use_rack_tongue = true;
key_lever_top_y = inner_width - (use_rack_tongue ? rack_th : wall_th * (1/3)) - key_lever_side_clearance;
balance_rail_fingerjoints = 10;

/* [Wrestplank] */

// Wrestplank width (?)
wrestplank_width = wall_th;
// Wrestplank height (?)
wrestplank_height = hitchpin_block_height;
// Wrestplank position (?) In this file the case interior spans
// [0, inner_length] x [0, inner_width] (walls sit outside), so no wall_th
// offsets here.
wrestplank_pos = [
    inner_length - wrestplank_width,
    0,
    inner_bottom_z
];

// Belly rail thickness (supports front edge of soundboard)
belly_rail_th = wall_th;

/* [Backrail] */

// Backrail width (?)
backrail_width = wall_th * 4;
// Backrail height
backrail_height = kb_pos.z - inner_bottom_z;
backrail_pos = [
    rack_pos.x,
    inner_width - backrail_width,
    rack_pos.z - wall_th
];

/* [Bridge] */

bridge_width = 98;
bridge_height = height * (2/7);
bridge_top_depth = wall_th * (2/14);
bridge_bottom_depth = wall_th;

/* [Soundboard] */

// Soundboard depth (?)
soundboard_depth = inner_width;
// Soundboard height (?)
soundboard_height = 3;
// Width of liners for the soundboard to rest on
soundboard_pos = [
    rack_pos.x + rack_width,
    // Rear edge sits against the back wall's inner face
    inner_width,
    // Keep the string (soundboard + bridge + string) just above the tangent
    kb_pos.z + nat_height + tangent_height + tangent_top_string_clearance - (bridge_height + soundboard_height)
];
soundboard_bottom_left_x = kb_end + 8;
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
    bridge_pos.y + (bridge_width) / 2,
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

// Center of the balance pin hole in a key lever
function balance_pin_pos(key_idx) = [
    (key_lever_x(key_idx) + key_lever_x(key_idx+1)) / 2 - key_clearance,
    wall_th
];

// Outline of the key front (the touch surface outside the case), traced
// right-to-left along the bottom so it closes the key lever outline.
// A natural following an accidental is notched at its front-left corner to
// admit the accidental's front (with key_clearance all around).
function key_front_points(key_idx) =
    let (
        x0 = key_lever_x(key_idx),
        x1 = x0 + key_lever_bottom_width(key_idx),
        front_y = kb_pos.y + (is_accidental(key_idx) ? accidental_depth : 0),
        notch_y = kb_pos.y + accidental_depth - key_clearance
    )
    !is_accidental(key_idx) && is_accidental(key_idx - 1)
        ? [
            [x1, front_y],
            [key_x(key_idx), front_y],
            [key_x(key_idx), notch_y],
            [x0, notch_y],
        ]
        : [
            [x1, front_y],
            [x0, front_y],
        ];

// Combined outline of a key: the lever (inside the case) unioned with the
// key front, as a single polygon. Ported from key_lever_2d()/key_front_2d()
// in monochord.scad.
function key_points(key_idx) =
    let (
        top_width = key_lever_top_width(key_idx),
        bottom_width = key_lever_bottom_width(key_idx),
        first_bend_y = wall_th,
        top = [slot_x(key_idx) - top_width/2, key_lever_top_y],
        bottom_x = key_lever_x(key_idx),
        top_rack_tongue_x = slot_x(key_idx) - rack_tongue_width / 2,
        bottom_rack_tongue_y = top.y + (rack_tongue_depth * (use_rack_tongue ? 1 : -1))
    )
    concat(
        [
            [bottom_x, first_bend_y],
            [top.x, second_bend_y],
            top,

            // Rack tongue or slot cutout, depending on use_rack_tongue
            [top_rack_tongue_x, top.y],
            [top_rack_tongue_x, bottom_rack_tongue_y],
            [top_rack_tongue_x + rack_tongue_width, bottom_rack_tongue_y],
            [top_rack_tongue_x + rack_tongue_width, top.y],

            [top.x + top_width, top.y],
            [top.x + top_width, second_bend_y],
            [bottom_x + bottom_width, first_bend_y],
        ],
        key_front_points(key_idx)
    );

/* [Soundboard Supports] */

// The soundboard rests on five vertical support strips: the belly rail
// under its angled front edge plus a leg under its left edge (one bent
// piece in monochord.scad, split into two straight strips so each can be
// laser-cut flat), and liners along its straight front, right, and back
// edges. Each support has simple tabs on its bottom edge (locking into
// cutouts in the case bottom) and on its top edge (registering into
// cutouts in the soundboard), so the whole stack assembles without
// adhesives: the supports tab into the bottom board, and the soundboard
// drops onto the top tabs, held down by gravity and string downbearing.
// The strips also abut the case walls and each other for lateral bracing.

// Height of the belly rail and liners: from the case floor to the
// underside of the soundboard
support_height = soundboard_pos.z - inner_bottom_z;

// Positions of the alignment tabs along each support, as fractions of its
// length
support_tab_fractions = [1/4, 3/4];

// The belly rail runs diagonally under the soundboard's angled front
// edge, from the end of the keyboard at the front wall to the rear start
// of the key taper
belly_rail_angle = atan2(second_bend_y, soundboard_pos.x - soundboard_bottom_left_x);
belly_rail_length = norm([soundboard_pos.x - soundboard_bottom_left_x, second_bend_y]);

// Support descriptors: [origin, z_rotation, length, thickness]. Each is a
// vertical strip standing on the case bottom: `origin` is the start of
// its length axis in plan, rotated counterclockwise by `z_rotation`, with
// its thickness extending to the right of the length direction.
supports = [
    // Belly rail, under the soundboard's angled front edge
    [
        [soundboard_bottom_left_x, 0],
        belly_rail_angle,
        belly_rail_length,
        belly_rail_th,
        [],
    ],
    // Belly rail leg, under the soundboard's left edge back to the wall
    [
        [soundboard_pos.x, second_bend_y],
        90,
        inner_width - second_bend_y,
        belly_rail_th,
        [[[0, 48, 0], -4, support_height, support_height*2]],
    ],
];

// Cutout rectangles ([x, y, w, h, rotation]) matching a support's tabs
// exactly, for cutting into both the case bottom and the soundboard (a
// support's top and bottom tabs share the same XY footprint). Each hole
// is a th x th square rotated with the support, so it lines up with the
// tabs even on the diagonal belly rail. The corner passed to the cutout
// is the tab's [u, v] = [f*length - th/2, -th] corner in the support's
// frame, mapped into case coordinates.
function support_tab_holes(s) =
    let (origin = s[0], angle = s[1], length = s[2], th = s[3])
    [
        for (f = support_tab_fractions)
        let (
            u = f*length - th/2,
            corner = origin + [
                u * cos(angle) + th * sin(angle),
                u * sin(angle) - th * cos(angle)
            ]
        )
        [corner.x, corner.y, th, th, [0, 0, angle]]
    ];

// Tab holes of all supports, cut into the case bottom
function all_support_tab_holes() = [
    for (s = supports) each support_tab_holes(s),
    [0, inner_width-wall_th, wall_th, wall_th*2],
];

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
            simple_tabs=[
                [LEFT, 0, -wall_th/2],
                [RIGHT, -wall_th, inner_width + wall_th / 2],
            ],
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
        lasercutoutSquare(
            thickness=wall_th,
            x=inner_length,
            y=inner_width,
            finger_joints=[
                [UP, 1, 15],
                [LEFT, 1, 4],
                [RIGHT, 0, 4],
                [DOWN, 1, 15]
            ],
            cutouts=concat(
                // Holes for the bottom tabs of the belly rail and liners
                all_support_tab_holes(),
                // Holes for the finger joints of the hitchpin block (left)
                // and wrestplank (right), which both use [LEFT, 0, 4]
                // fingers along the case's inner width
                [for (i = [0:3]) each [
                    [0, inner_width * (2*i + 1) / 8,
                        hitchpin_block_th, inner_width / 8],
                    [inner_length - wrestplank_width, inner_width * (2*i + 1) / 8,
                        wrestplank_width, inner_width / 8],
                ]]
            ),
        );

        // Back wall
        translate([0, inner_width + wall_th, wall_th]) rotate([90, 0, 0])
            lasercutoutSquare(
                thickness=wall_th,
                x=inner_length,
                y=height,
                cutouts = [
                    // Deepen finger joints on left side for hitchpin block
                    [ 0, -wall_th, wall_th, height / 8 ],
                    [ 0, height / 8, wall_th, height / 8 ],
                    // Deepen finger joints on right side for wrestplank
                    [ inner_length - wall_th, -wall_th, wall_th, height / 8 ],
                    [ inner_length - wall_th, height / 8, wall_th, height / 8 ],
                ],
                finger_joints=[
                    [LEFT, 1, 4],
                    [RIGHT, 0, 4],
                    [DOWN, 1, 15]
                ],
            );

        // Front wall
        keywell_y = kb_pos.z - nat_height;
        balance_rail_cutout_w = kb_length / balance_rail_fingerjoints / 2;

        translate([0, 0, wall_th]) rotate([90, 0, 0]) lasercutout(
            thickness=wall_th,
            points = [
                [0,0],
                [inner_length, 0],
                [inner_length, height],
                [kb_pos.x + kb_length, height],
                [kb_pos.x + kb_length, keywell_y],
                [kb_pos.x, kb_pos.z - nat_height],
                [kb_pos.x, height],
                [0, height],
                [0, 0],
            ],
            cutouts = [
                // Cutouts for the balance rail finger joints
                for (i=[0:balance_rail_fingerjoints - 1]) [
                    kb_pos.x + (balance_rail_cutout_w * i * 2),
                    keywell_y - wall_th,
                    balance_rail_cutout_w,
                    wall_th
                ],
                // Deepen finger joints on left side for hitchpin block
                [ 0, 0, wall_th, height / 8 ],
                [ 0, height / 4, wall_th, height / 8 ],
                // Deepen finger joints on right side for wrestplank
                [ inner_length - wall_th, 0, wall_th, height / 8 ],
                [ inner_length - wall_th, height / 4, wall_th, height / 8 ],
            ],
            finger_joints=[
                [LEFT, 0, 4],
                [RIGHT, 1, 4],
                [DOWN, 0, 15],
            ],
        );

        // Left wall
        translate([0, 0, wall_th]) rotate([0, -90, 0])
            side_wall();

        // Right wall
        translate([inner_length + wall_th, 0, wall_th]) rotate([0, -90, 0])
            side_wall();

    }
}

module hitchpin_block() {
    color(col_wood_light)
    rotate([0, -90, 0])
    translate([
        wrestplank_pos.z,
        0,
        -hitchpin_block_th,
    ])
        lasercutoutSquare(
            thickness=hitchpin_block_th,
            y=inner_width,
            x=hitchpin_block_height,
            cutouts = [
                // Rack finger joint cutout
                [
                    backrail_pos.z - wall_th,
                    inner_width - rack_th,
                    key_depth + wall_th,
                    wall_th,
                ],
                // Balance rail joint cutout
                [
                    kb_pos.z - nat_height - wall_th,
                    wall_th,
                    wall_th*4,
                    wall_th,
                ],
            ],
            simple_tabs = [
                // Right tabs connecting to front panel
                [
                    RIGHT,
                    0,
                    -wall_th/2,
                    [wall_th, height / 8, wall_th],
                ],
                [
                    RIGHT,
                    height / 4,
                    -wall_th/2,
                    [wall_th, height / 8, wall_th],
                ],
                // Left tabs connecting to back panel
                [
                    RIGHT,
                    -wall_th,
                    inner_width + wall_th / 2,
                    [wall_th, height / 8, wall_th],
                ],
                [
                    RIGHT,
                    height / 8,
                    inner_width + wall_th / 2,
                    [wall_th, height / 8, wall_th],
                ],
            ],
            finger_joints=[
                [LEFT, 0, 4],
            ],
        );
}

module wrestplank() {
    color(col_wood_dark)
    translate([
        wrestplank_pos.x + wrestplank_width,
        0,
        wrestplank_pos.z,
    ])
        rotate([0, -90, 0])
        lasercutoutSquare(
            thickness=wrestplank_width,
            x=hitchpin_block_height,
            y=inner_width,
            simple_tab_holes = [
                // Soundboard finger joint cutouts
                for (i = [1:3])
                    [RIGHT, hitchpin_block_height - 14.7, soundboard_pos.y*(i/4), [wall_th, 3, wall_th]],
            ],
            simple_tabs = [
                // Right tabs connecting to front panel
                [
                    RIGHT,
                    0,
                    -wall_th/2,
                    [wall_th, height / 8, wall_th],
                ],
                [
                    RIGHT,
                    height / 4,
                    -wall_th/2,
                    [wall_th, height / 8, wall_th],
                ],
                // Left tabs connecting to back panel
                [
                    RIGHT,
                    -wall_th,
                    inner_width + wall_th / 2,
                    [wall_th, height / 8, wall_th],
                ],
                [
                    RIGHT,
                    height / 8,
                    inner_width + wall_th / 2,
                    [wall_th, height / 8, wall_th],
                ],
            ],
            finger_joints=[
                [LEFT, 0, 4],
            ],
        );
}

module balance_rail() {
    color(col_wood_dark)
    translate([kb_pos.x, 0, kb_pos.z - nat_height])
        lasercutoutSquare(
            thickness=wall_th,
            x=kb_length,
            y=wall_th*2,
            // Hacky workaround so we have a single finger joint on the left side
            no_joint_points = [
                [0,0],
                [-kb_pos.x + wall_th,0],
                [-kb_pos.x + wall_th, wall_th],
                [-kb_pos.x, wall_th],
                [-kb_pos.x, wall_th*2],
                [0,wall_th*2],
                [0,0],
            ],
            slits = [
                [51, kb_length, 10, 100],
            ],
            circles_remove=[
                for (key_idx=[0:num_keys - 1]) [
                    balance_pin_radius * (3/2),
                    balance_pin_pos(key_idx).x - kb_pos.x,
                    balance_pin_pos(key_idx).y
                ],
            ],
            finger_joints=[
                [DOWN, 0, balance_rail_fingerjoints],
            ],
        );
}

module rack() {
    color(col_wood_dark)
    translate(rack_pos)
        lasercutoutSquare(
            thickness=wall_th,
            x=rack_width,
            y=rack_th,
            cutouts=[
                for (key_idx=[0:num_keys - 1]) [
                    slot_x(key_idx) - slot_width / 2 - rack_pos.x,
                    0,
                    slot_width,
                    rack_tongue_depth,
                ]
            ],
            finger_joints=[
                [LEFT, 1, 1],
                [UP, 0, 10],
            ],
        );
}

module backrail() {
    color(col_wood_dark)
    translate(backrail_pos)
        lasercutoutSquare(
            thickness=wall_th,
            x=rack_width,
            y=backrail_width,
            simple_tabs = [
                // Right tabs connecting to front panel
                [
                    LEFT,
                    0,
                    backrail_width - (rack_th/2) - wall_th/2,
                ],
            ],
            finger_joints=[
                [UP, 0, 10],
            ],
        );
}

module key(key_idx) {
    color(col_natural)
    translate([0, 0, kb_pos.z])
        lasercutout(
            thickness=nat_height,
            points=key_points(key_idx),
            circles_remove=[
                [
                    balance_pin_radius * (3/2),
                    balance_pin_pos(key_idx).x,
                    balance_pin_pos(key_idx).y
                ],
                [
                    tangent_mortise_radius,
                    tangent_x(key_idx) - tangent_depth / 2,
                    string_pos.y
                ],
            ]
        );
}

module keyboard() {
    for (key_idx=[0:num_keys - 1])
        key(key_idx);
}

module belly_rail_section(s) {
    length = s[2];
    color(col_wood_med)
    translate([s[0].x, s[0].y, inner_bottom_z])
        rotate([0, 0, s[1]])
        rotate([90, 0, 0])
        lasercutoutSquare(
            thickness=s[3],
            x=length,
            y=support_height,
            slits = s[4],
            simple_tabs=[
                for (f = support_tab_fractions) each concat(
                    [[DOWN, f*length, 0]],
                    [[UP, f*length, support_height]]
                )
            ],
        );
}

module belly_rail() {
    belly_rail_section(supports[0]);
    belly_rail_section(supports[1]);
}

module soundboard() {
    color(col_wood_light)
    translate([0, 0, soundboard_pos.z])
        lasercutout(
            thickness=soundboard_height,
            points=[
                [soundboard_pos.x, soundboard_pos.y],
                [soundboard_pos.x + soundboard_width, soundboard_pos.y],
                [soundboard_pos.x + soundboard_width, 0],
                [soundboard_bottom_left_x, 0],
                [soundboard_pos.x, second_bend_y],
            ],
            simple_tabs=[
                for (i = [1:3])
                    [RIGHT, soundboard_pos.x + soundboard_width, soundboard_pos.y*(i/4), [wall_th, wall_th, 3]],
            ],
            circles_remove=[
                [mousehole_radius, mousehole_pos.x, mousehole_pos.y]
            ],
            cutouts=[
                // Belly rail cutouts
                for (s = supports) each support_tab_holes(s),
                // Bridge tab cutouts
                [bridge_pos.x, bridge_pos.y+11, wall_th, wall_th],
                [bridge_pos.x, bridge_pos.y+bridge_width-24, wall_th, wall_th],
            ],
        );
}

module bridge() {
    color(col_wood_dark)
    translate([
        bridge_pos.x,
        bridge_pos.y,
        bridge_pos.z
    ])
        rotate([90, 0, 90])
        lasercutoutSquare(
            thickness=wall_th,
            x=bridge_width,
            y=bridge_height,
            simple_tabs=[
                [DOWN, 14, 0, [wall_th, 3, wall_th]],
                [DOWN, bridge_width-21, 0, [wall_th, 3, wall_th]],
            ],
            circles_remove=[
                [bridge_height, -12, 5],
                [9, 30, 0],
                [9.5, 45, 7],
                [9, 60, 0],
                [bridge_height, bridge_width+5, 5]
            ]
        );
}

module assembly() {
    if (show_case) case();
    if (show_hitchpin_block) hitchpin_block();
    if (show_wrestplank) wrestplank();
    if (show_rack && use_rack_tongue) rack();
    if (show_backrail) backrail();
    if (show_balance_rail) balance_rail();
    if (show_belly_rail) belly_rail();
    if (show_soundboard) soundboard();
    if (show_bridge) bridge();
    if (show_keyboard) keyboard();
}

assembly();