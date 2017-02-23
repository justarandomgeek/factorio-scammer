### SCAMMER - Scanning Controlled Automated Material Mapping Enhanced Radar

SCAMMER allows reading the presence of ores and entities on the map.

  * sub entities:
    * CC Control 1: primary commands - SW corner
    * CC Control 2: secondary data - SE corner
    * Control nodes only read one wire - if both are connected it will only read the red one. Use a combinator to merge wires if required. This is mostly a performance optimization, and is not likely to change.

Position: {X,Y} and {U,V}
BoundingBox: {{X,Y},{U,V}}

### Commands:

  * P=1 + XY : Scan Position
    * Output found ores/entities to CC2
  * A=1 + XYUV : Scan box
    * Output count of found ores/entities to CC2
