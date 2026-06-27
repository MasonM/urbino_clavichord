// German:
// "Das unserer Rekonstruktion zugrundeliegende innere Längenmaß von 644 mm (die
// äußere Länge beträgt 664 mm) wurde durch Annahme eines Vielfachen der von
// Arnaut! zur divisio longitudinis verwendeten Zahl 14 erreicht, wobei eine auf
// dem Verhältnis 1 :3 beruhende Übereinstimmung mit der Figur des Magisters
// (Tafel IX) besteht. Freilich kann diese Größenwahl lediglich als eine von
// vielen Möglichkeiten angesehen werden. Auch die Annahme des
// Längen-Breiten-Höhen-Verhältnisses (Breite = 3/14 longitudo = 138 mm; Höhe
// bzw. „altitudo tota" = 1/2 latitudo = 69 mm) erfolgte nach Arnaut. Eine
// Verkürzung der latitudo wurde nicht vorgenommen, da sich – abgesehen von
// Conrads Hinweis, das Monochord-corpus sei „ad instar clavichordii corporis in
// consimili longitudine, profunditate et si placet auch latitudine"
// herzustellen – ein Beibehalten der vollen Breite wegen des uneingeschränkten
// Resonanzbodens günstig auf die Klangfülle des Instrumentes auswirkt.
// Desgleichen wurden Anfangs- und Endpunkt der Messung, Steg und Resonanzloch
// an folgenden Orten eingesetzt: Der terminus a quo mensurationis und stephanus
// (= terminus ad quem mensurationis) bei 1/14 und 6/7 der longitudo (= 46 und
// 552 mm). Die dem '-ut zugehörige schwingende Saitenlänge mißt somit 506 mm.
// Demgegenüber befindet sich der Mittelpunkt des foramen rotundum pro
// resonantia bei 506 mm (= 11/14 der longitudo). Zudem erfahren wir bei Arnaut,
// daß der zwischen dem oberen und unteren Boden herrschende Abstand ("distantia
// inter duos fundos") 1/6 der Breite (= 1/28 der Länge = 23 mm) umfasse."
// English:
// "The internal length used for our reconstruction is 644 mm (the external
// length is 664 mm), which was determined by adopting a multiple of the number
// 14, as used by Arnaut for dividing the length, resulting in a 1:3 ratio
// consistent with the master's diagram (Plate IX). Of course, this choice of
// size is only one of many possible options. The length-width-height ratio
// (width = 3/14 of the length = 138 mm; height or "altitudo tota" = 1/2 of the
// width = 69 mm) was also adopted from Arnaut. The width was not reduced,
// since—apart from Conrad's note that the monochord body should be made "in the
// manner of a clavichord body, with similar length, depth, and, if desired,
// also width"—retaining the full width, due to the unrestricted soundboard, has
// a positive effect on the instrument's fullness of sound. Likewise, the
// starting and ending points for measurement, the bridge, and the sound hole
// were placed as follows: the starting point of measurement and the bridge
// (terminus a quo mensurationis and stephanus = terminus ad quem mensurationis)
// at 1/14 and 6/7 of the length (46 and 552 mm). The vibrating string length
// for '-ut is thus 506 mm. In contrast, the center of the sound hole (foramen
// rotundum pro resonantia) is at 506 mm (11/14 of the length). According to
// Arnaut, the distance between the upper and lower boards ("distantia inter
// duos fundos") is 1/6 of the width (1/28 of the length = 23 mm)."
c_inner_length = 644;
c_inner_width = c_inner_length * (3/14);
c_height = c_inner_width / 2;
wall_th = 10;
vibrating_string_length_g2 = c_inner_length * (11/14);

// German:
// "Moduli autem, id est claves ligneae, quae chordam tangere sive percutere
// debent, numero viginti praeter duo b-mollia, in ea parte, qua extra corpus
// monochordi protenduntur, omnes aequalis sint latitudinis, omnes quoque omnino
// integrae ad instar primae et ultimae clavium in ipso clavichordio ut
// communiter repertarum praeter has duas claves sub secundo scilicet et tertio
// c immediate positas. Quarum quaelibet -durum faciens sive repraesentans intra
// se capiet et admittet, quoad anteriorem sive priorem sui partem aut
// medietatem, ipsum modulum sive clavem b-mollis per modum semitonii sive parvi
// moduli."
// English:
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
cumsum_accidentals = [for (a=0, i=0; i < num_keys; i = i + 1, a = a + (is_accidental(i) ? 1 : 0)) a];
num_naturals = num_keys - cumsum_accidentals[num_keys - 1];

// English:
// "To conclude regarding the construction of the keys: According to Conrad's
// specifications, the outer surfaces of the "first ... and last ... keys" each
// begin at a distance from the ends that is a little more than one-sixth of the
// total length ( = 115 mm). By evenly dividing the remaining space ( = 414 mm),
// a theoretical width of 20.7 mm could be achieved for each of the twenty
// "lower keys," while in practice the width was just under 20 mm. (For the
// width of the two "upper keys," the "half-width of a key" was used.) The
// length of these keys was again calculated according to Arnaut ( = about 40
// mm). Regarding the inner part of the key, the rear start of the taper is at
// 2/5 of the width ( = 55.2 mm). Furthermore, the string runs at the location
// designated by Arnaut for the "first pair of strings" ( = 3/5 of the width =
// 82.8 mm, and 13.8 mm from the center). Thus, Conrad's requirement that it be
// placed "beyond the center of the total internal width of the monochord,
// toward the side away from us" was also fulfilled. (All further details can be
// seen in Fig. II.)"
key_depth = 40;
key_height = 10;
kb_length = 414;
kb_pos = [
    wall_th + 115,
    -key_depth,
    c_height - key_height - 16
];
nat_width = kb_length / num_naturals;
nat_height = 10;
accidental_width = nat_width / 2;
accidental_height = nat_height / 2;
accidental_depth = key_depth / 2;

// TODO: bottom board

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

frequency_a4 = 440;
key_lever_top_y = c_inner_width + wall_th - rack_th - 1;
debug_mode = true;

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
col_accidental = [0.15, 0.15, 0.15];

function is_accidental(key_idx) =
    let (
        pitch_class = key_octave_and_pitch_class[key_idx][1],
        pitch_class_accidentals = [false, true, false, true, false, false, true, false, true, false, true, false]
    )
    pitch_class_accidentals[pitch_class];

function key_x(key_idx) =
    kb_pos.x
    + (key_idx - cumsum_accidentals[key_idx]) * nat_width;

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

if (debug_mode) {
    for (key_idx=[0:num_keys-1]) {
        echo(key_idx=key_idx,
            is_accidental=is_accidental(key_idx),
            key_label=key_label(key_idx),
            sounding_length=sounding_length(key_idx),
            key_frequency=key_frequency(key_idx),
            slot_x=slot_x(key_idx),
            transpose=transpose(key_octave_and_pitch_class[key_idx][0], key_octave_and_pitch_class[key_idx][1]),
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
    bottom_width = (is_accidental(key_idx) ? accidental_width : nat_width) - 3;
    top = [
        slot_x(key_idx) - top_width/2,
        key_lever_top_y
    ];
    bottom = [
        key_x(key_idx),
        kb_pos.y + (is_accidental(key_idx) ? 45 : 0)
    ];
    second_bend_y = string_y - 10;
    first_bend_y = wall_th + 10 + (key_idx < 5 ? key_idx * 10 : max(50 - ((key_idx-10)*5), 0));

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

module accidental_key_top(key_idx) {
    translate([
        key_x(key_idx),
        -accidental_depth,
        kb_pos.z + nat_height
    ])
        color(col_accidental)
        cube([accidental_width, accidental_depth, accidental_height]);
}

module key(key_idx) {
    difference() {
        key_lever_3d(key_idx);
        // TODO
        //balance_pin(key_idx, balance_pin_radius + 0.5);
    }
    if (is_accidental(key_idx))
        accidental_key_top(key_idx);
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
