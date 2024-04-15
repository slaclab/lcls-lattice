#!/bin/env python3

import pytest
from subprocess import run, Popen, PIPE, STDOUT
import os

my_env = os.environ.copy()
LCLS_LATTICE=my_env['LCLS_LATTICE']

MODELS = [
'sc_bsyd',
'sc_sxr',
'sc_hxr',
# 'cu_sxr',
# 'cu_spec',
# 'sc_diag0',
# 'cu_hxr',
# 'cu_inj',
# 'sc_dasel',
 #'cu_linac',
# 'sc_inj',
]

@pytest.mark.parametrize("model", MODELS)
def test_exec_mad8s(model):
  mad8s_commands = open(LCLS_LATTICE+'/mad/'+model.upper()+'_CI-Testing.mad8')
  mad8s_result = run(['../mad8s'],cwd=LCLS_LATTICE+'/mad', stdin=mad8s_commands, capture_output=True, text=True)
  assert os.path.exists(LCLS_LATTICE+'/mad/'+model.upper()+'_GUN_CI.twiss')

@pytest.mark.parametrize("model", MODELS)
def test_exec_mad8s(model):
  bmad_result = run(['../../../lc_unit_test_bmad',model+'.lat.bmad'],cwd=LCLS_LATTICE+'/bmad/models/'+model, capture_output=True, text=True)
  assert os.path.exists(LCLS_LATTICE+'/bmad/models/'+model+'/twiss.out')

def parse_file(file_name):
  data_lines = []
  with open(file_name,'r') as f:
    for line in f:
      if line.lstrip()[0] not in comments:
        data_lines.append(line.split())
  return data_lines

comments = ['!','*','@','$','#']

@pytest.mark.parametrize("model", MODELS)
def test_bmad_mad8s_agreement(model):
  # test 1
  # Compare beta_x as the end of both the mad and bmad sc_bsyd (cathode to dump) line
  tests_pass = True

  eps = 1e-5

  bmad_data = parse_file(LCLS_LATTICE+'/bmad/models/'+model+'/twiss.out')
  mad8_data = parse_file(LCLS_LATTICE+'/mad/'+model.upper()+'_GUN_CI.twiss')
    
  bmad_beta_x = float(bmad_data[-1][3])
  mad8_beta_x = float(mad8_data[-1][2])

  test = abs((bmad_beta_x-mad8_beta_x) / (bmad_beta_x+mad8_beta_x) / 2) 
  print(test<eps)
  assert test < eps

# test 2
# Compare beta_x as the end of both the mad and bmad sc_hxr (cathode to dump) line

#   under development

#test_exec_mad8s()
#test_exec_mad8s()
#test_bmad_mad8s_agreement()
