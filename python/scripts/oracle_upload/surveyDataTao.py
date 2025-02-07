#!/bin/env python3

from pytao import Tao
import os
import sys
import numpy as np

survey = []
kws = {}
kws['Beginning_Ele']   = {'madk':'    ',
                          'params':[0,0,0,0,0,0,0,0,0,0]} 
kws['Multipole']       = {'madk':'MULT',
                          'params':['L','K0L','K1L','K2L','X1_LIMIT','T0','K3L','T1','T2','T3']} 
kws['Solenoid']        = {'madk':'SOLE',
                          'params':['L',0,0,0,'X1_LIMIT',0,'KS',0,0,0]}
kws['Lcavity']         = {'madk':'LCAV',
                          'params':['L',0,0,0,'X1_LIMIT',0,'RF_FREQUENCY','VOLTAGE','PHI0',0]}
kws['Instrument']      = {'madk':'INST',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['ECollimator']     = {'madk':'ECOL',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['RCollimator']     = {'madk':'ECOL',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['Monitor']         = {'madk':'MONI',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['HKicker']         = {'madk':'HKIC',
                          'params':['L',0,0,0,'X1_LIMIT','KICK',0,0,0,0]}
kws['VKicker']         = {'madk':'VKIC',
                          'params':['L',0,0,0,'X1_LIMIT',0,'KICK',0,0,0]}
kws['Quadrupole']      = {'madk':'QUAD',
                          'params':['L',0,'K1',0,'X1_LIMIT','TILT',0,0,0,0]}
kws['Sextupole']       = {'madk':'SEXT',
                          'params':['L',0,0,'K2','X1_LIMIT','TILT',0,0,0,0]}
kws['RBend']           = {'madk':'RBEN',
                          'params':['L','ANGLE','K1','K2','X1_LIMIT','REF_TILT','E1','E2','H1','H2']}
kws['SBend']           = {'madk':'SBEN',
                          'params':['L','ANGLE','K1','K2','X1_LIMIT','REF_TILT','E1','E2','H1','H2']}
kws['Taylor']          = {'madk':'MATR',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['Wiggler']         = {'madk':'MATR',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['Marker']          = {'madk':'MARK',
                          'params':[0,0,0,0,0,0,0,0,0,0]}
kws['Drift']           = {'madk':'DRIF',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}

skips = ['Patch','Pipe']
for skip in skips:
  kws[skip] = {'skip':True}

LCLS_LATTICE_ENV = os.getenv('LCLS_LATTICE')
if LCLS_LATTICE_ENV is None:
  print('Error:  LCLC_LATTICE is not set')
  sys.exit(1)

BDIR = f'{LCLS_LATTICE_ENV}/bmad/'
#MODELS = [d for d in os.listdir(BDIR+'models/') if os.path.isdir(BDIR+'/models/'+d)]
MODELS=['sc_sxr'] #FOO
INITFILE = {model:f'{LCLS_LATTICE_ENV}/bmad/models/{model}/tao.init' for model in MODELS}


for model in MODELS:
  print()
  print()
  tao = Tao(init_file=INITFILE[model], noplot=True)
  ix_eles = tao.lat_list('*', 'ele.ix_ele')
  suml = 0
  for ix in ix_eles[:-1]:
    ele_info = tao.ele_head(ix)
    ele_info.update(tao.ele_gen_attribs(ix))

    #shoehorn multipoles into the ele_info struct
    multipoles = tao.ele_multipoles(ix)['data']
    ele_info.update({f'K{x}L':0.0 for x in range(5)})
    ele_info.update({f'T{x}':0.0 for x in range(5)})
    for multipole in multipoles:
      k = f'K{multipole["index"]}L'
      v = multipole['KnL']
      ele_info.update({k:v})
      k = f'T{multipole["index"]}'
      v = multipole['Tn']
      ele_info.update({k:v})

    name = ele_info['name']
    key = ele_info['key']
    if key not in kws.keys():
      print(f'missing: {name}: {key}')
      sys.exit(1)
    template = kws[key]
    if 'skip' in template:
      continue
    else:
      madk = template['madk']
      params = template['params']

    if name == 'BEGINNING':
      name = 'initial'
    name_use = name.split('#',1)[0].upper()
    line = f'{madk:4s}{name_use:16s}'

    if params[0] == 0:
      line = line + f'{0:12.6f}'
    else:
      val = ele_info[params[0]]
      #if len(val) == 0:
      #  print(f'lat_list returned empty list for key {key} param {params[0]}')
      #  sys.exit(1)
      suml += val
      line = line + f'{val:12.6f}'
    for n,param in enumerate(params[1:]):
      if n==4:
        line = line + "\n"
      if param == 0:
        line = line + f'{0:16.9E}'
      else:
        val = ele_info[param]
        if key == 'Lcavity' and (param == 'RF_FREQUENCY' or param == 'VOLTAGE'):
          val = val / 1e6
        #if len(val) == 0:
        #  print(f'lat_list returned empty list for key {key} param {param}')
        #  sys.exit(1)
        line = line + f'{val:16.9E}'
    floor = tao.ele_floor(ix)['Reference']
    x,y,z,theta,phi,psi = map(float,floor)
    line = line + "\n" + f'{x:16.9E}{y:16.9E}{z:16.9E}{suml:16.9E}' + "\n"
    line = line + f'{theta:16.9E}{phi:16.9E}{psi:16.9E}'
      
    print(line)















