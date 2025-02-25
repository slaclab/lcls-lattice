#!/bin/env python3

from subprocess import run
import os, platform
from pytao import Tao
import matplotlib.pyplot as plt

my_env = os.environ.copy()
LCLS_LATTICE=my_env['LCLS_LATTICE']

supported = False
if (platform.system() == 'Linux'):
  supported = True

MODELS = [
'sc_bsyd',
'sc_sxr',
'sc_hxr',
'cu_sxr',
'cu_hxr',
'cu_spec',
# 'sc_diag0',
# 'cu_inj',
# 'sc_dasel',
 #'cu_linac',
# 'sc_inj',
]

def exec_mad8s(model):
  if not supported:
    pytest.skip('unsupported platform')
  for model in MODELS:
    mad8s_commands = open(LCLS_LATTICE+'/mad/'+model.upper()+'_CI_Testing.mad8')
    run([LCLS_LATTICE+'/mad8s'],cwd=LCLS_LATTICE+'/mad', stdin=mad8s_commands, capture_output=True, text=True)
    assert os.path.exists(LCLS_LATTICE+'/mad/'+model.upper()+'_GUN_CI.twiss')

comments = ['!','*','@','$','#']

def parse_file(file_name):
  data_lines = []
  with open(file_name,'r') as f:
    for line in f:
      if line.lstrip()[0] not in comments:
        data_lines.append(line.split())
  return data_lines

for model in MODELS:
  exec_mad8s(model)
  mad8_data = parse_file(LCLS_LATTICE+'/mad/'+model.upper()+'_GUN_CI.twiss')
    
  twiss = {}
  twiss['betax'] = [float(x[2]) for x in mad8_data]
  twiss['betay'] = [float(x[5]) for x in mad8_data]
  twiss['s']     = [float(x[1]) for x in mad8_data]

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
  plt.title(model+' (mad8)')
  plt.savefig(f'beta_{model}_mad8.png',dpi=300,bbox_inches='tight')
  plt.clf()

