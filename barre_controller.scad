/* ============================================================
 *  Parametric Barre Controller v4
 *  ------------------------------------------------------------
 *  Leaf-spring flex-beam barres with top-mounted 3.5 mm jacks
 *  (sized for a standard PJ398SM / "Thonkiconn" panel jack, but
 *  any 3.5 mm panel jack with a ~6 mm threaded barrel fits) for
 *  Eurorack-style patching.
 *
 *  A single continuous rail runs across the base. Each barre
 *  has a matching notch on the underside of its far end block
 *  that drops over the rail, providing lateral alignment. Two
 *  screws per barre clamp it down.
 *
 *  Each barre has three sections along X: a near end block
 *  (near clamp screw), a thin middle flex section (piezo glued
 *  to its underside), and a far end block (jack pocket + far
 *  clamp screw + rail notch).
 *
 *  Jack orientation: the plug inserts from the top face; the
 *  jack body sits in a pocket open at the bottom face, giving
 *  access to the solder lugs and cable routing. The far screw
 *  clamps just in front of (+X of) the jack.
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
part = "both"; // [barre, base, both, assembled, enclosure_shell, enclosure_panel, enclosure_both, enclosure_assembled]

/* [Array] */
num_barres  = 4;
barre_pitch = 37;   // Y centre-to-centre; must be >= barre_width

/* [Barre Geometry] */
barre_length  = 110;
barre_width   = 28;
barre_height  = 14;
middle_thickness = 5;  // pressing surface thickness; thinner = more flex (stiffness ~ thickness^3)
screw_clearance_d = 3.4;
notch_offset_from_middle = 4;

/* [Piezo] */
piezo_d = 27;
piezo_indent_clearance = 0.4;
piezo_indent_depth = 0.8;

/* [3.5 mm Jack — TS, top-mounted] */
// Sized for a PJ398SM ("Thonkiconn") panel jack, but any standard 3.5 mm
// panel jack with a ~6 mm threaded barrel fits. Plug inserts from above.
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
screw_head_d = 6.5;      // M3 screw head diameter
screw_head_depth = 2.0;  // Depth to recess screw head flush
nut_trap_af    = 5.5;    // M3 hex nut across-flats (wrench size)
nut_trap_depth = 2.6;    // Hex nut pocket depth on base underside (M3 nut ~2.4mm + clearance)
nut_trap_d     = nut_trap_af / cos(30) + 0.2;  // across-corners + clearance for $fn=6 pocket

/* [Feet] */
include_feet = false;  // Feet don't prevent base deflection; users can add rubber pads instead
foot_d = 14;  // Diameter of feet (for experimental base support)

/* [Enclosure] */
with_enclosure = false;  // Enable two-part enclosure mode
enclosure_height = 15;   // Height of upper shell walls (mm)
rim_height = 4;          // Height of lower panel rim (mm); 4 mm is enough for lateral location
board_standoff_height = 3;  // Height of circuit board above lower panel (mm)
piezo_hole_d = 3.5;      // Diameter of piezo wire pass-through holes (mm)
lid_thickness = 3;       // Thickness of lower panel base plate (mm); >=3 needed for hex_nut fasteners
board_fastener_type = "hex_nut";  // [hex_nut, square_nut, self_tap] — hex_nut = captive nut (durable, needs lid>=3mm); self_tap allows a thinner lid
nut_pocket_depth = 2.4;  // Depth of hex-nut recess (mm)
screw_margin = 13;       // Distance from corner to screw center (mm), positions screws in corners
include_edge_guides = true;  // Add optional edge guides on lower panel

/* [Enclosure — Power Switch] */
include_switch = true;   // Add panel-mount power switch pocket
switch_d = 12.2;         // Hole diameter for 12 mm illuminated latching push button (slight clearance)

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

// Piezo hole positions (one per barre, positioned under the jack cavity for cable routing)
// Placed at the far end (jack) area so cables can route up to jacks or down to circuit board
piezo_hole_positions = [for (i = [0 : num_barres - 1])
    [barre_x_start() + jack_pocket_x_center, barre_y_center(i)]
];

// Power switch position: front-left area, centered in the clear wall above the base plate
switch_x = base_outer_x / 4;
switch_y = 0;
switch_z = -(enclosure_height - lid_thickness) / 2;  // Center of wall between base plate top and ceiling

echo(str("Base: ", base_outer_x, " x ", base_outer_y,
         " x ", base_thickness + rail_height, " mm"));
echo(str("Barre: ", barre_length, " x ", barre_width,
         " x ", barre_height, " mm  (middle ",
         middle_thickness, " mm, flex gap ",
         middle_bottom_z, " mm)"));
echo(str("Rail X (world): ", rail_x_center,
         ",  jack X (barre local): ", jack_pocket_x_center));

if (with_enclosure) {
    echo(str("=== ENCLOSURE MODE ==="));
    echo(str("Upper Shell: ", panel_outer_x, " x ", panel_outer_y,
             " x ", base_thickness + enclosure_height, " mm"));
    echo(str("Lower Panel: ", panel_outer_x, " x ", panel_outer_y,
             " x ", lid_thickness, " mm"));
    echo(str("Board Standoff Height: ", board_standoff_height, " mm"));
    echo(str("Piezo Holes: ", len(piezo_hole_positions), " holes, diameter ",
             piezo_hole_d, " mm"));
}

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
        // No head recess: the screw head sits proud on the end blocks (clear of
        // the flex pad). A standard M3x20 still reaches full nut engagement in
        // the base's underside nut traps, so no filing is needed. A top
        // counterbore is deliberately avoided at the far screw — its 6.5 mm head
        // would breach the thin (2 mm) jack shoulder into the jack cavity.
        for (sx = [near_screw_x, far_screw_x]) {
            translate([sx, barre_width / 2, -EPS])
                cylinder(d = screw_clearance_d,
                         h = barre_height + 2 * EPS);
        }

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

// Shell flipped into print orientation (flat top face on bed, open end facing up).
// Standoffs print as pillars; screw/piezo holes open cleanly from the bed.
// The rail ridge on the outer top face is the lowest point (Z=0); the surrounding
// plate is rail_height above the bed — slicer may add a thin support strip there.
module upper_shell_for_print() {
    translate([0, base_outer_y, base_thickness + rail_height])
        rotate([180, 0, 0])
            upper_shell();
}

// ============================================================
//  Upper Shell (enclosure mode: barre housing with walls)
// ============================================================

module upper_shell() {
    wall_t = 2.5;  // Wall thickness
    top_thickness = base_thickness;  // Top surface thickness where barres mount
    standoff_od = 8;  // Outer diameter of corner standoff tubes
    standoff_id = 3.4;  // Inner diameter for M3 screw clearance
    standoff_height = 5;  // Short standoffs for shell support, leaves room for PCB

    difference() {
        union() {
            // Rounded box body extending from -enclosure_height to top_thickness
            // This maintains rounded corners all the way down the walls
            translate([0, 0, -enclosure_height])
                rounded_rect(base_outer_x, base_outer_y, top_thickness + enclosure_height, base_corner_r);

            // Continuous rail on TOP of mounting surface (for barre mounting)
            translate([rail_x_start, 0, top_thickness])
                cube([rail_width, base_outer_y, rail_height]);
        }

        // --- Hollow out interior (bottom-open shell) ---
        // Subtract slightly smaller rounded box to create walls
        translate([wall_t, wall_t, -enclosure_height])
            rounded_rect(base_outer_x - 2 * wall_t, base_outer_y - 2 * wall_t,
                        enclosure_height + EPS, base_corner_r - wall_t);

        // --- Barre mounting screw holes (vertical through top surface) ---
        for (i = [0 : num_barres - 1]) {
            x0 = barre_x_start();
            yc = barre_y_center(i);
            for (sx = [near_screw_x, far_screw_x]) {
                translate([x0 + sx, yc, -enclosure_height - EPS])
                    cylinder(d = screw_clearance_d,
                             h = enclosure_height + top_thickness + 2 * EPS);
                // Countersink for screw head on underside (inside)
                translate([x0 + sx, yc, -enclosure_height - EPS])
                    cylinder(d = screw_head_d,
                             h = screw_head_depth + EPS);
            }
        }

        // --- Corner screw holes (M3 for connecting upper shell to lower panel) ---
        for (pos = boss_corner_positions) {
            // M3 clearance hole through full top thickness
            translate([pos[0], pos[1], -EPS])
                cylinder(d = 3.4, h = top_thickness + 2 * EPS, $fn = 16);
            // Countersink for M3 screw head on underside (inside)
            translate([pos[0], pos[1], -EPS])
                cylinder(d = 5.5, h = 1.5 + EPS, $fn = 16);
        }

        // --- Hollow interior of standoff tubes (for screw pass-through) - goes full height ---
        for (pos = boss_corner_positions) {
            translate([pos[0], pos[1], -standoff_height])
                cylinder(d = standoff_id, h = standoff_height, $fn = 16);
        }

        // --- Piezo wire holes through top surface ---
        for (pos = piezo_hole_positions) {
            translate([pos[0], pos[1], -EPS])
                cylinder(d = piezo_hole_d, h = top_thickness + 2 * EPS, $fn = 16);
        }

        // --- Power switch hole through front wall ---
        if (include_switch) {
            // Cylinder through front Y-wall
            translate([switch_x, 1.25, switch_z])
                rotate([90, 0, 0])
                    cylinder(d = switch_d, h = 2.5, center=true, $fn = 32);
        }
    }

    // Corner standoff tubes (added after difference to prevent subtraction)
    // Hollow them out for screw pass-through
    difference() {
        for (pos = boss_corner_positions) {
            translate([pos[0], pos[1], -standoff_height])
                cylinder(d = standoff_od, h = standoff_height, $fn = 20);
        }
        for (pos = boss_corner_positions) {
            translate([pos[0], pos[1], -standoff_height - EPS])
                cylinder(d = standoff_id, h = standoff_height + 2 * EPS, $fn = 16);
        }
    }
}

// ============================================================
//  Lower Panel (enclosure mode: circuit board mount base)
// ============================================================

module lower_panel() {
    wall_t = 2.5;  // Must match upper shell wall thickness
    locating_fit = 0.3;  // Clearance for locating plug to fit into shell
    plug_width = base_outer_x - 2 * (wall_t + locating_fit);
    plug_depth = base_outer_y - 2 * (wall_t + locating_fit);
    plug_x_offset = wall_t + locating_fit;
    plug_y_offset = wall_t + locating_fit;
    standoff_od = 8;  // Must match upper shell standoff outer diameter
    standoff_height = board_standoff_height;  // Full height for component clearance (was half)
    total_panel_height = lid_thickness + rim_height;

    translate([0, 0, -enclosure_height])
    difference() {
        union() {
            // Solid base plate (full footprint)
            rounded_rect(base_outer_x, base_outer_y, lid_thickness, base_corner_r);

            // Raised locating rim/plug (sits inside shell opening for lateral location)
            // Slightly undersized so it slides into the shell cavity without binding
            translate([plug_x_offset, plug_y_offset, lid_thickness])
                rounded_rect(plug_width, plug_depth, rim_height,
                           max(0.5, base_corner_r - locating_fit));

            // Corner standoffs for circuit board mounting
            for (pos = boss_corner_positions) {
                translate([pos[0], pos[1], lid_thickness])
                    cylinder(d = standoff_od, h = standoff_height, $fn = 20);
            }
        }

        // --- M3 screw holes (shaft size 3.0 mm, not clearance) ---
        for (pos = boss_corner_positions) {
            translate([pos[0], pos[1], -EPS])
                cylinder(d = 3.0, h = total_panel_height + standoff_height + 2 * EPS, $fn = 16);
            // Countersink for M3 screw head on underside (bottom face)
            translate([pos[0], pos[1], -EPS])
                cylinder(d = 5.5, h = 1.5 + EPS, $fn = 16);
        }

        // --- Hex-nut pockets (recessed into underside of base plate) ---
        if (board_fastener_type == "hex_nut") {
            for (pos = boss_corner_positions) {
                translate([pos[0], pos[1], -EPS])
                    cylinder(d = 6.5, h = nut_pocket_depth + EPS, $fn = 6);
            }
        }
        else if (board_fastener_type == "square_nut") {
            for (pos = boss_corner_positions) {
                translate([pos[0], pos[1] - 3, -EPS])
                    cube([6, 6, nut_pocket_depth + EPS]);
            }
        }
        // If self_tap, no pockets needed

        // --- Switch body clearance through locating rim ---
        // Remove the rim in the switch zone at the front only — the body passes
        // over the absent section rather than through a full-length tunnel.
        if (include_switch) {
            switch_body_depth = 25;  // mm — typical panel-mount switch body depth
            translate([switch_x - (switch_d + 1.0) / 2,
                       plug_y_offset - EPS,
                       lid_thickness - EPS])
                cube([switch_d + 1.0,
                      switch_body_depth,
                      rim_height + 2 * EPS]);
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
            for (sx = [near_screw_x, far_screw_x]) {
                translate([x0 + sx, yc, -EPS])
                    cylinder(d = screw_clearance_d,
                             h = base_thickness + 2 * EPS);
                // Hex nut trap on underside (nut seats here, can't spin)
                translate([x0 + sx, yc, -EPS])
                    cylinder(d = nut_trap_d,
                             h = nut_trap_depth + EPS, $fn = 6);
            }
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

if (with_enclosure) {
    // Enclosure modes
    if      (part == "enclosure_shell") upper_shell_for_print();
    else if (part == "enclosure_panel") lower_panel();
    else if (part == "enclosure_both") {
        // Both parts in print orientation side by side at Z=0
        // Shell: top face on bed, open end up
        // Panel: flat base on bed (needs +enclosure_height to cancel internal offset)
        upper_shell_for_print();
        translate([base_outer_x + 5, 0, enclosure_height]) lower_panel();
    }
    else if (part == "enclosure_assembled") {
        // Assembled view: lower panel at bottom, upper shell, barres on top
        lower_panel();
        upper_shell();
        for (i = [0 : num_barres - 1])
            translate([barre_x_start(), barre_y_start(i), base_thickness])
                barre();
    }
}
else {
    // Original modes (backward compatibility)
    if      (part == "barre")     barre_for_print();
    else if (part == "base")      base();
    else if (part == "both")      show_both();
    else if (part == "assembled") show_assembled();
}
