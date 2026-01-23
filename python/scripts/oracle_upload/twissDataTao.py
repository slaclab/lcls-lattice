#!/bin/env python3

from pytao import Tao
import os
import sys
import re
import numpy as np
from datetime import datetime
from decimal import Decimal, ROUND_HALF_UP
import json

special_names = {
'L0A':'L0A___',
'L0B':'L0B___',
'L1X':'L1X___',
}

params = ['s','beta_a','beta_b','phi_a','phi_b','eta_a','eta_b','e_tot']

LCLS_LATTICE_ENV = os.getenv('LCLS_LATTICE')
if LCLS_LATTICE_ENV is None:
  print('Error:  LCLS_LATTICE is not set')
  sys.exit(1)

BDIR = f'{LCLS_LATTICE_ENV}/bmad/'
MODELS=['sc_sxr','sc_hxr','sc_bsyd','sc_diag0','cu_sxr']
LATFILE = {}
for model in MODELS:
  LATFILE[model] = f'{LCLS_LATTICE_ENV}/bmad/survey_models/{model}.lat.bmad@{model}i'

def my_lat_list(ix, p):
  if p == 0:
    ret = 0
  else:
    ret = tao.lat_list(ix, f'ele.{p}')[0]
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

def double_round_new(x, ndigits):
  # handle float noise in a consistent manner.
  # eg ensure numbers like 0.1000049999999 are rounded to 5 digits as 0.10001
  # also ensure numbers like 0.145608456 are rounded to 6 digits as 0.145608
  d = Decimal.from_float(x)                 # keep exact float value
  q = Decimal(1).scaleb(-ndigits)           # 10**(-ndigits)
  return float(d.quantize(q, rounding=ROUND_HALF_UP))

for model in MODELS:
  with open(model+'_twiss.dat','w') as f:
    f.write(f'# Linux    Bmad Twiss/{timestamp}\n\n')
    f.write(f'# name, s, beta_a, beta_b, phi_a, phi_b, eta_a, eta_b, e_tot')
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

      if split_bend is not None:
        match = [key for key in key_dict if key[:-1] == name]
        name = match[split_bend]
      else:
        match = [key for key in key_dict if key == name]

      if match:
        pass
      elif name == 'BEGINNING':
        name = 'INITIAL'
      else:
        #If element not in key dictionary, does not go into Oracle Upload
        print(f'{name} not in dictionary')
        continue

      vals = [my_lat_list(ix,p) for p in params]

      line = f'{name:<11s}' + '   '.join([f'{x:>16.9E}' for x in vals])
      line = line + '\n'
        
      f.write(line)


















