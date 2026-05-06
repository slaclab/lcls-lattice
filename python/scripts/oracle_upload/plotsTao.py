#!/bin/env python3

from pytao import Tao, SubprocessTao
import os
import sys
import numpy as np
from datetime import datetime
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

special_names = {
'L0A':'L0A___',
'L0B':'L0B___',
'L1X':'L1X___',
}

params = ['s','beta_a','beta_b','phi_a','phi_b','eta_x','eta_y','e_tot']

LCLS_LATTICE_ENV = os.getenv('LCLS_LATTICE')
if LCLS_LATTICE_ENV is None:
  print('Error:  LCLS_LATTICE is not set')
  sys.exit(1)

BDIR = f'{LCLS_LATTICE_ENV}/bmad/'
MODELS=['sc_sxr','sc_hxr','sc_bsyd','sc_diag0','sc_dasel','sc_diag02',
        'cu_sxr','cu_hxr','sc_hxr2','sc_sxr2','sc_dasel2','sc_bsyd2']
LATFILE = {}
for model in MODELS:
  LATFILE[model] = f'{LCLS_LATTICE_ENV}/bmad/survey_models/{model}.lat.bmad'

timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

for model in MODELS:
  print(f'model {model}')
  with PdfPages(f'{model}_plots.pdf') as pdf:
    tao = Tao(lattice_file=LATFILE[model], plot_file="tao_plot.init", plot="mpl")
    #tao.update_plot_shapes("quadrupole", type_label="name", layout=True, floor=True)    
    #tao.plot("energy", save=f'{model}_twiss.png', include_layout=True, ylim=(0,5e9))

    if model in ['sc_diag0','sc_diag02']:
        tao.plot("energy", include_layout=True, ylim=(0,0.2e9))
    else:
        tao.plot("energy", include_layout=True, ylim=(0,9e9))
    fig = plt.gcf()
    pdf.savefig(fig)
    plt.close(fig)
    
    tao.plot("beta", include_layout=True)
    fig = plt.gcf()
    pdf.savefig(fig)
    plt.close(fig)

    tao.plot("dispersion", include_layout=True)
    fig = plt.gcf()
    pdf.savefig(fig)
    plt.close(fig)

    if model in ['sc_sxr','sc_hxr','sc_hxr2','sc_sxr2']:
        tao.plot("beta", include_layout=True, xlim=(3420,3700), ylim=(0,100))
        fig = plt.gcf()
        pdf.savefig(fig)
        plt.close(fig)

    if model in ['cu_sxr','cu_hxr']:
        tao.plot("beta", include_layout=True, xlim=(1375,1680), ylim=(0,160))
        fig = plt.gcf()
        pdf.savefig(fig)
        plt.close(fig)

