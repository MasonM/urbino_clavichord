"""
3D model of the clavichord depicted in the 1479 intarsia from the Studiolo of
Ducal Palace at Urbino.  Based on dimensions from "The Urbino Clavichord
Revisited" by Pierre Verbeek.

© 2026 by Mason Malone. Repository: https://github.com/MasonM/urbino_clavichord/
Licensed under CC BY 4.0. To view a copy of this license, visit
https://creativecommons.org/licenses/by/4.0/
"""

import math

from build123d import *
from build123d import export_stl, export_step

MIN3 = (Align.MIN, Align.MIN, Align.MIN)
SEGS = 16  # replaces $fn = 16

# --- Variables & Dimensions ---
#
# All dimensions are in millimeters (mm).
# A "(?)" indicates the value was guesstimated and should not be treated as exact

# Toggle Visibility
show_case      = True
show_internals = True
show_soundbox  = True
show_keyboard  = True
show_strings   = True

# Number of keys/strings/pins
num_keys        = 47
short_octave    = True
num_strings     = 34
num_tuning_pins = 36

# Case Dimensions (mm-R)
c_length = 1005
c_width  = 216
c_height = 82
wall_th  = 12

# Internal Component Dimensions (mm-R)
hitchpin_block_th     = 13   # (?)
hitchpin_block_height = 60   # (?)
rack_th               = 13
rack_width            = 836  # (?)
rack_height           = 30   # (?)
backrail_th           = 30   # (?)
backrail_height       = 42   # (?)
balance_rail_height   = 30   # (?)
balance_rail_depth    = 20   # (?)
wrestplank_width      = 30   # (?)
wrestplank_height     = 30   # (?)
slot_width            = 1.5  # (?)

# Soundbox Dimensions (mm-R)
bridge_width        = 98
bridge_height       = 22
bridge_top_depth    = 1    # (?)
bridge_bottom_depth = 10
soundboard_width    = 190  # (?)
soundboard_height   = 3    # (?)
mousehole_height    = 100  # (?)
mousehole_radius    = 30   # (?)
belly_rail_width    = 10   # (?)
belly_rail_depth    = 162  # (?)
belly_rail_height   = 43   # (?)

# String/Pin Dimensions (mm-R)
hitchpin_height    = 5     # (?)
hitchpin_radius    = 1     # (?)
balance_pin_height = 15    # (?)
balance_pin_radius = 1     # (?)
tuning_pin_height  = 23    # (?)
tuning_pin_radius  = 1.5   # (?)
string_radius      = 0.4   # (?)

# Keyboard Dimensions (mm-R)
nat_width        = 25.3
nat_depth        = 81.5
nat_height       = 10
key_top_height   = 2    # (?)
sharp_width      = 14.3
sharp_depth      = 41.2
sharp_height     = 4.9
tangent_width    = 3    # (?)
tangent_depth    = 1    # (?)
tangent_height   = 5    # (?)
rack_tongue_width  = 1  # (?)
rack_tongue_depth  = 7  # (?)
rack_tongue_height = 5  # (?)

# Advanced
debug_mode = False

# Colors (RGB)
col_wood_dark  = Color(0.35, 0.20, 0.10)
col_wood_light = Color(0.80, 0.65, 0.40)
col_wood_med   = Color(0.55, 0.35, 0.15)
col_key_lever  = Color(0.9,  0.9,  0.9)
col_natural    = Color(0.90, 0.88, 0.80)
col_sharp      = Color(0.15, 0.15, 0.15)
col_brass      = Color(0.85, 0.75, 0.30)
col_string     = Color(0.90, 0.90, 0.90)
col_iron       = Color(0.37, 0.4,  0.41)

# Array of [slot_position, sounding_length] pairs indexed by key_idx.
# slot_position is measured from the right edge of the case; sounding_length is
# the vibrating string length in mm.
note_slot_position_and_sounding_length = [
    [938.0, 837.0],
    [927.0, 826.0],
    [916.5, 815.5],
    [902.5, 801.5],
    [888.5, 787.5],
    [875.5, 774.5],
    [836.0, 735.0],
    [788.0, 687.0],
    [774.0, 673.0],
    [731.0, 630.0],
    [699.0, 598.0],
    [665.5, 565.0],
    [655.0, 554.0],
    [627.0, 526.0],
    [593.0, 492.0],
    [582.0, 481.5],
    [549.0, 448.0],
    [528.5, 427.5],
    [506.0, 405.0],
    [495.5, 394.5],
    [474.0, 373.0],
    [449.5, 348.5],
    [437.5, 336.5],
    [420.5, 319.5],
    [398.0, 297.0],
    [383.0, 282.0],
    [371.0, 270.5],
    [357.5, 256.5],
    [342.5, 241.5],
    [328.5, 227.5],
    [317.5, 216.5],
    [302.5, 202.0],
    [291.0, 190.0],
    [280.0, 179.5],
    [270.5, 169.5],
    [262.0, 161.0],
    [251.0, 150.5],
    [241.5, 140.5],
    [232.0, 131.0],
    [226.5, 125.5],
    [217.0, 116.0],
    [210.5, 109.5],
    [203.0, 102.0],
    [199.0,  98.0],
    [192.5,  91.5],
    [186.0,  85.0],
    [180.5,  79.5],
]

# --- Derived parameters ---

right_edge_x = c_length - wall_th

rack_pos = Vector(
    wall_th + hitchpin_block_th,
    c_width - wall_th - rack_th,
    c_height - rack_height - wall_th,
)

wrestplank_pos = Vector(
    right_edge_x - wrestplank_width,
    wall_th,
    27,
)

soundboard_depth = c_width - wall_th * 2  # (?)

soundboard_pos = Vector(
    right_edge_x - wrestplank_width - soundboard_width,
    wall_th,
    50,
)

bridge_pos = Vector(
    right_edge_x - 101,
    c_width - wall_th - rack_th - 82,
    soundboard_pos.Z + soundboard_height,
)

kb_pos = Vector(
    122,
    -nat_depth,
    c_height - nat_height - 16,
)

key_lever_top_y = c_width - wall_th - rack_th - 1  # (?)

# kb_length = key_x(num_keys + 1) - kb_pos.X  — computed after key_x() is defined
