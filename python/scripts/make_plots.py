#!/bin/env python3

import matplotlib.pyplot as plt
import os
from pytao import Tao
import numpy as np

my_env = os.environ.copy()
LCLS_LATTICE=my_env['LCLS_LATTICE']

MODELS = [
'sc_bsyd',
'sc_sxr',
'sc_hxr',
'sc_dasel',
'cu_sxr',
'cu_hxr',
'cu_spec',
# 'sc_diag0',
# 'cu_inj',
#'cu_linac',
# 'sc_inj',
]

def get_twiss_pytao(lattice_file):
  twiss = {}
  tao = Tao(lattice_file=lattice_file,noplot=True)
  twiss['name'] = tao.lat_list("*",'ele.name',flags="-array_out -track_only")
  twiss['s'] = tao.lat_list("*",'ele.s',flags="-array_out -track_only")
  twiss['betax'] = tao.lat_list("*",'ele.beta_a',flags="-array_out -track_only")
  twiss['betay'] = tao.lat_list("*",'ele.beta_b',flags="-array_out -track_only")
  return twiss

for model in MODELS:
  twiss = get_twiss_pytao(LCLS_LATTICE+'/bmad/models/'+model+'/'+model+'.lat.bmad')
  plt.figure(figsize=(10,3))
  if model == 'sc_dasel':
    ix = twiss['name'].index('ENDBSYA_2')+1
    plt.plot(twiss['s'][:ix],np.sqrt(twiss['betax'][:ix]), label='√β$_x$')
    plt.plot(twiss['s'][:ix],np.sqrt(twiss['betay'][:ix]), label='√β$_y$')
    plt.ylabel('√β$_{x,y}$ (m)')
  else:
    plt.plot(twiss['s'],twiss['betax'], label='β$_x$')
    plt.plot(twiss['s'],twiss['betay'], label='β$_y$')
    plt.ylabel('β$_{x,y}$ (m)')
  plt.legend()
  plt.xlabel('location (m)')
  plt.title(model)
  plt.savefig(f'beta_{model}.png',dpi=300,bbox_inches='tight')
  plt.clf()
