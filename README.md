# Barre Controller

A parametric Eurorack-style control interface with flexible barres and top-mounted 3.5 mm jacks.

## Overview

The Barre Controller features:
- **Leaf-spring flex barres**: Flexible middle sections with piezo sensors for dynamic control
- **3.5 mm jacks**: Top-mounted panel jacks with a ~6 mm threaded barrel — any standard 3.5 mm panel-mount jack works (e.g. PJ398SM / "Thonkiconn")
- **Modular array**: Configurable number of barres with adjustable pitch

## Design Details

### Barre Architecture
Each barre consists of three sections:
- **Near end block**: Houses the near mounting screw
- **Middle (flex section)**: Thin, flexible member that bows when pressed, with piezo contact on the underside
- **Far end block**: Houses the jack pocket and far screw, with wire routing to the piezo

### Assembly
- Barres mount onto a continuous rail on the base for lateral alignment
- Two screws per barre clamp it down to the base
- Near screw: through the near end block
- Far screw: through the far end block, in front of the jack pocket

#### Hardware (per barre: 2 screws)
- **Screws:** M3, inserted from the top; the head sits proud on the end blocks (clear of the flex pad). The clamp stack is 20 mm (14 mm barre + 6 mm base), so a standard **M3×20** seats flush — the tip lands right at the base underside with full nut engagement, no protrusion and **no filing or cutting needed**. (No top counterbore: at the far screw a recessed head would break through the thin jack shoulder into the jack pocket.)
- **Nuts:** M3 hex nuts drop into the recessed **hex nut traps** on the base underside — they seat flat-to-flat and won't spin, so you can tighten entirely from the top. Because the barres see repeated pressing (cyclic load), use **nyloc nuts or a dab of threadlocker** so they don't back off. A nyloc sits slightly proud of the base underside; the rubber feet noted below absorb that.

### Printing
- **Base**: Print flat on bed (rail ridge points up)
- **Barre**: Print upside down so cutouts open upward during printing
  - Piezo indent, wire channel, jack pocket, and notch all print cleanly
  - Small bridge under jack pocket is FDM-friendly

#### Plate size and per-part STLs

The `both` render lays the base and all four barres out side-by-side, which spans
~245 mm in X — wider than most build plates. For smaller plates, print the parts
separately using the per-part STLs in `Renders/`:

| File | Part | Footprint | Notes |
|------|------|-----------|-------|
| `barre_controller_base.stl` | Base (1×) | 130 × 157 × 9 mm | Print flat, rail up |
| `barre_controller_barre.stl` | Barre (print `num_barres`×) | 110 × 28 × 14 mm | Already in print orientation; duplicate in your slicer |
| `barre_controller_both.stl` | Base + 4 barres together | 245 × 157 mm | Single-plate layout (large plates only) |
| `barre_controller_assembled.stl` | Assembled preview | — | Visualization only, not printable as one piece |

For the default 4-barre array, print `barre_controller_base.stl` once and
`barre_controller_barre.stl` four times (arrange ~31 mm apart in Y, matching the
`both` layout). To regenerate any STL: `openscad -o Renders/barre_controller_<part>.stl -D 'part="<part>"' barre_controller.scad`

## File Structure

- `barre_controller.scad` - Main parametric model

## Customization

Key parameters in `barre_controller.scad`:

| Parameter | Default | Purpose |
|-----------|---------|---------|
| `num_barres` | 4 | Number of barres in the array |
| `barre_pitch` | 37 mm | Center-to-center spacing between barres |
| `barre_length` | 110 mm | Total length of each barre |
| `middle_thickness` | 5 mm | Flex section thickness (smaller = more flex; stiffness ~ thickness³) |
| `jack_offset_from_end` | 14 mm | Distance from far end to jack pocket center |
| `include_feet` | false | Enable corner feet for base support (experimental) |
| `foot_d` | 14 mm | Diameter of corner feet (tunable when enabled) |

## Manufacturing Notes

- Material: PLA or similar suitable for FDM printing
- Print orientation: See "Printing" section above
- **Base deflection:** The base is 6 mm thick by default, which resists press deflection reasonably well (and sets the 20 mm clamp stack for a flush M3×20). The corner feet feature is disabled by default (`include_feet = false`) because small feet don't effectively prevent base flex. If you still see flex, increase `base_thickness` in 5 mm steps to keep a standard screw flush (6 mm → M3×20, 11 mm → M3×25, 16 mm → M3×30), add adhesive rubber pads (~12 mm diameter) to the underside corners, or experiment with feet at larger `foot_d` (e.g. 18–20 mm)
- Piezo sensors are glued to the bottom of each middle section
- Jack bodies mount from below through the pocket opening; the threaded barrel passes up through the top shoulder and is secured with the jack's own nut on top
- Wire routing connects jack terminals to piezo sensor

## License

Public domain / CC0

## Enclosure Mode (Optional)

The barre controller can optionally be printed as a two-part enclosure to house a circuit board (e.g., circuit-mesh prototyping board).

### Enabling Enclosure Mode

In the OpenSCAD Customizer:
1. Set `with_enclosure` to `true`
2. Choose a render option:
   - `enclosure_shell` - Just the upper housing
   - `enclosure_panel` - Just the lower circuit board mount
   - `enclosure_both` - Both parts side-by-side for printing
   - `enclosure_assembled` - View of assembled enclosure with barres

### Enclosure Parameters

| Parameter | Default | Purpose |
|-----------|---------|---------|
| `enclosure_height` | 15 mm | Height of upper shell walls |
| `board_standoff_height` | 3 mm | Height of circuit board above lower panel |
| `piezo_hole_d` | 3.5 mm | Diameter of piezo wire pass-through holes |
| `lid_thickness` | 3 mm | Thickness of lower panel |
| `board_fastener_type` | "hex_nut" | Fastening style: "hex_nut", "square_nut", "self_tap" |
| `nut_pocket_depth` | 2.4 mm | Depth of hex-nut recess (tune per nut size) |
| `screw_margin` | 13 mm | Distance from corner to standoff center |
| `include_edge_guides` | true | Add shallow edge guides for panel alignment |
| `include_switch` | true | Add M16x2 threaded barrel power switch pocket |
| `switch_d` | 14.5 mm | Hole diameter for M16x2 switch (slight clearance) |

### Assembly

1. Print both parts (upper shell and lower panel)
2. *(Hex/square nut modes only)* Insert M3 nuts into corner pockets on the lower panel's underside
3. Mount your circuit board (e.g., circuit-mesh) to the standoffs on the lower panel using M3 screws from underneath
4. Lower the upper shell onto the lower panel, aligning corner posts
5. Insert M3 machine screws from the top and tighten into the nut pockets
6. Route piezo wires from the barres through the floor holes to your circuit board
7. Solder or connect piezo leads to your circuit board

### Power Switch (Enclosure Mode)

If `include_switch = true`, the upper shell includes a power switch pocket on the front-left face at mid-height for ergonomic thumb access.

**Switch type:** M16x2 threaded barrel (same mounting style as the Thonkiconn jacks)
- Hole diameter: 14.5 mm (for M16x2 clearance)
- Thread the switch barrel through the hole from the front
- Secure with M16x2 hex nut on the inside
- Route the switch leads down to your circuit board (e.g., between power supply and main microcontroller rail)
- Recommended switches: Latching toggle, pushbutton, or rotary switches with M16x2 threads (widely available in Eurorack supply shops)

### Backward Compatibility

When `with_enclosure = false`, the original single-piece base is rendered (default behavior). All original parameters and render modes remain unchanged.
