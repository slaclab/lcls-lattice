#!/bin/env python3

from pytao import Tao
import os
import sys
import re
import numpy as np
from datetime import datetime
from decimal import Decimal, ROUND_HALF_UP

special_names = {
'L0A':'L0A___',
'L0B':'L0B___',
'L1X':'L1X___',
}

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
                          'params':['L',0,0,0,0,'X1_LIMIT','Y1_LIMIT',0,0,0]}
kws['RCollimator']     = {'madk':'RCOL',
                          'params':['L',0,0,0,0,'X1_LIMIT','Y1_LIMIT',0,0,0]}
kws['Monitor']         = {'madk':'MONI',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['Pipe']            = {'madk':'MONI',
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
                          'params':['L','ANGLE','K1','K2','HGAP','REF_TILT','E1','E2','H1','H2']}
kws['SBend']           = {'madk':'SBEN',
                          'params':['L','ANGLE','K1','K2','HGAP','REF_TILT','E1','E2','H1','H2']}
kws['Taylor']          = {'madk':'MATR',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['Wiggler']         = {'madk':'MATR',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['Marker']          = {'madk':'MARK',
                          'params':[0,0,0,0,0,0,0,0,0,0]}
kws['Drift']           = {'madk':'DRIF',
                          'params':['L',0,0,0,'X1_LIMIT',0,0,0,0,0]}
kws['Patch']           = {'madk':'SROT',
                          'params':[0,0,0,0,0,0,'TILT',0,0,0]}
kws['Fixer']           = {'madk':'FIXR',
                          'params':[0,0,0,0,0,0,0,0,0,0]}
kws['Crab_Cavity']     = {'madk':'LCAV',
                          'params':['L',0,0,0,'X1_LIMIT',0,'RF_FREQUENCY','VOLTAGE','PHI0',0]}

#skips = ['Patch']
skips = []
for skip in skips:
  kws[skip] = {'skip':True}

LCLS_LATTICE_ENV = os.getenv('LCLS_LATTICE')
if LCLS_LATTICE_ENV is None:
  print('Error:  LCLS_LATTICE is not set')
  sys.exit(1)

BDIR = f'{LCLS_LATTICE_ENV}/bmad/'
#MODELS=['sc_sxr']
MODELS=['sc_sxr','sc_hxr','sc_bsyd','sc_diag0','sc_dasel','sc_sfts','cu_sxr','cu_hxr','cu_sfth','cu_gspec','cu_spec']
LATFILE = {}
for model in MODELS:
  if model.startswith('sc_'):
    LATFILE[model] = f'{LCLS_LATTICE_ENV}/bmad/models/{model}/{model}.lat.bmad'

  elif model.startswith('cu_'):
    LATFILE[model] = f'{LCLS_LATTICE_ENV}/bmad/models/{model}/{model}_svy.lat.bmad'

def my_lat_list(ix, p):
  if p == 0:
    ret = 0
  else:
    ret = tao.lat_list(ix, f'ele.{p}')[0]
  return ret

def extract_kv_pairs(text):
  pattern = r'(\w+):(\w+)'
  pairs = re.findall(pattern, text)
  ret = {}
  for kv in pairs:
    ret[kv[0]] = kv[1]
  return ret

def get_slave_status(ix):
  slave_status = tao.ele_lord_slave(ix)
  ret = None
  for x in slave_status:
    if x['type'] == 'Lord' and x['status'] == 'Super_Lord':
      ret = int(x['location_name'].split('>>')[1])
  return ret
  
key_dict = {}
with open(f'unified_keys.dat','r') as fkey:
  for line in fkey:
    if line.strip().startswith("#"):
      continue
    data = line.split()
    name, madk = data[0:2]
    dbkey = ''
    if len(data) > 2:
      dbkey = data[2]
    key_dict[name] = [madk,dbkey]

timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

def double_round(x,n):
  # handle float noise in a consistent manner.
  # eg ensure numbers like 0.1000049999999 are consistently rounded to 0.10001
  a = Decimal(x)
  a = a.quantize(Decimal('10')**-(n+1),rounding=ROUND_HALF_UP)
  return a.quantize(Decimal('10')**-n,rounding=ROUND_HALF_UP)

def double_round_new(x, ndigits):
  # handle float noise in a consistent manner.
  # eg ensure numbers like 0.1000049999999 are rounded to 5 digits as 0.10001
  # also ensure numbers like 0.145608456 are rounded to 6 digits as 0.145608
  d = Decimal.from_float(x)                 # keep exact float value
  q = Decimal(1).scaleb(-ndigits)           # 10**(-ndigits)
  return float(d.quantize(q, rounding=ROUND_HALF_UP))

for model in MODELS:
  with open(model+'_survey.tape','w') as f:
    f.write(f'Linux    Bmad Survey/{timestamp}\n\n')
    tao = Tao(lattice_file=LATFILE[model], noplot=True)
    ix_eles = tao.lat_list('*', 'ele.ix_ele')
    suml = 0
    for ix in ix_eles[:-1]:
      name = tao.lat_list(ix,'ele.name')[0]
      key = tao.lat_list(ix,'ele.key')[0]
      inspect_name = name.split('#')
      split_bend = None
      if len(inspect_name) > 1:
        if inspect_name[0] in special_names:
          name = special_names[inspect_name[0]] + inspect_name[1]
        elif key == 'Lcavity' and not name.startswith(('TCAV','K','TCX','TCY')):
          if inspect_name[1] == '1':
            name = inspect_name[0] + "A"
          elif inspect_name[1] == '2':
            name = inspect_name[0] + "B"
        elif key == 'Lcavity' and name.startswith('K'):
            name = inspect_name[0] + inspect_name[1]
        elif key in ('Solenoid','Quadrupole','Sextupole','Lcavity'):
          name = inspect_name[0]
        elif key == 'SBend':
          if inspect_name[1] == '1':
            split_bend = 0
            name = inspect_name[0]
          elif inspect_name[1] == '2':
            split_bend = 1
            name = inspect_name[0]
        else:
            name = inspect_name[0]

      ele_lord_slave = tao.ele_lord_slave(ix)
      energy = tao.lat_list(ix,'ele.e_tot')[0] / 1e9

      if key not in kws.keys():
        print(f'missing from kws in script: {name}: {key}')
        sys.exit(1)
      template = kws[key]
      if 'skip' in template:
        continue
      else:
        if split_bend is not None:
          match = [key for key in key_dict if key[:-1] == name]
          name = match[split_bend]
        else:
          match = [key for key in key_dict if key == name]

        if match:
          madk = key_dict[match[0]][0]
          upload_name = key_dict[match[0]][1]
        elif name == 'BEGINNING':
          name = 'INITIAL'
          madk = ''
          upload_name = ''
        else:
          #If element not in key dictionary, does not go into Oracle Upload
          print(f'{name} not in dictionary')
          continue
        slave_status = get_slave_status(ix)
        if slave_status:
          ele_type = tao.ele_head(slave_status)['type']
        else:
          ele_type = tao.ele_head(ix)['type']
        params = template['params']

      name_use = name.split('#',1)[0].upper()
      line = f'{madk.upper():4s}{name_use:16s}'

      val = my_lat_list(ix,params[0])
      suml += val
      line = line + f'{double_round_new(val,6):12.6f}'

      vals = [my_lat_list(ix,p) for p in params[1:]]
      for n,val in enumerate(vals,1):
        if n==5:
          line = line + f' {ele_type[:16]:<16}' + f'  {energy:.9E}' + '\n'
        if key in ['Lcavity','Crab_Cavity'] and (params[n] == 'RF_FREQUENCY' or params[n] == 'VOLTAGE'):
          val = val / 1e6
        if isinstance(val,(float,int)):
            line = line + f'{val:16.9E}'
        elif isinstance(val,str):
            line = line + f' {val:<16}'
        elif val is None:
            line = line + ' '*16
        else:
            print(f'val is of unknown type: {val=} {type(val)=}')
            bomb
      line = line + f' {upload_name}'

      floor = tao.ele_floor(ix)['Reference']
      x,y,z,theta,phi,psi = map(float,floor)
      line = line + "\n" + f'{x:16.9E}{y:16.9E}{z:16.9E}{suml:16.9E}' + "\n"
      line = line + f'{theta:16.9E}{phi:16.9E}{psi:16.9E}\n'
        
      f.write(line)
    f.write('\n')
    f.write(f"{' '*33}{suml:.9E}")




