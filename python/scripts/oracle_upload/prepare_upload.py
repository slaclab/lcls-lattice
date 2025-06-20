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
    """
    x : list
    y : list
    return : list

    This function returns the intersection of x and y, those elements
    that are common to both.

    Because of context, the intersection needs to preserve the ordering of x.
    """
    y_set = set(y) #set makes this faster
    return [v for v in x if v in y_set]
    #return [v for v in x if v in y]

def strmatch(n_str,N_lst,exact=False):
    """
    n_str is a string.
    N_lst is list of strings.

    This function returns the indexes of N_lst which contain n_str.

    If exact it true, then only exact matches there n_str == N_lst[ix] are returned.
    If exact is false, then n_str is treated as a prefix.  e.g. n_str='QA' would match 'QA01', 'QAdump', etc.
    """
    if not isinstance(N_lst,list):
        print('strmatch passed non-list. Stopping')
        stop
    if exact:
        return [ix for ix,n_ in enumerate(N_lst) if n_ == n_str]
    else:
        mylen = len(n_str)
        return [ix for ix,n_ in enumerate(N_lst) if n_[:mylen] == n_str]
        #return [ix for ix,n_ in enumerate(N_lst) if n_.startswith(n_str)] #startswith is slow

def madval(rval):
    """
    rval is a float.
    return value is rval formatted to a string.

    This function replicates mad8's behavior with regards to formatted float output.
    """
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
    """
    val is a float
    prec is an float

    return value is val rounded to prec.
    """
    if isinstance(val,list):
        return None
    if prec is None:
        return val
    else:
        return prec * np.round(val / prec)

#------------------------------------------

script_dir = Path(__file__).parent.resolve()

optics='09JUN2025s'
vfile=['LCLS2sc_value.echo','LCLS2cu_value.echo']

outdir='oracle_upload'
xfile='AD_ACCEL-'+optics+'.xls'
noXTES_TEMPs=True; # skip elements named TEMP* in XTES systems

print(' ')
print('   ===============================================')
print('       AD_ACCEL Oracle Upload File Generation')
print('   ===============================================')
print(' ')

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
    {'root':'LCLS2scH',     'beg':'BEGSPH',       'end':'ENDSLTH',     'ix':6},      #  6
    {'root':'LCLS2scD',     'beg':'BEGSPD_2',     'end':'ENDSLTD',     'ix':7},      #  7
    {'root':'DIAG0',        'beg':'BEGDIAG0',     'end':'ENDDIAG0',    'ix':8},      #  8
    {'root':'LCLS2scDA',    'beg':'BEGSPA',       'end':'ENDESA',      'ix':9},      #  9 (DASEL)
    {'root':'LCLS2cuH',     'beg':'BEGGUN',       'end':'ENDDMPH_2',   'ix':10},     # 10
    {'root':'LCLS2cuHS',    'beg':'BEGSFTH_1',    'end':'ENDSFTH_2',   'ix':11},     # 11
    {'root':'LCLS2cuS',     'beg':'BEGCLTS',      'end':'ENDCLTS',     'ix':14},     # 14
    {'root':'LCLS2cuGSPEC', 'beg':'BEGGSPEC',     'end':'ENDGSPEC',    'ix':15},     # 15
    {'root':'LCLS2cuSPEC',  'beg':'BEGSPEC',      'end':'ENDSPEC',     'ix':16},     # 16
]

bsy_file_roots = [
    {'root':'LCLS2scS',     'beg':'BEGSPD_1',     'end':'ENDDMPS_2',   'ix':1},      #  1
    {'root':'LCLS2scSS',    'beg':'BEGSFTS_1',    'end':'ENDSFTS_2',   'ix':2},      #  2
    {'root':'LCLS2scH',     'beg':'BEGSPH',       'end':'ENDSLTH',     'ix':6},      #  6
    {'root':'LCLS2scD',     'beg':'BEGSPD_2',     'end':'ENDSLTD',     'ix':7},      #  7
    {'root':'LCLS2scDA',    'beg':'BEGSPA',       'end':'ENDESA',      'ix':9},      #  9 (DASEL)
    {'root':'LCLS2cuH',     'beg':'BEGCLTH_0',    'end':'ENDDMPH_2',   'ix':10},     # 10
    {'root':'LCLS2cuHS',    'beg':'BEGSFTH_1',    'end':'ENDSFTH_2',   'ix':11},     # 11
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

from parse_survey import parse_survey

# ------------------------------------------------------------------------------
# read the MAD output files
K, N, T, FDN = [], [], [], []
L, P, A, E, coor, S, Sd = [], [], [], [], [], [], []
idf, idd = [], []  # idf: which MAD output file an element came from
                   # idd: ordinal position in MAD output file

for file_root in file_roots:
    fname = f'{file_root["root"]}_survey.tape'
    print(f'Opening file {fname}')
    titl, tK, tN, tL, tP, tA, tT, tE, tFDN, tcoor, tS = parse_survey(fname)

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
K_bsy, N_bsy, L_bsy, P_bsy, S_bsy, coor_bsy, idf_bsy, FDN_bsy = [], [], [], [], [], [], [], []
if cBSY:
    for file_root in bsy_file_roots:
        fname = f'BSY-{file_root["root"]}_survey.tape'
        print(f'Opening file {fname}')
        titl, tK, tN, tL, tP, tA, tT, tE, tFDN, tcoor, tS = parse_survey(fname)

        id1 = tN.index(file_root['beg'])
        id2 = tN.index(file_root['end']) 
        slc = slice(id1, id2 + 1)

        K_bsy.extend(tK[slc])
        N_bsy.extend(tN[slc])
        L_bsy.extend(tL[slc])
        P_bsy.extend(tP[slc])
        S_bsy.extend(tS[slc])
        coor_bsy.extend(tcoor[slc])
        FDN_bsy.extend(tFDN[slc])

        ndata = len(tK[slc])
        idf_bsy.extend([file_root['ix']] * ndata)

# get UND coordinates
K_und, N_und, L_und, P_und, S_und, coor_und, idf_und, FDN_und = [], [], [], [], [], [], [], []
if cUND:
    for file_root in file_roots:
        if file_root['UND']:
            fname = f'{file_root[0]}_survey.tape'
            print(f'Opening file {fname}')
            titl, tK, tN, tL, tP, tA, tT, tE, tFDN, tcoor, tS = parse_survey(fname)

            K_und.extend(tK)
            N_und.extend(tN)
            L_und.extend(tL)
            P_und.extend(tP)
            S_und.extend(tS)
            coor_und.extend(tcoor)
            FDN_und.extend(tFDN)

            idf_und.extend([file_root['ix']] * len(tK))

Sd = np.array(Sd)
S = np.array(S)
S_bsy = np.array(S_bsy)
S_und = np.array(S_und)
L = np.array(L)
L_bsy = np.array(L_bsy)
L_und = np.array(L_und)
P = np.array(P)
P_bsy = np.array(P_bsy)
P_und = np.array(P_und)
E = np.array(E)
coor = np.array(coor)
coor_bsy = np.array(coor_bsy)
coor_und = np.array(coor_und)
A = np.array(A)

def FixUpgradeNames(N):
  """
  N is a list of strings.
  This function removes trailing "_" from any names.

  Device names in upgraded SXR cells have "_" appended ... remove it
  """
  for i in range(len(N)):
    if N[i].endswith('_'):
      N[i] = N[i][:-1]

FixUpgradeNames(N)
if cBSY:
  FixUpgradeNames(N_bsy)
if cUND:
  FixUpgradeNames(N_und)

# assign machine areas
ida=[]
for ix,a in enumerate(area):
    id1 = N.index(a['beg']) + a['offset'][0]
    id2 = N.index(a['end']) + a['offset'][1]
    ida.extend([ix]*(id2-id1+1))

def fix_dump_coords(N, P, coor):
    """
    special handling for rolled dump lines and A-line
    """

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

    return coor
coor = fix_aline_coords(N, P, coor)

if cBSY:
    coor_bsy = fix_dump_coords(N_bsy, P_bsy, coor_bsy)
    coor_bsy = fix_aline_coords(N_bsy, P_bsy, coor_bsy)
if cUND:
    coor_und = fix_dump_coords(N_und, P_und, coor_und)
    coor_und = fix_aline_coords(N_und, P_und, coor_und)

# kicker/septum groups
KSnames = [
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

P_und = np.zeros((Nelem, 2))

idb = [i for i,x in enumerate(K) if x == 'SBEN']
for m in range(0, len(idb), 2):
    na = idb[m]
    nb = idb[m+1]
    name = N[na].strip()
    name = name.split('.')[0]  # remove decoration, if any
    id_ = strmatch(name,C)[0]
    fint = float(C[id_+6])
    P_und[na][0] = fint
    P_und[nb][0] = fint

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
    P_und[n1, :] = [undl, undk]
    P_und[n2, :] = [undl, undk]


# Shared devices (devices which see both kicked and unkicked beams)
aname_all = ['DIAG0', 'SPH', 'SPS', 'SPA', 'CLTS']
name_all = ['BPMDG000', 'BPMSPH', 'BPMSPS', 'BPMDAS', 'BPMCUS']

for name, aname in zip(name_all,aname_all):
    jd = strmatch(name,N,True)
    for m in range(len(jd)):
        if aname == area[ida[jd[m]]]['name']:
            N[jd[m]] = name + '?'

    if cBSY:
        jd1 = strmatch(name,N_bsy,True)
        for m in range(len(jd1)):
            if aname == area[ida[jd[m]]]['name']:
                N_bsy[jd1[m]] = name + '?'

    if cUND:
        jd2 = strmatch(name,N_und,True)
        for m in range(len(jd2)):
            if aname == area[ida[jd[m]]]['name']:
                N_bsy[jd2[m]] = name + '?'

# copy T1 into TILT slot
name = ['CQ01', 'SQ01', 'CQ01B', 'SQ01B', 'SQ02B']
for n in name:
    id_ = strmatch(n,N,True)
    for i in id_:
        P[i][3] = P[i][5]  # T1 -> TILT

def assign_ucell(N, coor):
    UCELL = ['' for x in N]

    # SXR partial cell 16
    i1 = strmatch('BEGUNDS',N,True)[0]
    i2 = strmatch('SXR17BEG',N,True)[0]-1
    for i in range(i1,i2+1):
        UCELL[i]='SXR 16'
    # SXR cells
    for nc in range(17,50+1):
        i1 = strmatch(f'SXR{nc:02}BEG',N,True)[0]
        i2 = strmatch(f'SXR{nc:02}END',N,True)[0]
        for j in range(i1,i2+1):
            UCELL[j]=f'SXR {nc:02}'

    # HXR partial cell 12
    i1 = strmatch('BEGUNDH',N,True)[0]
    i2 = strmatch('HXR13BEG',N,True)[0]-1
    for i in range(i1,i2+1):
        UCELL[i]='HXR 12'
    # SXR cells
    for nc in range(13,50+1):
        i1 = strmatch(f'HXR{nc:02}BEG',N,True)[0]
        i2 = strmatch(f'HXR{nc:02}END',N,True)[0]
        for j in range(i1,i2+1):
            UCELL[j]=f'HXR {nc:02}'
    return UCELL

# Assign undulator cell names
UCELL = assign_ucell(N_bsy, coor_bsy)

def read_sector_data():
    filename = f'{script_dir}/sectors.xlsx'
    wb= pyxl.load_workbook(filename,data_only=True)

    # read worksheet 1 (scS)
    sheet = wb.worksheets[0]
    data = sheet['A4':'J72']
    sector_data = []
    for row in data:
        sector_data.append({
            'name': row[0].value,
            'froot': row[1].value,
            'BSY': row[2].value,
            'Zbeg': row[4].value,
            'Zend': row[5].value,
            'Nbeg': row[8].value,
            'Nend': row[9].value
        })

    # read worksheet 2 (cuH)
    sheet = wb.worksheets[1]
    data = sheet['A4':'J39']
    for row in data:
        sector_data.append({
            'name': row[0].value,
            'froot': row[1].value,
            'BSY': row[2].value,
            'Zbeg': row[4].value,
            'Zend': row[5].value,
            'Nbeg': row[8].value,
            'Nend': row[9].value
        })

    return sector_data

def set_sector(N, SECTORS, coor, idf, nf, sector):
    Z = [x[2] for x in coor]

    id_ = [i for i,x in enumerate(idf) if x == nf]
    if sector['Nbeg'] == None:
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

    if sector['Nend'] == None:
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

def assign_sector(N, coor, idf, N_bsy, coor_bsy, idf_bsy):
    # NOTE: coordinates are assumed to be in MAD (not SYMBOLS) order

    sector_data = read_sector_data()

    SECTORS = ['' for x in N]
    SECTORS_bsy = ['' for x in N_bsy]

    for nf in [x['ix'] for x in file_roots]:
        for sector in sector_data:
            if nf == sector['froot']:
                if sector['BSY']:
                    set_sector(N_bsy, SECTORS_bsy, coor_bsy, idf_bsy, nf, sector)
                else:
                    set_sector(N, SECTORS, coor, idf, nf, sector)

    return SECTORS, SECTORS_bsy

# Assign sector names
SECTORS, SECTORS_bsy = assign_sector(N, coor, idf, N_bsy, coor_bsy, idf_bsy)

# MAD SURVEY coordinates  [x,y,z,theta,phi   ,psi]
# correspond to SolidEdge [z,x,y,roll ,-pitch,yaw]

ic = [2, 0, 1, 5, 4, 3]
coor = coor[:, ic]
coor[:, 4] = -coor[:, 4]

if cBSY:
    coor_bsy = np.array(coor_bsy) #Probably not necessary
    coor_bsy = coor_bsy[:, ic]
    coor_bsy[:, 4] = -coor_bsy[:, 4]

if cUND:
    coor_und = np.array(coor_und) #Probably not necessary
    coor_und = coor_und[:, ic]
    coor_und[:, 4] = -coor_und[:, 4]

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

# gather key structures into element dictionary
ele_dict = {
'LCAV':[],
'SBEN':[],
'QUAD':[],
'SEXT':[],
'SOLE':[],
'MATR':[],
'RCOL':[],
'ECOL':[],
'SROT':[],
'HKIC':[],
'VKIC':[],
'MONI':[],
'WIRE':[],
'PROF':[],
'IMON':[],
'BLMO':[],
'INST':[],
'MARK':[],
'MULT':[]
}

def process_bsy(name,ele,split=False,exact=True):
    ids = strmatch(name,N_bsy,exact)
    if len(ids) > 0:
        if split:
            ide = [ids[0]-1, ids[-1]]
            coor_bsyc = np.mean(coor_bsy[ide], axis=0)  # m, rad (beam center)
            ele['suml1'] = np.mean(S_bsy[ide])  # m (beam center)
            ids = ids[0]
        else:
            ids = ids[0]
            coor_bsyc = coor_bsy[ids]  # m, rad (beam center)
            ele['suml1'] = S_bsy[ids]  # m (beam center)
            
        for k in range(6):
            ele[f'c1{k+1}'] = coor_bsyc[k]
        if not ele['sector']:
            ele['sector'] = SECTORS_bsy[ids].strip()
        ele['ucell'] = UCELL[ids].strip()

def process_und(name,ele,split=False,exact=True):
    ids = strmatch(name,N_und,exact)
    if len(ids) > 0:
        if split:
            ide = [ids[0]-1, ids[-1]]
            coor_undc = np.mean(coor_und[ide], axis=0)  # m, rad (beam center)
            ele['suml1'] = np.mean(S_und[ide])  # m (beam center)
            ids = ids[0]
        else:
            ids = ids[0]
            coor_undc = coor_und[ids]  # m, rad (beam center)
            ele['suml2'] = S_und[ids]  # m (beam center)
            
        for k in range(6):
            ele[f'c2{k+1}'] = coor_undc[k]

#Cu linac klystrons power cavities in groups of 4.
# First the power is split 50/50, so that A & B together get half, and  C & D together get the other half.
# Then the power is split again, so that A gets 25%, B gets 25% and so on.
# If A or B is missing, then B or A gets the full 50%.  Similarly for C & D.
POWER_FACTORS = {
    ("A", "B", "C", "D"): {'A':0.25, 'B':0.25, 'C':0.25, 'D':0.25},
    ("B", "C", "D"): {'B':0.5, 'C':0.25, 'D':0.25},
    ("A", "C", "D"): {'A':0.5, 'C':0.25, 'D':0.25},
    ("A", "B", "C"): {'A':0.25, 'B':0.25, 'C':0.5},
    ("A", "B", "D"): {'A':0.25, 'B':0.25, 'D':0.5},
}

for kwn,eles in ele_dict.items():
    key_ids = strmatch(kwn,K,True)
    names = list(dict.fromkeys([N[i] for i in key_ids]))
    if kwn == 'LCAV':
        # create list of unique names that will allow unsplitting
        for i in range(len(names)):
            if names[i][0:4] in ['CAVL', 'CAVC']:  # unique in 7 characters
                names[i] = names[i][0:7]
            else:  # unique in 6 characters
                names[i] = names[i][0:6]
        names = list(dict.fromkeys(names))

        for name in names:
            if name.startswith('TCX'):
                ids = strmatch(name,N,True)
            else:
                ids = strmatch(name,N)
            id1 = ids[0]  # first segment
            ide = [id1-1, ids[-1]]  # [entrance, exit]
            leng = np.sum(L[ids])  # m
            ampl = np.sum(P[ids, 5])  # MeV
            grad = ampl / leng  # MeV/m
            if re.match(r'K\d\d_\d[ABCD]', name[0:6]):  # i.e. K27_3D
                cav_section = name[5]
                cav_ids = strmatch(name[0:5],N)
                cav_sections = tuple(dict.fromkeys([N[x][5] for x in  cav_ids]))
                power = POWER_FACTORS[cav_sections][cav_section]
            else:
                power = 1
            coorc = np.mean(coor[ide, :], axis=0)  # m,rad (beam center)
            eles.append({
                'idf': idf[id1],
                'id': idd[id1],
                'area': area[ida[id1]]['name'],
                'parent': area[ida[id1]]['parent'],
                'sector': SECTORS[id1].strip(),
                'ucell': [],
                'prim': FDN[id1],
                'name': name,
                'type': T[id1].strip(),
                'energy': np.mean(E[ide]),  # GeV (beam center)
                'leng': leng,
                'freq': P[id1, 4],  # MHz
                'ampl': ampl,
                'phase': 360 * P[id1, 6],
                'grad': grad,
                'power': power,
                'sdsp': np.mean(Sd[ide]),  # m (beam center)
                'suml': np.mean(S[ide]),  # m (beam center)
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates
            if cBSY:
                if name.startswith('TCX'):
                    process_bsy(name,eles[-1],split=True,exact=True)
                else:
                    process_bsy(name,eles[-1],split=True,exact=False)

            # UND coordinates
            if cUND:
                if name.startswith('TCX'):
                    process_und(name,eles[-1],split=True,exact=True)
                else:
                    process_und(name,eles[-1],split=True,exact=False)

    elif kwn == 'SBEN':
        Nelm = len(key_ids) // 2
        for m in range(Nelm):
            mname1 = names[2 * m].strip()
            mname2 = names[2 * m + 1].strip()
            name = mname1[:-1]  # remove last character from name
            id1 = strmatch(mname1,N,True)[0]  # end point of first of 2 halfs of split bend.
            id0 = id1 - 1  # start point of bend
            id2 = strmatch(mname2,N,True)[0]  # exit point of bend
            sdsp = Sd[id1]  # m
            suml = S[id1]  # m
            energy = E[id1]  # GeV
            leng = L[id1] + L[id2]  # m
            gap = 2 * A[id1]  # m
            fint = P_und[id1, 0]  # m
            tilt = P[id1, 3]  # rad
            ang = P[id1,0] + P[id2,0]  # rad
            if abs(ang) < amin:
                ang = 0
                e1 = 0
                e2 = 0
            else:
                e1 = P[id1, 4]  # rad
                e2 = P[id2, 5]  # rad
            EeV = 1e9 * energy  # eV
            brho = np.sqrt(EeV ** 2 - Er ** 2) / clight  # T-m
            BL = brho * ang  # T-m
            B = BL / leng  # T
            k1 = P[id1, 1]  # 1/m^2
            if abs(k1) < kmin:
                k1 = 0
            G = brho * k1  # T/m
            GL = G * leng  # T
            if name[:3] in Ebend:
                sname = 'GeV2T'
                sval = brho * abs(ang) / (leng * energy)
            else:
                sname = 'kG2T_Bdl2B'
                sval = 1 / (leng * T2kG)
            polarity = -np.sign(ang + np.finfo(float).eps)  # add eps so that sign=1 when ang=0
            coori = np.copy(coor[id0, :])  # coordinates at bend entrance
            coorc = np.copy(coor[id1, :])  # coordinates at end of first half
            cooro = np.copy(coor[id2, :])  # coordiantes at exit
            coorm = np.zeros(coorc.shape)  # m,rad (magnet steel center)
            if name in KSnames:
                jd = strmatch(f'D{name}',N)
                if len(jd) != 2:
                    raise ValueError(f'{name} not split?')
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
            eles.append({
                'idf': idf[id1],
                'id': idd[id1],
                'area': area[ida[id1]]['name'],
                'parent': pname,
                'sector': SECTORS[id1].strip(),
                'ucell': [],
                'prim': FDN[id1],
                'name': name,
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
                eles[-1][f'c1{k+1}'] = []
                eles[-1][f'm1{k+1}'] = []
            if cBSY:
                id1 = strmatch(mname1,N_bsy,True)  # first piece (beam center)
                id2 = strmatch(mname2,N_bsy,True)  # beam out
                id1 = id1[0] if id1 else None
                id2 = id2[0] if id2 else None
                if id1 and id2:
                    id0 = id1 - 1  # beam in
                    eles[-1]['suml1'] = S_bsy[id1]  # m
                    coor_bsy0 = np.copy(coor_bsy[id0, :])  # m,rad
                    coor_bsy1 = np.copy(coor_bsy[id1, :])  # m,rad
                    coor_bsy2 = np.copy(coor_bsy[id2, :])  # m,rad
                    coor_bsym = np.zeros(coor_bsy1.shape)  # m,rad (magnet steel center)
                    if name in KSnames:
                        jd = strmatch(f'D{name}',N_bsy)
                        coor_bsym = np.copy(coor_bsy[jd[0], :])
                        coor_bsym[3] = 0
                    else:
                        if chicane1 | chicane2:
                            coor_bsym[:3] = np.mean([coor_bsy0[:3], coor_bsy2[:3]], axis=0)
                            if chicane1:
                                coor_bsym[3:6] = np.copy(coor_bsy0[3:6])
                            else:
                                coor_bsym[3:6] = np.copy(coor_bsy2[3:6])
                        else:
                            coor_bsym[:3] = (coor_bsy0[:3] + coor_bsy2[:3] + 2 * coor_bsy1[:3]) / 4
                            coor_bsym[3:6] = np.copy(coor_bsy1[3:6])
                    if pname in ['DMPS', 'DMPH']:
                        coor_bsym[3] = coor_bsy1[3]  # dump line magnet coords set in FixDumpCoords
                    elif pname == 'BSYA':
                        coor_bsym[3] = coor_bsy1[3]  # dump line magnet coords set in FixAlineCoords
                    else:
                        coor_bsym[3] = tilt  # remove "creeping" rolls from non-rolled SBENs
                    for k in range(6):
                        eles[-1][f'c1{k+1}'] = coor_bsy1[k]
                        eles[-1][f'm1{k+1}'] = coor_bsym[k]
                    if not eles[-1]['sector']:
                        eles[-1]['sector'] = SECTORS_bsy[id1].strip()
                    eles[-1]['ucell'] = UCELL[id1].strip()

            # UND coordinates

            eles[-1]['suml2'] = []
            for k in range(6):
                eles[-1][f'c2{k+1}'] = []
                eles[-1][f'm2{k+1}'] = []
            if cUND:
                id1 = strmatch(mname1,N_und,True)[0]
                id2 = strmatch(mname2,N_und,True)[0]
                id1 = id1[0] if id1 else None
                id2 = id2[0] if id2 else None
                if id1 and id2:
                    id1 = ids[0]  # first piece (beam center)
                    id0 = id1 - 1  # beam in
                    id2 = ids[1]  # beam out
                    coor_und0 = coor_und[id0, :]  # m,rad
                    coor_und1 = coor_und[id1, :]  # m,rad
                    coor_und2 = coor_und[id2, :]  # m,rad
                    coor_undm = np.zeros(coor_und1.shape)  # m,rad (magnet steel center)
                    if name in KSnames:
                        jd = strmatch(f'D{name}',N_und)
                        coor_undm = coor_und[jd[0], :]
                        coor_undm[3] = 0
                    else:
                        if chicane1 | chicane2:
                            coor_undm[:3] = np.mean([coor_und0[:3], coor_und2[:3]], axis=0)
                            if chicane1:
                                coor_undm[3:6] = coor_und0[3:6]
                            else:
                                coor_undm[3:6] = coor_und2[3:6]
                        else:
                            coor_undm[:3] = (coor_und0[:3] + coor_und2[:3] + 2 * coor_und1[:3]) / 4
                            coor_undm[3:6] = coor_und1[3:6]
                    if pname in ['DMPS', 'DMPH']:
                        coor_undm[3] = coor_und1[3]  # dump line magnet coords set in FixDumpCoords
                    elif pname == 'BSYA':
                        coor_undm[3] = coor_und1[3]  # dump line magnet coords set in FixAlineCoords
                    else:
                        coor_undm[3] = tilt  # remove "creeping" rolls from non-rolled SBENs
                    eles[-1]['suml2'] = S_und[id1]  # m
                    for k in range(6):
                        eles[-1][f'c2{k+1}'] = coor_und1[k]
                        eles[-1][f'm2{k+1}'] = coor_undm[k]

    elif kwn in ('QUAD','SEXT','SOLE'):
        for name in names:
            ids = strmatch(name,N,True)
            id1 = ids[0]  # first segment (beam center)
            leng = np.sum(L[ids])  # m
            if kwn == 'QUAD':
                sname = 'kG2T_Gdl2G'
                k = P[id1, 1]
                sval = 1 / (leng * T2kG)
            elif kwn == 'SEXT':
                sname = 'kG2T_Gpdl2Gp'
                k = P[id1, 2]
                sval = 1 / (leng * T2kG)
            elif kwn == 'SOLE' and leng != 0:
                sname = 'kG2T_Bdl2B'
                k = P[id1, 4]
                sval = 1 / (leng * T2kG)
            elif kwn == 'SOLE' and leng == 0:
                sname = 'kG2T'
                k = P[id1, 4]
                sval = 1 / T2kG
            if abs(k) < kmin:
                k = 0

            sdsp = Sd[id1]  # m
            suml = S[id1]  # m
            energy = E[id1]  # GeV
            bore = 2 * A[id1]  # m
            tilt = P[id1, 3]  # rad
            EeV = 1e9 * energy  # eV
            brho = np.sqrt(EeV ** 2 - Er ** 2) / clight  # T-m
            G = brho * k  # T/m
            GL = G * leng  # T
            polarity = -np.sign(k1 + np.finfo(float).eps)  # add eps so that sign=1 when k1=0
            coorc = np.copy(coor[id1, :])  # m,rad
            eles.append({
                'idf': idf[id1],
                'id': idd[id1],
                'area': area[ida[id1]]['name'],
                'parent': area[ida[id1]]['parent'],
                'sector': SECTORS[id1].strip(),
                'ucell': [],
                'prim': FDN[id1],
                'name': name,
                'type': T[id1].strip(),
                'energy': energy,
                'leng': leng,
                'bore': bore,
                'tilt': np.rad2deg(tilt),  # deg
                'k': k,
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
            if cBSY:
                process_bsy(name,eles[-1])

            # UND coordinates
            if cUND:
                process_und(name,eles[-1])

    elif kwn == 'MATR':
        for name in names:
            ids = strmatch(name,N,True)
            id1 = ids[0]  # first half (beam center)
            sdsp = Sd[id1]  # m
            suml = S[id1]  # m
            energy = E[id1]  # GeV
            leng = np.sum(L[ids])  # m
            undl = P_und[id1, 0]  # m
            undk = P_und[id1, 1]  # 1
            coorc = np.copy(coor[id1])  # m, rad
            eles.append({
                'idf': idf[id1],
                'id': idd[id1],
                'area': area[ida[id1]]['name'],
                'parent': area[ida[id1]]['parent'],
                'sector': SECTORS[id1].strip(),
                'ucell': [],
                'prim': FDN[id1],
                'name': name,
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
            if cBSY:
                process_bsy(name,eles[-1])

            # UND coordinates
            if cUND:
                process_und(name,eles[-1])

    elif kwn in ('RCOL','ECOL'):
        for name in names:
            ids = strmatch(name,N,True)[0]
            ide = [ids - 1, ids]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[ids]  # GeV
            leng = L[ids]  # m
            xgap = 2 * P[ids, 3]  # m
            ygap = 2 * P[ids, 4]  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            eles.append({
                'idf': idf[ids],
                'id': idd[ids],
                'area': area[ida[ids]]['name'],
                'parent': area[ida[ids]]['parent'],
                'sector': SECTORS[ids].strip(),
                'ucell': [],
                'prim': FDN[ids],
                'name': name,
                'type': T[ids].strip(),
                'energy': energy,
                'leng': leng,
                'xgap': xgap,
                'ygap': ygap,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates
            if cBSY:
                process_bsy(name,eles[-1],split=True)

            # UND coordinates
            if cUND:
                process_und(name,eles[-1],split=True)

    elif kwn == 'SROT':
        for name in names:
            ids = strmatch(name,N,True)[0]
            ide = [ids - 1, ids]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[ids]  # GeV
            leng = L[ids]  # m
            ang = np.rad2deg(P[ids, 4])  # deg
            if abs(ang) < amin:
                ang = 0
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            eles.append({
                'idf': idf[ids],
                'id': idd[ids],
                'area': area[ida[ids]]['name'],
                'parent': area[ida[ids]]['parent'],
                'sector': SECTORS[ids].strip(),
                'ucell': [],
                'prim': FDN[ids],
                'name': name,
                'type': T[ids].strip(),
                'energy': energy,
                'leng': leng,
                'ang': ang,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates
            if cBSY:
                process_bsy(name,eles[-1],split=True)

            # UND coordinates
            if cUND:
                process_und(name,eles[-1],split=True)

    elif kwn == 'MULT':
        for name in names:
            ids = strmatch(name,N,True)[0]
            sdsp = Sd[ids]  # m (beam center)
            suml = S[ids]  # m (beam center)
            energy = E[ids]  # GeV
            leng = np.sum(L[ids])  # m
            k1 = P[ids, 1]  # 1/m^2
            if abs(k1) < kmin:
                k1 = 0
            EeV = 1e9 * energy  # eV
            tilt = P[ids, 3]  # rad
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
            coorc = coor[ids,:] # m, rad (beam center)
            aper = 2 * A[ids]  # m
            eles.append({
                'idf': idf[ids],
                'id': idd[ids],
                'area': area[ida[ids]]['name'],
                'parent': area[ida[ids]]['parent'],
                'sector': SECTORS[ids].strip(),
                'ucell': [],
                'prim': FDN[ids],
                'bore': aper,
                'k1': k1,
                'tilt': np.rad2deg(tilt),  # deg
                'G': charge * G,
                'GL': T2kG * GL,  # kG
                'polarity': polarity,
                'name': name,
                'sname': sname,
                'sval': sval,
                'type': T[ids].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)},
                **{f'm{k+1}': [] for k in range(6)}
            })

            # BSY coordinates
            if cBSY:
                process_bsy(name,eles[-1])

            # UND coordinates
            if cUND:
                process_und(name,eles[-1])

    elif kwn in ('MONI','INST','HKIC','VKIC'):
        for name in names:
            ids = strmatch(name,N,True)
            ide = [ids[0]-1, ids[-1]]  # [entrance, exit]
            sdsp = np.mean(Sd[ide])  # m (beam center)
            suml = np.mean(S[ide])  # m (beam center)
            energy = E[ids[0]]  # GeV
            leng = np.sum(L[ids])  # m
            coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
            eles.append({
                'idf': idf[ids[0]],
                'id': idd[ids[0]],
                'area': area[ida[ids[0]]]['name'],
                'parent': area[ida[ids[0]]]['parent'],
                'sector': SECTORS[ids[0]].strip(),
                'ucell': [],
                'prim': FDN[ids[0]],
                'name': name,
                'type': T[ids[0]].strip(),
                'energy': energy,
                'leng': leng,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates
            if cBSY:
                process_bsy(name,eles[-1],split=True)

            # UND coordinates
            if cUND:
                process_und(name,eles[-1],split=True)

    elif kwn in ('MARK','PROF','WIRE','IMON','BLMO'):
        if kwn == 'MARK':
            leng = None
        else:
            leng = 0.0 #historical reasons
        for name in names:
            ids = strmatch(name,N,True)[0]
            sdsp = Sd[ids]
            suml = S[ids]
            energy = E[ids] 
            coorc = np.copy(coor[ids])
            eles.append({
                'idf': idf[ids],
                'id': idd[ids],
                'area': area[ida[ids]]['name'],
                'parent': area[ida[ids]]['parent'],
                'sector': SECTORS[ids].strip(),
                'ucell': [],
                'leng': None,
                'prim': FDN[ids],
                'name': name,
                'leng': leng,
                'type': T[ids].strip(),
                'energy': energy,
                'sdsp': sdsp,
                'suml': suml,
                **{f'c{k+1}': coorc[k] for k in range(6)}
            })

            # BSY coordinates
            if cBSY:
                process_bsy(name,eles[-1])

            # UND coordinates
            if cUND:
                process_und(name,eles[-1],split=True)

# deferred devices
nDEPR = 0
pname = [x['parent'] for x in area]

for kwn,eles in ele_dict.items():
    for m in range(len(eles)):
        t = eles[m]['type']
        if t and t[0] == '@':
            deplev = int(t[1])
            if len(t) > 2:
                t = t[3:]  # skip ","
            else:
                t = ''
            nDEPR += 1
            if kwn == 'SBEN':
                z_use = eles[m]['m1']
            else:
                z_use = eles[m]['c1']

            eles[m]['parent'] = '*' + eles[m]['parent']
            eles[m]['area'] = '*' + eles[m]['area']
            eles[m]['type'] = t

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
        id1 = strmatch(f"{name}BEG",N,True)[0]
        id2 = strmatch(f"{name}END",N,True)[0]
        ids = range(id1, id2 + 1)
        jd1 = [i for i,x in enumerate(K) if x == 'SBEN']
        idb = intersection(ids,jd1)[::2]
        ang = P[idb[0], 0]
        X, Y, Z, yaw, pitch, roll = coor[ids, 1], coor[ids, 2], coor[ids, 0], coor[id1, 5], -coor[id1, 4], coor[id1, 3]
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
            jdb = strmatch(name,[N[i] for i in ids])[0]
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
        ids = strmatch(name[n],Bname,True)[0]
        X0 = SBEN[ids][f'm{cflag or ""}2']
        X = X0 + dX[n]
        SBEN[ids][f'm{cflag or ""}2'] = X

    # safety dump bends (permanent magnet dipoles)

    name = ['BXPM1B', 'BXPM1', 'BXPM2']
    for n in range(len(name)):
        if n == 0:  # SXR
            Xm = 1.25
        else:  # HXR
            Xm = -1.215
        id1 = strmatch(f"{name[n]}1",N,True)[0] #center
        id0 = id1 - 1  # entrance
        if n != 2:
            pitch = -coor[id0, 4]
            z0 = coor[id0, 0]
            y0 = coor[id0, 2]
        z1 = coor[id1, 0]
        Ym = y0 + np.tan(pitch) * (z1 - z0)
        yaw = 0
        ids = strmatch(name[n],Bname,True)[0]
        SBEN[ids][f'm{cflag or ""}2'] = Xm
        SBEN[ids][f'm{cflag or ""}3'] = Ym
        SBEN[ids][f'm{cflag or ""}6'] = yaw
        SBEN[ids][f'm{cflag or ""}5'] = -pitch

    # Lambertson septa
    # coor=[z,x,y,roll,-pitch,yaw] (SYMBOLS coordinates)

    name = ['BLRDG0', 'BLXSPS', 'BLXSPH', 'BLRDAS', 'BLRCUS']
    r = 0.010  # radius of field-free channel
    off = -0.004  # beam is 6 mm from top of field-free channel
    for n in range(len(name)):
        if n <= 1 and cflag is not None:
            continue  # no BSY or UND coords for BLRDG0 or BLRL3X
        ids = strmatch(name[n],Bname,True)[0]
        Xm0 = SBEN[ids][f'm{cflag or ""}2']
        Ym0 = SBEN[ids][f'm{cflag or ""}3']
        Zm0 = SBEN[ids][f'm{cflag or ""}1']
        yaw = SBEN[ids][f'm{cflag or ""}6']
        pitch = -SBEN[ids][f'm{cflag or ""}5']
        roll = (np.pi / 180) * SBEN[ids]['tilt']
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
        SBEN[ids][f'm{cflag or ""}2'] = Xm
        SBEN[ids][f'm{cflag or ""}3'] = Ym
        SBEN[ids][f'm{cflag or ""}1'] = Zm

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
        ids = strmatch(name[n],Bname,True)[0]
        Ym0 = SBEN[ids][f'm{cflag or ""}3']
        SBEN[ids][f'm{cflag or ""}3'] = Ym0 + yoff

    # CUSXR extraction magnets
    # coor=[z,x,y,roll,-pitch,yaw] (SYMBOLS coordinates)

    name = ['BRCUSDC1', 'BKRCUS', 'BRCUSDC2']
    for namen in name:
        dname = f'D{namen}A'
        idd = strmatch(dname,N,True)[0]
        ids = strmatch(namen,Bname,True)[0]
        for m in [1,2,3,5,6]:
            SBEN[ids][f'm{cflag or ""}{m}'] = coor[idd, m-1]

    # QDG001 and QDG003

    if cflag is None:  # only linac coordinates
        name = ['QDG001', 'QDG003']
        for n in range(len(name)):
            ids = strmatch(name[n], N)
            KL = np.sum(P[ids, 1] * L[ids])
            ids = strmatch(f'DY{name[n]}', N)[0]
            kick = P[ids, 0]
            off = kick / KL
            ids = strmatch(name[n],Qname,True)[0]
            Xm0 = QUAD[ids]['c2']
            Ym0 = QUAD[ids]['c3']
            Zm0 = QUAD[ids]['c1']
            yaw = QUAD[ids]['c6']
            pitch = -QUAD[ids]['c5']
            roll = QUAD[ids]['c4']
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
            QUAD[ids]['m2'] = Xm
            QUAD[ids]['m3'] = Ym
            QUAD[ids]['m1'] = Zm
            QUAD[ids]['m6'] = yaw
            QUAD[ids]['m5'] = -pitch
            QUAD[ids]['m4'] = roll

    # SXRSS optical components

    name = ['GSXS1', 'MSXS1', 'SLSXS1', 'MSXS2', 'MSXS3']
    dX = 1e-3 * np.array([0, -1.93, -3.85, -3.85, 0])
    for n in range(len(name)):
        ids = strmatch(name[n],Iname,True)[0]
        X0 = INST[ids][f'c{cflag or ""}2']
        Y0 = INST[ids][f'c{cflag or ""}3']
        Z0 = INST[ids][f'c{cflag or ""}1']
        yaw = INST[ids][f'c{cflag or ""}6']
        pitch = -INST[ids][f'c{cflag or ""}5']
        roll = INST[ids][f'c{cflag or ""}4']
        O1 = np.array([[np.cos(yaw), 0, np.sin(yaw)], [0, 1, 0], [-np.sin(yaw), 0, np.cos(yaw)]])
        O2 = np.array([[1, 0, 0], [0, np.cos(pitch), np.sin(pitch)], [0, -np.sin(pitch), np.cos(pitch)]])
        O3 = np.array([[np.cos(roll), -np.sin(roll), 0], [np.sin(roll), np.cos(roll), 0], [0, 0, 1]])
        O = O1 @ O2 @ O3
        t = np.linalg.solve(O, np.array([X0, Y0, Z0]))  # remove roll, pitch, and yaw
        Xr, Yr, Zr = t[0], t[1], t[2]
        Xr = Xr + dX[n]  # apply horizontal offset
        t = O @ np.array([Xr, Yr, Zr])  # restore roll, pitch, and yaw
        Xm, Ym, Zm = t[0], t[1], t[2]
        INST[ids][f'm{cflag or ""}2'] = Xm
        INST[ids][f'm{cflag or ""}3'] = Ym
        INST[ids][f'm{cflag or ""}1'] = Zm
        INST[ids][f'm{cflag or ""}6'] = yaw
        INST[ids][f'm{cflag or ""}5'] = -pitch
        INST[ids][f'm{cflag or ""}4'] = roll

FixMagnetCoords(ele_dict['SBEN'], ele_dict['QUAD'], ele_dict['INST'], K, N, L, P, coor, None)
if cBSY:
    FixMagnetCoords(ele_dict['SBEN'], ele_dict['QUAD'], ele_dict['INST'], K_bsy, N_bsy, L_bsy, P_bsy, coor_bsy, 1)
if cUND:
    FixMagnetCoords(ele_dict['SBEN'], ele_dict['QUAD'], ele_dict['INST'], K_und, N_und, L_und, P_und, coor_und, 2)

# Precision for coordinate output
prec = 1e-6

# ------------------------------------------------------------------------------
# Write SYMBOLS txt-files ...

# SYMBOLS text-file headers and footers

#The following columns in the symbols file are defunct:
#  S[13] H1
#  S[14] H2
#  S[34] XAL_Scale_Name
#  S[35] XAL_Scale_Value
#  S[36] XAL_Polarity
#  S[48] Section
#  S[49] Distance_From_Section_Start
#  S[50] XAL_Keyword


head = ('Solid Edge,AREA,KeyW,ELEMENT,Eng_Name,L_EFF,APER,ANGLE,K1,K2,'  #0-9
        'TILT,E1,E2,H1,H2,ENERGY,SUML,X Coor,Y Coor,Z Coor,'  #10-19
        'X Angle,Y Angle,Z Angle,RF_Frequency,RF_Amplitude,RF_Phase,RF_Gradient,RF_Power_Fraction,Z_Length,Fringe_Field_Integral,'  #20-29
        'Integrated_Field_BL,Field_B,Integrated_Field_Gradient_GL,Field_Gradient_G,XAL_Scale_Name,XAL_Scale_Value,XAL_Polarity,Magnet_X_Coor,Magnet_Y_Coor,Magnet_Z_Coor,'  #30-39
        'Magnet_X_Angle,Magnet_Y_Angle,Magnet_Z_Angle,Solenoid_Strength_KS,Undulator_Period_Length,Undulator_Strength_K,X_Size,Y_Size,Section,Distance_From_Section_Start,'  #40-49
        'XAL_Keyword,S_Display')  #50-51

foot = ('MAD #,AREA,KeyW,ELEMENT,Eng_Name,L_EFF,APER,ANGLE,K1,K2,'
        'TILT,E1,E2,H1,H2,ENERGY,SUML,MAD Z,MAD X,MAD Y,'
        'MAD Psi,MAD Phi,MAD Theta,RF_Frequency,RF_Amplitude,RF_Phase,RF_Gradient,RF_Power_Fraction,Z_Length,Fringe_Field_Integral,Integrated_Field_BL,'
        'Field_B,Integrated_Field_Gradient_GL,Field_Gradient_G,XAL_Scale_Name,XAL_Scale_Value,XAL_Polarity,Magnet_MAD_Z,Magnet_MAD_X,Magnet_MAD_Y,'
        'Magnet_MAD_Psi,Magnet_MAD_Phi,Magnet_MAD_Theta,Solenoid_Strength_KS,Undulator_Period_Length,Undulator_Strength_K,X_Size,Y_Size,Section,Distance_From_Section_Start,'
        'XAL_Keyword,S_Display')

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
for kwn,eles in ele_dict.items():
    for m in range(len(eles)):
        ip.append([eles[m]["idf"], eles[m]['id'], kwn, m])
ip = sorted(ip, key=lambda x: (x[0], x[1]))
    
def arrange_output(system_name, filename):
    filepath = Path(outdir+'/'+fname)
    filepath.parent.mkdir(parents=True, exist_ok=True)
    with filepath.open('wt') as fid:
        fid.write(f'{head}\n')
        fid.write(f'{unit}\n')
        for entry in ip:
            kwn = entry[2]
            m = entry[3]
            TEMP = ele_dict[kwn][m]

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
            if kwn == 'LCAV':
                s[23] = TEMP['freq']
                s[24] = TEMP['ampl']
                s[25] = TEMP['phase']
                s[26] = TEMP['grad']
                s[27] = TEMP['power']
            elif kwn == 'SBEN':
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
            elif kwn == 'QUAD':
                s[6] = TEMP['bore']
                s[8] = TEMP['k']
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
            elif kwn == 'SEXT':
                s[6] = TEMP['bore']
                s[9] = TEMP['k']
                s[10] = TEMP['tilt']
                s[32] = TEMP['GL']
                s[33] = TEMP['G']
            elif kwn == 'SOLE':
                s[6] = TEMP['bore']
                s[30] = TEMP['GL']
                s[31] = TEMP['G']
                s[43] = TEMP['k']
            elif kwn == 'MATR':
                s[44] = TEMP['lambda']
                s[45] = TEMP['k']
            elif kwn in ('RCOL','ECOL'):
                s[46] = TEMP['xgap']
                s[47] = TEMP['ygap']
            elif kwn == 'SROT':
                s[7] = TEMP['ang']
            elif kwn == 'INST':
                if system_name == 'NOMINAL' and 'm1' in TEMP:
                    s[37] = roundoff(TEMP['m1'], prec)
                    s[38] = roundoff(TEMP['m2'], prec)
                    s[39] = roundoff(TEMP['m3'], prec)
                    s[40] = roundoff(TEMP['m4'], prec)
                    s[41] = roundoff(TEMP['m5'], prec)
                    s[42] = roundoff(TEMP['m6'], prec)
                elif system_name == 'BSY' and 'm11' in TEMP:
                    s[37] = roundoff(TEMP['m11'], prec)
                    s[38] = roundoff(TEMP['m12'], prec)
                    s[39] = roundoff(TEMP['m13'], prec)
                    s[40] = roundoff(TEMP['m14'], prec)
                    s[41] = roundoff(TEMP['m15'], prec)
                    s[42] = roundoff(TEMP['m16'], prec)
                elif system_name == 'UND' and 'm21' in TEMP:
                    s[37] = roundoff(TEMP['m21'], prec)
                    s[38] = roundoff(TEMP['m22'], prec)
                    s[39] = roundoff(TEMP['m23'], prec)
                    s[40] = roundoff(TEMP['m24'], prec)
                    s[41] = roundoff(TEMP['m25'], prec)
                    s[42] = roundoff(TEMP['m26'], prec)
            elif kwn == 'MULT':
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
arrange_output('NOMINAL',fname)
if cBSY:
    fname = f'BSY-AD_ACCEL-{optics}.txt'
    arrange_output('BSY',fname)
if cUND:
    fname = f'UND-AD_ACCEL-{optics}.txt'
    arrange_output('UND',fname)

# ------------------------------------------------------------------------------
# Write extra SYMBOLS txt-file ...
# Element name, area name, undulator cell, sector

fname = f'AD_ACCEL-extra-{optics}.txt'
with open(outdir+'/'+fname, 'wt') as fid:
    fid.write('ELEMENT,Area2,Undulator Cell,Sector\n')
    for entry in ip:
        kwn = entry[2]
        m = entry[3]
        if kwn in ['MARK', 'SROT']:
            continue
        TEMP = ele_dict[kwn][m]
        TEMPucell = TEMP['ucell']
        TEMPucell = '' if isinstance(TEMPucell,list) else TEMPucell
        fid.write(f"{TEMP['name']},{TEMP['area']},{TEMPucell},{TEMP['sector']}\n")
    fid.write('ELEMENT,Area2,Undulator Cell,Sector\n')

# ------------------------------------------------------------------------------

print(f'Be sure to add FACET2 elements to {fname}!\n')
