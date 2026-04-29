#!/bin/env python3

import os
from subprocess import run

LCLS_LATTICE_ENV = os.environ['LCLS_LATTICE']
assert LCLS_LATTICE_ENV != ''
lcls_lat_check_1 = run(f'ls {LCLS_LATTICE_ENV}/bmad/conversion',shell=True,capture_output=True)
assert lcls_lat_check_1.returncode == 0
print(f'{LCLS_LATTICE_ENV=}')

BMAD_CONVERT_SCRIPT = os.environ['MAD8_TO_BMAD']
assert BMAD_CONVERT_SCRIPT != ''
bmad_env_check_1 = run(f'ls {BMAD_CONVERT_SCRIPT}',shell=True,capture_output=True)
assert bmad_env_check_1.returncode == 0
print(f'{BMAD_CONVERT_SCRIPT=}')

WORK_DIR = LCLS_LATTICE_ENV + '/bmad/conversion/work'
TEMP_DIR = LCLS_LATTICE_ENV + '/bmad/conversion/temp'
DEST_DIR = os.path.expandvars('$LCLS_LATTICE/bmad/master/')
print(f'{WORK_DIR=}')
print(f'{TEMP_DIR=}')


# Patch in the slac2bmad package
import sys
sys.path.append(f'{LCLS_LATTICE_ENV}/bmad/conversion/python')

from slac2bmad.xsif import prepare_xsif, remove_comment_blocks, replace_set, replace_set_commands, fix_matrix, expand_names, fix_names, unfold_comments, fold_comments
from slac2bmad.desplit import desplit_eles, desplit_ele
from slac2bmad.replace import replace_element, replace_eles
from slac2bmad.bmad import finalize_bmad

from glob import glob
import shutil

import ast
import json


INCLUDE_DEFERRED = False

NEWELES = {}
NEWELES['umasxh'] = """
!------- SXR Undulator -------
!new my_umasxh_k = 5.0
!new umasxh: wiggler, 
!new         type = "VGHPU",
!new         L_period = 0.039, 
!new         n_period = 87, 
!new         b_max = my_umasxh_k * 2*pi*m_electron / (c_light * 0.039), 
!new         L = 87*0.039, 
!new         ds_step = 0.039*10
!new 
!new umasxh[L] = umasxh[L]/2 ! Will be doubled in desplitting process. 
!---------------------------------
umasxh: taylor, type = "VGHPU39", l = lsxuh, tt11 = 1.0, tt12 = lsxuh, tt21 = 0, tt22 = 1.0,
          tt33 = cos(lsxuh*sqrt(kqsx)), tt34 = sin(lsxuh*sqrt(kqsx))/sqrt(kqsx), tt43 = -sin(lsxuh*sqrt(kqsx))*sqrt(kqsx),
          tt44 = cos(lsxuh*sqrt(kqsx)), tt55 = 1.0, tt66 = 1.0, mat_und_k = ksxu, mat_und_l = lusxu
"""
NEWELES['umasxh_'] = """
!------- HXR Undulator -------
umasxh_: taylor, type = "VGHPU56", l = lsxuh_, tt11 = 1.0, tt12 = lsxuh_, tt21 = 0, tt22 = 1.0,
          tt33 = cos(lsxuh_*sqrt(kqsx_)), tt34 = sin(lsxuh_*sqrt(kqsx_))/sqrt(kqsx_),
          tt43 = -sin(lsxuh_*sqrt(kqsx_))*sqrt(kqsx_), tt44 = cos(lsxuh_*sqrt(kqsx_)), tt55 = 1.0, tt66 = 1.0, 
          mat_und_k = ksxu_, mat_und_l = lusxu_

!---------------------------------
    """
NEWELES['umahxh'] = """
!------- HXR Undulator -------
!new my_umahxh_k = 2.0
!new umahxh: wiggler, 
!new         type = "HGVPU",
!new         L_period = 0.026, 
!new         n_period = 129, 
!new         b_max = my_umahxh_k * 2*pi*m_electron / (c_light * 0.026), 
!new         L = 129*0.026, 
!new         tilt=pi/2,
!new         ds_step = 0.026*10
!new 
!new umahxh[L] = umahxh[L]/2 ! Will be doubled in desplitting process. 
umahxh: taylor, type = "HGVPU26", l = lhxuh, tt11 = cos(lhxuh*sqrt(kqhx)), tt12 = sin(lhxuh*sqrt(kqhx))/sqrt(kqhx),
          tt21 = -sin(lhxuh*sqrt(kqhx))*sqrt(kqhx), tt22 = cos(lhxuh*sqrt(kqhx)), tt33 = 1.0, tt34 = lhxuh, tt43 = 0, tt44 = 1.0,
          tt55 = 1.0, tt66 = 1.0, mat_und_k = khxu, mat_und_l = luhxu

!---------------------------------
    """
NEWELES['pssxh'] = """
!------- SXR Phase Shifter -------
!
! B_max = 2pi/lambda * sqrt(2*PHASE_INTEGRAL / L)
! 
!new pssxh_phase_integral = 3814e-9  !T^2 m^3, maximum, from: T^2mm^3 (180-3814)
!new pssxh_L        = 0.0825   ! m 
!new pssxh_L_period = 0.075 ! m 
!new pssxh: wiggler, type = "phase shifter", 
!new     L = pssxh_L,
!new     b_max = 2*pi / pssxh_L_period * sqrt(2 * pssxh_phase_integral / pssxh_L  ),
!new     n_period = 1
!new pssxh[L] = pssxh[L]/2 ! Will be doubled in desplitting process. 
pssxh: taylor, type = "PS75", l = lpssxh, tt11 = 1.0, tt12 = lpssxh, tt21 = 0, tt22 = 1.0,
          tt33 = cos(lpssxh*sqrt(kqpssx)), tt34 = sin(lpssxh*sqrt(kqpssx))/sqrt(kqpssx),
          tt43 = -sin(lpssxh*sqrt(kqpssx))*sqrt(kqpssx), tt44 = cos(lpssxh*sqrt(kqpssx)), tt55 = 1.0, tt66 = 1.0,
          mat_und_k = kpssx, mat_und_l = lupssx
!---------------------------------
"""
NEWELES['pssxh_'] = """
!------- SXR Phase Shifter -------
!
! B_max = 2pi/lambda * sqrt(2*PHASE_INTEGRAL / L)
! 
pssxh_: taylor, type = "PS97.5", l = lpssxh_, tt11 = 1.0, tt12 = lpssxh_, tt21 = 0, tt22 = 1.0,
          tt33 = cos(lpssxh_*sqrt(kqpssx_)), tt34 = sin(lpssxh_*sqrt(kqpssx_))/sqrt(kqpssx_),
          tt43 = -sin(lpssxh_*sqrt(kqpssx_))*sqrt(kqpssx_), tt44 = cos(lpssxh_*sqrt(kqpssx_)), tt55 = 1.0, tt66 = 1.0,
          mat_und_k = kpssx_, mat_und_l = lupssx_
!---------------------------------
"""
NEWELES['pshxh'] = """
!------- HXR Phase Shifter -------
!
! B_max = 2pi/lambda * sqrt(2*PHASE_INTEGRAL / L)
! 
!new pshxh_phase_integral = 490e-9  !T^2 m^3, maximum, from: T^2mm^3 (80-490)
!new pshxh_L        = 0.0495 ! m 
!new pshxh_L_period = 0.045 ! m 
!new pshxh: wiggler, type = "phase shifter", 
!new     L = pshxh_L,
!new     b_max = 2*pi / pshxh_L_period * sqrt(2 * pshxh_phase_integral / pshxh_L  ),
!new     n_period = 1
!new pshxh[L] = pshxh[L]/2 ! Will be doubled in desplitting process. 
pshxh: taylor, type = "PS45", l = lpshxh, tt11 = 1.0, tt12 = lpshxh, tt21 = 0, tt22 = 1.0,
          tt33 = cos(lpshxh*sqrt(kqpshx)), tt34 = sin(lpshxh*sqrt(kqpshx))/sqrt(kqpshx),
          tt43 = -sin(lpshxh*sqrt(kqpshx))*sqrt(kqpshx), tt44 = cos(lpshxh*sqrt(kqpshx)), tt55 = 1.0, tt66 = 1.0,
          mat_und_k = kpshx, mat_und_l = lupshx
!---------------------------------
"""
#-----------------
# XLEAP-II wigglers
NEWELES['umxl1h'] = """
!new !------- XLEAP-II wigglers -------
!new umxl0h: wiggler, 
!new         type = "LCLS-I",
!new         L_period = 0.555, 
!new         n_period = 6, 
!new         b_max = 0, ! = K * 2*pi*m_electron / (c_light * 0.55), 
!new         L = 6*0.555
!new         !ds_step = 0.55*10
!new 
!new umxl0h[L] = umxl0h[L]/2 ! Will be doubled in desplitting process. 
!new !---------------------------------
!new 
!new umxl1h: umxl0h
umxl1h: taylor, type = "LCLS-I", l = lundh, tt11 = r11xl1, tt12 = r12xl1, tt21 = r21xl1, tt22 = r22xl1, tt33 = r33xl1,
          tt34 = r34xl1, tt43 = r43xl1, tt44 = r44xl1, mat_und_k = kund, mat_und_l = lamu

"""
NEWELES['umxl3h'] = """
umxl3h: taylor, type = "LCLS-I", l = lundh, tt11 = r11xl3, tt12 = r12xl3, tt21 = r21xl3, tt22 = r22xl3, tt33 = r33xl3,
          tt34 = r34xl3, tt43 = r43xl3, tt44 = r44xl3, mat_und_k = kund, mat_und_l = lamu
"""
NEWELES['umxl4h'] = """
umxl4h: taylor, type = "LCLS-I", l = lundh, tt11 = r11xl4, tt12 = r12xl4, tt21 = r21xl4, tt22 = r22xl4, tt33 = r33xl4,
          tt34 = r34xl4, tt43 = r43xl4, tt44 = r44xl4, mat_und_k = kund, mat_und_l = lamu
"""
# This needs to be extended
NEWELES['duqxl'] = """
! Extend to account for real WIGGLER elements for XLEAP
duqxl: drift, L = 0.2166 + 0.03
"""


# CU only replacements
CU_NEWELES = {}
CU_NEWELES['lh_und'] = """
!------- Laser Heater Undulator for Copper Linac -------
!new my_lh_und_k = 1.38523
!new lh_und: wiggler, 
!new         type = "laser_heater_undulator",
!new         L_period = 0.054, 
!new         n_period = 10, 
!new         b_max = my_lh_und_k * 2*pi*m_electron / (c_light * 0.054), 
!new          L = 10*0.054 ! Was: 0.506263, 
!new         ds_step = 0.054
!new 
!new lh_und[L] = lh_und[L]/2 ! Will be doubled in desplitting process. 
lh_und: taylor, type = "LHund", l = lhunh, tt11 = 1.0, tt12 = lhunh, tt21 = 0, tt22 = 1.0, tt33 = cos(lhunh*sqrt(kqlh)),
          tt34 = r34h, tt43 = -sin(lhunh*sqrt(kqlh))*sqrt(kqlh), tt44 = cos(lhunh*sqrt(kqlh)),
          mat_und_k = k_und, mat_und_l = lam
!---------------------------------
    """
CU_NEWELES['dh03a'] = """
! Shorten so that lh_und has an integer number of poles
dh03a: drift, l = 0.09290825 - ( 10*0.054 - 0.506263 ) /2, type = "CSR"
"""
CU_NEWELES['dh03b'] = """
! Shorten so that lh_und has an integer number of poles
dh03b: drift, l = 0.08401830- ( 10*0.054 - 0.506263 ) /2, type = "CSR"
"""
# Append json replacements to CU_NEWELES
#CU_LINAC_REPLACEMENTS = json.load(open('bmad/conversion/replacements/good_cu_linac_replacements.json'))

cu_replacements_file = 'bmad/conversion/replacements/good_cu_linac_replacements.py'
with open(cu_replacements_file,'r') as f:
 CU_LINAC_REPLACEMENTS = ast.literal_eval(f.read())

for name, replace in CU_LINAC_REPLACEMENTS.items():
    CU_NEWELES[name.lower()+'_full'] = replace
# Append deferred replacements to CU_NEWELES
if INCLUDE_DEFERRED:
    CU_NEWELES.update(json.load(open('bmad/conversion/replacements/deferred_cu_replacements.json')))

# SC Only replacements
SC_NEWELES = {}
SC_NEWELES['umhtr'] = """
!------- Laser Heater Undulator for SC Linac -------
!new my_umhtr_k = 0.960143
!new 
!new umhtr: wiggler, 
!new         type = "laser_heater_undulator",
!new         L_period = 0.054, 
!new         n_period = 10, 
!new         b_max = my_umhtr_k * 2*pi*m_electron / (c_light * 0.054), 
!new         L = 10*0.054 ! Was: 0.506263, 
!new         ds_step = 0.054
!new 
!new umhtr[L] = umhtr[L]/2 ! Will be doubled in desplitting process. 
umhtr: taylor, type = "UMLHB", l = lhunh, tt11 = 1.0, tt12 = lhunh, tt21 = 0, tt22 = 1.0, tt33 = cos(lhunh*sqrt(kqlh)),
          tt34 = r34h, tt43 = -sin(lhunh*sqrt(kqlh))*sqrt(kqlh), tt44 = cos(lhunh*sqrt(kqlh)), tt55 = 1, tt66 = 1,
          mat_und_k = k_und, mat_und_l = lam
!---------------------------------
"""
SC_NEWELES['wigxlh'] = """
wigxlh: taylor, type = "variable gap", l = lwigh, tt11 = 1.0, tt12 = lwigh, tt21 = 0, tt22 = 1.0, tt33 = cos(argw),
          tt34 = r34w, tt43 = -sin(argw)*sqrt(kqwig), tt44 = cos(argw), mat_und_k = kwig, mat_und_l = lwigh
"""

SC_NEWELES['dh02c'] = """
! Shorten so that umhtr has an integer number of poles
dh02c: drift, l = 0.2795065 - ( 10*0.054 - 0.506263 ) /2 , type = "CSR" !0.297036
"""
SC_NEWELES['dh02d'] = """
! Shorten so that umhtr has an integer number of poles
dh02d: drift, l = 0.2724707 - ( 10*0.054 - 0.506263 ) /2, type = "CSR" !0.2900002
"""
# Bmad now supports mad8-like k0l moments
#  SC_NEWELES['qdg001'] = """
#  ! Replace k0l with quad offset and patch with y_pitch.
#  qdg001: quadrupole, type = "1.51Q7.00", l = lqs/2, aperture = rqs, k1 = kqbf0, y_offset=-4.83865231890650768E-003
#  """
#  SC_NEWELES['qdg003'] = """
#  ! Replace k0l with quad offset and patch with y_pitch.
#  qdg003: quadrupole, type = "1.51Q7.00", l = lqs/2, aperture = rqs, k1 = kqbf0, y_offset=-2.99813063290814820E-004
#  """
#  SC_NEWELES['dyqdg001'] = """
#  ! Replace k0l with quad offset and patch with y_pitch.
#  dyqdg001: patch, y_pitch = 9.49758257820075558E-003
#  """
#  SC_NEWELES['dyqdg003'] = """
#  ! Replace k0l with quad offset and patch with y_pitch.
#  dyqdg003: patch, y_pitch = 5.88487966838956720E-004
#  """
SC_NEWELES['tcxdg0'] = """
! mad8 describes tcav as lcavity.  Replace it with a crab_cavity.
tcxdg0: crab_cavity, type = "STCAV_X", rf_frequency = 2856 * 1e6, l = 20*in2m/2
"""
SC_NEWELES['tcydg0'] = """
! mad8 describes tcav as lcavity.  Replace it with a crab_cavity.
tcydg0: crab_cavity, type = "@4,STCAV_Y", rf_frequency = 2856 * 1e6, l = 20*in2m/2
"""

# Not needed. Desplitting handles cavities now.
# Add these repalcements
#SC_LINAC_REPLACEMENTS = json.load(open('replacements/good_sc_linac_replacements.json'))
#for name, replace in SC_LINAC_REPLACEMENTS.items():
#    SC_NEWELES[name.lower()+'_full'] = replace
# Append deferred replacements to SC_NEWELES
if INCLUDE_DEFERRED:
    SC_NEWELES.update(json.load(open('bmad/conversion/replacements/deferred_sc_replacements.json')))

CU_REPLACEMENTS = NEWELES.copy()
CU_REPLACEMENTS.update(CU_NEWELES)
SC_REPLACEMENTS = NEWELES.copy()
SC_REPLACEMENTS.update(SC_NEWELES)

#Cleanup from previous conversion run
run(f'rm -rf {TEMP_DIR}',shell=True)
run(f'mkdir {TEMP_DIR}',shell=True)
#run('rm -f *.xsif *.bmad *.digested*',shell=True)
run(f'cp $LCLS_LATTICE/mad/*.xsif {TEMP_DIR}',shell=True)

#Identify and prepare all xsif files
XSIF_FILES=[f for f in os.listdir(TEMP_DIR) if f.endswith('.xsif')]
print(XSIF_FILES)
for f in XSIF_FILES:
    prepare_xsif(f'{TEMP_DIR}/{f}', save=False)

#Identify Cu and SC xsif files
CU_MASTERS = [f for f in os.listdir('mad') if f.startswith('CU_') and f.endswith('xsif')]
SC_MASTERS = [f for f in os.listdir('mad') if f.startswith('SC_') and f.endswith('xsif')]

# exclude_strs will not go through the automatic-desplitter
exclude_strs = ['BUN1B','BUN1LEI','BUN2LEI','WIGX','UMXL','LH_UND','UMHTR','UMASX','UMAHX','PSSX','PSHX','K21_1B','K21_1C']

# new elements are added commented out with !new
shadows = ['duqxl','dh03a','dh03b','dh02c','dh02d']

shutil.copytree(TEMP_DIR, WORK_DIR, dirs_exist_ok=True)

def process_master(master, REPLACEMENTS):
    print(f'Converting {master}')

    #The BMAD_CONVERT_SCRIPT descends through mad8 call statements
    SCRIPT = f'python {BMAD_CONVERT_SCRIPT} --no_prepend_vars -f {master}'
    res = run(SCRIPT, shell=True, cwd=WORK_DIR)
    assert res.returncode == 0

    BMAD_FILES=glob(WORK_DIR+'/*bmad')

    for f in BMAD_FILES:
        finalize_bmad(f, replacements=REPLACEMENTS, verbose=False, exclude_strs=exclude_strs, shadows=shadows)  
        shutil.copy(f, DEST_DIR)
        os.remove(f)

for _m in CU_MASTERS:
    process_master(_m,CU_REPLACEMENTS)

for _m in SC_MASTERS:
    process_master(_m,SC_REPLACEMENTS)

#****************************
# cleanup conversion slop: conversion mistakes that can't be fixed more elegantly.
#****************************
# Bmad's mad8 to bmad translator replaces all instances of PROF with MONITOR.
# Thus, PROFILE becomes MONITORILE.  SFT has a type field containing PROFILE
SFT_file = 'bmad/master/SFT.bmad'
with open(SFT_file, 'r') as f:
    content = f.read()
content = content.replace('MONITORILE','PROFILE')
with open(SFT_file, 'w') as f:
    f.write(content)

#cleanup working areas
run(f'rm -r {TEMP_DIR}',shell=True)
run(f'rm -r {WORK_DIR}',shell=True)













