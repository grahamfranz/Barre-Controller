/* ============================================================
 *  Parametric Barre Controller v4
 *  ------------------------------------------------------------
 *  Leaf-spring flex-beam barres with top-mounted 3.5 mm jacks
 *  (sized for Thonk PJ398SM / Thonkiconn) for Eurorack-style
 *  patching.
 *
 *  A single continuous rail runs across the base. Each barre
 *  has a matching notch on the underside of its far end block
 *  that drops over the rail, providing lateral alignment. Two
 *  screws per barre clamp it down — the far screw passes
 *  through the notch and rail into the base.
 *
 *  === Barre side profile (along X) ===
 *
 *   Z=end_thickness ┬───────────────┬──────────────┬──────┐
 *                   │ near          │              │     ⊓│ ← jack plug
 *                   │ end  ┌────────┴──────────┐   │ jack │   points up
 *                   │ block│ middle flex (thin)│   │ block│
 *                   │      └───────────────────┘   │      │
 *                   │  ↑screw   ↑piezo  ↑far screw│      │
 *   Z=0  ───────────┴────────────────────┬──┬─────┴──────┘
 *                                        notch └─ rail on base
 *
 *  The middle's bottom sits (end_thickness - middle_thickness)
 *  above the base, giving a natural flex gap so the middle can
 *  bow downward when pressed.
 *
 *  === Printing ===
 *  • Base: flat on bed. Rail is just a ridge running in Y.
 *  • Barre: print UPSIDE DOWN (flat top face on the bed). Every
 *    cutout (piezo indent, wire channel, jack pocket, notch)
 *    opens upward during printing — clean buckets and grooves.
 *    Only notable bridge is the floor of the jack pocket
 *    (~10 mm circular span), which FDM handles fine.
 *
 *  License: public domain / CC0
 * ============================================================ */

/* [Render] */
part = "both"; // [barre, base, both, assembled]

/* [Array] */
num_barres  = 4;
barre_pitch = 28;   // Y centre-to-centre between barres

/* [Barre Geometry] */
barre_length     = 80;
barre_width      = 20;
// End blocks must fit the vertical jack pocket (pocket depth +
// plug hole shoulder). 14 mm fits a PJ398SM with margin.
end_thickness    = 14;
// Thin flex middle. Smaller = more flex = more piezo signal.
middle_thickness = 4;
end_length_near  = 15;
end_length_far   = 22;

/* [Screws] */
screw_clearance_d = 3.4;   // M3 through-hole

/* [Piezo] */
// Glued to a shallow circular indent on the bottom of the middle.
piezo_d                = 20;
piezo_indent_clearance = 0.4;
piezo_indent_depth     = 0.8;

/* [Thonk Jack — 3.5 mm TS, top-mounted] */
// Sized for PJ398SM ("Thonkiconn") panel jack. Plug inserts
// from above for Eurorack-style patching.
jack_plug_hole_d     = 6.2;   // for 6 mm threaded barrel
jack_plug_hole_wall  = 2.0;   // top shoulder (where the nut clamps)
jack_pocket_d        = 10;    // body pocket diameter (~9 mm body + clearance)
jack_pocket_depth    = 11;    // body pocket depth
// Jack position: distance from the barre's +X face to pocket centre.
// Keeps the +X portion of the far block for the jack and leaves
// the -X portion for the notch + screw.
jack_offset_from_end = 7;

/* [Wire Channel] */
// Grooves on the underside of the middle (up into it) and the
// underside of the far end block (connecting to the jack pocket
// from below). Wires route through both with the flex gap air
// between them.
wire_channel_w = 2;
wire_channel_d = 1;

/* [Base] */
base_margin_x  = 10;
base_margin_y  = 10;
base_thickness = 4;
base_corner_r  = 3;

/* [Rail & Notch] */
// Rail runs continuously across the full Y of the base. Each
// barre has a matching notch on its underside at the same X.
rail_width      = 4;     // X extent of rail
rail_height     = 3;     // Z height above base top
notch_clearance = 0.3;   // per-side clearance for easy drop-in
// Notch centre X (barre local): a bit inside the far end block,
// with enough wall between it and the jack pocket.
notch_offset_from_middle = 4;

/* [Feet] */
include_feet = true;
foot_d       = 8;
foot_h       = 3;

/* [Quality] */
$fn = 48;
EPS = 0.02;

// ============================================================
//  Derived
// ============================================================

middle_length    = barre_length - end_length_near - end_length_far;
middle_x_start   = end_length_near;
middle_x_end     = barre_length - end_length_far;
middle_bottom_z  = end_thickness - middle_thickness;  // flex gap

notch_x_center   = middle_x_end + notch_offset_from_middle;
notch_width      = rail_width  + 2 * notch_clearance;
notch_depth      = rail_height + notch_clearance;

jack_pocket_x_center = barre_length - jack_offset_from_end;
pocket_top_z         = end_thickness - jack_plug_hole_wall;
pocket_bot_z         = pocket_top_z - jack_pocket_depth;

near_screw_x     = end_length_near / 2;
// Far screw sits just behind the jack pocket (toward -X), centred in Y.
// It clamps the far end block down to the base independently of the notch.
far_screw_x      = jack_pocket_x_center - jack_pocket_d / 2 - 4;

array_span_y     = (num_barres - 1) * barre_pitch + barre_width;
base_outer_x     = 2 * base_margin_x + barre_length;
base_outer_y     = 2 * base_margin_y + array_span_y;

rail_x_center    = base_margin_x + notch_x_center;
rail_x_start     = rail_x_center - rail_width / 2;

function barre_x_start()   = base_margin_x;
function barre_y_start(i)  = base_margin_y + i * barre_pitch;
function barre_y_center(i) = barre_y_start(i) + barre_width / 2;

echo(str("Base: ", base_outer_x, " x ", base_outer_y,
         " x ", base_thickness + rail_height, " mm"));
echo(str("Barre: ", barre_length, " x ", barre_width,
         " x ", end_thickness, " mm  (middle ",
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
            cube([end_length_near, barre_width, end_thickness]);
            // Middle section — elevated to create the flex gap
            translate([middle_x_start, 0, middle_bottom_z])
                cube([middle_length, barre_width, middle_thickness]);
            // Far end block (full thickness, houses jack + notch)
            translate([barre_length - end_length_far, 0, 0])
                cube([end_length_far, barre_width, end_thickness]);
        }

        // --- Screw through-holes (vertical) ---
        for (sx = [near_screw_x, far_screw_x])
            translate([sx, barre_width / 2, -EPS])
                cylinder(d = screw_clearance_d,
                         h = end_thickness + 2 * EPS);

        // --- Piezo indent on bottom of middle ---
        translate([barre_length / 2, barre_width / 2,
                   middle_bottom_z - EPS])
            cylinder(d = piezo_d + piezo_indent_clearance,
                     h = piezo_indent_depth + EPS);

        // --- Jack pocket: open on BOTTOM so jack inserts from below.
        // The threaded barrel passes up through the plug hole; the nut
        // clamps on the top shoulder. The body hangs below the barre.
        // Full-depth cut (Z=0 to pocket_top_z) leaves only the thin
        // top shoulder with the plug hole through it.
        translate([jack_pocket_x_center, barre_width / 2, -EPS])
            cylinder(d = jack_pocket_d,
                     h = pocket_top_z + EPS);
        // Plug hole through top shoulder (for the threaded barrel)
        translate([jack_pocket_x_center, barre_width / 2,
                   pocket_top_z - EPS])
            cylinder(d = jack_plug_hole_d,
                     h = jack_plug_hole_wall + 2 * EPS);

        // --- Notch on underside of far block (mates with rail) ---
        translate([notch_x_center - notch_width / 2, -EPS, -EPS])
            cube([notch_width,
                  barre_width + 2 * EPS,
                  notch_depth + EPS]);

        // --- Wire channel: middle's underside groove ---
        // From piezo centre out to the middle/far boundary.
        translate([barre_length / 2,
                   (barre_width - wire_channel_w) / 2,
                   middle_bottom_z - EPS])
            cube([middle_x_end - barre_length / 2,
                  wire_channel_w,
                  wire_channel_d + EPS]);

        // --- Wire channel: far block's underside groove ---
        // Runs from the middle/far boundary to the jack pocket opening.
        // Since the pocket is open on the bottom, wires pass straight
        // into the pocket body from this groove.
        translate([middle_x_end,
                   (barre_width - wire_channel_w) / 2,
                   -EPS])
            cube([jack_pocket_x_center - jack_pocket_d / 2 - middle_x_end,
                  wire_channel_w,
                  wire_channel_d + EPS]);
    }
}

// Barre flipped into print orientation (top face on bed, every
// cutout opens upward).
module barre_for_print() {
    translate([0, barre_width, end_thickness])
        rotate([180, 0, 0])
            barre();
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
        // Near + far screws both pass through base_thickness only.
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
        fi = base_corner_r + 2;
        for (fx = [fi, base_outer_x - fi],
             fy = [fi, base_outer_y - fi])
            translate([fx, fy, -foot_h])
                cylinder(d = foot_d, h = foot_h + EPS);
    }
}

// ============================================================
//  Render modes
// ============================================================

module show_both() {
    base();
    // Tile each barre next to the base, already print-ready
    for (i = [0 : num_barres - 1])
        translate([base_outer_x + 15,
                   i * (barre_width + 3), 0])
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
