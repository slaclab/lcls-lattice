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

import json


INCLUDE_DEFERRED = False

NEWELES = {}
NEWELES['umasxh'] = """
!------- SXR Undulator -------
my_umasxh_k = 5.0
umasxh: wiggler, 
        type = "VGHPU",
        L_period = 0.039, 
        n_period = 87, 
        b_max = my_umasxh_k * 2*pi*m_electron / (c_light * 0.039), 
        L = 87*0.039, 
        ds_step = 0.039*10

umasxh[L] = umasxh[L]/2 ! Will be doubled in desplitting process. 
!---------------------------------
"""
NEWELES['umahxh'] = """
!------- HXR Undulator -------
my_umahxh_k = 2.0
umahxh: wiggler, 
        type = "HGVPU",
        L_period = 0.026, 
        n_period = 129, 
        b_max = my_umahxh_k * 2*pi*m_electron / (c_light * 0.026), 
        L = 129*0.026, 
        tilt=pi/2,
        ds_step = 0.026*10

umahxh[L] = umahxh[L]/2 ! Will be doubled in desplitting process. 
!---------------------------------
    """
NEWELES['pssxh'] = """
!------- SXR Phase Shifter -------
!
! B_max = 2pi/lambda * sqrt(2*PHASE_INTEGRAL / L)
! 
pssxh_phase_integral = 3814e-9  !T^2 m^3, maximum, from: T^2mm^3 (180-3814)
pssxh_L        = 0.0825   ! m 
pssxh_L_period = 0.075 ! m 
pssxh: wiggler, type = "phase shifter", 
    L = pssxh_L,
    b_max = 2*pi / pssxh_L_period * sqrt(2 * pssxh_phase_integral / pssxh_L  ),
    n_period = 1
pssxh[L] = pssxh[L]/2 ! Will be doubled in desplitting process. 
!---------------------------------
"""
NEWELES['pshxh'] = """
!------- HXR Phase Shifter -------
!
! B_max = 2pi/lambda * sqrt(2*PHASE_INTEGRAL / L)
! 
pshxh_phase_integral = 490e-9  !T^2 m^3, maximum, from: T^2mm^3 (80-490)
pshxh_L        = 0.0495 ! m 
pshxh_L_period = 0.045 ! m 
pshxh: wiggler, type = "phase shifter", 
    L = pshxh_L,
    b_max = 2*pi / pshxh_L_period * sqrt(2 * pshxh_phase_integral / pshxh_L  ),
    n_period = 1
pshxh[L] = pshxh[L]/2 ! Will be doubled in desplitting process. 
!---------------------------------
"""
#-----------------
# XLEAP-II wigglers
NEWELES['umxl1h'] = """
!------- XLEAP-II wigglers -------
umxl0h: wiggler, 
        type = "LCLS-I",
        L_period = 0.555, 
        n_period = 6, 
        b_max = 0, ! = K * 2*pi*m_electron / (c_light * 0.55), 
        L = 6*0.555
        !ds_step = 0.55*10

umxl0h[L] = umxl0h[L]/2 ! Will be doubled in desplitting process. 
!---------------------------------

umxl1h: umxl0h

"""
# Inherit from umxl0h
NEWELES['umxl2h'] = """
umxl2h: umxl0h
"""
NEWELES['umxl3h'] = """
umxl3h: umxl0h
"""
NEWELES['umxl4h'] = """
umxl4h: umxl0h
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
my_lh_und_k = 1.38523
lh_und: wiggler, 
        type = "laser_heater_undulator",
        L_period = 0.054, 
        n_period = 10, 
        b_max = my_lh_und_k * 2*pi*m_electron / (c_light * 0.054), 
         L = 10*0.054 ! Was: 0.506263, 
        ds_step = 0.054

lh_und[L] = lh_und[L]/2 ! Will be doubled in desplitting process. 
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
CU_LINAC_REPLACEMENTS = json.load(open('bmad/conversion/replacements/good_cu_linac_replacements.json'))
for name, replace in CU_LINAC_REPLACEMENTS.items():
    CU_NEWELES[name.lower()+'_full'] = replace
# Append deferred replacements to CU_NEWELES
if INCLUDE_DEFERRED:
    CU_NEWELES.update(json.load(open('bmad/conversion/replacements/deferred_cu_replacements.json')))

# SC Only replacements
SC_NEWELES = {}
SC_NEWELES['umhtr'] = """
!------- Laser Heater Undulator for SC Linac -------
my_umhtr_k = 0.960143

umhtr: wiggler, 
        type = "laser_heater_undulator",
        L_period = 0.054, 
        n_period = 10, 
        b_max = my_umhtr_k * 2*pi*m_electron / (c_light * 0.054), 
        L = 10*0.054 ! Was: 0.506263, 
        ds_step = 0.054

umhtr[L] = umhtr[L]/2 ! Will be doubled in desplitting process. 
!---------------------------------
    """
SC_NEWELES['dh02c'] = """
! Shorten so that umhtr has an integer number of poles
dh02c: drift, l = 0.2795065 - ( 10*0.054 - 0.506263 ) /2 , type = "CSR" !0.297036
"""
SC_NEWELES['dh02d'] = """
! Shorten so that umhtr has an integer number of poles
dh02d: drift, l = 0.2724707 - ( 10*0.054 - 0.506263 ) /2, type = "CSR" !0.2900002
"""
SC_NEWELES['qdg001'] = """
! Replace k0l with quad offset and patch with y_pitch.
qdg001: quadrupole, type = "1.51Q7.00", l = lqs/2, aperture = rqs, k1 = kqbf0, y_offset=-5.03544523659801846E-003
"""
SC_NEWELES['qdg003'] = """
! Replace k0l with quad offset and patch with y_pitch.
qdg003: quadrupole, type = "1.51Q7.00", l = lqs/2, aperture = rqs, k1 = kqbf0, y_offset=-4.18723145115109838E-004
"""
SC_NEWELES['dyqdg001'] = """
dyqdg001: marker
"""
SC_NEWELES['dyqdg001a'] = """
! Replace k0l with quad offset and patch with y_pitch.
dyqdg001a: patch, y_pitch = 3.08416446042434310E-003
"""
SC_NEWELES['dyqdg001b'] = """
! Replace k0l with quad offset and patch with y_pitch.
dyqdg001b: patch, y_pitch = 7.01203984191581167E-003
"""
SC_NEWELES['dyqdg003'] = """
dyqdg003: marker
"""
SC_NEWELES['dyqdg003a'] = """
! Replace k0l with quad offset and patch with y_pitch.
dyqdg003a: patch, y_pitch = -1.88994601141060660E-003
"""
SC_NEWELES['dyqdg003b'] = """
! Replace k0l with quad offset and patch with y_pitch.
dyqdg003b: patch, y_pitch =  2.03871586661245191E-003
"""
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
exclude_strs = ['BUN1B','WIGX','UMXL','LH_UND','UMHTR','UMASX','UMAHX','PSSX','PSHX','K21_1B','K21_1C']

# new elements are added commented out with !new
shadows = ['umasxh','umahxh','pssxh','pshxh','umxl1h','umxl2h','umxl3h','umxl4h',
           'duqxl','lh_und','dh03a','dh03b','umhtr','dh02c','dh02d']

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













