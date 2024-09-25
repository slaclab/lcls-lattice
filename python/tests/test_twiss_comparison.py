#!/bin/env python3

import pytest
from subprocess import run, Popen, PIPE, STDOUT
import os, platform

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

TOLS = [
#beta_x, beta_y, end_s
(1e-5,   1e-5,   1e-9), #sc_bsyd
(1e-5,   5e-5,   1e-9), #sc_sxr
(1e-5,   5e-5,   1e-9), #sc_hxr
(1e-2,   1e-2,   1e-9), #cu_sxr
(1e-2,   1e-2,   1e-9), #cu_hxr
(1e-2,   1e-2,   1e-9), #cu_spec
]

@pytest.fixture(scope='module',autouse=True)
def exec_mad8s():
  if not supported:
    pytest.skip('unsupported platform')
  for model in MODELS:
    mad8s_commands = open(LCLS_LATTICE+'/mad/'+model.upper()+'_CI_Testing.mad8')
    run([LCLS_LATTICE+'/mad8s'],cwd=LCLS_LATTICE+'/mad', stdin=mad8s_commands, capture_output=True, text=True)

@pytest.fixture(scope='module',autouse=True)
def exec_bmad():
  if not supported:
    pytest.skip('unsupported platform')
  for model in MODELS:
    bmad_result = run([LCLS_LATTICE+'/lc_unit_test_bmad',model+'.lat.bmad'],
                      cwd=LCLS_LATTICE+'/bmad/models/'+model, capture_output=True, text=True)
    print(bmad_result)

def parse_file(file_name):
  data_lines = []
  with open(file_name,'r') as f:
    for line in f:
      if line.lstrip()[0] not in comments:
        data_lines.append(line.split())
  return data_lines

comments = ['!','*','@','$','#']

@pytest.mark.parametrize("model", MODELS)
def test_bmad_ran(model):
  assert os.path.exists(LCLS_LATTICE+'/bmad/models/'+model+'/twiss.out')

@pytest.mark.parametrize("model", MODELS)
def test_mad8s_ran(model):
  assert os.path.exists(LCLS_LATTICE+'/mad/'+model.upper()+'_GUN_CI.twiss')

@pytest.mark.parametrize("model", MODELS)
def test_bmad_mad8s_agreement(model):
  # test 1
  # Compare beta_x and beta_y as the end of both the mad and bmad (cathode to dump) lines
  index = MODELS.index(model)
  eps = TOLS[index]

  bmad_data = parse_file(LCLS_LATTICE+'/bmad/models/'+model+'/twiss.out')
  mad8_data = parse_file(LCLS_LATTICE+'/mad/'+model.upper()+'_GUN_CI.twiss')
    
  bmad_beta_x = float(bmad_data[-1][3])
  mad8_beta_x = float(mad8_data[-1][2])
  bmad_beta_y = float(bmad_data[-1][11])
  mad8_beta_y = float(mad8_data[-1][5])
  bmad_end_s = float(bmad_data[-1][1])
  mad8_end_s = float(mad8_data[-1][1])

  assert abs((bmad_beta_x-mad8_beta_x) / (bmad_beta_x+mad8_beta_x) / 2) < eps[0]
  assert abs((bmad_beta_y-mad8_beta_y) / (bmad_beta_y+mad8_beta_y) / 2) < eps[1]
  assert abs((bmad_end_s-mad8_end_s) / (bmad_end_s+mad8_end_s) / 2) < eps[2]

