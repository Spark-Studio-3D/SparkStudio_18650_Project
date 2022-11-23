# SparkStudio_18650_Project
 
This OpenSCAD file prints parts for an 18650 based USB charger.
It can be configured for any number of 18650 cells up to the size limits of 
your 3d printer.

The SCAD Customizer can be used to set the following variables:

part  - The part to be rendered. Possible parts are box, lid, button, window, & test.
        The "test" part is the pcb end of the box to verify that parts printed on a 
        particular printer will fit the pcb snugly.

battery_count - The number of 18650's the box is intended to hold.  Typically 4 or 6.
buffer - The buffer space around each battery for flame-suppressing buffer filler.
wall - The box wall thickness. Typically 2mm.
corner - The radius of the corner rounding on the outside of the box.
iwall_fudge - A fudge factor to adjust the box for a snug fit of the pcb, Initially 1.25.
              Decrease it for a tighter fit, increase it to loosen the fit.

With the exception of the window, parts can be printed with any available filament.
The window must be printed with transparent filament. Use 4 perimeters, 
ZERO infill, ZERO bottom layers and 4 top layers with a rectilinear top fill pattern.

