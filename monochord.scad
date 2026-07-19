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

/* [US Lumber Stock] */
// All structural parts are sized to be cut from common US dimensional
// lumber and plywood. Actual (not nominal) sizes are used below.

// 3/4" stock: 1x lumber (1x3, 1x6, etc.) is 3/4" thick
stock_3_4 = 0.75;
// 1/2" stock: plywood or resawn 1x lumber
stock_1_2 = 0.5;
// 1/4" stock: plywood, key levers
stock_1_4 = 0.25;
// 1/8" stock: soundboard (thin plywood or resawn tonewood)
stock_1_8 = 0.125;
// Actual width of a 1x3 board (2.5")
width_1x3 = 2.5;
// Actual width of a 1x6 board (5.5")
width_1x6 = 5.5;

/* [Main Dimensions] */
use_us_lumber_dimensions = true;

// "The internal length used for our reconstruction is 644 mm (the external
// length is 664 mm), which was determined by adopting a multiple of the number
// 14, as used by Arnaut for dividing the length, resulting in a 1:3 ratio
// consistent with the master's diagram (Plate IX). Of course, this choice of
// size is only one of many possible options."

// For US lumber, 25.5" (647.7 mm) is used instead of 644 mm, which keeps
// the historical proportions to within 1%.

inner_length = use_us_lumber_dimensions ? 25.5 : 644;

// "The length-width-height ratio (width = 3/14 of the length = 138 mm; height
// or "altitudo tota" = 1/2 of the width = 69 mm) was also adopted from Arnaut.
// The width was not reduced, since—apart from Conrad's note that the monochord
// body should be made "in the manner of a clavichord body, with similar length,
// depth, and, if desired, also width"—retaining the full width, due to the
// unrestricted soundboard, has a positive effect on the instrument's fullness
// of sound."

// The historical width (3/14 of length = 138 mm) is almost exactly the
// actual width of a 1x6 board (5.5" = 139.7 mm), and the height (69 mm)
// is close to the actual width of a 1x3 board (2.5" = 63.5 mm). So the
// bottom can be cut from a 1x6 and the walls from 1x3 stock.

inner_width = use_us_lumber_dimensions ? width_1x6 : inner_length * (3/14);
height = use_us_lumber_dimensions ? width_1x3 : inner_width / 2;
wall_th = use_us_lumber_dimensions ? stock_3_4 : 10;

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

// Historically 1/6 of the width (23 mm); 3/4" stock (19 mm) is close.

upper_bottom_board_th = use_us_lumber_dimensions ? stock_3_4 : inner_width / 6;
lower_bottom_board_th = wall_th;
inner_bottom_z = lower_bottom_board_th + (use_us_lumber_dimensions ? 0 : upper_bottom_board_th);

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

key_depth = use_us_lumber_dimensions ? 1.5 : inner_width * (2/7);
nat_height = use_us_lumber_dimensions ? stock_1_4 : wall_th;
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

tangent_height = from_mm(10);
tangent_top_width = tangent_height / 2;
tangent_bottom_width = tangent_top_width / 4;
tangent_depth = wall_th / 10;
tangent_top_string_clearance = wall_th / 10;

/* [Hitchpin Block] */

// Hitchpin block thickness (?)
hitchpin_block_th = wall_th;
// Hitchpin block height (?)
hitchpin_block_height = (height - inner_bottom_z) * (2/3);
// Hitchpin height (?)
hitchpin_height = hitchpin_block_height * (2/3);
// Hitchpin radius (?)
hitchpin_radius = wall_th * (1/14);

/* [Backrail] */

// Backrail thickness (?)
backrail_th = wall_th;
// Backrail height
backrail_height = kb_pos.z - inner_bottom_z;

/* [Rack] */

// Slot width (?)
slot_width = key_width * (1/7);
// Rack thickness (?)
rack_th = wall_th;
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

/* [Key Levers] */

// "Regarding the inner part of the key, the rear start of the taper is
// at 2/5 of the width ( = 55.2 mm)."

second_bend_y = inner_width * (2/5);
key_lever_side_clearance = slot_width / 6;
key_lever_top_y = inner_width + wall_th - rack_th - key_lever_side_clearance;
rack_tongue_width = slot_width * (2/3);
rack_tongue_depth = rack_th * (2/3);

/* [Wrestplank] */

// Wrestplank width (?)
wrestplank_width = wall_th;
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

/* [Bridge] */

bridge_width = wall_th * 4;
// Cut from 3/4" stock in US mode; historically ~20 mm on a 69 mm-tall case
bridge_height = use_us_lumber_dimensions ? stock_3_4 : height * (2/7);
bridge_top_depth = wall_th * (2/14);
bridge_bottom_depth = wall_th;

/* [Soundboard] */

// Soundboard depth (?)
soundboard_depth = inner_width;
// Soundboard height (?)
soundboard_height = use_us_lumber_dimensions ? stock_1_8 : wall_th / 3;
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

string_radius = from_mm(0.4);

// Tuning pin radius (?)
tuning_pin_radius = from_mm(1);
tuning_pin_x = wrestplank_pos.x + (wrestplank_width / 2);
tuning_pin_height = height - wrestplank_pos.z - wrestplank_height * (3/4);

// Balance pin height (?)
balance_pin_height = from_mm(20);
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
// Echo a cutlist of all wooden parts to the console
generate_cutlist = true;
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

// ---------------------------------------------------------------------------
// Cutlist helpers
// ---------------------------------------------------------------------------
// Wooden parts are built with board()/cut_blank() below, which echo a
// "CUT:" line for each part when generate_cutlist is enabled. Dimensions
// are sorted largest-first (L x W x T) and shown in inches (nearest 1/16")
// and mm. Parts instantiated multiple times echo once per instance, so the
// echoed lines double as a quantity count. The stock a part is cut from is
// derived from the blank's smallest dimension (its thickness) unless
// overridden with the `stock` parameter.

// Model units are inches when use_us_lumber_dimensions is set, else mm.
function from_mm(v) = use_us_lumber_dimensions ? v / 25.4 : v;
function to_inches(v) = use_us_lumber_dimensions ? v : v / 25.4;
function to_mm(v) = use_us_lumber_dimensions ? v * 25.4 : v;

// Format a length as inches rounded to the nearest 1/16"
function fmt_inches(v) = str(round(to_inches(v) * 16) / 16, "\"");

// Sort a [x, y, z] size vector largest-first
function sorted_size(s) =
    let (lo = min(s), hi = max(s))
    [hi, s[0] + s[1] + s[2] - hi - lo, lo];

function fmt_size(size) = let (s = sorted_size(size)) str(
    fmt_inches(s[0]), " x ", fmt_inches(s[1]), " x ", fmt_inches(s[2]),
    "  (", round(to_mm(s[0])), " x ", round(to_mm(s[1])), " x ", round(to_mm(s[2])), " mm)"
);

// Name the lumber/plywood stock a blank of the given thickness is cut from.
// Non-standard thicknesses are labeled as rips from the next size up.
function stock_label(th) =
    let (eps = 0.01)
    !use_us_lumber_dimensions ? str(round(to_mm(th)), " mm stock") :
    abs(th - stock_3_4) < eps ? "3/4\" stock (1x lumber)" :
    abs(th - stock_1_2) < eps ? "1/2\" stock (plywood or resawn 1x)" :
    abs(th - stock_1_4) < eps ? "1/4\" stock (plywood)" :
    abs(th - stock_1_8) < eps ? "1/8\" stock (plywood or resawn tonewood)" :
    abs(th - (stock_1_4 + stock_1_8)) < eps ? "1/4\" + 1/8\" stock, laminated" :
    th < stock_3_4 ? str(fmt_inches(th), ", ripped from 3/4\" stock") :
    str(fmt_inches(th), " stock");

// Echo a cutlist entry for the rectangular blank a part is cut from, and
// render the part's geometry (children).
module cut_blank(name, size, stock, do_echo=true) {
    if (generate_cutlist && do_echo)
        echo(str(
            "CUT: ", name, ": ", fmt_size(size),
            " -- ", is_undef(stock) ? stock_label(min(size)) : stock
        ));
    children();
}

// A simple rectangular board: registers itself on the cutlist and renders
// as a cube of the given size.
module board(name, size, stock) {
    cut_blank(name, size, stock) cube(size);
}

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

module bottom(name, thickness) {
    board(name, [inner_length, inner_width, thickness]);
}

module side_wall(name) {
    board(name, [wall_th, inner_width + 2*wall_th, height]);
}

front_back_wall_size = [inner_length, wall_th, height];

module case() {
    color(col_wood_med) {
        // Lower bottom
        translate([wall_th, wall_th, 0]) bottom("lower bottom", lower_bottom_board_th);

        // Upper bottom
        if (!use_us_lumber_dimensions)
            translate([wall_th, wall_th, lower_bottom_board_th])
                bottom("upper bottom", upper_bottom_board_th);

        // Left wall
        side_wall("left wall");

        // Right wall
        translate([inner_length + wall_th, 0, 0]) side_wall("right wall");

        // Back wall
        translate([wall_th, inner_width + wall_th, 0])
            board("back wall", front_back_wall_size);

        // Front wall
        cut_blank("front wall", front_back_wall_size)
        difference() {
            translate([wall_th, 0, 0])
                cube(front_back_wall_size);
            translate([kb_pos.x, -wall_th, kb_pos.z])
                cube([kb_length, 999, 999]);
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
        board("rack", [rack_width, rack_th, rack_height]);
}

module hitchpin_block() {
    color(col_wood_dark)
    cut_blank("hitchpin block", [hitchpin_block_th, inner_width, hitchpin_block_height])
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
        wall_th + inner_width - rack_th - backrail_th,
        wrestplank_pos.z
    ])
        color(col_wood_dark)
        board("backrail", [rack_width, backrail_th, backrail_height]);
}

module wrestplank() {
    color(col_wood_dark)
    cut_blank("wrestplank", [wrestplank_width, inner_width, wrestplank_height])
    difference() {
        translate(wrestplank_pos)
            cube([wrestplank_width, inner_width, wrestplank_height]);
        tuning_pin();
    }
}

module tangent(key_idx) {
    translate([
        tangent_x(key_idx),
        string_pos.y,
        kb_pos.z + nat_height
    ])
        color(col_brass)
        rotate([90, 0, -90])
        linear_extrude(tangent_depth)
            polygon([
                [-tangent_bottom_width, 0],
                [-tangent_top_width/2, tangent_height],
                [tangent_top_width/2, tangent_height],
                [tangent_bottom_width, 0],
            ]);
}

module tangent_mortise_2d(key_idx) {
    translate([tangent_x(key_idx) - tangent_bottom_width, string_pos.y, 0])
        circle(r=tangent_bottom_width);
}

module rack_tongue_2d(key_idx) {
    translate([slot_x(key_idx) - (rack_tongue_width) / 2, key_lever_top_y, 0])
        square([rack_tongue_width, rack_tongue_depth]);
}

module key_lever_2d(key_idx) {
    top_width = key_lever_top_width(key_idx);
    bottom_width = is_accidental(key_idx)
        ? accidental_width
        : (is_accidental(key_idx - 1) ? accidental_width - key_clearance : key_width) - key_clearance;
    first_bend_y = wall_th;
    top = [
        slot_x(key_idx) - top_width/2,
        key_lever_top_y
    ];
    bottom = [
        key_lever_x(key_idx),
        kb_pos.y + key_depth
    ];

    rack_tongue_2d(key_idx);
    difference() {
        polygon([
            bottom,
            [bottom.x, first_bend_y],
            [top.x, second_bend_y],
            top,
            [top.x + top_width, top.y],
            [top.x + top_width, second_bend_y],
            [bottom.x + bottom_width, first_bend_y],
            [bottom.x + bottom_width, bottom.y],
        ]);
        balance_pin_2d(key_idx, balance_pin_radius * (3/2));
        tangent_mortise_2d(key_idx);
    }
}

module key_lever_3d(key_idx) {
    color(col_key_lever)
    cut_blank(
        str("key lever ", key_label(key_idx)),
        [
            max(key_lever_top_width(key_idx), key_width),
            key_lever_top_y + rack_tongue_depth - kb_pos.y,
            nat_height
        ]
    ) {
        translate([0, 0, kb_pos.z])
            linear_extrude(nat_height)
                key_lever_2d(key_idx);
    }
}

module key_3d(key_idx, offset_delta=0) {
    size = key_size(key_idx);
    translate([0, 0, kb_pos.z])
        color(col_natural)
        // Only register the real key, not offset copies used as cutters
        cut_blank(str("key ", key_label(key_idx)), size, do_echo=offset_delta==0)
        linear_extrude(size.z)
            key_2d(key_idx, offset_delta);
}

module key_2d(key_idx, offset_delta=0) {
    size = key_size(key_idx);
    difference() {
        translate([
            key_x(key_idx),
            kb_pos.y + (is_accidental(key_idx) ? accidental_depth : 0),
            0
        ])
            offset(delta=offset_delta)
            square([size.x, size.y]);
        if (offset_delta == 0)
            key_2d(key_idx - 1, key_clearance);
    }
}

module balance_pin_2d(key_idx, radius) {
    translate([
        (key_lever_x(key_idx) + key_lever_x(key_idx+1)) / 2 - key_clearance,
        wall_th / 2,
        0
    ])
        circle(r=radius);
}

module balance_pin_3d(key_idx, radius) {
    color(col_iron)
        translate([0, 0, kb_pos.z - (balance_pin_height / 3)])
            linear_extrude(balance_pin_height)
                balance_pin_2d(key_idx, radius);
}

module balance_pins() {
    for (key_idx=[0:num_keys - 1])
        balance_pin_3d(key_idx, balance_pin_radius);
}

module tangents() {
    for (key_idx=[0:num_keys - 1])
        tangent(key_idx);
}

module key_labels() {
    for (key_idx=[0:num_keys - 1])
        translate([
            key_x(key_idx) + (is_accidental(key_idx) ? accidental_width : key_width) / 7,
            (is_accidental(key_idx) ? -accidental_depth : -key_depth) * (6/7),
            kb_pos.z + nat_height + (is_accidental(key_idx) ? accidental_height  : 0)
        ])
            color("black")
                linear_extrude(key_clearance)
                text(text=key_label(key_idx), size=(is_accidental(key_idx) ? accidental_width : key_width) / 3);
}

module keyboard() {
    for (key_idx=[0:num_keys - 1]) {
        key_3d(key_idx);
        key_lever_3d(key_idx);
    }
}

module string() {
    translate(string_pos)
        rotate([0, 90, 0])
        color(col_brass)
        cylinder(
            h=tuning_pin_x - string_pos.x,
            r=string_radius
        );
}

module hitchpin() {
    translate([
        string_pos.x,
        string_pos.y,
        wrestplank_pos.z + wrestplank_height * (2/3)
    ])
        color(col_iron)
        cylinder(h=hitchpin_height, r=hitchpin_radius);
}

module tuning_pin() {
    translate([
        tuning_pin_x,
        string_pos.y,
        wrestplank_pos.z + wrestplank_height * (2/3)
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
        cut_blank("bridge", [bridge_width, bridge_bottom_depth, bridge_height])
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
    cut_blank("soundboard", [soundboard_width, soundboard_depth, soundboard_height])
    difference() {
        translate([0, 0, soundboard_pos.z]) {
            linear_extrude(soundboard_height)
                polygon([
                    [soundboard_pos.x, soundboard_pos.y],
                    [soundboard_pos.x + soundboard_width, soundboard_pos.y],
                    [soundboard_pos.x + soundboard_width, wall_th],
                    [kb_end, wall_th],
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
    color(col_wood_med)
    cut_blank(
        "belly rail",
        [
            norm([kb_end - soundboard_pos.x, soundboard_pos.y - wall_th]) + belly_rail_th,
            belly_rail_th,
            soundboard_pos.z - inner_bottom_z
        ]
    ) {
        // Rail under the soundboard's front edge
        translate([0, 0, inner_bottom_z])
            linear_extrude(soundboard_pos.z - inner_bottom_z)
                polygon([
                    [soundboard_pos.x, soundboard_pos.y],
                    [soundboard_pos.x, second_bend_y],
                    [kb_end, wall_th],
                    [kb_end + belly_rail_th, wall_th],
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
                board("soundboard liner (front)", [
                    wrestplank_pos.x - soundboard_liner_th - kb_end - belly_rail_th,
                    soundboard_liner_th,
                    soundboard_pos.z - inner_bottom_z
                ]);

            // Liner along the wrestplank face supporting the soundboard's right edge
            translate([wrestplank_pos.x - soundboard_liner_th, 0, 0])
                board("soundboard liner (right)", [
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
                board("soundboard liner (back)", [
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