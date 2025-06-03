#!/bin/env python3

from pytao import Tao
import os
import sys
import re
import numpy as np

# These are FDN defaults from the mad8 dict file'
fdn_defaults = {
'sben':'bend',
'matr':'useg',
'quad':'quad',
'sext':'sext',
'mult':'inst',
'sole':'sole',
'srot':'mark',
'hkic':'xcor',
'vkic':'ycor',
'moni':'bpm',
'ecol':'pc',
'rcol':'coll',
'inst':'inst',
'mark':'mark',
'lcav':'lcav',
'prof':'prof',
'wire':'wire',
'blmo':'blmo',
'imon':'imon',
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

def parse_fdn_file(filename):
  fdnfile = {}
  with open(filename,'r') as f:
    for line in f:
      x = [y.rstrip().strip("'").strip('"').upper() for y in re.split(r'[\[\]=]+',line.replace(' ',''))]
      if len(x)>1 and x[1] == 'DESCRIP':
        fdnfile[x[0]] = x[2]
  return fdnfile

cu_fdn = parse_fdn_file(f'{LCLS_LATTICE_ENV}/bmad/master/Cu_FDN.bmad')
sc_fdn = parse_fdn_file(f'{LCLS_LATTICE_ENV}/bmad/master/SC_FDN.bmad')

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
    if x['type'] == 'Lord':
      ret = int(x['location_name'].split('>>')[1])
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
      slave_status = get_slave_status(ix)

      if key not in kws.keys():
        print(f'missing: {name}: {key}')
        sys.exit(1)
      template = kws[key]
      if 'skip' in template:
        continue
      else:
        if slave_status:
          descrip_dict = extract_kv_pairs(tao.ele_head(slave_status)['descrip'])
        else:
          descrip_dict = extract_kv_pairs(tao.ele_head(ix)['descrip'])
        if 'mad8_key' in descrip_dict:
          madk = descrip_dict['mad8_key']
        else:
          #If elements has no madk, it does not belong in Oracle Upload.
          continue
        #Load default FDN 
        if madk in fdn_defaults:
          fdn = fdn_defaults[madk]
        else:
          fdn = None
        #Overwrite default FDN if it exists in FDN file
        if model.startswith('sc_'):
          if name in sc_fdn:
            fdn = sc_fdn[name] 
        elif model.startswith('cu_'):
          if name in sc_fdn:
            fdn = cu_fdn[name] 
        else:
          print('file prefix error')
          bomb
        params = template['params']

      if name == 'BEGINNING':
        name = 'INITIAL'
      name_use = name.split('#',1)[0].upper()
      line = f'{madk.upper():4s}{name_use:16s}'

      val = my_lat_list(ix,params[0])
      suml += val
      line = line + f'{val:12.6f}'

      vals = [my_lat_list(ix,p) for p in params[1:]]
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
      if fdn:
        line = line + f' {fdn.upper():<16}'

      floor = tao.ele_floor(ix)['Reference']
      x,y,z,theta,phi,psi = map(float,floor)
      line = line + "\n" + f'{x:16.9E}{y:16.9E}{z:16.9E}{suml:16.9E}' + "\n"
      line = line + f'{theta:16.9E}{phi:16.9E}{psi:16.9E}\n'
        
      f.write(line)















