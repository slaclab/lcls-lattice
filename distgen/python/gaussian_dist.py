from matplotlib import pyplot as plt
from distgen.reader import reader
from distgen.writers import get_writer
from distgen.generator import generator
from distgen.drivers import run_distgen
from distgen.plot import *

par = reader("",verbose=0)
gen = generator(verbose=0)

#GPT units
#units = {"x":"mm","y":"mm","px":"keV/c","py":"keV/c","t":"ps","q":"pC"}

#ASTRA units
units={"x":"m", "y":"m", "z":"m","px":"eV/c","py":"eV/c","pz":"eV/c","t":"ns","q":"nC"}

# Truncated radial gaussian distribution with pihole size of 2 mm, gaussian clipped at 50% intensity
par.reset("rad.trunc.gaussian.100pC.json",verbose=0)
p = par.read()
gen.parse_input(p)
beam,outfile = gen.get_beam()

print("User Input:")
print("r_dist:",p["r_dist"])

basename = 'astra_1M_'
fig=plt.figure(1)
# X-Y Plot
plot_2d(beam,1,"x",units["x"],"y",units["y"],'scatter_hist2d',nbins=50,axis="equal")
plt.savefig(basename+'scatter.pdf', bbox_inches='tight', dpi=800)
plt.show()
plt.close()

# Laser Current Profile
plot_current_profile(beam,1,units);
plt.savefig(basename+'long.pdf', bbox_inches='tight', dpi=800)
plt.show()
plt.close()

# Long dist?
print("User Input:")
print("t_dist:",p["t_dist"])
plot_1d(beam,"t",units["t"],nbins=100)
plt.savefig(basename+'long2.pdf', bbox_inches='tight', dpi=800)
plt.show()
plt.close()

print(p)
# The distgen writer is used to write the beam to files for different codes (GPT,ASTRA)
astra_writer =  get_writer("astra","rad.gaussian.astra.1M")
astra_writer.write(beam,verbose=1,params=p)

#gpt_writer =  get_writer("gpt","rad.gaussian.gpt.out")
#gpt_writer.write(beam,verbose=1,params=p)
