#!/bin/env python3

import pytest
from subprocess import run, Popen, PIPE, STDOUT
import os, platform
from pytao import Tao
from pathlib import Path

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
'sc_dasel',
'sc_diag0',
'sc_diag02',
'sc_diagis',
# 'cu_inj',
 #'cu_linac',
# 'sc_inj',
]

TOLS = {}           #beta_x, beta_y, end_s
TOLS['sc_bsyd']  =  (1e-5,   1e-5,   1e-9)
TOLS['sc_sxr']   =  (5e-5,   5e-5,   1e-9)
TOLS['sc_hxr']   =  (1e-5,   5e-5,   1e-9)
TOLS['sc_dasel'] =  (1e-5,   5e-5,   1e-9)
TOLS['sc_diag0'] =  (1e-5,   5e-5,   1e-9)
TOLS['sc_diag02'] = (1e-5,   5e-5,   1e-9)
TOLS['sc_diagis'] = (1e-5,   5e-5,   1e-9)
TOLS['cu_sxr']   =  (2e-2,   2e-2,   1e-9)
TOLS['cu_hxr']   =  (2e-2,   2e-2,   1e-9)
TOLS['cu_spec']  =  (2e-2,   2e-2,   1e-9)

@pytest.fixture(scope='module',autouse=True)
def exec_mad8s():
  if not supported:
    pytest.skip('unsupported platform')
  for model in MODELS:
    mad8s_commands = open(LCLS_LATTICE+'/mad/'+model.upper()+'_CI_Testing.mad8')
    run([LCLS_LATTICE+'/mad8s'],cwd=LCLS_LATTICE+'/mad', stdin=mad8s_commands, capture_output=True, text=True)

def get_end_params_pytao(lattice_file):
  tao = Tao(lattice_file=lattice_file,noplot=True)
  end_params = tao.ele_twiss("end",verbose=False)
  end_params['s'] = tao.lat_list("end","ele.s",verbose=False)
  #make Twiss artifacts to assist with debugging
  s = tao.lat_list("*", "ele.s")
  bx = tao.lat_list("*", "ele.a.beta")
  by = tao.lat_list("*", "ele.a.beta")
  artifact_file_name = Path(lattice_file).stem+'.twiss' 
  with open(artifact_file_name,'w') as f:
    for s_,bx_,by_ in zip(s,bx,by):
      f.write('{}   {}   {}\n'.format(s_,bx_,by_))
  return end_params

def parse_file(file_name):
  data_lines = []
  with open(file_name,'r') as f:
    for line in f:
      if line.lstrip()[0] not in comments:
        data_lines.append(line.split())
  return data_lines

comments = ['!','*','@','$','#']

@pytest.mark.parametrize("model", MODELS)
def test_mad8s_ran(model):
  assert os.path.exists(LCLS_LATTICE+'/mad/'+model.upper()+'_GUN_CI.twiss')

@pytest.mark.parametrize("model", MODELS)
def test_bmad_mad8s_agreement(model):
  # test 1
  # Compare beta_x and beta_y as the end of both the mad and bmad (cathode to dump) lines
  eps = TOLS[model]

  mad8_data = parse_file(LCLS_LATTICE+'/mad/'+model.upper()+'_GUN_CI.twiss')
  pytao_result = get_end_params_pytao(LCLS_LATTICE+'/bmad/models/'+model+'/'+model+'.lat.bmad')
    
  pytao_beta_x = pytao_result['beta_a']
  mad8_beta_x = float(mad8_data[-1][2])
  pytao_beta_y = pytao_result['beta_b']
  mad8_beta_y = float(mad8_data[-1][5])
  pytao_end_s = pytao_result['s']
  mad8_end_s = float(mad8_data[-1][1])


  test_beta_x = abs((pytao_beta_x-mad8_beta_x) / (pytao_beta_x+mad8_beta_x) / 2)
  test_beta_y = abs((pytao_beta_y-mad8_beta_y) / (pytao_beta_y+mad8_beta_y) / 2)
  test_s = abs((pytao_end_s-mad8_end_s) / (pytao_end_s+mad8_end_s) / 2)  
  assert test_beta_x < eps[0], f'beta_x fail {test_beta_x} < {eps[0]}'
  assert test_beta_y < eps[1], f'beta_y fail {test_beta_y} < {eps[1]}'
  assert test_s < eps[2], f's fail {test_s} < {eps[2]}'


