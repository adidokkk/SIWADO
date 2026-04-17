# Tcl file for Magic layout

# Disable rescaling when reading GDS
calma rescale no

# Read the GDS file
gds read ../../implementation/top.gds
load top

# Flatten design
flatten flattop
load flattop
save flattop

# Check DRC errors
select top cell
drc why

# Check box size
select top cell
scalegrid 1 1
box

# # Extract netlist and sim for IRSIM
# extract all
# ext2sim -t!

# Exit magic
quit -noprompt