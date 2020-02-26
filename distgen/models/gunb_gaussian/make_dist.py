from distgen import Generator
from pmd_beamphysics import ParticleGroup,  particle_paths
from pmd_beamphysics.readers import all_components, component_str


input_file = "distgen.yaml"

# Create a generator object
gen = Generator(input_file, verbose=1) 

# Generate distribution, return the beam 
beam = gen.beam()

# Print some stats
beam.print_stats()

# Dist parameters 
p = gen.params

# openPMD
P = ParticleGroup(data=beam.data())

# Write astra or opal file
#P.write_astra('astra.dat')
P.write_opal('opal.txt')




















