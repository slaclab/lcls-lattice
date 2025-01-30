#!/bin/env python3

from pytao import Tao
import os

LCLS_LATTICE_ENV = os.environ['LCLS_LATTICE']
BDIR = f'{LCLS_LATTICE_ENV}/bmad/'
MODELS = [d for d in os.listdir(BDIR+'models/') if os.path.isdir(BDIR+'/models/'+d)]
INITFILE = {model:f'{LCLS_LATTICE_ENV}/bmad/models/{model}/tao.init' for model in MODELS}

for model in MODELS[0:1]:
  tao = Tao(init_file=INITFILE[model], noplot=True)
