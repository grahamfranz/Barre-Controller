/* ============================================================
 *  Parametric Barre Controller v4
 *  ------------------------------------------------------------
 *  Leaf-spring flex-beam barres with side-mounted 3.5 mm jacks
 *  (sized for Thonk PJ398SM / Thonkiconn) for Eurorack-style
 *  patching.
 *
 *  A single continuous rail runs across the base. Each barre
 *  has a matching notch on the underside of its far end block
 *  that drops over the rail, providing lateral alignment. Two
 *  screws per barre clamp it down.
 *
 *  === Barre side profile (along X) ===
 *
 *   Z=barre_height ┬───────────────┬──────────────┬──────────┐
 *                   │ near          │              │ jack     │
 *                   │ end  ┌────────┴──────────┐   │ block    │─┤← plug (Y=0)
 *                   │ block│ middle flex (thin)│   │ [hollow] │
 *                   │      └───────────────────┘   │ back open│
 *                   │  ↑screw   ↑piezo             │ ↑screw   │
 *   Z=0  ───────────┴──────────────────┬──┬─────────┴──────────┘
 *                                      notch└─ rail on base
 *
 *  Jack orientation: plug faces the user (Y=0 face). The body
 *  sits in a hollow cavity open at the back face (Y=barre_width),
 *  giving access to the solder lugs and cable routing.
 *  The far screw clamps in front of (+X of) the jack.
 *
 *  The middle's bottom sits (barre_height - middle_thickness)
 *  above the base, giving a natural flex gap so the middle can
 *  bow downward when pressed.
 *
 *  === Printing ===
 *  • Base: flat on bed. Rail is just a ridge running in Y.
 *  • Barre: print UPSIDE DOWN (flat top face on the bed). Every
 *    cutout (piezo indent, wire channel, jack pocket, notch)
 *    opens upward during printing — clean buckets and grooves.
 *
 *  License: public domain / CC0
 * ============================================================ */

/* [Render] */
part = "both"; // [barre, base, both, assembled]

/* [Array] */
num_barres  = 4;
barre_pitch = 37;   // Y centre-to-centre; must be >= barre_width

/* [Barre Geometry] */
barre_length  = 110;
barre_width   = 28;
barre_height  = 14;
middle_thickness = 4;  // pressing surface thickness; thinner = more flex
screw_clearance_d = 3.4;
notch_offset_from_middle = 4;

/* [Piezo] */
piezo_d = 27;
piezo_indent_clearance = 0.4;
piezo_indent_depth = 0.8;

/* [Thonk Jack — 3.5 mm TS, top-mounted] */
// Sized for PJ398SM ("Thonkiconn") panel jack. Plug inserts from above.
jack_plug_hole_d     = 6.2;   // for 6 mm threaded barrel
jack_plug_hole_wall  = 2.0;   // top shoulder (where the nut clamps)
jack_pocket_d        = 10;    // body pocket diameter (~9 mm body + clearance)
jack_offset_from_end = 14;
cavity_wall_y = 2;
wire_channel_w = 5;
wire_channel_d = 2;

/* [Base] */
base_margin_x  = 10;
base_margin_y  = 9;
base_thickness = 4;
base_corner_r  = 3;
rail_width = 4;
rail_height = 3;

/* [Feet] */
include_feet = true;
foot_d = 14;  // increased for better base support

/* [Enclosure] */
with_enclosure = false;  // Enable two-part enclosure mode
enclosure_height = 15;   // Height of upper shell walls (mm)
board_standoff_height = 3;  // Height of circuit board above lower panel (mm)
piezo_hole_d = 1.5;      // Diameter of piezo wire pass-through holes (mm)
lid_thickness = 3;       // Thickness of lower panel (mm)
board_fastener_type = "hex_nut";  // [hex_nut, square_nut, self_tap]
nut_pocket_depth = 2.4;  // Depth of hex-nut recess (mm)
screw_margin = 5;        // Distance from panel corner to standoff center (mm)
include_edge_guides = true;  // Add optional edge guides on lower panel

$fn = 48;
EPS = 0.02;

// ============================================================
//  Internal parameters (computed)
// ============================================================

end_length_near  = 15;
end_length_far   = 29;
notch_clearance  = 0.3;

// ============================================================
//  Derived
// ============================================================

middle_length    = barre_length - end_length_near - end_length_far;
middle_x_start   = end_length_near;
middle_x_end     = barre_length - end_length_far;
middle_bottom_z  = barre_height - middle_thickness;

notch_x_center   = middle_x_end + notch_offset_from_middle;
notch_width      = rail_width  + 2 * notch_clearance;
notch_depth      = rail_height + notch_clearance;

jack_pocket_x_center = barre_length - jack_offset_from_end;

cavity_x_span        = jack_pocket_d + 6;  // expanded for better wiring room
cavity_x_min         = jack_pocket_x_center - cavity_x_span / 2;

near_screw_x     = end_length_near / 2;
far_screw_x      = barre_length - 5;  // moved to far end, 5mm from end

array_span_y     = (num_barres - 1) * barre_pitch + barre_width;
base_outer_x     = 2 * base_margin_x + barre_length;
base_outer_y     = 2 * base_margin_y + array_span_y;

rail_x_center    = base_margin_x + notch_x_center;
rail_x_start     = rail_x_center - rail_width / 2;

function barre_x_start()   = base_margin_x;
function barre_y_start(i)  = base_margin_y + i * barre_pitch;
function barre_y_center(i) = barre_y_start(i) + barre_width / 2;

// Enclosure dimensions (computed when with_enclosure = true)
panel_outer_x    = base_outer_x;
panel_outer_y    = base_outer_y;
panel_margin_x   = 1;  // Small clearance between panel and shell walls
panel_width      = panel_outer_x - 2 * panel_margin_x;
panel_depth      = panel_outer_y - 2 * panel_margin_x;

// Screw boss corner positions (for both upper shell and lower panel)
boss_corner_positions = [
    [base_corner_r + screw_margin, base_corner_r + screw_margin],
    [base_outer_x - base_corner_r - screw_margin, base_corner_r + screw_margin],
    [base_corner_r + screw_margin, base_outer_y - base_corner_r - screw_margin],
    [base_outer_x - base_corner_r - screw_margin, base_outer_y - base_corner_r - screw_margin]
];

// Piezo hole positions (one per barre, at X center, Y center of each barre)
piezo_hole_positions = [for (i = [0 : num_barres - 1])
    [barre_x_start() + barre_length / 2, barre_y_center(i)]
];

echo(str("Base: ", base_outer_x, " x ", base_outer_y,
         " x ", base_thickness + rail_height, " mm"));
echo(str("Barre: ", barre_length, " x ", barre_width,
         " x ", barre_height, " mm  (middle ",
         middle_thickness, " mm, flex gap ",
         middle_bottom_z, " mm)"));
echo(str("Rail X (world): ", rail_x_center,
         ",  jack X (barre local): ", jack_pocket_x_center));

// ============================================================
//  Helpers
// ============================================================

module rounded_rect(l, w, h, r) {
    rr = max(0.1, min(r, min(l, w)/2 - 0.1));
    hull() for (x = [rr, l - rr], y = [rr, w - rr])
        translate([x, y, 0]) cylinder(r = rr, h = h);
}

// ============================================================
//  Barre (USE orientation: Z=0 is bottom of end blocks)
// ============================================================

module barre() {
    difference() {
        union() {
            // Near end block (full thickness)
            cube([end_length_near, barre_width, barre_height]);
            // Middle section — elevated to create the flex gap
            translate([middle_x_start, 0, middle_bottom_z])
                cube([middle_length, barre_width, middle_thickness]);
            // Far end block (full thickness, houses jack + notch)
            translate([barre_length - end_length_far, 0, 0])
                cube([end_length_far, barre_width, barre_height]);
        }

        // --- Screw through-holes (vertical) ---
        for (sx = [near_screw_x, far_screw_x])
            translate([sx, barre_width / 2, -EPS])
                cylinder(d = screw_clearance_d,
                         h = barre_height + 2 * EPS);

        // --- Piezo indent on bottom of middle ---
        translate([barre_length / 2, barre_width / 2,
                   middle_bottom_z - EPS])
            cylinder(d = piezo_d + piezo_indent_clearance,
                     h = piezo_indent_depth + EPS);

        // --- Bottom-up rectangular pocket for jack body + cable routing ---
        // Opens at Z=0 (bottom face). Symmetrical walls on front and back.
        translate([cavity_x_min, cavity_wall_y, -EPS])
            cube([cavity_x_span, barre_width - 2 * cavity_wall_y,
                  barre_height - jack_plug_hole_wall + EPS]);

        // --- Barrel hole through the top shoulder ---
        // 2 mm shoulder at top face; nut clamps here.
        translate([jack_pocket_x_center, barre_width / 2,
                   barre_height - jack_plug_hole_wall - EPS])
            cylinder(d = jack_plug_hole_d,
                     h = jack_plug_hole_wall + 2 * EPS);

        // --- Notch on underside of far block (mates with rail) ---
        translate([notch_x_center - notch_width / 2, -EPS, -EPS])
            cube([notch_width,
                  barre_width + 2 * EPS,
                  notch_depth + EPS]);

        // --- Wire channel: groove extending into hollow cavity ---
        // Centered on the width of the barre
        translate([barre_length / 2,
                   barre_width / 2 - wire_channel_w / 2,
                   middle_bottom_z - 6])
            cube([cavity_x_min + 0.5 - barre_length / 2,
                  wire_channel_w,
                  middle_thickness + 3]);
    }
}

// Barre flipped into print orientation (top face on bed, every
// cutout opens upward).
module barre_for_print() {
    translate([0, barre_width, barre_height])
        rotate([180, 0, 0])
            barre();
}

// ============================================================
//  Upper Shell (enclosure mode: barre housing with walls)
// ============================================================

module upper_shell() {
    difference() {
        union() {
            // Main body: solid block with rounded corners and extended walls
            rounded_rect(base_outer_x, base_outer_y,
                        base_thickness + enclosure_height,
                        base_corner_r);

            // Continuous rail running across full Y
            translate([rail_x_start, 0, base_thickness])
                cube([rail_width, base_outer_y, rail_height]);
        }

        // --- Screw holes for barre mounting (unchanged, vertical) ---
        for (i = [0 : num_barres - 1]) {
            x0 = barre_x_start();
            yc = barre_y_center(i);
            for (sx = [near_screw_x, far_screw_x])
                translate([x0 + sx, yc, -EPS])
                    cylinder(d = screw_clearance_d,
                             h = base_thickness + enclosure_height + 2 * EPS);
        }

        // --- Screw boss clearance holes (M3 through full height) ---
        for (pos = boss_corner_positions) {
            translate([pos[0], pos[1], -EPS])
                cylinder(d = 3.4,  // M3 clearance
                         h = base_thickness + enclosure_height + 2 * EPS, $fn = 20);
        }

        // --- Piezo wire pass-through holes (Z floor only) ---
        for (pos = piezo_hole_positions) {
            translate([pos[0], pos[1], base_thickness - EPS])
                cylinder(d = piezo_hole_d,
                         h = base_thickness + 2 * EPS, $fn = 16);
        }
    }
}

// ============================================================
//  Lower Panel (enclosure mode: circuit board mount base)
// ============================================================

module lower_panel() {
    difference() {
        union() {
            // Main panel: solid block with rounded corners
            rounded_rect(panel_outer_x, panel_outer_y, lid_thickness,
                        base_corner_r);

            // Standoffs at four corners (for circuit board mounting)
            for (pos = boss_corner_positions) {
                translate([pos[0], pos[1], lid_thickness])
                    cylinder(d = 6, h = board_standoff_height, $fn = 20);
            }
        }

        // --- M3 screw holes through standoffs and panel ---
        for (pos = boss_corner_positions) {
            // Hole through full height (standoff + panel)
            translate([pos[0], pos[1], -EPS])
                cylinder(d = 3.2,  // M3 clearance
                         h = lid_thickness + board_standoff_height + 2 * EPS,
                         $fn = 20);
        }

        // --- Hex-nut pockets (recessed into underside) ---
        if (board_fastener_type == "hex_nut") {
            // Hexagonal pockets
            for (pos = boss_corner_positions) {
                translate([pos[0], pos[1], -EPS])
                    cylinder(d = 6.5,  // M3 hex nut width-across-flats (~5.5mm) + clearance
                             h = nut_pocket_depth + EPS,
                             $fn = 6);
            }
        }
        else if (board_fastener_type == "square_nut") {
            // Square nut pockets
            for (pos = boss_corner_positions) {
                translate([pos[0], pos[1] - 3, -EPS])
                    cube([6, 6, nut_pocket_depth + EPS]);
            }
        }
        // If self_tap, no pockets needed
    }

    // --- Optional edge guides (shallow lips to center panel) ---
    if (include_edge_guides) {
        // Small guide lips on inner edges to prevent sliding
        guide_height = 1;
        guide_width = 2;
        translate([0, 0, lid_thickness])
            difference() {
                rounded_rect(panel_outer_x, panel_outer_y, guide_height,
                            base_corner_r);
                rounded_rect(panel_width, panel_depth, guide_height + EPS,
                            base_corner_r);
            }
    }
}

// ============================================================
//  Base with continuous rail
// ============================================================

module base() {
    difference() {
        union() {
            rounded_rect(base_outer_x, base_outer_y,
                         base_thickness, base_corner_r);
            // Continuous rail running across full Y
            translate([rail_x_start, 0, base_thickness])
                cube([rail_width, base_outer_y, rail_height]);
        }

        // Per-barre screw holes through the base.
        for (i = [0 : num_barres - 1]) {
            x0 = barre_x_start();
            yc = barre_y_center(i);
            for (sx = [near_screw_x, far_screw_x])
                translate([x0 + sx, yc, -EPS])
                    cylinder(d = screw_clearance_d,
                             h = base_thickness + 2 * EPS);
        }
    }

    // Feet
    if (include_feet) {
        fi = base_corner_r + foot_d / 2 + 1;  // positioned to stay within base edges
        for (fx = [fi, base_outer_x - fi],
             fy = [fi, base_outer_y - fi])
            translate([fx, fy, -3])
                cylinder(d = foot_d, h = 3 + EPS);
    }
}

// ============================================================
//  Render modes
// ============================================================

module show_both() {
    base();
    barre_z = include_feet ? -3 : 0;
    for (i = [0 : num_barres - 1])
        translate([base_outer_x + 5,
                   i * (barre_width + 3), barre_z])
            barre_for_print();
}

module show_assembled() {
    base();
    for (i = [0 : num_barres - 1])
        translate([barre_x_start(), barre_y_start(i),
                   base_thickness])
            barre();
}

if      (part == "barre")     barre_for_print();
else if (part == "base")      base();
else if (part == "both")      show_both();
else if (part == "assembled") show_assembled();
