#!/bin/env python3

from pytao import Tao
import os
import sys
import numpy as np

survey = []
kws = {}
kws['Multipole']   = {'madk':'MULT',
                      'params':['l','k0l','k1l','k2l','t0','k3l','t1','t2','t3']}  #Skew quads
kws['Solenoid']    = {'madk':'SOLE',
                      'params':['l',0,0,0,0,'ks',0,0,0]}
kws['Lcavity']     = {'madk':'LCAV',
                      'params':['l',0,0,0,0,'rf_frequency','voltage','phi0',0]}
kws['Instrument']  = {'madk':'INST',
                      'params':['l',0,0,0,0,0,0,0,0]}
kws['ECollimator'] = {'madk':'ECOL',
                      'params':['l',0,0,0,0,0,0,0,0]}
kws['RCollimator'] = {'madk':'ECOL',
                      'params':['l',0,0,0,0,0,0,0,0]}
kws['Monitor']     = {'madk':'MONI',
                      'params':['l',0,0,0,0,0,0,0,0]}
kws['HKicker']     = {'madk':'HKIC',
                      'params':['l',0,0,0,'kick',0,0,0,0]}
kws['VKicker']     = {'madk':'VKIC',
                      'params':['l',0,0,0,0,'kick',0,0,0]}
kws['Quadrupole']  = {'madk':'QUAD',
                      'params':['l',0,'k1',0,'tilt',0,0,0,0]}
kws['Sextupole']   = {'madk':'SEXT',
                      'params':['l',0,0,'k2','tilt',0,0,0,0]}
kws['RBend']       = {'madk':'RBEN',
                      'params':['l','angle','k1','k2','ref_tilt','e1','e2','h1','h2']}
kws['SBend']       = {'madk':'SBEN',
                      'params':['l','angle','k1','k2','ref_tilt','e1','e2','h1','h2']}
kws['Taylor']      = {'madk':'MATR',
                      'params':['l',0,0,0,0,0,0,0,0]}
kws['Wiggler']     = {'madk':'MATR',
                      'params':['l',0,0,0,0,0,0,0,0]}
kws['Marker']      = {'madk':'MARK',
                      'params':['l',0,0,0,0,0,0,0,0]}
kws['Drift']       = {'madk':'DRIF',
                      'params':['l',0,0,0,0,0,0,0,0]}

skips = ['Patch','Pipe','Beginning_Ele']
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
  tao = Tao(init_file=INITFILE[model], noplot=True)
  names = tao.lat_list("*", "ele.name")
  for ix,name in enumerate(names):
    print()
    print()
    key = tao.lat_list(ix,"ele.key")
    if key[0] not in kws.keys():
      print(f'missing: {name}: {key[0]}')
      sys.exit(1)
    template = kws[key[0]]
    if 'skip' in template:
      continue
    else:
      madk = template['madk']
      params = template['params']

    line = f'{madk:4s}{name.upper():16s}'

    if params[0] == 0:
      line = line + f'{0:12.6f}'
    else:
      result = tao.lat_list(ix,'ele.'+params[0])
      if len(result) == 0:
        print(f'lat_list returned empty list for key {key} param {params[0]}')
        sys.exit(1)
      val = float(result)
      line = line + f'{val:12.6f}'
    for n,param in enumerate(params[1:]):
      if n==3:
        line = line + "\n"
      if param == 0:
        line = line + f'{0:16.9E}'
      else:
        result = tao.lat_list(ix,'ele.'+param)
        if len(result) == 0:
          print(f'lat_list returned empty list for key {key} param {param}')
          sys.exit(1)
        val = loat(result)
        line = line + f'{val:16.9E}'
      
    print(line)















