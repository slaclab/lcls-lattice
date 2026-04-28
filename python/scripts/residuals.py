#!/bin/env python3

import matplotlib.pyplot as plt
from pytao import Tao
import numpy as np

comments = ['!','*','@','$','#']

def parse_file(file_name):
  data_lines = []
  with open(file_name,'r') as f:
    for line in f:
      if line.lstrip()[0] not in comments:
        data_lines.append(line.split())
  return data_lines

MODELS = [
'sc_bsyd',
'sc_sxr',
'sc_hxr',
'sc_dasel',
'cu_sxr',
'cu_hxr',
'cu_spec',
'sc_diag0',
]

def get_twiss_pytao(model):
  lattice_file = 'bmad/models/'+model+'/'+model+'.lat.bmad'
  twiss = {}
  tao = Tao(lattice_file=lattice_file,noplot=True)
  twiss['name'] = tao.lat_list("*",'ele.name',flags="-array_out -track_only")
  twiss['s'] = tao.lat_list("*",'ele.s',flags="-array_out -track_only")
  twiss['betax'] = tao.lat_list("*",'ele.beta_a',flags="-array_out -track_only")
  twiss['betay'] = tao.lat_list("*",'ele.beta_b',flags="-array_out -track_only")
  return twiss

def get_twiss_mad8(model):
  mad8_data = parse_file('mad/'+model.upper()+'_GUN_CI.twiss')
    
  twiss = {}
  twiss['name'] = [float(x[2]) for x in mad8_data]
  twiss['betax'] = [float(x[2]) for x in mad8_data]
  twiss['betay'] = [float(x[5]) for x in mad8_data]
  twiss['s']     = [float(x[1]) for x in mad8_data]
  return twiss

for model in MODELS:
  with open('residual_'+model+'.dat','w') as f:
    s_data = []
    bx_data = []
    by_data = []
    f.write('# res_bx def. (bx_bmad-bx_mad8)/(bx_bmad+bx_mad8)')
    f.write('# s, res_bx, res_by')
    twiss_bmad = get_twiss_pytao(model)
    twiss_mad8 = get_twiss_mad8(model)

    last = -99.0
    for bmad_s,bmad_bx,bmad_by in zip(twiss_bmad['s'], twiss_bmad['betax'], twiss_bmad['betay']):
      if bmad_s > last + 1e-6:
        for mad_s,mad_bx,mad_by in zip(twiss_mad8['s'], twiss_mad8['betax'], twiss_mad8['betay']):
          if( abs(bmad_s-mad_s) < 1e-5 ):
            bx_res = (bmad_bx-mad_bx)/(bmad_bx+mad_bx)
            by_res = (bmad_by-mad_by)/(bmad_by+mad_by)
            s_data.append(bmad_s)
            bx_data.append(bx_res)
            by_data.append(by_res)
            f.write('{} {} {}\n'.format(bmad_s,bx_res,by_res))
            last = bmad_s
            break
  plt.figure(figsize=(10,3))
  s_data = np.array(s_data)
  bx_data = np.array(bx_data)
  by_data = np.array(by_data)
  mask = s_data > 10.0
  plt.plot(s_data[mask], bx_data[mask], label='res(β$_x$)')
  plt.plot(s_data[mask], by_data[mask], label='res(β$_y$)')
  plt.ylabel('res(β$_{x,y}$) (%)')
  plt.legend()
  plt.xlabel('location (m)')
  plt.title(model+' (bmad-mad8)/(bmad+mad8)')
  plt.savefig(f'residual_{model}.png',dpi=300,bbox_inches='tight')
  plt.clf()

