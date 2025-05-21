#!/bin/env python3

import numpy as np
import openpyxl as pyxl
import re
import math
from pathlib import Path


#------------------------------------------
# utility functions.  To be moved to module
#------------------------------------------

def intersection(x,y):
    return [v for v in x if v in y]

def strmatch(n_str,N_lst,exact=False):
    if not isinstance(N_lst,list):
        print('strmatch passed non-list. Stopping')
        stop
    if exact:
        return [ix for ix,n_ in enumerate(N_lst) if n_.strip() == n_str.strip()]
    else:
        return [ix for ix,n_ in enumerate(N_lst) if n_.startswith(n_str)]

def notnone(val):
    if val is None:
        return ''
    else:
        return val

def madval(rval):
    if rval == 0:
        return '0.0'
    else:
        aval = abs(rval)
        if 0.01 < aval < 100:
            iexp = 0.0
        else:
            iexp = int(math.log10(aval))
            rval = rval * 10**(-iexp)
        
        s = f'{rval:.12f}'
        s = s.rstrip('0')
        
        if s.endswith('.'):
            s = s + '0'
        
        if iexp != 0:
            s += f'E{iexp}'
        
        return s.strip()

def roundoff(val, prec=None):
    if isinstance(val,list):
        return None
    if prec is None:
        return val
    else:
        return prec * np.round(val / prec)

#------------------------------------------
#------------------------------------------
#------------------------------------------

script_dir = Path(__file__).parent.resolve()

optics='12MAY2025s'
vfile=['LCLS2sc_value.echo','LCLS2cu_value.echo']

outdir='oracle_upload'
xfile='AD_ACCEL-'+optics+'.xls'
noXTES_TEMPs=True; # skip elements named TEMP* in XTES systems

print(' ')
print('   ===============================================')
print('           AD_ACCEL Excel File Generation')
print('   ===============================================')
print(' ')

stepnum=0;

Er=5.10998918e5     # electron rest mass (eV) ... XAL value
clight=2.99792458e8 # speed of light (m/s) ... XAL value
charge=-1           # sign of electron charge ... XAL value
pi=3.141592653
rad2deg=180/pi      # degrees per radian
T2kG=10             # kG per Tesla

# ==============================================================================
# hardwired LCLS2sc MAD/XAL stuff
# ------------------------------------------------------------------------------

# file name roots

file_roots = [
    {'root':'LCLS2scS',     'beg':'BEGGUNB',      'end':'ENDDMPS_2',   'ix':1},      #  1
    {'root':'LCLS2scSS',    'beg':'BEGSFTS_1',    'end':'ENDSFTS_2',   'ix':2},      #  2
    {'root':'LCLS2scS2_X',  'beg':'BEGSXTES_1',   'end':'ENDSXTES_2',  'ix':3},      #  3
    {'root':'LCLS2scSTXI',  'beg':'BEGSXTES_3',   'end':'ENDSXTES_3',  'ix':4},      #  4
    {'root':'LCLS2scSTMO',  'beg':'BEGSXTES_4',   'end':'ENDSXTES_4',  'ix':5},      #  5
    {'root':'LCLS2scH',     'beg':'BEGSPH',       'end':'ENDSLTH',     'ix':6},      #  6
    {'root':'LCLS2scD',     'beg':'BEGSPD_2',     'end':'ENDSLTD',     'ix':7},      #  7
    {'root':'DIAG0',        'beg':'BEGDIAG0',     'end':'ENDDIAG0',    'ix':8},      #  8
    {'root':'LCLS2scDA',    'beg':'BEGSPA',       'end':'ENDESA',      'ix':9},      #  9 (DASEL)
    {'root':'LCLS2cuH',     'beg':'BEGGUN',       'end':'ENDDMPH_2',   'ix':10},     # 10
    {'root':'LCLS2cuHS',    'beg':'BEGSFTH_1',    'end':'ENDSFTH_2',   'ix':11},     # 11
    {'root':'LCLS2cuHXTES', 'beg':'BEGHXTES_1',   'end':'ENDHXTES_2',  'ix':12},     # 12
    {'root':'LCLS2cuHTXI',  'beg':'BEGHXTES_3',   'end':'ENDHXTES_3',  'ix':13},     # 13
    {'root':'LCLS2cuS',     'beg':'BEGCLTS',      'end':'ENDCLTS',     'ix':14},     # 14
    {'root':'LCLS2cuGSPEC', 'beg':'BEGGSPEC',     'end':'ENDGSPEC',    'ix':15},     # 15
    {'root':'LCLS2cuSPEC',  'beg':'BEGSPEC',      'end':'ENDSPEC',     'ix':16},     # 16
]

bsy_file_roots = [
    {'root':'LCLS2scS',     'beg':'BEGSPD_1',     'end':'ENDDMPS_2',   'ix':1},      #  1
    {'root':'LCLS2scSS',    'beg':'BEGSFTS_1',    'end':'ENDSFTS_2',   'ix':2},      #  2
    {'root':'LCLS2scS2_X',  'beg':'BEGSXTES_1',   'end':'ENDSXTES_2',  'ix':3},      #  3
    {'root':'LCLS2scSTXI',  'beg':'BEGSXTES_3',   'end':'ENDSXTES_3',  'ix':4},      #  4
    {'root':'LCLS2scSTMO',  'beg':'BEGSXTES_4',   'end':'ENDSXTES_4',  'ix':5},      #  5
    {'root':'LCLS2scH',     'beg':'BEGSPH',       'end':'ENDSLTH',     'ix':6},      #  6
    {'root':'LCLS2scD',     'beg':'BEGSPD_2',     'end':'ENDSLTD',     'ix':7},      #  7
    {'root':'LCLS2scDA',    'beg':'BEGSPA',       'end':'ENDESA',      'ix':9},      #  9 (DASEL)
    {'root':'LCLS2cuH',     'beg':'BEGCLTH_0',    'end':'ENDDMPH_2',   'ix':10},     # 10
    {'root':'LCLS2cuHS',    'beg':'BEGSFTH_1',    'end':'ENDSFTH_2',   'ix':11},     # 11
    {'root':'LCLS2cuHXTES', 'beg':'BEGHXTES_1',   'end':'ENDHXTES_2',  'ix':12},     # 12
    {'root':'LCLS2cuHTXI',  'beg':'BEGHXTES_3',   'end':'ENDHXTES_3',  'ix':13},     # 13
    {'root':'LCLS2cuS',     'beg':'BEGCLTS',      'end':'ENDCLTS',     'ix':14},     # 14
]

und_file_roots = []

# ------------------------------------------------------------------------------
# machine areas
# scS
area = []
area.append({'name': 'GUNB', 'beg': 'BEGGUNB', 'end': 'ENDGUNB', 'offset': [0, 0]})
area.append({'name': 'L0B', 'beg': 'BEGL0B', 'end': 'ENDL0B', 'offset': [0, 0]})
area.append({'name': 'HTR', 'beg': 'BEGHTR', 'end': 'ENDHTR', 'offset': [0, 0]})
area.append({'name': 'COL0', 'beg': 'BEGCOL0', 'end': 'ENDCOL0', 'offset': [0, 0]})
area.append({'name': 'L1B', 'beg': 'BEGL1B', 'end': 'ENDL1B', 'offset': [0, 0]})
area.append({'name': 'BC1B', 'beg': 'BEGBC1B', 'end': 'ENDBC1B', 'offset': [0, 0]})
area.append({'name': 'COL1', 'beg': 'BEGCOL1', 'end': 'ENDCOL1', 'offset': [0, 0]})
area.append({'name': 'L2B', 'beg': 'BEGL2B', 'end': 'ENDL2B', 'offset': [0, 0]})
area.append({'name': 'BC2B', 'beg': 'BEGBC2B', 'end': 'ENDBC2B', 'offset': [0, 0]})
area.append({'name': 'EMIT2', 'beg': 'BEGEMIT2', 'end': 'ENDEMIT2', 'offset': [0, 0]})
area.append({'name': 'L3B', 'beg': 'BEGL3B', 'end': 'ENDL3B', 'offset': [0, 0]})
area.append({'name': 'EXT', 'beg': 'BEGEXT', 'end': 'ENDEXT', 'offset': [0, 0]})
area.append({'name': 'DOG', 'beg': 'BEGDOG', 'end': 'ENDDOG', 'offset': [0, 0]})
area.append({'name': 'BYP', 'beg': 'BEGBYP', 'end': 'ENDBYP', 'offset': [0, 0]})
area.append({'name': 'SPD_1', 'beg': 'BEGSPD_1', 'end': 'ENDSPD_1', 'parent': 'SPD', 'offset': [0, 0]})
area.append({'name': 'SPS', 'beg': 'BEGSPS', 'end': 'ENDSPS', 'offset': [0, 0]})
area.append({'name': 'SLTS', 'beg': 'BEGSLTS', 'end': 'ENDSLTS', 'offset': [0, 0]})
area.append({'name': 'BSYS', 'beg': 'BEGBSYS', 'end': 'ENDBSYS', 'offset': [0, 0]})
area.append({'name': 'LTUS', 'beg': 'BEGLTUS', 'end': 'ENDLTUS', 'offset': [0, 0]})
area.append({'name': 'UNDS', 'beg': 'BEGUNDS', 'end': 'ENDUNDS', 'offset': [0, 0]})
area.append({'name': 'DMPS_1', 'beg': 'BEGDMPS_1', 'end': 'ENDDMPS_1', 'parent': 'DMPS', 'offset': [0, 0]})
area.append({'name': 'DMPS_2', 'beg': 'BEGDMPS_2', 'end': 'ENDDMPS_2', 'parent': 'DMPS', 'offset': [0, 0]})

# scSS
area.append({'name': 'SFTS_1', 'beg': 'BEGSFTS_1', 'end': 'ENDSFTS_1', 'parent': 'SFTS', 'offset': [0, 0]})
area.append({'name': 'SFTS_2', 'beg': 'BEGSFTS_2', 'end': 'ENDSFTS_2', 'parent': 'SFTS', 'offset': [0, 0]})
# scSXTES/scS2_X/scSTXI/scSTMO
area.append({'name': 'SXTES_1', 'beg': 'BEGSXTES_1', 'end': 'ENDSXTES_1', 'parent': 'SXTES', 'offset': [0, 0]})  # common line
area.append({'name': 'SXTES_2', 'beg': 'BEGSXTES_2', 'end': 'ENDSXTES_2', 'parent': 'SXTES', 'offset': [0, 0]})  # "2.X" line
area.append({'name': 'SXTES_3', 'beg': 'BEGSXTES_3', 'end': 'ENDSXTES_3', 'parent': 'SXTES', 'offset': [0, 0]})  # TXI line
area.append({'name': 'SXTES_4', 'beg': 'BEGSXTES_4', 'end': 'ENDSXTES_4', 'parent': 'SXTES', 'offset': [0, 0]})  # TMO line
# scH
area.append({'name': 'SPH', 'beg': 'BEGSPH', 'end': 'ENDSPH', 'offset': [0, 0]})
area.append({'name': 'SLTH', 'beg': 'BEGSLTH', 'end': 'ENDSLTH', 'offset': [0, 0]})
# scD
area.append({'name': 'SPD_2', 'beg': 'BEGSPD_2', 'end': 'ENDSPD_2', 'parent': 'SPD', 'offset': [0, 0]})
area.append({'name': 'SPD_3', 'beg': 'BEGSPD_3', 'end': 'ENDSPD_3', 'parent': 'SPD', 'offset': [0, 0]})
area.append({'name': 'SLTD', 'beg': 'BEGSLTD', 'end': 'ENDSLTD', 'offset': [0, 0]})
# DIAG0
area.append({'name': 'DIAG0', 'beg': 'BEGDIAG0', 'end': 'ENDDIAG0', 'offset': [0, 0]})
# DASEL
area.append({'name': 'SPA', 'beg': 'BEGSPA', 'end': 'ENDSPA', 'offset': [0, 0]})
area.append({'name': 'SLTA', 'beg': 'BEGSLTA', 'end': 'ENDSLTA', 'offset': [0, 0]})
area.append({'name': 'BSYA', 'beg': 'BEGBSYA', 'end': 'ENDBSYA', 'offset': [0, 0]})
area.append({'name': 'ESA', 'beg': 'BEGESA', 'end': 'ENDESA', 'offset': [0, 0]})
# cuH
area.append({'name': 'GUN', 'beg': 'BEGGUN', 'end': 'ENDGUN', 'offset': [0, 0]})
area.append({'name': 'L0', 'beg': 'BEGL0', 'end': 'ENDL0', 'offset': [0, 0]})
area.append({'name': 'DL1_1', 'beg': 'BEGDL1_1', 'end': 'ENDDL1_1', 'parent': 'DL1', 'offset': [0, 0]})
area.append({'name': 'DL1_2', 'beg': 'BEGDL1_2', 'end': 'ENDDL1_2', 'parent': 'DL1', 'offset': [0, 0]})
area.append({'name': 'L1', 'beg': 'BEGL1', 'end': 'ENDL1', 'offset': [0, 0]})
area.append({'name': 'BC1', 'beg': 'BEGBC1', 'end': 'ENDBC1', 'offset': [0, 0]})
area.append({'name': 'L2', 'beg': 'BEGL2', 'end': 'ENDL2', 'offset': [0, 0]})
area.append({'name': 'BC2', 'beg': 'BEGBC2', 'end': 'ENDBC2', 'offset': [0, 0]})
area.append({'name': 'L3', 'beg': 'BEGL3', 'end': 'ENDL3', 'offset': [0, 0]})
area.append({'name': 'CLTH_0', 'beg': 'BEGCLTH_0', 'end': 'ENDCLTH_0', 'parent': 'CLTH', 'offset': [0, 0]})
area.append({'name': 'CLTH_1', 'beg': 'BEGCLTH_1', 'end': 'ENDCLTH_1', 'parent': 'CLTH', 'offset': [0, 0]})
area.append({'name': 'CLTH_2', 'beg': 'BEGCLTH_2', 'end': 'ENDCLTH_2', 'parent': 'CLTH', 'offset': [0, 0]})
area.append({'name': 'BSYH', 'beg': 'BEGBSYH', 'end': 'ENDBSYH', 'offset': [0, 0]})

area.append({'name': 'LTUH', 'beg': 'BEGLTUH', 'end': 'ENDLTUH', 'offset': [0, 0]})
area.append({'name': 'UNDH', 'beg': 'BEGUNDH', 'end': 'ENDUNDH', 'offset': [0, 0]})
area.append({'name': 'DMPH_1', 'beg': 'BEGDMPH_1', 'end': 'ENDDMPH_1', 'parent': 'DMPH', 'offset': [0, 0]})
area.append({'name': 'DMPH_2', 'beg': 'BEGDMPH_2', 'end': 'ENDDMPH_2', 'parent': 'DMPH', 'offset': [0, 0]})
# cuHS
area.append({'name': 'SFTH_1', 'beg': 'BEGSFTH_1', 'end': 'ENDSFTH_1', 'parent': 'SFTH', 'offset': [0, 0]})
area.append({'name': 'SFTH_2', 'beg': 'BEGSFTH_2', 'end': 'ENDSFTH_2', 'parent': 'SFTH', 'offset': [0, 0]})
# cuHXTES/cuHTXI
area.append({'name': 'HXTES_1', 'beg': 'BEGHXTES_1', 'end': 'ENDHXTES_1', 'parent': 'HXTES', 'offset': [0, 0]})  # common line
area.append({'name': 'HXTES_2', 'beg': 'BEGHXTES_2', 'end': 'ENDHXTES_2', 'parent': 'HXTES', 'offset': [0, 0]})  # XTES line
area.append({'name': 'HXTES_3', 'beg': 'BEGHXTES_3', 'end': 'ENDHXTES_3', 'parent': 'HXTES', 'offset': [0, 0]})  # TXI line
# cuS
area.append({'name': 'CLTS', 'beg': 'BEGCLTS', 'end': 'ENDCLTS', 'offset': [0, 0]})
# cuGSPEC
area.append({'name': 'GSPEC', 'beg': 'BEGGSPEC', 'end': 'ENDGSPEC', 'offset': [0, 0]})
# cuSPEC
area.append({'name': 'SPEC', 'beg': 'BEGSPEC', 'end': 'ENDSPEC', 'offset': [0, 0]})

# assign default area "parent" names
for a in area:
    if 'parent' not in a:
        a['parent']=a['name']

cBSY=len(bsy_file_roots)>0
cUND=len(und_file_roots)>0

from xtffs2mat import xtffs2mat

# ------------------------------------------------------------------------------
# read the MAD output files
stepnum += 1
print('   {}) Read MAD output files ...'.format(stepnum))

K, N, L, P, A, T, E, FDN, coor, S, Sd = [], [], [], [], [], [], [], [], [], [], []
idf, idd = [], []  # idf: which MAD output file an element came from
                   # idd: ordinal position in MAD output file

for file_root in file_roots:
    fname = f'{file_root["root"]}_survey.tape'
    print(f'Opening file {fname}')
    titl, tK, tN, tL, tP, tA, tT, tE, tFDN, tcoor, tS = xtffs2mat(fname)

    id1 = tN.index(file_root['beg'])
    id2 = tN.index(file_root['end']) 
    slc = slice(id1, id2 + 1)

    K.extend(tK[slc])
    N.extend(tN[slc])
    L.extend(tL[slc])
    P.extend(tP[slc])
    A.extend(tA[slc])
    T.extend(tT[slc])
    E.extend(tE[slc])
    FDN.extend(tFDN[slc])
    coor.extend(tcoor[slc])
    S.extend(tS[slc])

    ndata = len(tK[slc])
    idf.extend([file_root['ix']] * ndata)
    idd.extend(list(range(id1,id2+1)))

Sd = [x[2] for x in coor] # set "display S" to linac Z-coordinate

Nelem = len(N)
# get BSY coordinates
K1, N1, L1, P1, S1, coor1, idf1, FDN1 = [], [], [], [], [], [], [], []
if cBSY:
    for file_root in bsy_file_roots:
        fname = f'BSY-{file_root["root"]}_survey.tape'
        print(f'Opening file {fname}')
        titl, tK, tN, tL, tP, tA, tT, tE, tFDN, tcoor, tS = xtffs2mat(fname)

        id1 = tN.index(file_root['beg'])
        id2 = tN.index(file_root['end']) 
        slc = slice(id1, id2 + 1)

        K1.extend(tK[slc])
        N1.extend(tN[slc])
        L1.extend(tL[slc])
        P1.extend(tP[slc])
        S1.extend(tS[slc])
        coor1.extend(tcoor[slc])
        FDN1.extend(tFDN[slc])

        ndata = len(tK[slc])
        idf1.extend([file_root['ix']] * ndata)

# get UND coordinates
K2, N2, L2, P2, S2, coor2, idf2, FDN2 = [], [], [], [], [], [], [], []
if cUND:
    for file_root in file_roots:
        if file_root['UND']:
            fname = f'{file_root[0]}_survey.tape'
            print(f'Opening file {fname}')
            titl, tK, tN, tL, tP, tA, tT, tE, tFDN, tcoor, tS = xtffs2mat(fname)

            K2.extend(tK)
            N2.extend(tN)
            L2.extend(tL)
            P2.extend(tP)
            S2.extend(tS)
            coor2.extend(tcoor)
            FDN2.extend(tFDN)

            idf2.extend([file_root['ix']] * len(tK))

def FixUpgradeNames(N):
  # Device names in upgraded SXR cells have "_" appended ... remove it
  for i in range(len(N)):
    if N[i].endswith('_'):
      N[i] = N[i][:-1]
FixUpgradeNames(N)
if cBSY:
  FixUpgradeNames(N1)
if cUND:
  FixUpgradeNames(N2)

# assign machine areas
ida=[]
for ix,a in enumerate(area):
    id1 = N.index(a['beg']) + a['offset'][0]
    id2 = N.index(a['end']) + a['offset'][1]
    ida.extend([ix]*(id2-id1+1))

# special handling for rolled dump lines and A-line
def fix_dump_coords(N, P, coor):
    # Implementation of FixDumpCoords function

    # set roll angle for SXR dump line components
    id1=N.index('RODMP1S')
    id2=N.index('RODMP2S')-1
    ARODMP1S=P[id1][4]
    for i in range(id1,id2+1):
      coor[i][5]=ARODMP1S

    id1=id2+1
    id2=N.index('ENDDMPS_2')
    for i in range(id1,id2+1):
      coor[i][5]=0

    # set roll angle for HXR dump line components
    id1=N.index('RODMP1H')
    id2=N.index('RODMP2H')-1
    ARODMP1H=P[id1][4];
    for i in range(id1,id2+1):
      coor[i][5]=ARODMP1H

    id1=id2+1;
    id2=N.index('ENDDMPH_2')
    for i in range(id1,id2+1):
      coor[i][5]=0

    return coor
coor = fix_dump_coords(N, P, coor)

def fix_aline_coords(N, P, coor):
    # Implementation of FixAlineCoords function
    # set roll angle for A-line components
    id1 = N.index('ROLL2')
    id2 = N.index('ENDBSYA')
    AROLL2 = P[id1][4]
    for i in range(id1,id2+1):
      coor[i][5] = AROLL2

    # The following block is commented out in the original code
    '''
    id1 = N.index('BEGBSYA_1')
    id2 = N.index('ROLL2') - 1
    id_slice = slice(id1, id2 + 1)
    coor[id_slice, 5] = 0  # remove residual "creeping" roll
    '''
    return coor
coor = fix_aline_coords(N, P, coor)

def fix_sxtes_coords(N, coor):
    # Implementation of FixSXTESCoords function
    # fix BSY coordinates for selected SXTES system devices per P. Stephens
    name = [
        'MR1K3_VGC_1', 'ND1S', 'SP1K1_MONO_VGC_1',  # 2.2 line
        'IM1K3_PPM', 'BT1K3_AIR',  # TXI line
        'BT2K0_PLEG_TMO', 'LUSI'  # TMO line
    ]
    coor_id = [
        1, 1, 1,
        0, 0,
        -1, 0
    ]
    coor_val = [
        -0.8826040, -2.0921000, -0.7249275,
        1.0694435, 1.0480923,
        1.2500000, -1.2194000
    ]

    for n in range(len(name)):
        if coor_id[n] == -1:
            continue
        id_matches = N.index(name[n])
        coor[id_matches][coor_id[n]] = coor_val[n]
    return coor
if cBSY:
    coor1 = fix_dump_coords(N1, P1, coor1)
    coor1 = fix_aline_coords(N1, P1, coor1)
    coor1 = fix_sxtes_coords(N1, coor1)
if cUND:
    coor2 = fix_dump_coords(N2, P2, coor2)
    coor2 = fix_aline_coords(N2, P2, coor2)

# kicker/septum groups
KSname = [
    'BKRDG0', 'BLRDG0',
    'BKYSP0H', 'BKYSP1H', 'BKYSP2H', 'BKYSP3H', 'BKYSP4H', 'BKYSP5H', 'BLXSPH',
    'BKYSP0S', 'BKYSP1S', 'BKYSP2S', 'BKYSP3S', 'BKYSP4S', 'BKYSP5S', 'BLXSPS',
    'BKRDAS1', 'BKRDAS2', 'BKRDAS3', 'BKRDAS4', 'BKRDAS5', 'BKRDAS6', 'BLRDAS',
    'BKRCUS', 'BLRCUS'
]

# read FINT values for SBENs and undulator parameters from a special echo-file
# generated via MAD VALUE commands

C = []
for n in range(len(vfile)):
    fname = vfile[n]
    with open(fname, 'r') as f:
        C.extend(f.read().split())

P2 = np.zeros((Nelem, 2))

idb = [i for i,x in enumerate(K) if x == 'SBEN']
for m in range(0, len(idb), 2):
    na = idb[m]
    nb = idb[m+1]
    name = N[na].strip()
    name = name.split('.')[0]  # remove decoration, if any
    id_ = strmatch(name,C)[0]
    #id_ = [i for i, x in enumerate(C) if name in x][0]
    #if not id_:
    #    raise ValueError(f'No FINT for {name}')
    #elif len(id_) > 1:
    #    print('oops')
    fint = float(C[id_+6])
    P2[na][0] = fint
    P2[nb][0] = fint

idm = [i for i,x in enumerate(K) if x == 'MATR']
for m in range(0, len(idm), 2):
    n1 = idm[m]
    n2 = idm[m+1]
    name = N[n1].strip()
    Ktxt = f'"{name}_K"'
    Ltxt = f'"{name}_L"'
    idK = strmatch(Ktxt,C)[0]
    idL = strmatch(Ltxt,C)[0]
    undk = float(C[idK+2])
    undl = float(C[idL+2])
    P2[n1, :] = [undl, undk]
    P2[n2, :] = [undl, undk]


# Shared devices (devices which see both kicked and unkicked beams)
aname_all = ['DIAG0', 'SPH', 'SPS', 'SPA', 'CLTS']
name_all = ['BPMDG000', 'BPMSPH', 'BPMSPS', 'BPMDAS', 'BPMCUS']

for name, aname in zip(name_all,aname_all):
    jd = strmatch(name,N,True)
    for m in range(len(jd)):
        if aname == area[ida[jd[m]]]['name']:
            N[jd[m]] = name + '?'

    if cBSY:
        jd1 = strmatch(name,N1,True)
        for m in range(len(jd1)):
            if aname == area[ida[jd[m]]]['name']:
                N1[jd1[m]] = name + '?'

    if cUND:
        jd2 = strmatch(name,N2,True)
        for m in range(len(jd2)):
            if aname == area[ida[jd[m]]]['name']:
                N1[jd2[m]] = name + '?'

# copy T1 into TILT slot
name = ['CQ01', 'SQ01', 'CQ01B', 'SQ01B', 'SQ02B']
for n in name:
    id_ = strmatch(n,N,True)
    for i in id_:
        P[i][3] = P[i][5]  # T1 -> TILT

def assign_ucell(N, coor):
    UCELL = ['' for x in N]

    # SXR partial cell 16
    i1 = strmatch('BEGUNDS',N)[0]
    i2 = strmatch('SXR17BEG',N)[0]-1
    for i in range(i1,i2+1):
        UCELL[i]='SXR 16'
    # SXR cells
    for nc in range(17,50+1):
        i1 = strmatch(f'SXR{nc:02}BEG',N)[0]
        i2 = strmatch(f'SXR{nc:02}END',N)[0]
        for j in range(i1,i2+1):
            UCELL[j]=f'SXR {nc:02}'

    # HXR partial cell 12
    i1 = strmatch('BEGUNDH',N)[0]
    i2 = strmatch('HXR13BEG',N)[0]-1
    for i in range(i1,i2+1):
        UCELL[i]='HXR 12'
    # SXR cells
    for nc in range(13,50+1):
        i1 = strmatch(f'HXR{nc:02}BEG',N)[0]
        i2 = strmatch(f'HXR{nc:02}END',N)[0]
        for j in range(i1,i2+1):
            UCELL[j]=f'HXR {nc:02}'
    return UCELL

# Assign undulator cell names
UCELL = assign_ucell(N1, coor1)

def read_sector_data():
    filename = f'{script_dir}/sectors.xlsx'
    wb= pyxl.load_workbook(filename,data_only=True)

    # read worksheet 1 (scS)
    sheet = wb.worksheets[0]
    data = sheet['A4':'J72']
    sect_sc = []
    for row in data:
        sect_sc.append({
            'name': row[0].value,
            'froot': row[1].value,
            'BSY': row[2].value,
            'Zbeg': row[4].value,
            'Zend': row[5].value,
            'Nbeg': notnone(row[8].value),
            'Nend': notnone(row[9].value)
        })

    # read worksheet 2 (cuH)
    sheet = wb.worksheets[1]
    data = sheet['A4':'J39']
    sect_cu = []
    for row in data:
        sect_cu.append({
            'name': row[0].value,
            'froot': row[1].value,
            'BSY': row[2].value,
            'Zbeg': row[4].value,
            'Zend': row[5].value,
            'Nbeg': notnone(row[8].value),
            'Nend': notnone(row[9].value)
        })

    return sect_sc, sect_cu

def set_sector(N, SECTORS, coor, idf, nf, sector):
    if nf != sector['froot']:
        return
    Z = [x[2] for x in coor]

    id_ = [i for i,x in enumerate(idf) if x == nf]
    if sector['Nbeg'] == '':
        jd2 = [i for i,x in enumerate(Z) if x > sector['Zbeg']]
        inter1 = intersection(id_,jd2)
        if inter1 == []:
            return
        else:
            inter1 = inter1[0]
    else:
        jd2 = strmatch(sector['Nbeg'],N,True)
        inter1 = intersection(id_,jd2)
        if inter1 != []:
            inter1 = inter1[0]

    if sector['Nend'] == '':
        jd2 = [i for i,x in enumerate(Z) if x < sector['Zend']]
        inter2 = intersection(id_,jd2)
        if inter2 == []:
            return
        else:
            inter2 = inter2[-1]
    else:
        jd2 = strmatch(sector['Nend'],N,True)
        inter2 = intersection(id_,jd2)
        if inter2 != []:
            inter2 = inter2[0]
    if inter1 != [] and inter2 != []:
        for n in range(inter1, inter2 + 1):
            if SECTORS[n].strip() == '':
                SECTORS[n] = sector['name']

def assign_sector(N, coor, idf, N1, coor1, idf1):
    # NOTE: coordinates are assumed to be in MAD (not SYMBOLS) order

    sect_SC, sect_CU = read_sector_data()

    # superconducting linac LINEs
    # nf= 1: LCLS2scS
    # nf= 2: LCLS2scSS
    # nf= 3: LCLS2scS2_X
    # nf= 4: LCLS2scSTXI
    # nf= 5: LCLS2scSTMO
    # nf= 6: LCLS2scH
    # nf= 7: LCLS2scD
    # nf= 8: DIAG0
    # nf= 9: LCLS2scDA (DASEL)

    SECTORS = ['' for x in N]
    SECTORS1 = ['' for x in N]

    for nf in range(1, 10):  # idf values
        if nf in [3, 4, 5]:
            continue  # do SXTES: 2_X/TXI/TMO separately
        for ns, sector in enumerate(sect_SC, 1):
            if sector['BSY']:
                set_sector(N1, SECTORS1, coor1, idf1, nf, sector)
            else:
                set_sector(N, SECTORS, coor, idf, nf, sector)

    # copper linac LINEs
    # nf=10: LCLS2cuH
    # nf=11: LCLS2cuHS
    # nf=12: LCLS2cuHXTES
    # nf=13: LCLS2cuHTXI
    # nf=14: LCLS2cuS
    # nf=15: LCLS2cuGSPEC
    # nf=16: LCLS2cuSPEC

    for nf in range(10, 17):  # idf values
        if nf in [12, 13]:
            continue  # do XTECH: HXTES/TXI separately
        for ns, sector in enumerate(sect_CU, 1):
            if sector['BSY']:
                set_sector(N1, SECTORS1, coor1, idf1, nf, sector)
            else:
                set_sector(N, SECTORS, coor, idf, nf, sector)

    # handle SXTES lines separately
    ix = [x['froot'] for x in sect_SC].index(3) # XTESS(2_x)
    set_sector(N1, SECTORS1, coor1, idf1, 3, sect_SC[ix])
    ix = [x['froot'] for x in sect_SC].index(4) # XTESS(TXI)
    set_sector(N1, SECTORS1, coor1, idf1, 4, sect_SC[ix])
    ix = [x['froot'] for x in sect_SC].index(5) # XTESS(TMO)
    set_sector(N1, SECTORS1, coor1, idf1, 5, sect_SC[ix])

    # handle HXTES lines separately
    ix = [x['froot'] for x in sect_CU].index(12) # XTESH(HXTES)
    set_sector(N1, SECTORS1, coor1, idf1, 12, sect_CU[ix])
    ix = [x['froot'] for x in sect_CU].index(13) # XTESH(TXI)
    set_sector(N1, SECTORS1, coor1, idf1, 13, sect_CU[ix])

    return SECTORS, SECTORS1

# Assign sector names
SECTORS, SECTORS1 = assign_sector(N, coor, idf, N1, coor1, idf1)

# MAD SURVEY coordinates  [x,y,z,theta,phi   ,psi]
# correspond to SolidEdge [z,x,y,roll ,-pitch,yaw]

ic = [2, 0, 1, 5, 4, 3]
coor = np.array(coor)  #Probably not necessary ... coor is already a numpy array.
coor = coor[:, ic]
coor[:, 4] = -coor[:, 4]

if cBSY:
    coor1 = np.array(coor1) #Probably not necessary
    coor1 = coor1[:, ic]
    coor1[:, 4] = -coor1[:, 4]

if cUND:
    coor2 = np.array(coor2) #Probably not necessary
    coor2 = coor2[:, ic]
    coor2[:, 4] = -coor2[:, 4]

# generate ordered list of MAD keywords

MADK = [
    'LCAV', 'SBEN', 'QUAD', 'SEXT', 'SOLE', 'MATR', 'RCOL', 'ECOL', 'SROT',
    'HKIC', 'VKIC', 'MONI', 'WIRE', 'PROF', 'IMON', 'BLMO', 'INST',
    'MARK', 'MULT'
]

#FOO FLAG key*, etc in following block for removal.
# this prunes from MADK those keyword not in the survey files.
keyw = []
jdmisc = []
tkeyw = sorted(list(set(K)))
for n in range(len(MADK)):
    id_ = strmatch(MADK[n], tkeyw)
    if len(id_) > 0:
        keyw.append(MADK[n])

# hard-wired list of bends that have energy polynomials in the database
Ebend = []  # ['BRB', 'BXSP', 'BYSP', 'BRSP', 'BYSP', 'BX3', 'BY1', 'BY2', 'BYD']

# Keyword Worksheets
# (NOTE: suml, energy, and coord are quoted at element's center)
# ==============================================================================
# LCAV (unsegmented):
# - idf,id,sequence,area,xkey,prim,name,type,dist(m),energy(GeV)
# - length(m),freq(MHz),ampl(MeV),phase(deg),grad(MeV/m),power(1)
# - sdsp(m),suml(m),coord(m,rad)
# - suml1(m),coord1(m,rad),suml2(m),coord2(m,rad)
# SBEN (unsplit):
# - idf,id,sequence,area,xkey,prim,name,type,dist(m),energy(GeV)
# - zleng(m),leng(m),gap(m),fint(1),tilt(deg),ang(deg),e1(deg),e2(deg),
#   BL(kG-m),B(T),k1(1/m^2),GL(kG),G(T/m),scale(name,value),polarity
# - sdsp(m),suml(m),coord(m,rad),mcoord(m,rad)
# - suml1(m),coord1(m,rad),mcoord1(m,rad),suml2(m),coord2(m,rad),mcoord2(m,rad)
# QUAD (unsplit):
# - idf,id,sequence,area,xkey,prim,name,type,dist(m),energy(GeV)
# - leng(m),bore(m),tilt(deg),k1(1/m^2),GL(kG),G(T/m),scale(name,value),polarity
# - sdsp(m),suml(m),coord(m,rad),mcoord(m,rad)
# - suml1(m),coord1(m,rad),suml2(m),coord2(m,rad)
# SEXT (unsplit):
# - idf,id,sequence,area,xkey,prim,name,type,dist(m),energy(GeV)
# - leng(m),bore(m),tilt(deg),k2(1/m^3),G'L(kG/m),G'(T/m^2),scale(name,value),
#   polarity
# - sdsp(m),suml(m),coord(m,rad)
# - suml1(m),coord1(m,rad),suml2(m),coord2(m,rad)
# SOLE (unsplit):
# - idf,id,sequence,area,xkey,prim,name,type,dist(m),energy(GeV)
# - leng(m),bore(m),ks(1/m),BL(kG-m),B(T),scale(name,value),polarity
# - sdsp(m),suml(m),coord(m,rad)
# - suml1(m),coord1(m,rad),suml2(m),coord2(m,rad)
# MATR (unsplit):
# - idf,id,sequence,area,xkey,prim,name,type,dist(m),energy(GeV)
# - leng(m),lambda(m),k(1)
# - sdsp(m),suml(m),coord(m,rad)
# - suml1(m),coord1(m,rad),suml2(m),coord2(m,rad)
# RCOL,ECOL:
# - idf,id,sequence,area,xkey,prim,name,type,dist(m),energy(GeV)
# - leng(m),xsize(m),ysize(m)
# - sdsp(m),suml(m),coord(m,rad)
# - suml1(m),coord1(m,rad),suml2(m),coord2(m,rad)
# SROT:
# - idf,id,sequence,area,xkey,prim,name,type,dist(m),energy(GeV)
# - leng(m),ang(deg)
# - sdsp(m),suml(m),coord(m,rad)
# - suml1(m),coord1(m,rad),suml2(m),coord2(m,rad)
# HKIC,VKIC,MONI,WIRE,PROF,IMON,BLMO,INST:
# - idf,id,sequence,area,xkey,prim,name,type,dist(m),energy(GeV)
# - leng(m)
# - sdsp(m),suml(m),coord(m,rad)
# - suml1(m),coord1(m,rad),suml2(m),coord2(m,rad)
# MARK:
# - idf,id,sequence,area,xkey,prim,name,type,dist(m),energy(GeV)
# - sdsp(m),suml(m),coord(m,rad)
# - suml1(m),coord1(m,rad),suml2(m),coord2(m,rad)

# Assumptions
# ==============================================================================
# - LCAVs may be segmented
# - the first 6 characters of an LCAV's name associate it with it's parent
# - all SBENs are split into two pieces
# - the last character of an SBEN's name differentiates it's pieces
# - all QUADs, SEXTs, and MATRs are split in half
# - all other keyword types are not (necessarily) split
# - SBENs with abs(ang)<amin will have ang set to zero
# - SBENs or QUADs with abs(k1)<kmin will have k1 set to zero
# - SOLEs with abs(ks)<kmin will have ks set to zero
# - SROTs with abs(ang)<amin will have ang set to zero

amin = 1e-9
kmin = 1e-6

# process by keyword

nHKIC = 0
nVKIC = 0
nMONI = 0
nWIRE = 0
nPROF = 0
nIMON = 0
nBLMO = 0

#HEAD
Sd = np.array(Sd)  #Probably not needed ... already numpy array
S = np.array(S)
S1 = np.array(S1)
S2 = np.array(S2)
L = np.array(L)
L1 = np.array(L1)
L2 = np.array(L2)
P = np.array(P)
P1 = np.array(P1)
P2 = np.array(P2)
E = np.array(E)
coor1 = np.array(coor1)
coor2 = np.array(coor2)
A = np.array(A)
for kwn in keyw:
    key_ids = strmatch(kwn,K)
    name = list(dict.fromkeys([N[i] for i in key_ids]))
    if kwn == 'LCAV':
        LCAV = []
        # create list of unique names that will allow unsplitting
        for i in range(len(name)):
            if name[i][0:4] in ['CAVL', 'CAVC']:  # unique in 7 characters
                name[i] = name[i][0:7]
            else:  # unique in 6 characters
                name[i] = name[i][0:6]
        name = list(dict.fromkeys(name))
        nLCAV = 0

        for mname in name:
            if mname.startswith('TCX'):
                id = strmatch(mname,N,True)
            else:
                id = strmatch(mname,N)
            id1 = id[0]  # first segment
            ide = [id1-1, id[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = np.mean(E[ide])  # GeV (beam center)
            leng = np.sum(L[id])  # m
            freq = P[id1, 4]  # MHz
            ampl = np.sum(P[id, 5])  # MeV
            phase = P[id1, 6]  # rad/2pi
            grad = ampl / leng  # MeV/m
            if re.match(r'K\d\d_\d[ABCD]', mname[0:6]):  # i.e. K27_3D
                id = strmatch(mname[0:5],N)
                grad0 = np.min(P[id, 5] / L[id])
                if grad0 == 0:
                    power = float("NaN")
                else:
                    power = 0.25 * round((grad / grad0) ** 2)  # KLYS power fraction (1)
            else:
                power = 1
            coorc = np.mean(coor[ide, :], axis=0)  # m,rad (beam center)
            nLCAV += 1
            LCAV.append({
                'idf': idf[id1],
                'id': idd[id1],
                'area': area[ida[id1]]['name'],
                'parent': area[ida[id1]]['parent'],
                'sector': SECTORS[id1].strip(),
                'ucell': [],
                'prim': FDN[id1],
                'name': mname,
                'type': T[id1].strip(),
                'energy': energy,
                'leng': leng,
                'freq': freq,
                'ampl': ampl,
                'phase': 360 * phase,  # deg
                'grad': grad,
                'power': power,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                LCAV[-1][f'c1{k+1}'] = []
            if cBSY:
                if mname.startswith('TCX'):
                    id = strmatch(mname,N1,True) # differentiate between TCX01/02 and TCX01B/02B
                else:
                    id = strmatch(mname,N1)
                if len(id) > 0:
                    id1 = id[0]  # first segment
                    ide = [id1 - 1, id[-1]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide, :], axis=0)  # m,rad (beam center)
                    LCAV[-1]['suml1'] = suml1
                    for k in range(6):
                        LCAV[-1][f'c1{k+1}'] = coorc1[k]
                    if not LCAV[-1]['sector']:
                        LCAV[-1]['sector'] = SECTORS1[id1].strip()
                    LCAV[-1]['ucell'] = UCELL[id1].strip()

            # UND coordinates

            LCAV[-1]['suml2'] = []
            for k in range(6):
                LCAV[-1][f'c2{k+1}'] = []
            if cUND:
                if mname.startswith('TCX'):
                    id = strmatch(mname,N2,True) # differentiate between TCX01/02 and TCX01B/02B
                else:
                    id = strmatch(mname,N2)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide, :], axis=0)  # m,rad (beam center)
                    LCAV[-1]['suml2'] = suml2
                    for k in range(6):
                        LCAV[-1][f'c2{k+1}'] = coorc2[k]
    elif kwn == 'SBEN':
        Nelm = len(key_ids) // 2
        SBEN = []
        for m in range(Nelm):
            mname1 = name[2 * m].strip()
            mname2 = name[2 * m + 1].strip()
            mname = mname1[:-1]  # remove last character from name
            id = [strmatch(mname1,N,True),strmatch(mname2,N,True)]
            id1 = id[0][0]  # end point of first of 2 halfs of split bend.
            idi = id1 - 1  # start point of bend
            ido = id[1][-1]  # exit point of bend
            sdsp = Sd[id1]  # m
            suml = S[id1]  # m
            energy = E[id1]  # GeV
            leng = np.sum(L[id])  # m
            gap = 2 * A[id1]  # m
            fint = P2[id1, 0]  # m
            tilt = P[id1, 3]  # rad
            ang = np.sum(P[id, 0])  # rad
            if abs(ang) < amin:
                ang = 0
                e1 = 0
                e2 = 0
            else:
                e1 = P[id1, 4]  # rad
                e2 = P[ido, 5]  # rad
            EeV = 1e9 * energy  # eV
            brho = np.sqrt(EeV ** 2 - Er ** 2) / clight  # T-m
            BL = brho * ang  # T-m
            B = BL / leng  # T
            k1 = P[id1, 1]  # 1/m^2
            if abs(k1) < kmin:
                k1 = 0
            G = brho * k1  # T/m
            GL = G * leng  # T
            if mname[:3] in Ebend:
                sname = 'GeV2T'
                sval = brho * abs(ang) / (leng * energy)
            else:
                sname = 'kG2T_Bdl2B'
                sval = 1 / (leng * T2kG)
            polarity = -np.sign(ang + np.finfo(float).eps)  # add eps so that sign=1 when ang=0
            coori = np.copy(coor[idi, :])  # coordinates at bend entrance
            coorc = np.copy(coor[id1, :])  # coordinates at end of first half
            cooro = np.copy(coor[ido, :])  # coordiantes at exit
            coorm = np.zeros(coorc.shape)  # m,rad (magnet steel center)
            if mname in KSname:
                jd = strmatch(f'D{mname}',N)
                if len(jd) != 2:
                    raise ValueError(f'{mname} not split?')
                zleng = np.sum(L[jd])  # m
                coorm = np.copy(coor[jd[0], :]) # coordinates at end of first half of counterpart drift
            else:
                chicane1 = (e1 == 0) & (e2 != 0)
                chicane2 = (e1 != 0) & (e2 == 0)
                if chicane1 | chicane2:
                    zleng = leng * np.sinc(ang/np.pi)  # m
                    coorm[:3] = np.mean([coori[:3], cooro[:3]], axis=0)
                    if chicane1:
                        coorm[3:6] = np.copy(coori[3:6])
                    else:
                        coorm[3:6] = np.copy(cooro[3:6])
                else:
                    zleng = leng * np.sinc(ang / 2 / np.pi)  # m
                    coorm[:3] = (coori[:3] + cooro[:3] + 2 * coorc[:3]) / 4
                    coorm[3:6] = np.copy(coorc[3:6])
            pname = area[ida[id1]]['parent']
            if pname in ['DMPS', 'DMPH']:
                coorm[3] = coorc[3]  # dump line magnet coords set in FixDumpCoords
            elif pname == 'BSYA':
                coorm[3] = coorc[3]  # dump line magnet coords set in FixAlineCoords
            else:
                coorm[3] = tilt  # remove "creeping" rolls from non-rolled SBENs
            SBEN.append({
                'idf': idf[id1],
                'id': idd[id1],
                'area': area[ida[id1]]['name'],
                'parent': pname,
                'sector': SECTORS[id1].strip(),
                'ucell': [],
                'prim': FDN[id1],
                'name': mname,
                'type': T[id1].strip(),
                'energy': energy,
                'zleng': zleng,
                'leng': leng,
                'gap': 2 * A[id1],  # m
                'fint': fint,
                'tilt': np.rad2deg(tilt),  # deg
                'ang': np.rad2deg(ang),  # deg
                'e1': np.rad2deg(e1),  # deg
                'e2': np.rad2deg(e2),  # deg
                'BL': T2kG * BL,  # kG-m
                'B': charge * B,
                'k1': k1,
                'GL': T2kG * GL,  # kG
                'G': charge * G,
                'sname': sname,
                'sval': sval,
                'polarity': polarity,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)},
                **{f'm{k+1}': coorm[k] for k in range(6)}
            })
            # BSY coordinates

            for k in range(6):
                SBEN[-1][f'c1{k+1}'] = []
                SBEN[-1][f'm1{k+1}'] = []
            if cBSY:
                id = [strmatch(mname1,N1,True),strmatch(mname2,N1,True)]
                if any(id):
                    id1 = id[0][0]  # first piece (beam center)
                    idi = id1 - 1  # beam in
                    ido = id[1][-1]  # beam out
                    suml1 = S1[id1]  # m
                    coori1 = np.copy(coor1[idi, :])  # m,rad
                    coorc1 = np.copy(coor1[id1, :])  # m,rad
                    cooro1 = np.copy(coor1[ido, :])  # m,rad
                    coorm1 = np.zeros(coorc1.shape)  # m,rad (magnet steel center)
                    if mname in KSname:
                        jd = strmatch(f'D{mname}',N1)
                        coorm1 = np.copy(coor1[jd[0], :])
                        coorm1[3] = 0
                    else:
                        if chicane1 | chicane2:
                            coorm1[:3] = np.mean([coori1[:3], cooro1[:3]], axis=0)
                            if chicane1:
                                coorm1[3:6] = np.copy(coori1[3:6])
                            else:
                                coorm1[3:6] = np.copy(cooro1[3:6])
                        else:
                            coorm1[:3] = (coori1[:3] + cooro1[:3] + 2 * coorc1[:3]) / 4
                            coorm1[3:6] = np.copy(coorc1[3:6])
                    if pname in ['DMPS', 'DMPH']:
                        coorm1[3] = coorc1[3]  # dump line magnet coords set in FixDumpCoords
                    elif pname == 'BSYA':
                        coorm1[3] = coorc1[3]  # dump line magnet coords set in FixAlineCoords
                    else:
                        coorm1[3] = tilt  # remove "creeping" rolls from non-rolled SBENs
                    SBEN[-1]['suml1'] = suml1
                    for k in range(6):
                        SBEN[-1][f'c1{k+1}'] = coorc1[k]
                        SBEN[-1][f'm1{k+1}'] = coorm1[k]
                    if not SBEN[-1]['sector']:
                        SBEN[-1]['sector'] = SECTORS1[id1].strip()
                    SBEN[-1]['ucell'] = UCELL[id1].strip()

            # UND coordinates

            SBEN[-1]['suml2'] = []
            for k in range(6):
                SBEN[-1][f'c2{k+1}'] = []
                SBEN[-1][f'm2{k+1}'] = []
            if cUND:
                id = [strmatch(mname1,N2,True),strmatch(mname2,N2,True)]
                if any(id) > 0:
                    id1 = id[0][0]  # first piece (beam center)
                    idi = id1 - 1  # beam in
                    ido = id[1][-1]  # beam out
                    suml2 = S2[id1]  # m
                    coori2 = coor2[idi, :]  # m,rad
                    coorc2 = coor2[id1, :]  # m,rad
                    cooro2 = coor2[ido, :]  # m,rad
                    coorm2 = np.zeros(coorc2.shape)  # m,rad (magnet steel center)
                    if mname in KSname:
                        jd = strmatch(f'D{mname}',N2)
                        coorm2 = coor2[jd[0], :]
                        coorm2[3] = 0
                    else:
                        if chicane1 | chicane2:
                            coorm2[:3] = np.mean([coori2[:3], cooro2[:3]], axis=0)
                            if chicane1:
                                coorm2[3:6] = coori2[3:6]
                            else:
                                coorm2[3:6] = cooro2[3:6]
                        else:
                            coorm2[:3] = (coori2[:3] + cooro2[:3] + 2 * coorc2[:3]) / 4
                            coorm2[3:6] = coorc2[3:6]
                    if pname in ['DMPS', 'DMPH']:
                        coorm2[3] = coorc2[3]  # dump line magnet coords set in FixDumpCoords
                    elif pname == 'BSYA':
                        coorm2[3] = coorc2[3]  # dump line magnet coords set in FixAlineCoords
                    else:
                        coorm2[3] = tilt  # remove "creeping" rolls from non-rolled SBENs
                    SBEN[-1]['suml2'] = suml2
                    for k in range(6):
                        SBEN[-1][f'c2{k+1}'] = coorc2[k]
                        SBEN[-1][f'm2{k+1}'] = coorm2[k]

    elif kwn == 'QUAD':
        QUAD = []
        for mname in name:
            id = strmatch(mname,N,True)
            id1 = id[0]  # first segment (beam center)
            sdsp = Sd[id1]  # m
            suml = S[id1]  # m
            energy = E[id1]  # GeV
            leng = np.sum(L[id])  # m
            bore = 2 * A[id1]  # m
            tilt = P[id1, 3]  # rad
            k1 = P[id1, 1]  # 1/m^2
            if abs(k1) < kmin:
                k1 = 0
            EeV = 1e9 * energy  # eV
            brho = np.sqrt(EeV ** 2 - Er ** 2) / clight  # T-m
            if leng == 0:
                G = 0  # T/m
                GL = brho * k1  # T
                sname = 'kG2T'
                sval = 1 / T2kG
            else:
                G = brho * k1  # T/m
                GL = G * leng  # T
                sname = 'kG2T_Gdl2G'
                sval = 1 / (leng * T2kG)
            polarity = -np.sign(k1 + np.finfo(float).eps)  # add eps so that sign=1 when k1=0
            coorc = np.copy(coor[id1, :])  # m,rad
            QUAD.append({
                'idf': idf[id1],
                'id': idd[id1],
                'area': area[ida[id1]]['name'],
                'parent': area[ida[id1]]['parent'],
                'sector': SECTORS[id1].strip(),
                'ucell': [],
                'prim': FDN[id1],
                'name': mname,
                'type': T[id1].strip(),
                'energy': energy,
                'leng': leng,
                'bore': bore,
                'tilt': np.rad2deg(tilt),  # deg
                'k1': k1,
                'GL': T2kG * GL,  # kG
                'G': charge * G,
                'sname': sname,
                'sval': sval,
                'polarity': polarity,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)},
                **{f'm{k+1}': [] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                QUAD[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    id1 = id[0]  # first segment (beam center)
                    suml1 = S1[id1]  # m
                    coorc1 = np.copy(coor1[id1, :])  # m,rad
                    QUAD[-1]['suml1'] = suml1
                    for k in range(6):
                        QUAD[-1][f'c1{k+1}'] = coorc1[k]
                    if not QUAD[-1]['sector']:
                        QUAD[-1]['sector'] = SECTORS1[id1].strip()
                    QUAD[-1]['ucell'] = UCELL[id1].strip()

            # UND coordinates

            QUAD[-1]['suml2'] = []
            for k in range(6):
                QUAD[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    id1 = id[0]  # first segment (beam center)
                    suml2 = S2[id1]  # m
                    coorc2 = coor2[id1, :]  # m,rad
                    QUAD[-1]['suml2'] = suml2
                    for k in range(6):
                        QUAD[-1][f'c2{k+1}'] = coorc2[k]

    elif kwn == 'SEXT':
        SEXT = []
        for mname in name:
            id = strmatch(mname,N,True)
            id1 = id[0]  # first half (beam center)
            sdsp = Sd[id1]  # m
            suml = S[id1]  # m
            energy = E[id1]  # GeV
            leng = np.sum(L[id])  # m
            bore = 2 * A[id1]  # m
            tilt = P[id1, 3]  # rad
            k2 = P[id1, 2]  # 1/m^3
            if abs(k2) < kmin:
                k2 = 0
            EeV = 1e9 * energy  # eV
            brho = np.sqrt(EeV ** 2 - Er ** 2) / clight  # T-m
            Gp = brho * k2  # T/m
            GpL = Gp * leng  # T
            if leng == 0:
                sname = 'kG2T'
                sval = 1 / T2kG
            else:
                sname = 'kG2T_Gpdl2Gp'
                sval = 1 / (leng * T2kG)
            polarity = -np.sign(k2 + np.finfo(float).eps)  # add eps so that sign=1 when k2=0
            coorc = np.copy(coor[id1, :])  # m,rad
            SEXT.append({
                'idf': idf[id1],
                'id': idd[id1],
                'area': area[ida[id1]]['name'],
                'parent': area[ida[id1]]['parent'],
                'sector': SECTORS[id1].strip(),
                'ucell': [],
                'prim': FDN[id1],
                'name': mname,
                'type': T[id1].strip(),
                'energy': energy,
                'leng': leng,
                'bore': bore,
                'tilt': np.rad2deg(tilt),  # deg
                'k2': k2,
                'GpL': T2kG * GpL,  # kG/m
                'Gp': charge * Gp,
                'sname': sname,
                'sval': sval,
                'polarity': polarity,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                SEXT[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    id1 = id[0]  # first segment (beam center)
                    suml1 = S1[id1]  # m
                    coorc1 = np.copy(coor1[id1, :])  # m,rad
                    SEXT[-1]['suml1'] = suml1
                    for k in range(6):
                        SEXT[-1][f'c1{k+1}'] = coorc1[k]
                    if not SEXT[-1]['sector']:
                        SEXT[-1]['sector'] = SECTORS1[id1].strip()
                    SEXT[-1]['ucell'] = UCELL[id1].strip()

            # UND coordinates

            SEXT[-1]['suml2'] = []
            for k in range(6):
                SEXT[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    id1 = id[0]  # first segment (beam center)
                    suml2 = S2[id1]  # m
                    coorc2 = coor2[id1, :]  # m,rad
                    SEXT[-1]['suml2'] = suml2
                    for k in range(6):
                        SEXT[-1][f'c2{k+1}'] = coorc2[k]

    elif kwn == 'SOLE':
        SOLE = []
        for mname in name:
            id = strmatch(mname,N,True)
            id1 = id[0]
            ide = [id1 - 1, id[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m
            suml = np.mean(S[ide])  # m
            energy = np.mean(E[ide])  # GeV
            leng = np.sum(L[id])  # m
            bore = 2 * A[id1]  # m
            ks = P[id1, 4]  # 1/m
            if abs(ks) < kmin:
                ks = 0
            EeV = 1e9 * energy  # eV
            brho = np.sqrt(EeV**2 - Er**2) / clight  # T-m
            B = brho * ks  # T
            BL = B * leng  # T-m
            if leng == 0:
                sname = 'kG2T'
                sval = 1 / T2kG
            else:
                sname = 'kG2T_Bdl2B'
                sval = 1 / (leng * T2kG)
            polarity = -np.sign(ks + np.finfo(float).eps)  # add eps so that sign=1 when ks=0
            coorc = np.mean(coor[ide], axis=0)  # m, rad
            SOLE.append({
                'idf': idf[id1],
                'id': idd[id1],
                'area': area[ida[id1]]['name'],
                'parent': area[ida[id1]]['parent'],
                'sector': SECTORS[id1].strip(),
                'ucell': [],
                'prim': FDN[id1],
                'name': mname,
                'type': T[id1].strip(),
                'energy': energy,
                'leng': leng,
                'bore': bore,
                'ks': ks,
                'BL': T2kG * BL,  # kG-m
                'B': charge * B,
                'sname': sname,
                'sval': sval,
                'polarity': polarity,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                SOLE[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    id1 = id[0]  # first segment (beam center)
                    ide = [id1 - 1, id[-1]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad
                    SOLE[-1]['suml1'] = suml1
                    for k in range(6):
                        SOLE[-1][f'c1{k+1}'] = coorc1[k]
                    if not SOLE[-1]['sector']:
                        SOLE[-1]['sector'] = SECTORS1[id1].strip()
                    SOLE[-1]['ucell'] = UCELL[id1].strip()

            # UND coordinates

            SOLE[-1]['suml2'] = []
            for k in range(6):
                SOLE[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2)
                if len(id) > 0:
                    id1 = id[0]  # first segment (beam center)
                    ide = [id1 - 1, id[-1]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad
                    SOLE[-1]['suml2'] = suml2
                    for k in range(6):
                        SOLE[-1][f'c2{k+1}'] = coorc2[k]

    elif kwn == 'MATR':
        MATR = []
        for mname in name:
            id = strmatch(mname,N,True)
            id1 = id[0]  # first half (beam center)
            sdsp = Sd[id1]  # m
            suml = S[id1]  # m
            energy = E[id1]  # GeV
            leng = np.sum(L[id])  # m
            undl = P2[id1, 0]  # m
            undk = P2[id1, 1]  # 1
            coorc = np.copy(coor[id1])  # m, rad
            MATR.append({
                'idf': idf[id1],
                'id': idd[id1],
                'area': area[ida[id1]]['name'],
                'parent': area[ida[id1]]['parent'],
                'sector': SECTORS[id1].strip(),
                'ucell': [],
                'prim': FDN[id1],
                'name': mname,
                'type': T[id1].strip(),
                'energy': energy,
                'leng': leng,
                'lambda': undl,
                'k': undk,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                MATR[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    id1 = id[0]  # first segment (beam center)
                    suml1 = S1[id1]  # m
                    coorc1 = np.copy(coor1[id1])  # m, rad
                    MATR[-1]['suml1'] = suml1
                    for k in range(6):
                        MATR[-1][f'c1{k+1}'] = coorc1[k]
                    if not MATR[-1]['sector']:
                        MATR[-1]['sector'] = SECTORS1[id1].strip()
                    MATR[-1]['ucell'] = UCELL[id1].strip()

            # UND coordinates

            MATR[-1]['suml2'] = []
            for k in range(6):
                MATR[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    id1 = id[0]  # first segment (beam center)
                    suml2 = S2[id1]  # m
                    coorc2 = coor2[id1]  # m, rad
                    MATR[-1]['suml2'] = suml2
                    for k in range(6):
                        MATR[-1][f'c2{k+1}'] = coorc2[k]

    elif kwn == 'RCOL':
        RCOL = []
        for mname in name:
            id = strmatch(mname,N,True)[0]
            ide = [id - 1, id]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id]  # GeV
            leng = L[id]  # m
            xgap = 2 * P[id, 3]  # m
            ygap = 2 * P[id, 4]  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            RCOL.append({
                'idf': idf[id],
                'id': idd[id],
                'area': area[ida[id]]['name'],
                'parent': area[ida[id]]['parent'],
                'sector': SECTORS[id].strip(),
                'ucell': [],
                'prim': FDN[id],
                'name': mname,
                'type': T[id].strip(),
                'energy': energy,
                'leng': leng,
                'xgap': xgap,
                'ygap': ygap,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                RCOL[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[0]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    RCOL[-1]['suml1'] = suml1
                    for k in range(6):
                        RCOL[-1][f'c1{k+1}'] = coorc1[k]
                    if not RCOL[-1]['sector']:
                        RCOL[-1]['sector'] = SECTORS1[id[0]].strip()
                    RCOL[-1]['ucell'] = UCELL[id[0]].strip()

            # UND coordinates

            RCOL[-1]['suml2'] = []
            for k in range(6):
                RCOL[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2)
                if len(id) > 0:
                    ide = [id[0] - 1, id[0]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    RCOL[-1]['suml2'] = suml2
                    for k in range(6):
                        RCOL[-1][f'c2{k+1}'] = coorc2[k]

    elif kwn == 'ECOL':
        ECOL = []
        for mname in name:
            id = strmatch(mname,N,True)[0]
            ide = [id - 1, id]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id]  # GeV
            leng = L[id]  # m
            xbore = 2 * P[id, 3]  # m
            ybore = 2 * P[id, 4]  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            ECOL.append({
                'idf': idf[id],
                'id': idd[id],
                'area': area[ida[id]]['name'],
                'parent': area[ida[id]]['parent'],
                'sector': SECTORS[id].strip(),
                'ucell': [],
                'prim': FDN[id],
                'name': mname,
                'type': T[id].strip(),
                'energy': energy,
                'leng': leng,
                'xbore': xbore,
                'ybore': ybore,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                ECOL[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[0]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    ECOL[-1]['suml1'] = suml1
                    for k in range(6):
                        ECOL[-1][f'c1{k+1}'] = coorc1[k]
                    if not ECOL[-1]['sector']:
                        ECOL[-1]['sector'] = SECTORS1[id[0]].strip()
                    ECOL[-1]['ucell'] = UCELL[id[0]].strip()

            # UND coordinates

            ECOL[-1]['suml2'] = []
            for k in range(6):
                ECOL[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[0]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    ECOL[-1]['suml2'] = suml2
                    for k in range(6):
                        ECOL[-1][f'c2{k+1}'] = coorc2[k]

    elif kwn == 'SROT':
        SROT = []
        for mname in name:
            id = strmatch(mname,N,True)[0]
            ide = [id - 1, id]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id]  # GeV
            leng = L[id]  # m
            ang = np.rad2deg(P[id, 4])  # deg
            if abs(ang) < amin:
                ang = 0
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            SROT.append({
                'idf': idf[id],
                'id': idd[id],
                'area': area[ida[id]]['name'],
                'parent': area[ida[id]]['parent'],
                'sector': SECTORS[id].strip(),
                'ucell': [],
                'prim': FDN[id],
                'name': mname,
                'type': T[id].strip(),
                'energy': energy,
                'leng': leng,
                'ang': ang,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                SROT[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[0]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    SROT[-1]['suml1'] = suml1
                    for k in range(6):
                        SROT[-1][f'c1{k+1}'] = coorc1[k]
                    if not SROT[-1]['sector']:
                        SROT[-1]['sector'] = SECTORS1[id[0]].strip()
                    SROT[-1]['ucell'] = UCELL[id[0]].strip()

            # UND coordinates

            SROT[-1]['suml2'] = []
            for k in range(6):
                SROT[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[0]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    SROT[-1]['suml2'] = suml2
                    for k in range(6):
                        SROT[-1][f'c2{k+1}'] = coorc2[k]

    elif kwn == 'MULT':
        MULT = []
        for mname in name:
            id = strmatch(mname,N,True)[0]
            if id == 1:
                idi = 1
            else:
                idi = id - 1  # beam in
            sdsp = Sd[id]  # m (beam center)
            suml = S[id]  # m (beam center)
            energy = E[id]  # GeV
            leng = np.sum(L[id])  # m
            k1 = P[id, 1]  # 1/m^2
            if abs(k1) < kmin:
                k1 = 0
            EeV = 1e9 * energy  # eV
            tilt = P[id, 3]  # rad
            brho = np.sqrt(EeV ** 2 - Er ** 2) / clight  # T-m
            if leng == 0:
                G = 0  # T/m
                GL = brho * k1  # T
                sname = 'kG2T'
                sval = 1 / T2kG
            else:
                G = brho * k1  # T/m
                GL = G * leng  # T
                sname = 'kG2T_Gdl2G'
                sval = 1 / (leng * T2kG)
            polarity = -np.sign(k1 + np.finfo(float).eps)  # add eps so that sign=1 when k1=0
            #coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            coorc = coor[id,:] # m, rad (beam center)
            t = T[id].strip()
            aper = 2 * A[id]  # m
            MULT.append({
                'idf': idf[id],
                'id': idd[id],
                'area': area[ida[id]]['name'],
                'parent': area[ida[id]]['parent'],
                'sector': SECTORS[id].strip(),
                'ucell': [],
                'prim': FDN[id],
                'bore': aper,
                'k1': k1,
                'tilt': np.rad2deg(tilt),  # deg
                'G': charge * G,
                'GL': T2kG * GL,  # kG
                'polarity': polarity,
                'name': mname,
                'sname': sname,
                'sval': sval,
                'type': T[id].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)},
                **{f'm{k+1}': [] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                MULT[-1][f'c1{k+1}'] = []
                MULT[-1][f'm1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    id = id[0]
                    suml1 = S1[id] 
                    coorc1 = coor1[id]
                    MULT[-1]['suml1'] = suml1
                    for k in range(6):
                        MULT[-1][f'c1{k+1}'] = coorc1[k]
                    if not MULT[-1]['sector']:
                        MULT[-1]['sector'] = SECTORS1[id].strip()
                    MULT[-1]['ucell'] = UCELL[id].strip()

            # UND coordinates

            MULT[-1]['suml2'] = []
            for k in range(6):
                MULT[-1][f'c2{k+1}'] = []
                MULT[-1][f'm2{k+1}'] = []  # for MULT
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    id = id[0]
                    suml2 = S2[id]
                    coorc2 = coor2[id]
                    MULT[-1]['suml2'] = suml2
                    for k in range(6):
                        MULT[-1][f'c2{k+1}'] = coorc2[k]

    elif kwn == 'INST':
        INST = []
        for mname in name:
            id = strmatch(mname,N,True)
            if id[0] == 1:
                idi = 1
            else:
                idi = id[0] - 1  # beam in
            ide = [idi, id[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id[0]]  # GeV
            leng = np.sum(L[id])  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            t = T[id[0]].strip()
            INST.append({
                'idf': idf[id[0]],
                'id': idd[id[0]],
                'area': area[ida[id[0]]]['name'],
                'parent': area[ida[id[0]]]['parent'],
                'sector': SECTORS[id[0]].strip(),
                'ucell': [],
                'prim': FDN[id[0]],
                'name': mname,
                'type': T[id[0]].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)},
                **{f'm{k+1}': [] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                INST[-1][f'c1{k+1}'] = []
                INST[-1][f'm1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    INST[-1]['suml1'] = suml1
                    for k in range(6):
                        INST[-1][f'c1{k+1}'] = coorc1[k]
                    if not INST[-1]['sector']:
                        INST[-1]['sector'] = SECTORS1[id[0]].strip()
                    INST[-1]['ucell'] = UCELL[id[0]].strip()

            # UND coordinates

            INST[-1]['suml2'] = []
            for k in range(6):
                INST[-1][f'c2{k+1}'] = []
                INST[-1][f'm2{k+1}'] = []  # for INST
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    INST[-1]['suml2'] = suml2
                    for k in range(6):
                        INST[-1][f'c2{k+1}'] = coorc2[k]

    elif kwn == 'HKIC':
        HKIC = []
        for mname in name:
            id = strmatch(mname,N,True)
            if id[0] == 1:
                idi = 1
            else:
                idi = id[0] - 1  # beam in
            ide = [idi, id[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id[0]]  # GeV
            leng = np.sum(L[id])  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            t = T[id[0]].strip()
            HKIC.append({
                'idf': idf[id[0]],
                'id': idd[id[0]],
                'area': area[ida[id[0]]]['name'],
                'parent': area[ida[id[0]]]['parent'],
                'sector': SECTORS[id[0]].strip(),
                'ucell': [],
                'prim': FDN[id[0]],
                'name': mname,
                'type': T[id[0]].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                HKIC[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    HKIC[-1]['suml1'] = suml1
                    for k in range(6):
                        HKIC[-1][f'c1{k+1}'] = coorc1[k]
                    if not HKIC[-1]['sector']:
                        HKIC[-1]['sector'] = SECTORS1[id[0]].strip()
                    HKIC[-1]['ucell'] = UCELL[id[0]].strip()

            HKIC[-1]['suml2'] = []
            for k in range(6):
                HKIC[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    HKIC[-1]['suml2'] = suml2
                    for k in range(6):
                        HKIC[-1][f'c2{k+1}'] = coorc2[k]

    elif kwn == 'VKIC':
        VKIC = []
        for mname in name:
            id = strmatch(mname,N,True)
            if id[0] == 1:
                idi = 1
            else:
                idi = id[0] - 1  # beam in
            ide = [idi, id[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id[0]]  # GeV
            leng = np.sum(L[id])  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            t = T[id[0]].strip()
            VKIC.append({
                'idf': idf[id[0]],
                'id': idd[id[0]],
                'area': area[ida[id[0]]]['name'],
                'parent': area[ida[id[0]]]['parent'],
                'sector': SECTORS[id[0]].strip(),
                'ucell': [],
                'prim': FDN[id[0]],
                'name': mname,
                'type': T[id[0]].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                VKIC[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    VKIC[-1]['suml1'] = suml1
                    for k in range(6):
                        VKIC[-1][f'c1{k+1}'] = coorc1[k]
                    if not VKIC[-1]['sector']:
                        VKIC[-1]['sector'] = SECTORS1[id[0]].strip()
                    VKIC[-1]['ucell'] = UCELL[id[0]].strip()

            VKIC[-1]['suml2'] = []
            for k in range(6):
                VKIC[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    VKIC[-1]['suml2'] = suml2
                    for k in range(6):
                        VKIC[-1][f'c2{k+1}'] = coorc2[k]
    elif kwn == 'MONI':
        MONI = []
        for mname in name:
            id = strmatch(mname,N,True)
            if id[0] == 1:
                idi = 1
            else:
                idi = id[0] - 1  # beam in
            ide = [idi, id[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id[0]]  # GeV
            leng = np.sum(L[id])  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            t = T[id[0]].strip()
            MONI.append({
                'idf': idf[id[0]],
                'id': idd[id[0]],
                'area': area[ida[id[0]]]['name'],
                'parent': area[ida[id[0]]]['parent'],
                'sector': SECTORS[id[0]].strip(),
                'ucell': [],
                'prim': FDN[id[0]],
                'name': mname,
                'type': T[id[0]].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                MONI[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    MONI[-1]['suml1'] = suml1
                    for k in range(6):
                        MONI[-1][f'c1{k+1}'] = coorc1[k]
                    if not MONI[-1]['sector']:
                        MONI[-1]['sector'] = SECTORS1[id[0]].strip()
                    MONI[-1]['ucell'] = UCELL[id[0]].strip()

            MONI[-1]['suml2'] = []
            for k in range(6):
                MONI[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    MONI[-1]['suml2'] = suml2
                    for k in range(6):
                        MONI[-1][f'c2{k+1}'] = coorc2[k]
    elif kwn == 'WIRE':
        WIRE = []
        for mname in name:
            id = strmatch(mname,N,True)
            if id[0] == 1:
                idi = 1
            else:
                idi = id[0] - 1  # beam in
            ide = [idi, id[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id[0]]  # GeV
            leng = np.sum(L[id])  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            t = T[id[0]].strip()
            WIRE.append({
                'idf': idf[id[0]],
                'id': idd[id[0]],
                'area': area[ida[id[0]]]['name'],
                'parent': area[ida[id[0]]]['parent'],
                'sector': SECTORS[id[0]].strip(),
                'ucell': [],
                'prim': FDN[id[0]],
                'name': mname,
                'type': T[id[0]].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                WIRE[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    WIRE[-1]['suml1'] = suml1
                    for k in range(6):
                        WIRE[-1][f'c1{k+1}'] = coorc1[k]
                    if not WIRE[-1]['sector']:
                        WIRE[-1]['sector'] = SECTORS1[id[0]].strip()
                    WIRE[-1]['ucell'] = UCELL[id[0]].strip()

            WIRE[-1]['suml2'] = []
            for k in range(6):
                WIRE[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    WIRE[-1]['suml2'] = suml2
                    for k in range(6):
                        WIRE[-1][f'c2{k+1}'] = coorc2[k]
    elif kwn == 'PROF':
        PROF = []
        for mname in name:
            id = strmatch(mname,N,True)
            if id[0] == 1:
                idi = 1
            else:
                idi = id[0] - 1  # beam in
            ide = [idi, id[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id[0]]  # GeV
            leng = np.sum(L[id])  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            t = T[id[0]].strip()
            PROF.append({
                'idf': idf[id[0]],
                'id': idd[id[0]],
                'area': area[ida[id[0]]]['name'],
                'parent': area[ida[id[0]]]['parent'],
                'sector': SECTORS[id[0]].strip(),
                'ucell': [],
                'prim': FDN[id[0]],
                'name': mname,
                'type': T[id[0]].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                PROF[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    PROF[-1]['suml1'] = suml1
                    for k in range(6):
                        PROF[-1][f'c1{k+1}'] = coorc1[k]
                    if not PROF[-1]['sector']:
                        PROF[-1]['sector'] = SECTORS1[id[0]].strip()
                    PROF[-1]['ucell'] = UCELL[id[0]].strip()

            PROF[-1]['suml2'] = []
            for k in range(6):
                PROF[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    PROF[-1]['suml2'] = suml2
                    for k in range(6):
                        PROF[-1][f'c2{k+1}'] = coorc2[k]
    elif kwn == 'IMON':
        IMON = []
        for mname in name:
            id = strmatch(mname,N,True)
            if id[0] == 1:
                idi = 1
            else:
                idi = id[0] - 1  # beam in
            ide = [idi, id[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id[0]]  # GeV
            leng = np.sum(L[id])  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            t = T[id[0]].strip()
            IMON.append({
                'idf': idf[id[0]],
                'id': idd[id[0]],
                'area': area[ida[id[0]]]['name'],
                'parent': area[ida[id[0]]]['parent'],
                'sector': SECTORS[id[0]].strip(),
                'ucell': [],
                'prim': FDN[id[0]],
                'name': mname,
                'type': T[id[0]].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                IMON[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    IMON[-1]['suml1'] = suml1
                    for k in range(6):
                        IMON[-1][f'c1{k+1}'] = coorc1[k]
                    if not IMON[-1]['sector']:
                        IMON[-1]['sector'] = SECTORS1[id[0]].strip()
                    IMON[-1]['ucell'] = UCELL[id[0]].strip()

            IMON[-1]['suml2'] = []
            for k in range(6):
                IMON[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    IMON[-1]['suml2'] = suml2
                    for k in range(6):
                        IMON[-1][f'c2{k+1}'] = coorc2[k]
    elif kwn == 'BLMO':
        BLMO = []
        for mname in name:
            id = strmatch(mname,N,True)
            if id[0] == 1:
                idi = 1
            else:
                idi = id[0] - 1  # beam in
            ide = [idi, id[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[id[0]]  # GeV
            leng = np.sum(L[id])  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            t = T[id[0]].strip()
            BLMO.append({
                'idf': idf[id[0]],
                'id': idd[id[0]],
                'area': area[ida[id[0]]]['name'],
                'parent': area[ida[id[0]]]['parent'],
                'sector': SECTORS[id[0]].strip(),
                'ucell': [],
                'prim': FDN[id[0]],
                'name': mname,
                'type': T[id[0]].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                BLMO[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml1 = np.mean(S1[ide])  # m (beam center)
                    coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                    BLMO[-1]['suml1'] = suml1
                    for k in range(6):
                        BLMO[-1][f'c1{k+1}'] = coorc1[k]
                    if not BLMO[-1]['sector']:
                        BLMO[-1]['sector'] = SECTORS1[id[0]].strip()
                    BLMO[-1]['ucell'] = UCELL[id[0]].strip()

            BLMO[-1]['suml2'] = []
            for k in range(6):
                BLMO[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                    suml2 = np.mean(S2[ide])  # m (beam center)
                    coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                    BLMO[-1]['suml2'] = suml2
                    for k in range(6):
                        BLMO[-1][f'c2{k+1}'] = coorc2[k]
    elif kwn == 'MARK':
        MARK = []
        for mname in name:
            id = strmatch(mname,N,True)[0]
            sdsp = Sd[id]  # m
            suml = S[id]  # m
            energy = E[id]  # GeV
            coorc = np.copy(coor[id])
            MARK.append({
                'idf': idf[id],
                'id': idd[id],
                'area': area[ida[id]]['name'],
                'parent': area[ida[id]]['parent'],
                'sector': SECTORS[id].strip(),
                'ucell': [],
                'leng': None,
                'prim': FDN[id],
                'name': mname,
                'type': T[id].strip(),
                'energy': energy,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates

            for k in range(6):
                MARK[-1][f'c1{k+1}'] = []
            if cBSY:
                id = strmatch(mname,N1,True)
                if len(id) > 0:
                    suml1 = S1[id[0]]  # m (beam center)
                    coorc1 = np.copy(coor1[id[0]])  # m, rad (beam center)
                    MARK[-1]['suml1'] = suml1
                    for k in range(6):
                        MARK[-1][f'c1{k+1}'] = coorc1[k]
                    if not MARK[-1]['sector']:
                        MARK[-1]['sector'] = SECTORS1[id[0]].strip()
                    MARK[-1]['ucell'] = UCELL[id[0]].strip()

            # UND coordinates

            MARK[-1]['suml2'] = []
            for k in range(6):
                MARK[-1][f'c2{k+1}'] = []
            if cUND:
                id = strmatch(mname,N2,True)
                if len(id) > 0:
                    suml2 = S2[id]  # m (beam center)
                    coorc2 = coor2[id]  # m, rad (beam center)
                    MARK[-1]['suml2'] = suml2
                    for k in range(6):
                        MARK[-1][f'c2{k+1}'] = coorc2[k]

import scipy.io as sio

def fix_power_fraction(lcav):
    #fname = r'V:\LCLS\Users\Woodley\AD_ACCEL\20190613_13JUN19\RDB\RDBdata'
    #fname = f'{script_dir}/RDBdata.mat'
    fname = f'{script_dir}/LCAVITY_PowerFraction.mat'
    old = sio.loadmat(fname)['LCAV']
    
    name = [x['name'] for x in old[0]]
    powr = [float(x['power'][0][0]) for x in old[0]]
    
    for cav in lcav:
        if np.isnan(cav['power']):
            id = [i for i, x in enumerate(name) if x == cav['name']]
            if len(id) != 1:
                raise ValueError(f"{cav['name']} not found!")
            cav['power'] = powr[id[0]]
    
    return lcav


# fix LCAV power fraction values (for deactivated klystrons)
LCAV = fix_power_fraction(LCAV)

def add_eic(inst):
    # Add EIC Faraday cup
    name = [x['name'] for x in inst]
    id = name.index('CATHODEB')
    temp = inst[id].copy()
    temp.id = 59
    temp.area = 'EIC'
    temp.name = 'FC00EIC'
    temp.type = 'Faraday cup'
    temp.sdsp = -7.044667
    temp.suml = 3.0
    temp.c1 = -7.044667
    inst.append(temp)
    return inst

# deferred devices
DEPR = []
nDEPR = 0
pname = [x['parent'] for x in area]

# gather key structures into KEYLIST
KEYLIST = [
    LCAV, SBEN, QUAD, SEXT, SOLE, MATR, RCOL, ECOL, SROT,
    HKIC, VKIC, MONI, WIRE, PROF, IMON, BLMO, INST,
    MARK, MULT
]

for KEY in KEYLIST:
    for m in range(len(KEY)):
        t = KEY[m]['type']
        if t and t[0] == '@':
            deplev = int(t[1])
            if len(t) > 2:
                t = t[3:]  # skip ","
            else:
                t = ''
            nDEPR += 1
            id = strmatch(KEY[m]['parent'],pname)
            if KEY == 'SBEN':
                z_use = KEY[m]['m1']
            else:
                z_use = KEY[m]['c1']
            DEPR.append({
                'id':KEY[m]['id'],
                'parent':KEY[m]['parent'],
                'ida': id[0]+1,
                'prim': KEY[m]['prim'],
                'name': KEY[m]['name'],
                'z': z_use,
                'type': t,
                'level': deplev,
                })

            KEY[m]['parent'] = '*' + KEY[m]['parent']
            KEY[m]['area'] = '*' + KEY[m]['area']
            KEY[m]['type'] = t

# ------------------------------------------------------------------------------
# Fix magnet coordinates ...
# ------------------------------------------------------------------------------
def FixMagnetCoords(SBEN, QUAD, INST, K, N, L, P, coor, cflag):
    # Set special magnet coordinates for:
    # - R56 compensation chicanes
    # - self-seeding chicanes and Cavity-Based-XFEL (CBXFEL) chicanes
    # - safety dump bends
    # - Lambertson septa
    # - rolled vertical bends, kickers, and septa
    # - spreader kickers
    # - CUSXR extraction magnets
    # - QDG001 and QDG003
    # - SXRSS optical components
    #
    #   cflag : []=linac, 1=BSY, 2=UND
    #
    # NOTE: see the MAD User's Reference Manual (v8.19), Section 1.3
    if cflag is None:
        n1 = 0  # all chicanes have linac coordinates
    else:
        n1 = 2  # CCDLU and CCDLD chicanes do not have BSY or UND coordinates
    Xgun = 0.28
    Ygun = -0.99
    Bname = [i['name'] for i in SBEN]
    Qname = [i['name'] for i in QUAD]
    Iname = [i['name'] for i in INST]

    # R56 compensation chicanes
    # coor=[z,x,y,roll,-pitch,yaw] (SYMBOLS coordinates)

    R56name = ['CCDLU', 'CCDLD', 'CC31B', 'CC32B', 'CC31', 'CC32', 'CC35', 'CC36']
    off = 0.005  # 5 mm offset
    for name in R56name[n1:]:
        id1 = strmatch(f"{name}BEG",N)[0]
        id2 = strmatch(f"{name}END",N)[0]
        id = range(id1, id2 + 1)
        jd1 = [i for i,x in enumerate(K) if x == 'SBEN']
        idb = intersection(id,jd1)[::2]
        ang = P[idb[0], 0]
        X, Y, Z, yaw, pitch, roll = coor[id, 1], coor[id, 2], coor[id, 0], coor[id1, 5], -coor[id1, 4], coor[id1, 3]
        O1 = np.array([[np.cos(yaw), 0, np.sin(yaw)], [0, 1, 0], [-np.sin(yaw), 0, np.cos(yaw)]])
        O2 = np.array([[1, 0, 0], [0, np.cos(pitch), np.sin(pitch)], [0, -np.sin(pitch), np.cos(pitch)]])
        O3 = np.array([[np.cos(roll), -np.sin(roll), 0], [np.sin(roll), np.cos(roll), 0], [0, 0, 1]])
        O = O1 @ O2 @ O3
        t = np.linalg.solve(O, np.array([X, Y, Z]))  # remove yaw, pitch, and roll
        Xr, Yr, Zr = t[0], t[1], t[2]
        dX = -off * np.sign(ang + np.finfo(float).eps)  # offset in chicane direction
        Xr = Xr[0] + dX * np.ones_like(Xr)
        t = O @ np.array([Xr, Yr, Zr])  # restore roll, pitch, and yaw
        Xm, Ym, Zm = t[0], t[1], t[2]
        for m in range(len(idb)):
            name = N[idb[m]].strip()[:-1] #remove last character
            jdb = strmatch(name,[N[i] for i in id])[0]
            jd = strmatch(name,Bname)[0]
            SBEN[jd][f'm{cflag or ""}2'] = Xm[jdb]
            SBEN[jd][f'm{cflag or ""}3'] = Ym[jdb]
            SBEN[jd][f'm{cflag or ""}1'] = Zm[jdb]

    # self-seeding chicane bends and Cavity-Based-XFEL bends

    name = ['BCXHS1', 'BCXHS2', 'BCXHS3', 'BCXHS4',  # HXRSS self-seeding chicane
            'BCXSS1', 'BCXSS2', 'BCXSS3', 'BCXSS4',  # SXRSS self-seeding chicane
            'BCXXL1', 'BCXXL2', 'BCXXL3', 'BCXXL4',  # XLEAP-II self-seeding chicane
            'BCXCBX11', 'BCXCBX12', 'BCXCBX13', 'BCXCBX14',  # CBXFEL chicane #1
            'BCXCBX21', 'BCXCBX22', 'BCXCBX23', 'BCXCBX24']  # CBXFEL chicane #2
    dX = 1e-3 * np.array([0, -2.39, -2.39, 0,  # HXRSS
                          +1, +9.7, +9.7, +1,  # SXRSS
                          -5, -12, -12, -5,  # XLEAP-II
                          +1, +9.7, +9.7, +1,  # CBXFEL #1
                          +1, +9.7, +9.7, +1])  # CBXFEL #2
    for n in range(len(name)):
        id = strmatch(name[n],Bname,True)[0]
        X0 = SBEN[id][f'm{cflag or ""}2']
        X = X0 + dX[n]
        SBEN[id][f'm{cflag or ""}2'] = X

    # safety dump bends (permanent magnet dipoles)

    name = ['BXPM1B', 'BXPM1', 'BXPM2']
    for n in range(len(name)):
        if n == 0:  # SXR
            Xm = 1.25
        else:  # HXR
            Xm = -1.215
        id1 = strmatch(f"{name[n]}1",N)[0] #center
        id0 = id1 - 1  # entrance
        if n != 2:
            pitch = -coor[id0, 4]
            z0 = coor[id0, 0]
            y0 = coor[id0, 2]
        z1 = coor[id1, 0]
        Ym = y0 + np.tan(pitch) * (z1 - z0)
        yaw = 0
        id = strmatch(name[n],Bname,True)[0]
        SBEN[id][f'm{cflag or ""}2'] = Xm
        SBEN[id][f'm{cflag or ""}3'] = Ym
        SBEN[id][f'm{cflag or ""}6'] = yaw
        SBEN[id][f'm{cflag or ""}5'] = -pitch

    # Lambertson septa
    # coor=[z,x,y,roll,-pitch,yaw] (SYMBOLS coordinates)

    name = ['BLRDG0', 'BLXSPS', 'BLXSPH', 'BLRDAS', 'BLRCUS']
    r = 0.010  # radius of field-free channel
    off = -0.004  # beam is 6 mm from top of field-free channel
    for n in range(len(name)):
        if n <= 1 and cflag is not None:
            continue  # no BSY or UND coords for BLRDG0 or BLRL3X
        id = strmatch(name[n],Bname,True)[0]
        Xm0 = SBEN[id][f'm{cflag or ""}2']
        Ym0 = SBEN[id][f'm{cflag or ""}3']
        Zm0 = SBEN[id][f'm{cflag or ""}1']
        yaw = SBEN[id][f'm{cflag or ""}6']
        pitch = -SBEN[id][f'm{cflag or ""}5']
        roll = (np.pi / 180) * SBEN[id]['tilt']
        O1 = np.array([[np.cos(yaw), 0, np.sin(yaw)], [0, 1, 0], [-np.sin(yaw), 0, np.cos(yaw)]])
        O2 = np.array([[1, 0, 0], [0, np.cos(pitch), np.sin(pitch)], [0, -np.sin(pitch), np.cos(pitch)]])
        O3 = np.array([[np.cos(roll), -np.sin(roll), 0], [np.sin(roll), np.cos(roll), 0], [0, 0, 1]])
        O = O1 @ O2 @ O3
        t = np.linalg.solve(O, np.array([Xm0, Ym0, Zm0]))  # remove roll, pitch, and yaw
        Xr, Yr, Zr = t[0], t[1], t[2]
        Yr = Yr + off  # apply vertical offset
        t = O @ np.array([Xr, Yr, Zr])  # restore roll, pitch, and yaw
        Xm, Ym, Zm = t[0], t[1], t[2]
        # CheckMagnetCoords
        SBEN[id][f'm{cflag or ""}2'] = Xm
        SBEN[id][f'm{cflag or ""}3'] = Ym
        SBEN[id][f'm{cflag or ""}1'] = Zm

    # set magnet installation roll for bends, kickers, and septa
    # coor=[z,x,y,roll,-pitch,yaw] (SYMBOLS coordinates)

    for n in range(len(SBEN)):
        mtype = SBEN[n]['type'].strip()
        if mtype in ['0.787K35.4','1.378K35.4']:
            # LCLS-II kickers (built to kick vertically when installed unrolled)
            roll = (np.pi / 180) * (SBEN[n]['tilt'] - 90)
        elif mtype in ['1.26D18.43','1.69VD55.1']:
            # dump line soft bends and permanent magnet vertical bends
            continue  # see FixDumpCoords
        elif mtype in ['Aline_bend']:
            # A-line bends
            continue  # see FixAlineCoords
        else:
            roll = (np.pi / 180) * SBEN[n]['tilt']  # other bends, kickers, or septa
        SBEN[n][f'm{cflag or ""}4'] = roll

    # spreader kickers
    # coor=[z,x,y,roll,-pitch,yaw] (SYMBOLS coordinates)

    name = ['BKYSP0H', 'BKYSP1H', 'BKYSP2H', 'BKYSP3H', 'BKYSP4H', 'BKYSP5H',
            'BKYSP0S', 'BKYSP1S', 'BKYSP2S', 'BKYSP3S', 'BKYSP4S', 'BKYSP5S']
    off = [0.0002, 0.0004]  # to mitigate resistive wall wakefield effects
    for n in range(len(name)):
        if n <= 5:
            yoff = off[0]
        else:
            yoff = off[1]
        id = strmatch(name[n],Bname,True)[0]
        Ym0 = SBEN[id][f'm{cflag or ""}3']
        SBEN[id][f'm{cflag or ""}3'] = Ym0 + yoff

    # CUSXR extraction magnets
    # coor=[z,x,y,roll,-pitch,yaw] (SYMBOLS coordinates)

    name = ['BRCUSDC1', 'BKRCUS', 'BRCUSDC2']
    for namen in name:
        dname = f'D{namen}A'
        idd = strmatch(dname,N,True)[0]
        id = strmatch(namen,Bname,True)[0]
        for m in [1,2,3,5,6]:
            SBEN[id][f'm{cflag or ""}{m}'] = coor[idd, m-1]

    # QDG001 and QDG003

    if cflag is None:  # only linac coordinates
        name = ['QDG001', 'QDG003']
        for n in range(len(name)):
            id = strmatch(name[n], N)
            KL = np.sum(P[id, 1] * L[id])
            id = strmatch(f'DY{name[n]}', N)[0]
            kick = P[id, 0]
            off = kick / KL
            id = strmatch(name[n],Qname,True)[0]
            Xm0 = QUAD[id]['c2']
            Ym0 = QUAD[id]['c3']
            Zm0 = QUAD[id]['c1']
            yaw = QUAD[id]['c6']
            pitch = -QUAD[id]['c5']
            roll = QUAD[id]['c4']
            O1 = np.array([[np.cos(yaw), 0, np.sin(yaw)], [0, 1, 0], [-np.sin(yaw), 0, np.cos(yaw)]])
            O2 = np.array([[1, 0, 0], [0, np.cos(pitch), np.sin(pitch)], [0, -np.sin(pitch), np.cos(pitch)]])
            O3 = np.array([[np.cos(roll), -np.sin(roll), 0], [np.sin(roll), np.cos(roll), 0], [0, 0, 1]])
            O = O1 @ O2 @ O3
            t = np.linalg.solve(O, np.array([Xm0, Ym0, Zm0]))  # remove roll, pitch, and yaw
            Xr, Yr, Zr = t[0], t[1], t[2]
            Yr = Yr + off  # apply vertical offset
            t = O @ np.array([Xr, Yr, Zr])  # restore roll, pitch, and yaw
            Xm, Ym, Zm = t[0], t[1], t[2]
            # CheckMagnetCoords
            QUAD[id]['m2'] = Xm
            QUAD[id]['m3'] = Ym
            QUAD[id]['m1'] = Zm
            QUAD[id]['m6'] = yaw
            QUAD[id]['m5'] = -pitch
            QUAD[id]['m4'] = roll

    # SXRSS optical components

    name = ['GSXS1', 'MSXS1', 'SLSXS1', 'MSXS2', 'MSXS3']
    dX = 1e-3 * np.array([0, -1.93, -3.85, -3.85, 0])
    for n in range(len(name)):
        id = strmatch(name[n],Iname,True)[0]
        X0 = INST[id][f'c{cflag or ""}2']
        Y0 = INST[id][f'c{cflag or ""}3']
        Z0 = INST[id][f'c{cflag or ""}1']
        yaw = INST[id][f'c{cflag or ""}6']
        pitch = -INST[id][f'c{cflag or ""}5']
        roll = INST[id][f'c{cflag or ""}4']
        O1 = np.array([[np.cos(yaw), 0, np.sin(yaw)], [0, 1, 0], [-np.sin(yaw), 0, np.cos(yaw)]])
        O2 = np.array([[1, 0, 0], [0, np.cos(pitch), np.sin(pitch)], [0, -np.sin(pitch), np.cos(pitch)]])
        O3 = np.array([[np.cos(roll), -np.sin(roll), 0], [np.sin(roll), np.cos(roll), 0], [0, 0, 1]])
        O = O1 @ O2 @ O3
        t = np.linalg.solve(O, np.array([X0, Y0, Z0]))  # remove roll, pitch, and yaw
        Xr, Yr, Zr = t[0], t[1], t[2]
        Xr = Xr + dX[n]  # apply horizontal offset
        t = O @ np.array([Xr, Yr, Zr])  # restore roll, pitch, and yaw
        Xm, Ym, Zm = t[0], t[1], t[2]
        INST[id][f'm{cflag or ""}2'] = Xm
        INST[id][f'm{cflag or ""}3'] = Ym
        INST[id][f'm{cflag or ""}1'] = Zm
        INST[id][f'm{cflag or ""}6'] = yaw
        INST[id][f'm{cflag or ""}5'] = -pitch
        INST[id][f'm{cflag or ""}4'] = roll

    return SBEN, QUAD,INST

SBEN, QUAD, INST = FixMagnetCoords(SBEN, QUAD, INST, K, N, L, P, coor, None)
if cBSY:
    SBEN, QUAD, INST = FixMagnetCoords(SBEN, QUAD, INST, K1, N1, L1, P1, coor1, 1)
if cUND:
    SBEN, QUAD, INST = FixMagnetCoords(SBEN, QUAD, INST, K2, N2, L2, P2, coor2, 2)

# Precision for coordinate output
prec = 1e-6

# ------------------------------------------------------------------------------
# Write SYMBOLS txt-files ...

# SYMBOLS text-file headers and footers

head = ('Solid Edge,AREA,KeyW,ELEMENT,Eng_Name,L_EFF,'
        'APER,ANGLE,K1,K2,TILT,E1,E2,H1,H2,ENERGY,'
        'SUML,X Coor,Y Coor,Z Coor,X Angle,Y Angle,Z Angle,'
        'RF_Frequency,RF_Amplitude,RF_Phase,RF_Gradient,RF_Power_Fraction,'
        'Z_Length,Fringe_Field_Integral,Integrated_Field_BL,Field_B,'
        'Integrated_Field_Gradient_GL,Field_Gradient_G,'
        'XAL_Scale_Name,XAL_Scale_Value,XAL_Polarity,'
        'Magnet_X_Coor,Magnet_Y_Coor,Magnet_Z_Coor,'
        'Magnet_X_Angle,Magnet_Y_Angle,Magnet_Z_Angle,'
        'Solenoid_Strength_KS,Undulator_Period_Length,Undulator_Strength_K,'
        'X_Size,Y_Size,'
        'Section,Distance_From_Section_Start,XAL_Keyword,S_Display')

foot = ('MAD #,AREA,KeyW,ELEMENT,Eng_Name,L_EFF,'
        'APER,ANGLE,K1,K2,TILT,E1,E2,H1,H2,ENERGY,'
        'SUML,MAD Z,MAD X,MAD Y,MAD Psi,MAD Phi,MAD Theta,'
        'RF_Frequency,RF_Amplitude,RF_Phase,RF_Gradient,RF_Power_Fraction,'
        'Z_Length,Fringe_Field_Integral,Integrated_Field_BL,Field_B,'
        'Integrated_Field_Gradient_GL,Field_Gradient_G,'
        'XAL_Scale_Name,XAL_Scale_Value,XAL_Polarity,'
        'Magnet_MAD_Z,Magnet_MAD_X,Magnet_MAD_Y,'
        'Magnet_MAD_Psi,Magnet_MAD_Phi,Magnet_MAD_Theta,'
        'Solenoid_Strength_KS,Undulator_Period_Length,Undulator_Strength_K,'
        'X_Size,Y_Size,'
        'Section,Distance_From_Section_Start,XAL_Keyword,S_Display')

unit = (',,,,,m,'
        'm,deg,1/m^2,1/m^3,deg,deg,deg,1/m,1/m,GeV,'
        'm,m,m,m,rad,rad,rad,'
        'MHz,MeV,deg,MeV/m,1,'
        'm,1,kG-m,T,'
        'kG,T/m,'
        ',,,'
        'm,m,m,'
        'rad,rad,rad,'
        '1/m,m,1,'
        'm,m,'
        ',m,,m')

Ncol = head.count(',') + 1

# SYMBOLS text-file (linac coordinates)

# set up pointers
# ip is effectively a way to sort the eles on two keys:  file-root and ordinal position in file
# this effectively preserves the survey file ordering in the txt output files.
ip = []
for n,KEY in enumerate(KEYLIST):
    for m in range(len(KEY)):
        ip.append([KEY[m]["idf"], n, m, KEY[m]['id']])
ip = sorted(ip, key=lambda x: (x[0], x[3]))

def arrange_output(roots, system_name, filename):
    filepath = Path(outdir+'/'+fname)
    filepath.parent.mkdir(parents=True, exist_ok=True)
    with filepath.open('wt') as fid:
        fid.write(f'{head}\n')
        fid.write(f'{unit}\n')
        for entry in roots:
            id = [i for i,x in enumerate(ip) if x[0]==entry['ix']]

            for n in id:
                idk = ip[n][1]
                idn = ip[n][2]
                TEMP = KEYLIST[idk][idn]

                s = [None] * Ncol

                # common data
                s[0] = TEMP['id']
                s[1] = TEMP['parent']
                s[2] = TEMP['prim']
                s[3] = TEMP['name']
                s[4] = TEMP['type']
                s[5] = TEMP['leng']
                s[15] = TEMP['energy']
                s[51] = TEMP['sdsp']

                if system_name == 'NOMINAL':
                    s[16] = TEMP['suml']
                    s[17] = roundoff(TEMP['c1'], prec)
                    s[18] = roundoff(TEMP['c2'], prec)
                    s[19] = roundoff(TEMP['c3'], prec)
                    s[20] = roundoff(TEMP['c4'], prec)
                    s[21] = roundoff(TEMP['c5'], prec)
                    s[22] = roundoff(TEMP['c6'], prec)
                elif system_name == 'BSY':
                    if 'suml1' not in TEMP:
                        # use suml1 as a proxy to see if element is in BSY
                        continue
                    s[16] = TEMP['suml1']
                    s[17] = roundoff(TEMP['c11'], prec)
                    s[18] = roundoff(TEMP['c12'], prec)
                    s[19] = roundoff(TEMP['c13'], prec)
                    s[20] = roundoff(TEMP['c14'], prec)
                    s[21] = roundoff(TEMP['c15'], prec)
                    s[22] = roundoff(TEMP['c16'], prec)
                elif system_name == 'UND':
                    if 'suml2' not in TEMP:
                        # use suml2 as a proxy to see if element is in UND
                        continue
                    s[16] = TEMP['suml2']
                    s[17] = roundoff(TEMP['c21'], prec)
                    s[18] = roundoff(TEMP['c22'], prec)
                    s[19] = roundoff(TEMP['c23'], prec)
                    s[20] = roundoff(TEMP['c24'], prec)
                    s[21] = roundoff(TEMP['c25'], prec)
                    s[22] = roundoff(TEMP['c26'], prec)

                # keyword data
                if keyw[idk] == 'LCAV':
                    s[23] = TEMP['freq']
                    s[24] = TEMP['ampl']
                    s[25] = TEMP['phase']
                    s[26] = TEMP['grad']
                    s[27] = TEMP['power']
                elif keyw[idk] == 'SBEN':
                    s[6] = TEMP['gap']
                    s[7] = TEMP['ang']
                    s[8] = TEMP['k1']
                    s[10] = TEMP['tilt']
                    s[11] = TEMP['e1']
                    s[12] = TEMP['e2']
                    s[28] = TEMP['zleng']
                    s[29] = TEMP['fint']
                    s[30] = TEMP['BL']
                    s[31] = TEMP['B']
                    s[32] = TEMP['GL']
                    s[33] = TEMP['G']

                    if system_name == 'NOMINAL':
                        s[37] = roundoff(TEMP['m1'], prec)
                        s[38] = roundoff(TEMP['m2'], prec)
                        s[39] = roundoff(TEMP['m3'], prec)
                        s[40] = roundoff(TEMP['m4'], prec)
                        s[41] = roundoff(TEMP['m5'], prec)
                        s[42] = roundoff(TEMP['m6'], prec)
                    elif system_name == 'BSY':
                        s[37] = roundoff(TEMP['m11'], prec)
                        s[38] = roundoff(TEMP['m12'], prec)
                        s[39] = roundoff(TEMP['m13'], prec)
                        s[40] = roundoff(TEMP['m14'], prec)
                        s[41] = roundoff(TEMP['m15'], prec)
                        s[42] = roundoff(TEMP['m16'], prec)
                    elif system_name == 'UND':
                        s[37] = roundoff(TEMP['m21'], prec)
                        s[38] = roundoff(TEMP['m22'], prec)
                        s[39] = roundoff(TEMP['m23'], prec)
                        s[40] = roundoff(TEMP['m24'], prec)
                        s[41] = roundoff(TEMP['m25'], prec)
                        s[42] = roundoff(TEMP['m26'], prec)
                elif keyw[idk] == 'QUAD':
                    s[6] = TEMP['bore']
                    s[8] = TEMP['k1']
                    s[10] = TEMP['tilt']
                    s[32] = TEMP['GL']
                    s[33] = TEMP['G']

                    if system_name == 'NOMINAL':
                        s[37] = roundoff(TEMP['m1'], prec)
                        s[38] = roundoff(TEMP['m2'], prec)
                        s[39] = roundoff(TEMP['m3'], prec)
                        s[40] = roundoff(TEMP['m4'], prec)
                        s[41] = roundoff(TEMP['m5'], prec)
                        s[42] = roundoff(TEMP['m6'], prec)
                elif keyw[idk] == 'SEXT':
                    s[6] = TEMP['bore']
                    s[9] = TEMP['k2']
                    s[10] = TEMP['tilt']
                    s[32] = TEMP['GpL']
                    s[33] = TEMP['Gp']
                elif keyw[idk] == 'SOLE':
                    s[6] = TEMP['bore']
                    s[30] = TEMP['BL']
                    s[31] = TEMP['B']
                    s[43] = TEMP['ks']
                elif keyw[idk] == 'MATR':
                    s[44] = TEMP['lambda']
                    s[45] = TEMP['k']
                elif keyw[idk] == 'RCOL':
                    s[46] = TEMP['xgap']
                    s[47] = TEMP['ygap']
                elif keyw[idk] == 'ECOL':
                    s[46] = TEMP['xbore']
                    s[47] = TEMP['ybore']
                elif keyw[idk] == 'SROT':
                    s[7] = TEMP['ang']
                elif keyw[idk] == 'INST':
                    if system_name == 'NOMINAL':
                        s[37] = roundoff(TEMP['m1'], prec)
                        s[38] = roundoff(TEMP['m2'], prec)
                        s[39] = roundoff(TEMP['m3'], prec)
                        s[40] = roundoff(TEMP['m4'], prec)
                        s[41] = roundoff(TEMP['m5'], prec)
                        s[42] = roundoff(TEMP['m6'], prec)
                    elif system_name == 'BSY':
                        s[37] = roundoff(TEMP['m11'], prec)
                        s[38] = roundoff(TEMP['m12'], prec)
                        s[39] = roundoff(TEMP['m13'], prec)
                        s[40] = roundoff(TEMP['m14'], prec)
                        s[41] = roundoff(TEMP['m15'], prec)
                        s[42] = roundoff(TEMP['m16'], prec)
                    elif system_name == 'UND':
                        s[37] = roundoff(TEMP['m21'], prec)
                        s[38] = roundoff(TEMP['m22'], prec)
                        s[39] = roundoff(TEMP['m23'], prec)
                        s[40] = roundoff(TEMP['m24'], prec)
                        s[41] = roundoff(TEMP['m25'], prec)
                        s[42] = roundoff(TEMP['m26'], prec)
                elif keyw[idk] == 'MULT':
                    s[6] = TEMP['bore']
                    if TEMP['prim'] == 'MULT':
                        continue
                    if TEMP['prim'] == 'QUAD':
                        s[10] = TEMP['tilt']
                        s[32] = TEMP['GL']

                fid.write(f"{s[0]+1},")
                for k in range(1, Ncol-1):
                    if s[k] is None:
                        fid.write(",")
                    elif isinstance(s[k], str):
                        fid.write(f"{s[k]},")
                    else:
                        fid.write(f"{madval(s[k])},")
                k=Ncol-1  #No trailing commas
                if s[k] is None:
                    pass
                elif isinstance(s[k], str):
                    fid.write(f"{s[k]}")
                else:
                    fid.write(f"{madval(s[k])}")
                fid.write("\n")
        fid.write(f'{foot}\n')
        fid.write(f'{unit}\n')


fname = f'AD_ACCEL-{optics}.txt'
arrange_output(file_roots,'NOMINAL',fname)
if cBSY:
    fname = f'BSY-AD_ACCEL-{optics}.txt'
    arrange_output(bsy_file_roots,'BSY',fname)
if cUND:
    fname = f'UND-AD_ACCEL-{optics}.txt'
    arrange_output(und_file_roots,'UND',fname)

# ------------------------------------------------------------------------------
# Write extra SYMBOLS txt-file ...
# Element name, area name, undulator cell, sector

fname = f'AD_ACCEL-extra-{optics}.txt'
with open(outdir+'/'+fname, 'wt') as fid:
    fid.write('ELEMENT,Area2,Undulator Cell,Sector\n')
    for nf in range(1,len(file_roots)+1):
        id = [i for i,x in enumerate(ip) if x[0]==nf]
        for n in id:
            idk = ip[n][1]
            if keyw[idk] == 'MARK' or keyw[idk] == 'SROT':
                continue
            idn = ip[n][2]
            TEMP = KEYLIST[idk][idn]
            TEMPucell = TEMP['ucell']
            TEMPucell = '' if isinstance(TEMPucell,list) else TEMPucell
            fid.write(f"{TEMP['name']},{TEMP['area']},{TEMPucell},{TEMP['sector']}\n")
    fid.write('ELEMENT,Area2,Undulator Cell,Sector\n')

# ------------------------------------------------------------------------------

# # save RDBdata
# sio.savemat(outdir+'/makeExcel.dump.mat', 
# mdict={
# "K":K,
# "N":N,
# "L":L,
# "P":P,
# "A":A,
# "T":T,
# "E":E,
# "SECTORS":SECTORS,
# "coor":coor,
# "S":S,
# "idf":idf,
# "idd":idd,
# "K1":K,
# "N1":N,
# "L1":L,
# "P1":P,
# "S1":E,
# "coor1":coor,
# "SECTORS1":SECTORS1,
# })

print(f'Be sure to add FACET2 elements to {fname}!\n')
