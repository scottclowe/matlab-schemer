# MATLAB Schemer

This MATLAB package makes it easy to change the color scheme, or theme, of the
MATLAB display and GUI.

You can use `schemer` to import a predefined color scheme, transfer your color
settings between installations, or create your own color scheme.

A collection of color schemes is available at
https://github.com/scottclowe/matlab-schemes.

## Importing a color scheme

Color schemes can be easily imported by running `schemer_import` without inputs
on the MATLAB command prompt.

When importing a color scheme, most of the settings will change immediately.
However, some settings will require MATLAB to be restarted:
- Variable highlighting colours
- Wavy underlines for errors
- Wavy underlines for warnings

## Transferring color scheme between MATLAB installations

On the source machine, run `schemer_export` to save a temporary color scheme,
and transfer this file to the destination machine.

When importing the new color scheme, you should run `schemer_import(true)` which
passes a flag to also import the boolean settings (whether to highlight the
current cell/line, etc) from the the source installation along with the colours.

## Reverting to the MATLAB default color scheme

Should you wish to revert to the color scheme which MATLAB ships with, you
should run `schemer_import('default.prf')` to import the MATLAB default theme
from the included stylesheet.
This is preferable over using the built-in reset buttons in the `Color` pane of
the MATLAB preferences because the MATLAB restore buttons will not restore all
the colours to their originals (ommiting the Editor display preferences).

## Creating a color scheme

When creating a color scheme to share with the rest of the world, it is
recommended to ensure colours are chosen appropriately for all possible
settings, even if they are not enabled.

For example, if you are creating a dark colour scheme, you may have cell
highlighting disabled but it would still be ill-advised to leave the background
highlight colour for cell displays as the default pale beige because other users
may have this setting enabled.

### Exporting through GUI

If you have made a custom color scheme using the MATLAB GUI to pick the colours,
you can export
the new color scheme with `schemer_export`.

Please note, this requires you to have visited all relevant panes of the
Preferences window at least once since MATLAB was installed, even if the
settings have not been changed from the default.
See the help for `schemer_export` for more details about this.

### Converting from a pre-existing theme

If you are converting a color scheme from another editor into a MATLAB
stylesheet, you may find it easier to start with a copy of the template
stylesheet, `develop/template_scheme.prf`, and manually copy the colours into
this. Colours should be negative RGB integers (R as big endian),
without an alpha channel.

You may find the `color2javaRGBint` helper function useful to convert
hexadecimal or R,G,B colours into the correct format.

## Addendum

### Requirements

Please note that `schemer` requires MATLAB to be run with Java support.

### Further information

For details on how the method was implemented, see
http://undocumentedmatlab.com/blog/changing-system-preferences-programmatically
