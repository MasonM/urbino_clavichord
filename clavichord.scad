/*
 * 15th-Century Clavichord 3D Model
 * Based on dimensions from "The Urbino Clavichord Revisited" (Pierre Verbeek)
 * 
 * All dimensions are in millimeters (mm).
 * Render with OpenSCAD (F5 for preview, F6 to render).
 */

// --- Variables & Dimensions ---

// Case Dimensions (mm-R)
c_length = 1005;
c_width = 216;
c_height = 82;
wall_th = 12;

// Keyboard Dimensions
kb_start_x = 122;
kb_length = 734;       // derived from 1005 - 122 - 149
kb_protrusion = 81.5;  // Projection length of naturals outside the case
num_naturals = 29;     // Keyboard extends from F to f3
nat_width = 25.3;
nat_height = 10;
sharp_width = 14.0;
sharp_length = 45;
sharp_height = nat_height + 5;

// --- Colors ---
col_wood_dark = [0.35, 0.20, 0.10];
col_wood_light = [0.80, 0.65, 0.40];
col_wood_med = [0.55, 0.35, 0.15];
col_key_lever = [0.9, 0.9, 0.9];
col_natural = [0.90, 0.88, 0.80]; // Bone/boxwood finish
col_sharp = [0.15, 0.15, 0.15];   // Dark tortoise shell / ebony
col_brass = [0.85, 0.75, 0.30];
col_string = [0.90, 0.90, 0.90];

nat_index = [0, 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 8, 8, 9];
key_lever_top_offset_x = [-50, -38, -26, -14, -2, 10, 40, 70, 80, 110, 140, 160];
function is_sharp(i) = i > 0 && nat_index[i] == nat_index[i-1];
function nat_offset_x(i) = nat_index[i] * nat_width;
function cumulative_sum(vec) = [for (sum=vec[0], i=1; i<=len(vec); newsum=sum+vec[i], nexti=i+1, sum=newsum, i=nexti) sum];
    
// --- Modules ---

module clavichord_case() {
    color(col_wood_med)
    difference() {
        // Main outer block
        cube([c_length, c_width, c_height]);
        
        // Hollow interior
        translate([wall_th, wall_th, wall_th]) {
            cube([c_length - 2*wall_th, c_width - 2*wall_th, c_height]);
        }
            
        // Keyboard cutout in the front wall
        translate([kb_start_x, -1, -wall_th - 15]) {
            cube([kb_length, wall_th + 2, c_height-30]);
        }
    }
}

module nat_key_top(i) {
    color(col_natural) 
        translate([nat_index[i] * nat_width -1, -kb_protrusion, nat_height])
            linear_extrude(2)
                offset(delta=0)
                    square([nat_width - 1, kb_protrusion]);
}

module nat_key(i) {
     union() {
        key_lever_3d(i);
        nat_key_top(i);
    }
}

module key_lever_2d(i) {
    top = [
        key_lever_top_offset_x[i],
        c_width - wall_th - 30
    ];
    bottom = [
        (nat_index[i] * nat_width) + (is_sharp(i) ? nat_width - sharp_width/2 : 0), 
        -kb_protrusion + (is_sharp(i) ? 45 : 0)
    ]; 
    width = (is_sharp(i) ? sharp_width : nat_width) - 4;
    difference() {
        polygon([
           bottom,
           [bottom.x, 38 + i * 7],
           [top.x, 118],
           top,
           [top.x + 10, top.y],
           [top.x + 10, 118],
           [bottom.x + width, 43 + i * 7],
           [bottom.x + width, bottom.y],
        ]);
        if(is_sharp(i+1)) offset(delta=1) key_lever_2d(i+1);
        if(is_sharp(i-1)) offset(delta=1) key_lever_2d(i-1);
    }    
}

module key_lever_3d(i) {
    color(col_key_lever) linear_extrude(nat_height) key_lever_2d(i);
}

module sharp_key_top(i) {
    color(col_sharp)
        translate([nat_offset_x(i) + nat_width - sharp_width/2, -45, 5])
            cube([sharp_width, sharp_length, sharp_height]);
}

module sharp_key(i) {
    // Sharp key (Accidentals)
    // Note pattern for F major scale start: F(0), G(1), A(2), B(3), C(4), D(5), E(6)
    // Standard keyboard sharps are between: F-G, G-A, A-B, C-D, D-E
    union() {
        key_lever_3d(i);
        sharp_key_top(i);
    } 
}

module keyboard() {
    translate([kb_start_x, 0, wall_th]) {
       for(i=[0:len(nat_index)-1]) {        
            if (is_sharp(i)) sharp_key(i); else nat_key(i);        
       }
    }
   /*
    for(i=[3:num_naturals-1]) {
        
        // Natural key
        translate([i * nat_width + 0.5 + kb_start_x, -kb_protrusion, wall_th + 1])
            color(col_natural)
            cube([nat_width - 1, key_len, nat_height]);
            
        // Tangent (brass blade at the back of the key to strike strings)
        tangent_y = 150 + (i % 12) * 2; // Spread out diagonally to strike different strings
        translate([i * nat_width + nat_width/2 + kb_start_x, tangent_y, wall_th + 11])
            color(col_brass)
            cube([1.5, 4, 25]);
            
        // Sharp key (Accidentals)
        // Note pattern for F major scale start: F(0), G(1), A(2), B(3), C(4), D(5), E(6)
        // Standard keyboard sharps are between: F-G, G-A, A-B, C-D, D-E
        note_in_octave = i % 7;
        has_sharp = (note_in_octave == 0 || note_in_octave == 1 || note_in_octave == 2 || note_in_octave == 4 || note_in_octave == 5);
        

    }*/
}

module internal_components() {
    // Soundboard (Right side spanning the gap)
    translate([kb_start_x + kb_length, wall_th, 40])
        color(col_wood_light)
        cube([c_length - wall_th - (kb_start_x + kb_length), c_width - 2*wall_th, 3]);
        
    // Hitchpin cover block (Left side wall)
    translate([wall_th, wall_th, 12])
        color(col_wood_dark)
        cube([30, c_width - 2*wall_th, 35]);
        
    // Wrestplank (Right side under tuning pins)
    translate([c_length - wall_th - 60, wall_th, 12])
        color(col_wood_dark)
        cube([60, c_width - 2*wall_th, 35]);
        
    // Rack (Back wall guiding the keys)
    translate([kb_start_x - 10, c_width - wall_th - 25, wall_th])
        color(col_wood_dark)
        cube([kb_length + 20, 25, 30]);

    // Bridge (Simplified Viol-shaped on the right soundboard)
    translate([c_length - 80, wall_th + 20, 43])
        rotate([0, 0, 15])
        color(col_wood_dark)
        cube([8, 120, 6]);
        
    // Tuning Pins (36 pins mapped on the right as noted in text)
    for(x=[10:15:50]) {
        for(y=[15:15:160]) {
            translate([c_length - wall_th - 60 + x, wall_th + y, 47])
                color(col_brass)
                cylinder(h=15, r=1.5, $fn=12);
        }
    }
   
    // Strings (Double-strung representation)
    for(i=[0:34]) {
        translate([wall_th + 15, c_width - wall_th - 20 - (i*2), 49])
            rotate([0, 90, 0])
            color(col_string)
            cylinder(h=c_length - 2*wall_th - 50, r=0.4, $fn=6);
    }
}

// --- Assembly ---


#clavichord_case();
keyboard();
internal_components();
