#!/bin/env python3

LINES_ROOTS = ['sc_sxr','sc_hxr','sc_bsyd','sc_dasel','sc_diag0','cu_sxr','cu_hxr']

ED_FILES = ['elementdevices.dat','elementdevices_cavities_cuH.dat','elementdevices_cavities_cuS.dat','elementdevices_sbends_cuH.dat','elementdevices_sbends_cuS.dat']

ed = {}
for file in ED_FILES:
  with open(file,'r') as fed:
    for line in fed:
      name, pv = line.split() 
      if pv != '-':
        if name not in ed:
          ed[name] = pv
        else:
          print(f'dup name found in elementdevices.dat: {name}')

for model in LINES_ROOTS:
  with open(f'{model}_lines.precursor','r') as fpre, open(f'{model}_lines.dat','w') as fdat:
    for line in fpre:
      data = line.split()
      if data[2] != 'SBEN':
        if data[1] in ed:
          fdat.write(f'{ed[data[1]]} {" ".join(data[1:])}\n')
      else:
        if data[1][:-1] in ed:
          fdat.write(f'{ed[data[1][:-1]]} {" ".join(data[1:])}\n')

