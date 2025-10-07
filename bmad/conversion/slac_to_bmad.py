#!/bin/env python3

import os
from subprocess import run

LCLS_LATTICE_ENV = os.environ['LCLS_LATTICE']
assert LCLS_LATTICE_ENV != ''
lcls_lat_check_1 = run(f'ls {LCLS_LATTICE_ENV}/bmad/conversion',shell=True,capture_output=True)
assert lcls_lat_check_1.returncode == 0
print(f'{LCLS_LATTICE_ENV=}')

BMAD_ENV = os.environ['ACC_ROOT_DIR']
assert BMAD_ENV != ''
bmad_env_check_1 = run(f'ls {BMAD_ENV}/util/dist_source_me',shell=True,capture_output=True)
assert bmad_env_check_1.returncode == 0
print(f'{BMAD_ENV=}')

TEMP_DIR = LCLS_LATTICE_ENV + '/bmad/conversion/temp'
DEST_DIR = os.path.expandvars('$LCLS_LATTICE/bmad/master/')
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
qdg001: quadrupole, type = "1.51Q7.00", l = lqs/2, aperture = rqs, k1 = kqbf0, y_offset=-4.83865231890650768E-003
"""
SC_NEWELES['qdg003'] = """
! Replace k0l with quad offset and patch with y_pitch.
qdg003: quadrupole, type = "1.51Q7.00", l = lqs/2, aperture = rqs, k1 = kqbf0, y_offset=-2.99813063290814820E-004
"""
SC_NEWELES['dyqdg001'] = """
! Replace k0l with quad offset and patch with y_pitch.
dyqdg001: patch, y_pitch = 9.49758257820075558E-003
"""
SC_NEWELES['dyqdg003'] = """
! Replace k0l with quad offset and patch with y_pitch.
dyqdg003: patch, y_pitch = 5.88487966838956720E-004
"""
# Not needed. Desplitting handles cavities now.
# Add these repalcements
#SC_LINAC_REPLACEMENTS = json.load(open('replacements/good_sc_linac_replacements.json'))
#for name, replace in SC_LINAC_REPLACEMENTS.items():
#    SC_NEWELES[name.lower()+'_full'] = replace
# Append deferred replacements to SC_NEWELES
if INCLUDE_DEFERRED:
    SC_NEWELES.update(json.load(open('bmad/conversion/replacements/deferred_sc_replacements.json')))

def merge_replacements(master_file):
    dat = {}
    dat.update(NEWELES)
    if master_file.startswith('CU_'):
        print('CU replacements')
        dat.update(CU_NEWELES)
        return dat
    elif master_file.startswith('SC_'):
        print('SC replacements')
        dat.update(SC_NEWELES)
        return dat
    else:
        raise 

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

exclude_strs = ['BUN1B','WIGX','UMXL','LH_UND','UMHTR','UMASX','UMAHX','PSSX','PSHX']
shadows = ['umasxh','umahxh','pssxh','pshxh','umxl1h','umxl2h','umxl3h','umxl4h',
           'duqxl','lh_und','dh03a','dh03b','umhtr','dh02c','dh02d']

def process_master(master):
    print(f'Converting {master}')

    SCRIPT = f'python $ACC_ROOT_DIR/util_programs/mad_to_bmad/mad8_to_bmad_SLAC.py --no_prepend_vars -f {master}'
    res = run(SCRIPT, shell=True, cwd=TEMP_DIR)

    assert res.returncode == 0

    BMAD_FILES=glob(TEMP_DIR+'/*bmad')
    REPLACEMENTS = merge_replacements(master)
    for f in BMAD_FILES:
        finalize_bmad(f, replacements=REPLACEMENTS, verbose=False, exclude_strs=exclude_strs, shadows=shadows)  

    for f in BMAD_FILES:
        shutil.copy(f, DEST_DIR)

for _m in CU_MASTERS:
    process_master(_m)

for _m in SC_MASTERS:
    process_master(_m)

#cleanup working areas
#run(f'rm -r {TEMP_DIR}',shell=True)
