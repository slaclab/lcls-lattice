#!/bin/env python3

from pytao import Tao
import os
import sys
import numpy as np

default_dict = {
'SBend':'BEND',
'Taylor':'USEG',
'Quadrupole':'QUAD',
'Sectupole':'SEXT',
'Multipole':'INST',
'Solenoid':'SOLE',
'HKicker':'XCOR',
'VKicker':'YCOR',
'Monitor':'BPM',
'ECollimator':'PC',
'RCollimator':'COLL',
'Instrument':'INST',
'Marker':'MARK',
'Lcavity':'LCAV',
}

survey = []
kws = {}
kws['Beginning_Ele']   = {'madk':'    ',
                          'params':[0,0,0,0,0,0,0,0,0,0]} 
kws['Multipole']       = {'madk':'MULT',
                          'params':['L','K0L','K1L','K2L','X1_LIMIT','T0','K3L','T1','T2','T3','DESCRIP']} 
kws['Solenoid']        = {'madk':'SOLE',
                          'params':['L',0,0,0,'X1_LIMIT',0,'KS',0,0,0,'DESCRIP']}
kws['Lcavity']         = {'madk':'LCAV',
                          'params':['L',0,0,0,'X1_LIMIT',0,'RF_FREQUENCY','VOLTAGE','PHI0',0]}
kws['Instrument']      = {'madk':'INST',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0,'DESCRIP']}
kws['ECollimator']     = {'madk':'ECOL',
                          'params':['L',0,0,0,0,'X1_LIMIT','Y1_LIMIT',0,0,0,'DESCRIP']}
kws['RCollimator']     = {'madk':'RCOL',
                          'params':['L',0,0,0,0,'X1_LIMIT','Y1_LIMIT',0,0,0,'DESCRIP']}
kws['Monitor']         = {'madk':'MONI',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0,'DESCRIP']}
kws['Pipe']            = {'madk':'MONI',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['HKicker']         = {'madk':'HKIC',
                          'params':['L',0,0,0,'X1_LIMIT','KICK',0,0,0,0,'DESCRIP']}
kws['VKicker']         = {'madk':'VKIC',
                          'params':['L',0,0,0,'X1_LIMIT',0,'KICK',0,0,0,'DESCRIP']}
kws['Quadrupole']      = {'madk':'QUAD',
                          'params':['L',0,'K1',0,'X1_LIMIT','TILT',0,0,0,0,'DESCRIP']}
kws['Sextupole']       = {'madk':'SEXT',
                          'params':['L',0,0,'K2','X1_LIMIT','TILT',0,0,0,0,'DESCRIP']}
kws['RBend']           = {'madk':'RBEN',
                          'params':['L','ANGLE','K1','K2','HGAP','REF_TILT','E1','E2','H1','H2']}
kws['SBend']           = {'madk':'SBEN',
                          'params':['L','ANGLE','K1','K2','HGAP','REF_TILT','E1','E2','H1','H2','DESCRIP']}
kws['Taylor']          = {'madk':'MATR',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0,'DESCRIP']}
kws['Wiggler']         = {'madk':'MATR',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['Marker']          = {'madk':'MARK',
                          'params':[0,0,0,0,0,0,0,0,0,0,'DESCRIP']}
kws['Drift']           = {'madk':'DRIF',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}

skips = ['Patch']
for skip in skips:
  kws[skip] = {'skip':True}

LCLS_LATTICE_ENV = os.getenv('LCLS_LATTICE')
if LCLS_LATTICE_ENV is None:
  print('Error:  LCLS_LATTICE is not set')
  sys.exit(1)

BDIR = f'{LCLS_LATTICE_ENV}/bmad/'
#MODELS = [d for d in os.listdir(BDIR+'models/') if os.path.isdir(BDIR+'/models/'+d)]
MODELS=['sc_sxr'] #FOO
INITFILE = {model:f'{LCLS_LATTICE_ENV}/bmad/models/{model}/tao.init' for model in MODELS}

def my_lat_list(ix, p):
  if p == 0:
    ret = 0
  elif p == 'DESCRIP':
    ret = tao.ele_head(ix)['descrip']
  else:
    ret = tao.lat_list(ix, f'ele.{p}')[0]
  return ret

for model in MODELS:
  with open(model+'_survey.tape','w') as f:
    f.write('\n\n')
    tao = Tao(init_file=INITFILE[model], noplot=True)
    ix_eles = tao.lat_list('*', 'ele.ix_ele')
    suml = 0
    for ix in ix_eles[:-1]:
      name = tao.lat_list(ix,'ele.name')[0]
      key = tao.lat_list(ix,'ele.key')[0]
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
        name = 'INITIAL'
      name_use = name.split('#',1)[0].upper()
      line = f'{madk:4s}{name_use:16s}'

      val = my_lat_list(ix,params[0])
      suml += val
      line = line + f'{val:12.6f}'

      vals = [my_lat_list(ix,p) for p in params[1:]]
      if name == 'BEGL3B':
          print(vals)
      for n,val in enumerate(vals,1):
        if n==5:
          line = line + "\n"
        if key == 'Lcavity' and (params[n] == 'RF_FREQUENCY' or params[n] == 'VOLTAGE'):
          val = val / 1e6
        #if len(val) == 0:
        #  print(f'lat_list returned empty list for key {key} param {param}')
        #  sys.exit(1)
        if isinstance(val,(float,int)):
            line = line + f'{val:16.9E}'
        elif isinstance(val,str):
            line = line + f' {val:<16}'
        elif val is None:
            line = line + ' '*16
        else:
            print(f'val is of unknown type: {val=} {type(val)=}')
            bomb

      floor = tao.ele_floor(ix)['Reference']
      x,y,z,theta,phi,psi = map(float,floor)
      line = line + "\n" + f'{x:16.9E}{y:16.9E}{z:16.9E}{suml:16.9E}' + "\n"
      line = line + f'{theta:16.9E}{phi:16.9E}{psi:16.9E}\n'
        
      f.write(line)















