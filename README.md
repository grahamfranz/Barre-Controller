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
