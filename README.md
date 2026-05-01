# Barre Controller

A parametric Eurorack-style control interface with flexible barres and top-mounted 3.5 mm jacks.

## Overview

The Barre Controller features:
- **Leaf-spring flex barres**: Flexible middle sections with piezo sensors for dynamic control
- **Thonk jacks**: Top-mounted 3.5 mm panel jacks (PJ398SM/Thonkiconn) for Eurorack patching
- **Modular array**: Configurable number of barres with adjustable pitch

## Design Details

### Barre Architecture
Each barre consists of three sections:
- **Near end block**: Houses the first mounting screw and piezo sensor
- **Middle (flex section)**: Thin, flexible member that bows when pressed, with piezo contact on the underside
- **Far end block**: Houses the jack pocket and far screw, with wire routing to the piezo

### Assembly
- Barres mount onto a continuous rail on the base for lateral alignment
- Two screws per barre clamp it down to the base
- Near screw: through the near end block
- Far screw: through the far end block, in front of the jack pocket

### Printing
- **Base**: Print flat on bed (rail ridge points up)
- **Barre**: Print upside down so cutouts open upward during printing
  - Piezo indent, wire channel, jack pocket, and notch all print cleanly
  - Small bridge under jack pocket is FDM-friendly

## File Structure

- `barre_controller.scad` - Main parametric model

## Customization

Key parameters in `barre_controller.scad`:

| Parameter | Default | Purpose |
|-----------|---------|---------|
| `num_barres` | 4 | Number of barres in the array |
| `barre_pitch` | 37 mm | Center-to-center spacing between barres |
| `barre_length` | 110 mm | Total length of each barre |
| `middle_thickness` | 4 mm | Flex section thickness (smaller = more flex) |
| `jack_offset_from_end` | 14 mm | Distance from far end to jack pocket center |
| `foot_d` | 14 mm | Feet diameter (for base support) |

## Manufacturing Notes

- Material: PLA or similar suitable for FDM printing
- Print orientation: See "Printing" section above
- Piezo sensors are glued to the bottom of each middle section
- Thonk jack bodies mount from below through the pocket opening
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
| `piezo_hole_d` | 1.5 mm | Diameter of piezo wire pass-through holes |
| `lid_thickness` | 3 mm | Thickness of lower panel |
| `board_fastener_type` | "hex_nut" | Fastening style: "hex_nut", "square_nut", "self_tap" |
| `nut_pocket_depth` | 2.4 mm | Depth of hex-nut recess (tune per nut size) |
| `screw_margin` | 5 mm | Distance from corner to standoff center |
| `include_edge_guides` | true | Add shallow edge guides for panel alignment |

### Assembly

1. Print both parts (upper shell and lower panel)
2. *(Hex/square nut modes only)* Insert M3 nuts into corner pockets on the lower panel's underside
3. Mount your circuit board (e.g., circuit-mesh) to the standoffs on the lower panel using M3 screws from underneath
4. Lower the upper shell onto the lower panel, aligning corner posts
5. Insert M3 machine screws from the top and tighten into the nut pockets
6. Route piezo wires from the barres through the floor holes to your circuit board
7. Solder or connect piezo leads to your circuit board

### Backward Compatibility

When `with_enclosure = false`, the original single-piece base is rendered (default behavior). All original parameters and render modes remain unchanged.
