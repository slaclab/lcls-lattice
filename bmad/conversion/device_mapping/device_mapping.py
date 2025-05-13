#!/bin/env python3

import os
from subprocess import run

LCLS_LATTICE_ENV = os.environ['LCLS_LATTICE']
assert LCLS_LATTICE_ENV != ''
lcls_lat_check_1 = run(f'ls {LCLS_LATTICE_ENV}/bmad/conversion',shell=True,capture_output=True)
assert lcls_lat_check_1.returncode == 0

FACET2_LATTICE_ENV = os.environ['FACET2_LATTICE']
assert FACET2_LATTICE_ENV != ''
facet2_lat_check_1 = run(f'ls {FACET2_LATTICE_ENV}/bmad/conversion',shell=True,capture_output=True)
assert facet2_lat_check_1.returncode == 0

import pandas as pd
import json

# Table extracted from SLACPROD Oracle Database
MASTER = f'{LCLS_LATTICE_ENV}/bmad/conversion/from_oracle/lcls_elements.csv'

df = pd.read_csv(os.path.expandvars(MASTER))
# Remove empty
df = df[['Element', 'Control System Name']].dropna()

# Elements are unique
MADNAMES = list(df['Element'])
assert len(MADNAMES) == len(set(MADNAMES))
# Control System Names are not
DEVICENAMES = list(df['Control System Name'])
assert len(DEVICENAMES) >= len(set(DEVICENAMES))

# These devices have multiple elements - a mistake?
series  = df.groupby('Control System Name')['Element'].apply(list)
for i, val in series.items():
    if len(val) > 1:
        # Skip klystrons - these are expected to be duplicated
        if not val[0].startswith('K'):
            print(i, val)

# dict for lookup
DEVICE = dict(zip(MADNAMES, DEVICENAMES))
json.dump(DEVICE, open('element_devices.json', 'w'))

BDIR = f'{LCLS_LATTICE_ENV}/bmad/'

# All models
MODELS = [d for d in os.listdir(BDIR+'models/') if os.path.isdir(BDIR+'/models/'+d)]
INITFILE = {model:f'{LCLS_LATTICE_ENV}/bmad/models/{model}/tao.init' for model in MODELS}
for k,v, in INITFILE.items():
    print(f'{k:<16}{v}')

# Tack on FACET-II if availiable

FDIR = f'{FACET2_LATTICE_ENV}/bmad/'

if os.path.exists(FDIR):
    print('Adding FACET-II')
    model = 'f2_elec'
    ifile = f'{FDIR}/models/{model}/tao.init'
    if os.path.exists(ifile):
        print(f'Adding {model} model')
        MODELS.append(model)
        INITFILE[model] = ifile

from pytao import Tao

def ele_names(model):
    init = INITFILE[model]
    print(f'{model}')
    tao = Tao(f'-init {init} -noplot')
    names = tao.cmd('python lat_list 1@0>>*|model ele.name')
    return names

def remove_superslaves(names):
    return [x for x in names if '#' not in x]

def write_devicenames(unames, filename):
    my_names = remove_superslaves(unames)
    lines = ['! ---------',
             '! Device mapping derived from '+MASTER

            ]
    for name in my_names:
        if name in DEVICE:
            line = name+'[alias]='+ DEVICE[name]

        else:
            #continue
            line = '! No device listed for: '+name
        lines.append(line)    
    with open(filename, 'w') as f:
        for line in lines:
            f.write(line+'\n')
    print('Written:', filename)

CU_FILE = f'{BDIR}/master/LCLScu_devicenames.bmad'
CU_FILE_BAK = f'{BDIR}/master/LCLScu_devicenames-bak.bmad'
os.rename(CU_FILE,CU_FILE_BAK)
open(CU_FILE, 'a').close()  #make an empty file

_models = ['cu_hxr', 'cu_sxr', 'cu_spec']
_names = []
for _m in _models:
    print(_m)
    _names += ele_names(_m)
_unames = sorted(list(set(_names)))

write_devicenames(_unames, CU_FILE)

SC_FILE = f'{BDIR}/master/LCLSsc_devicenames.bmad'

_models = ['sc_hxr', 'sc_sxr', 'sc_diag0', 'sc_bsyd', 'sc_dasel']
_names = []
for _m in _models:
    print(_m)
    _names += ele_names(_m)
_unames = sorted(list(set(_names)))

write_devicenames(_unames, SC_FILE)

#os.environ['FACET2_LATTICE'] = 'path_to_facet2_directory'
if os.path.exists(FDIR):
    F2_FILE = f'{FDIR}/master/FACET2e_devicenames.bmad'
    _models = ['f2_elec']
    _names = []
    for _m in _models:
        print(_m)
        _names += ele_names(_m)
    _unames = sorted(list(set(_names)))

    write_devicenames(_unames, F2_FILE)

