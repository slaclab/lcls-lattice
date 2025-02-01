#!/bin/env python3

from pytao import Tao
import os

kws = {}
kws['Multipole'] = {}  #Skew quads
kws['Multipole']['madk']='QUAD'
kws['Multipole']['outk']='QUAD'
kws['Multipole']['xalk']='QUAD'
kws['Solenoid'] = {}
kws['Solenoid']['madk']='SOLE'
kws['Solenoid']['outk']='SOLE'
kws['Solenoid']['xalk']='SOLE'
kws['Lcavity'] = {}
kws['Lcavity']['madk']='LCAV'
kws['Lcavity']['outk']='LCAV'
kws['Lcavity']['xalk']='BNCH'
kws['Marker'] = {}
kws['Marker']['madk']=None
kws['Marker']['outk']=None
kws['Marker']['xalk']=None
kws['Instrument'] = {}
kws['Instrument']['madk'] = 'INST'
kws['Instrument']['outk'] = 'INST'
kws['Instrument']['xalk'] = 'INST'
kws['Drift'] = {}
kws['Drift']['madk'] = None
kws['Drift']['outk'] = None
kws['Drift']['xalk'] = None
kws['Patch'] = {}
kws['Patch']['madk'] = None
kws['Patch']['outk'] = None
kws['Patch']['xalk'] = None
kws['Pipe'] = {}
kws['Pipe']['madk'] = None
kws['Pipe']['outk'] = None
kws['Pipe']['xalk'] = None
kws['ECollimator'] = {}
kws['ECollimator']['madk'] = 'ECOL'
kws['ECollimator']['outk'] = 'PC  '
kws['ECollimator']['xalk'] = 'ECOL'
kws['RCollimator'] = {}
kws['RCollimator']['madk'] = 'ECOL'
kws['RCollimator']['outk'] = 'PC  '
kws['RCollimator']['xalk'] = 'ECOL'
kws['Monitor'] = {}
kws['Monitor']['madk'] = 'MONI'
kws['Monitor']['outk'] = 'BPM '
kws['Monitor']['xalk'] = 'BPM '
kws['HKicker'] = {}
kws['HKicker']['madk'] = 'HKIC'
kws['HKicker']['outk'] = 'XCOR'
kws['HKicker']['xalk'] = 'XCOR'
kws['VKicker'] = {}
kws['VKicker']['madk'] = 'VKIC'
kws['VKicker']['outk'] = 'YCOR'
kws['VKicker']['xalk'] = 'YCOR'
kws['Quadrupole'] = {}
kws['Quadrupole']['madk'] = 'QUAD'
kws['Quadrupole']['outk'] = 'QUAD'
kws['Quadrupole']['xalk'] = 'QUAD'
kws['SBend'] = {}
kws['SBend']['madk'] = 'SBEN'
kws['SBend']['outk'] = 'BEND'
kws['SBend']['xalk'] = 'BEND'
kws['Taylor'] = {}
kws['Taylor']['madk'] = 'MATR'
kws['Taylor']['outk'] = 'USEG'
kws['Taylor']['xalk'] = 'USEG'
kws['Wiggler'] = {}
kws['Wiggler']['madk'] = 'MATR'
kws['Wiggler']['outk'] = 'USEG'
kws['Wiggler']['xalk'] = 'USEG'

LCLS_LATTICE_ENV = os.environ['LCLS_LATTICE']
BDIR = f'{LCLS_LATTICE_ENV}/bmad/'
MODELS = [d for d in os.listdir(BDIR+'models/') if os.path.isdir(BDIR+'/models/'+d)]
INITFILE = {model:f'{LCLS_LATTICE_ENV}/bmad/models/{model}/tao.init' for model in MODELS}
MODELS=['sc_sxr']

for model in MODELS[0:1]:
  tao = Tao(init_file=INITFILE[model], noplot=True)
  names = tao.lat_list("*", "ele.name")
  for name in names:
    key = tao.lat_list(name,"ele.key")
    if key[0] in kws.keys():
      continue
    print(f'{name}: {key[0]}')
