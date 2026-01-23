#!/bin/env python3

from tao import Tao

LCLS_LATTICE_ENV = os.getenv('LCLS_LATTICE')
if LCLS_LATTICE_ENV is None:
  print('Error:  LCLS_LATTICE is not set')
  sys.exit(1)

BDIR = f'{LCLS_LATTICE_ENV}/bmad/'
MODELS=['sc_sxr','sc_hxr','sc_bsyd','sc_diag0','cu_sxr']
LATFILE = {}
for model in MODELS:
  LATFILE[model] = f'{LCLS_LATTICE_ENV}/bmad/survey_models/{model}.lat.bmad'

#'name', 's','beta_a','beta_b','phi_a','phi_b','eta_a','eta_b','e_tot'

for model in MODELS:
  with open(model+'_twiss.tape','w') as f:
    [name, 

