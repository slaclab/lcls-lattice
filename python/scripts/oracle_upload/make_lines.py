#!/bin/env python3

# Combine elementdevices files with *_lines.precursor files to make *_lines.dat and *_lines.all
# The elementdevices files are created by elementdevices.py, queries the oracle database.
# The *_lines.precursor files come from surveyDataBmad.py
#
# The output *_lines.dat files are meant to feed the directory service.
# The output *_lines.all files are meant to feed the dot beampaths images.

LINES_ROOTS = ['sc_sxr','sc_hxr','sc_bsyd','sc_dasel','sc_diag0','cu_sxr','cu_hxr','sc_diagis','sc_diag02',
               'sc_hxr2','sc_sxr2','sc_bsyd2','sc_dasel2']

ED_FILES = ['elementdevices.dat','elementdevices_cavities_cuH.dat','elementdevices_cavities_cuS.dat','elementdevices_sbends_cuH.dat','elementdevices_sbends_cuS.dat']

exclude_lst = ['MARK', 'DRIF']

ed = {}
for file in ED_FILES:
  with open(file,'r') as fed:
    for line in fed:
      name, pv = line.split() 
      if pv != '-':
        if name not in ed:
          ed[name] = pv
        else:
          pass
          #print(f'dup name found in elementdevices.dat: {name}')

# Make .dat files
for model in LINES_ROOTS:
  with open(f'{model}_lines.precursor','r') as fpre, open(f'{model}_lines.dat','w') as fdat:
    for line in fpre:
      data = line.split()
      if data[2] not in exclude_lst:
        if data[2] != 'SBEN':
          if data[1] in ed:
            fdat.write(f'{ed[data[1]]} {" ".join(data[1:])}\n')
        else:
          if data[1][:-1] in ed:
            fdat.write(f'{ed[data[1][:-1]]} {" ".join(data[1:])}\n')

# Make .all files
for model in LINES_ROOTS:
  with open(f'{model}_lines.precursor','r') as fpre, open(f'{model}_lines.all','w') as fdat:
    for line in fpre:
      data = line.split()
      if data[2] != 'SBEN':
        if data[1] in ed:
          fdat.write(f'{ed[data[1]]} {" ".join(data[1:])}\n')
        else:
          fdat.write(f'- {" ".join(data[1:])}\n')
      else:
        if data[1][:-1] in ed:
          fdat.write(f'{ed[data[1][:-1]]} {" ".join(data[1:])}\n')
        else:
          fdat.write(f'- {" ".join(data[1:])}\n')
