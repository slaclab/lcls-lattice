#!/bin/env python3

import numpy as np
import openpyxl as pyxl
import re
import math
from pathlib import Path


#------------------------------------------
# Tolerances
#------------------------------------------
prec = 1e-6 # Roundoff precision for some symbols output

# - SBENs with abs(ang)<amin will have ang set to zero
# - SBENs or QUADs with abs(k1)<kmin will have k1 set to zero
# - SOLEs with abs(ks)<kmin will have ks set to zero
# - SROTs with abs(ang)<amin will have ang set to zero
amin = 1e-9
kmin = 1e-6

#------------------------------------------
# utility functions.  To be moved to module
#------------------------------------------

def slicer(N,ix):
    return [N[i] for i in ix]

def safe_index(lst, target):
    for i, val in enumerate(lst):
        if val == target:
            return i
    return None

def intersection(x,y):
    return [v for v in x if v in y]

def strmatch(n_str,N_lst,exact=False):
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

optics='18FEB2025s'
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

        #linac            BSY                   UND
froot = [
        ['LCLS2scS',      "BSY-LCLS2scS"      , None],   #  0
        ['LCLS2scSS',     "BSY-LCLS2scSS"     , None],   #  1
        ['LCLS2scS2_X',   "BSY-LCLS2scS2_X"   , None],   #  2
        ['LCLS2scSTXI',   "BSY-LCLS2scSTXI"   , None],   #  3
        ['LCLS2scSTMO',   "BSY-LCLS2scSTMO"   , None],   #  4
        ['LCLS2scH',      "BSY-LCLS2scH"      , None],   #  5
        ['LCLS2scD',      "BSY-LCLS2scD"      , None],   #  6
        ['DIAG0',         None                , None],   #  7
        ['LCLS2scDA',     "BSY-LCLS2scDA"     , None],   #  8 (DASEL)
        ['LCLS2cuH',      "BSY-LCLS2cuH"      , None],   #  9
        ['LCLS2cuHS',     "BSY-LCLS2cuHS"     , None],   # 10
        ['LCLS2cuHXTES',  "BSY-LCLS2cuHXTES"  , None],   # 11
        ['LCLS2cuHTXI',   "BSY-LCLS2cuHTXI"   , None],   # 12
        ['LCLS2cuS',      "BSY-LCLS2cuS"      , None],   # 13
        ['LCLS2cuGSPEC',  None                , None],   # 14
        ['LCLS2cuSPEC',   None                , None]    # 15
]

# ------------------------------------------------------------------------------
# Sequences: SC linac
# SXR line
main_seq = []
main_seq.append({'froot': 0, 'name': 'CATHODE TO DIAG0', 'beg': 'BEGGUNB', 'end': 'ENDHTR', 'offset': [0, 0]})       #0
main_seq.append({'froot': 0, 'name': 'COL0 TO COL1', 'beg': 'BEGCOL0', 'end': 'ENDBC1B', 'offset': [0, 0]})          #1
main_seq.append({'froot': 0, 'name': 'COL1 TO EMIT2', 'beg': 'BEGCOL1', 'end': 'ENDBC2B', 'offset': [0, 0]})         #2
main_seq.append({'froot': 0, 'name': 'EMIT2 TO DOGLEG', 'beg': 'BEGEMIT2', 'end': 'ENDEXT', 'offset': [0, 0]})       #3
main_seq.append({'froot': 0, 'name': 'DOGLEG TO BYPASS', 'beg': 'BEGDOG', 'end': 'ENDDOG', 'offset': [0, 0]})        #4
main_seq.append({'froot': 0, 'name': 'BYPASS TO BKYSP0H', 'beg': 'BEGBYP', 'end': 'ENDBYP', 'offset': [0, 0]})       #5
main_seq.append({'froot': 0, 'name': 'BKYSP0H TO BKYSP0S', 'beg': 'BEGSPD_1', 'end': 'ENDSPD_1', 'offset': [0, 0]})  #6
main_seq.append({'froot': 0, 'name': 'BKYSP0S TO BSYBEG', 'beg': 'BEGSPS', 'end': 'ENDSPS', 'offset': [0, 0]})       #7
main_seq.append({'froot': 0, 'name': 'BSYBEG TO BRCUS1', 'beg': 'BEGSLTS', 'end': 'ENDSLTS', 'offset': [0, 0]})      #8
main_seq.append({'froot': 0, 'name': 'BRCUS1 TO BSYEND', 'beg': 'BEGBSYS', 'end': 'ENDBSYS', 'offset': [0, 0]})      #9
main_seq.append({'froot': 0, 'name': 'BSYEND TO SXRSTART', 'beg': 'BEGLTUS', 'end': 'ENDLTUS', 'offset': [0, 0]})    #10
main_seq.append({'froot': 0, 'name': 'SXRSTART TO BYD1B', 'beg': 'BEGUNDS', 'end': 'ENDDMPS_1', 'offset': [0, 0]})   #11
main_seq.append({'froot': 0, 'name': 'BYD1B TO DUMPB', 'beg': 'BEGDMPS_2', 'end': 'ENDDMPS_2', 'offset': [0, 0]})    #12
# SXR safety dump line
main_seq.append({ 'froot': 1, 'name': 'BYD1B TO SFTDUMPB', 'beg': 'BEGSFTS_1', 'end': 'ENDSFTS_2', 'offset': [0, 0]})  #13
# SXR XTES systems
main_seq.append({ 'froot': 2, 'name': 'SXR 2.X', 'beg': 'BEGSXTES_1', 'end': 'ENDSXTES_2', 'offset': [0, 0]})    #14
main_seq.append({ 'froot': 3, 'name': 'SXR TXI', 'beg': 'BEGSXTES_3', 'end': 'ENDSXTES_3', 'offset': [0, 0]})    #15
main_seq.append({ 'froot': 4, 'name': 'SXR TMO', 'beg': 'BEGSXTES_4', 'end': 'ENDSXTES_4', 'offset': [0, 0]})    #16
# HXR cross-connect
main_seq.append({ 'froot': 5, 'name': 'BKYSP0H TO BSYBEG', 'beg': 'BEGSPH', 'end': 'ENDSPH', 'offset': [0, 0]})   #17
main_seq.append({ 'froot': 5, 'name': 'BSYBEG TO BXSP1H', 'beg': 'BEGSLTH', 'end': 'ENDSLTH', 'offset': [0, 0]})  #18
# BSY dump line
main_seq.append({ 'froot': 6, 'name': 'BKYSP0S TO BKRDAS1', 'beg': 'BEGSPD_2', 'end': 'ENDSPD_2', 'offset': [0, 0]})  #19
main_seq.append({ 'froot': 6, 'name': 'BKRDAS1 TO BSYBEG', 'beg': 'BEGSPD_3', 'end': 'ENDSPD_3', 'offset': [0, 0]})   #20
main_seq.append({ 'froot': 6, 'name': 'BSYBEG TO BSYDUMP', 'beg': 'BEGSLTD', 'end': 'ENDSLTD', 'offset': [0, 0]})     #21
# DIAG0 line
main_seq.append({ 'froot': 7, 'name': 'DIAG0 TO FCDG0DU', 'beg': 'BEGDIAG0', 'end': 'ENDDIAG0', 'offset': [0, 0]})    #22
# DASEL
main_seq.append({ 'froot': 8, 'name': 'BKRDAS1 TO ESA',        'beg': 'BEGSPA', 'end': 'ENDBSYA', 'offset': [0, 0]}) #23
main_seq.append({ 'froot': 8, 'name': 'ESA TO BEAM DUMP EAST', 'beg': 'BEGESA', 'end': 'ENDESA', 'offset': [0, 0]}) #24

# XAL sequences: Cu linac
# HXR line
main_seq.append({ 'froot': 9, 'name': 'CATHODE TO BXG', 'beg': 'BEGGUN', 'end': 'ENDGUN', 'offset': [0, 0]})     #25
main_seq.append({ 'froot': 9, 'name': 'BXG TO BX01', 'beg': 'BEGL0', 'end': 'ENDDL1_1', 'offset': [0, 0]})       #26
main_seq.append({ 'froot': 9, 'name': 'BX01 TO BX02', 'beg': 'BEGDL1_2', 'end': 'DBMARK83', 'offset': [0, -1]})   #27
main_seq.append({ 'froot': 9, 'name': 'BX02 TO QM15', 'beg': 'DBMARK83', 'end': 'DBMARK28', 'offset': [0, -1]})   #28
main_seq.append({ 'froot': 9, 'name': 'QM15 TO FV2', 'beg': 'DBMARK28', 'end': 'ENDL3', 'offset': [0, 0]})         #29
main_seq.append({ 'froot': 9, 'name': 'FV2 TO BSYBEG', 'beg': 'BEGCLTH_0', 'end': 'ENDCLTH_0', 'offset': [0, 0]})    #30
main_seq.append({ 'froot': 9, 'name': 'BSYBEG TO BKRCUS', 'beg': 'BEGCLTH_1', 'end': 'ENDCLTH_1', 'offset': [0, 0]})   #31
main_seq.append({ 'froot': 9, 'name': 'BKRCUS TO BXSP1H', 'beg': 'BEGCLTH_2', 'end': 'ENDCLTH_2', 'offset': [0, 0]})   #32
main_seq.append({ 'froot': 9, 'name': 'BXSP1H TO BKRAPM1', 'beg': 'BEGBSYH_1', 'end': 'ENDBSYH_1', 'offset': [0, 0]})  #33
main_seq.append({ 'froot': 9, 'name': 'BKRAPM1 TO BSYEND', 'beg': 'BEGBSYH_2', 'end': 'ENDBSYH_2', 'offset': [0, 0]})  #34
main_seq.append({ 'froot': 9, 'name': 'BSYEND TO BX31', 'beg': 'BEGLTUH', 'end': 'DBMARK34', 'offset': [0, -1]})     #35
main_seq.append({ 'froot': 9, 'name': 'BX31 TO WS31', 'beg': 'DBMARK34', 'end': 'DBMARK36', 'offset': [0, 0]})       #36
main_seq.append({ 'froot': 9, 'name': 'WS31 TO HXRSTART', 'beg': 'DBMARK36', 'end': 'ENDLTUH', 'offset': [1, 0]})    #37
main_seq.append({ 'froot': 9, 'name': 'HXRSTART TO BYD1', 'beg': 'BEGUNDH', 'end': 'ENDDMPH_1', 'offset': [0, 0]})   #38
main_seq.append({ 'froot': 9, 'name': 'BYD1 TO DUMP', 'beg': 'BEGDMPH_2', 'end': 'ENDDMPH_2', 'offset': [0, 0]})     #39
# HXR safety dump line
main_seq.append({ 'froot': 10, 'name': 'BYD1 TO SFTDUMP', 'beg': 'BEGSFTH_1', 'end': 'ENDSFTH_2', 'offset': [0, 0]})  #40
# HXR XTES systems
main_seq.append({ 'froot': 11, 'name': 'HXR XTES', 'beg': 'BEGHXTES_1', 'end': 'ENDHXTES_2', 'offset': [0, 0]})     #41
main_seq.append({ 'froot': 12, 'name': 'HXR TXI', 'beg': 'BEGHXTES_3', 'end': 'ENDHXTES_3', 'offset': [0, 0]})      #42
# SXR cross-connect
main_seq.append({ 'froot': 13, 'name': 'BKRCUS TO BRCUS1', 'beg': 'BEGCLTS', 'end': 'ENDCLTS', 'offset': [0, 0]})   #43
# gun spectrometer
main_seq.append({ 'froot': 14, 'name': 'BXG TO GUN SPECT DUMP', 'beg': 'BEGGSPEC', 'end': 'ENDGSPEC', 'offset': [0, 0]})   #44
# 135 MeV spectrometer
main_seq.append({ 'froot': 15, 'name': 'BX01 TO 135-MEV SPECT DUMP', 'beg': 'BEGSPEC', 'end': 'ENDSPEC', 'offset': [0, 0]})   #45

# ------------------------------------------------------------------------------
# machine areas
# scS
area = []
area.append({'name': 'GUNB', 'beg': 'BEGGUNB', 'end': 'ENDGUNB', 'offset': [0, 0], 'parent': 'GUNB'})
area.append({'name': 'L0B', 'beg': 'BEGL0B', 'end': 'ENDL0B', 'offset': [0, 0], 'parent': 'L0B'})
area.append({'name': 'HTR', 'beg': 'BEGHTR', 'end': 'ENDHTR', 'offset': [0, 0], 'parent': 'HTR'})
area.append({'name': 'COL0', 'beg': 'BEGCOL0', 'end': 'ENDCOL0', 'offset': [0, 0], 'parent': 'COL0'})
area.append({'name': 'L1B', 'beg': 'BEGL1B', 'end': 'ENDL1B', 'offset': [0, 0], 'parent': 'L1B'})
area.append({'name': 'BC1B', 'beg': 'BEGBC1B', 'end': 'ENDBC1B', 'offset': [0, 0], 'parent': 'BC1B'})
area.append({'name': 'COL1', 'beg': 'BEGCOL1', 'end': 'ENDCOL1', 'offset': [0, 0], 'parent': 'COL1'})
area.append({'name': 'L2B', 'beg': 'BEGL2B', 'end': 'ENDL2B', 'offset': [0, 0], 'parent': 'L2B'})
area.append({'name': 'BC2B', 'beg': 'BEGBC2B', 'end': 'ENDBC2B', 'offset': [0, 0], 'parent': 'BC2B'})
area.append({'name': 'EMIT2', 'beg': 'BEGEMIT2', 'end': 'ENDEMIT2', 'offset': [0, 0], 'parent': 'EMIT2'})
area.append({'name': 'L3B', 'beg': 'BEGL3B', 'end': 'ENDL3B', 'offset': [0, 0], 'parent': 'L3B'})
area.append({'name': 'EXT', 'beg': 'BEGEXT', 'end': 'ENDEXT', 'offset': [0, 0], 'parent': 'EXT'})
area.append({'name': 'DOG', 'beg': 'BEGDOG', 'end': 'ENDDOG', 'offset': [0, 0], 'parent': 'DOG'})
area.append({'name': 'BYP', 'beg': 'BEGBYP', 'end': 'ENDBYP', 'offset': [0, 0], 'parent': 'BYP'})
area.append({'name': 'SPD_1', 'beg': 'BEGSPD_1', 'end': 'ENDSPD_1', 'offset': [0, 0], 'parent': 'SPD'})
area.append({'name': 'SPS', 'beg': 'BEGSPS', 'end': 'ENDSPS', 'offset': [0, 0], 'parent': 'SPS'})
area.append({'name': 'SLTS', 'beg': 'BEGSLTS', 'end': 'ENDSLTS', 'offset': [0, 0], 'parent': 'SLTS'})
area.append({'name': 'BSYS', 'beg': 'BEGBSYS', 'end': 'ENDBSYS', 'offset': [0, 0], 'parent': 'BSYS'})
area.append({'name': 'LTUS', 'beg': 'BEGLTUS', 'end': 'ENDLTUS', 'offset': [0, 0], 'parent': 'LTUS'})
area.append({'name': 'UNDS', 'beg': 'BEGUNDS', 'end': 'ENDUNDS', 'offset': [0, 0], 'parent': 'UNDS'})
area.append({'name': 'DMPS_1', 'beg': 'BEGDMPS_1', 'end': 'ENDDMPS_1', 'offset': [0, 0], 'parent': 'DMPS'})
area.append({'name': 'DMPS_2', 'beg': 'BEGDMPS_2', 'end': 'ENDDMPS_2', 'offset': [0, 0], 'parent': 'DMPS'})
# scSS
area.append({'name': 'SFTS_1', 'beg': 'BEGSFTS_1', 'end': 'ENDSFTS_1', 'offset': [0, 0], 'parent': 'SFTS'})
area.append({'name': 'SFTS_2', 'beg': 'BEGSFTS_2', 'end': 'ENDSFTS_2', 'offset': [0, 0], 'parent': 'SFTS'})
# scSXTES/scS2_X/scSTXI/scSTMO
area.append({'name': 'SXTES_1', 'beg': 'BEGSXTES_1', 'end': 'ENDSXTES_1', 'offset': [0, 0], 'parent': 'SXTES'})  # common line
area.append({'name': 'SXTES_2', 'beg': 'BEGSXTES_2', 'end': 'ENDSXTES_2', 'offset': [0, 0], 'parent': 'SXTES'})  # "2.X" line
area.append({'name': 'SXTES_3', 'beg': 'BEGSXTES_3', 'end': 'ENDSXTES_3', 'offset': [0, 0], 'parent': 'SXTES'})  # TXI line
area.append({'name': 'SXTES_4', 'beg': 'BEGSXTES_4', 'end': 'ENDSXTES_4', 'offset': [0, 0], 'parent': 'SXTES'})  # TMO line
# scH
area.append({'name': 'SPH', 'beg': 'BEGSPH', 'end': 'ENDSPH', 'offset': [0, 0], 'parent': 'SPH'})
area.append({'name': 'SLTH', 'beg': 'BEGSLTH', 'end': 'ENDSLTH', 'offset': [0, 0], 'parent': 'SLTH'})
# scD
area.append({'name': 'SPD_2', 'beg': 'BEGSPD_2', 'end': 'ENDSPD_2', 'offset': [0, 0], 'parent': 'SPD'})
area.append({'name': 'SPD_3', 'beg': 'BEGSPD_3', 'end': 'ENDSPD_3', 'offset': [0, 0], 'parent': 'SPD'})
area.append({'name': 'SLTD', 'beg': 'BEGSLTD', 'end': 'ENDSLTD', 'offset': [0, 0], 'parent': 'SLTD'})
# DIAG0
area.append({'name': 'DIAG0', 'beg': 'BEGDIAG0', 'end': 'ENDDIAG0', 'offset': [0, 0], 'parent': 'DIAG0'})
# DASEL
area.append({'name': 'DASEL', 'beg': 'BEGDASEL', 'end': 'ENDDASEL', 'offset': [0, 0], 'parent': 'DASEL'})
area.append({'name': 'ALINE', 'beg': 'BEGBSYA_2', 'end': 'ENDBSYA_2', 'offset': [0, 0], 'parent': 'ALINE'})
# cuH
area.append({'name': 'GUN', 'beg': 'BEGGUN', 'end': 'ENDGUN', 'offset': [0, 0], 'parent': 'GUN'})
area.append({'name': 'L0', 'beg': 'BEGL0', 'end': 'ENDL0', 'offset': [0, 0], 'parent': 'L0'})
area.append({'name': 'DL1_1', 'beg': 'BEGDL1_1', 'end': 'ENDDL1_1', 'offset': [0, 0], 'parent': 'DL1'})
area.append({'name': 'DL1_2', 'beg': 'BEGDL1_2', 'end': 'ENDDL1_2', 'offset': [0, 0], 'parent': 'DL1'})
area.append({'name': 'L1', 'beg': 'BEGL1', 'end': 'ENDL1', 'offset': [0, 0], 'parent': 'L1'})
area.append({'name': 'BC1', 'beg': 'BEGBC1', 'end': 'ENDBC1', 'offset': [0, 0], 'parent': 'BC1'})
area.append({'name': 'L2', 'beg': 'BEGL2', 'end': 'ENDL2', 'offset': [0, 0], 'parent': 'L2'})
area.append({'name': 'BC2', 'beg': 'BEGBC2', 'end': 'ENDBC2', 'offset': [0, 0], 'parent': 'BC2'})
area.append({'name': 'L3', 'beg': 'BEGL3', 'end': 'ENDL3', 'offset': [0, 0], 'parent': 'L3'})
area.append({'name': 'CLTH_0', 'beg': 'BEGCLTH_0', 'end': 'ENDCLTH_0', 'offset': [0, 0], 'parent': 'CLTH'})
area.append({'name': 'CLTH_1', 'beg': 'BEGCLTH_1', 'end': 'ENDCLTH_1', 'offset': [0, 0], 'parent': 'CLTH'})
area.append({'name': 'CLTH_2', 'beg': 'BEGCLTH_2', 'end': 'ENDCLTH_2', 'offset': [0, 0], 'parent': 'CLTH'})
area.append({'name': 'BSYH_1', 'beg': 'BEGBSYH_1', 'end': 'ENDBSYH_1', 'offset': [0, 0], 'parent': 'BSYH'})
area.append({'name': 'BSYH_2', 'beg': 'BEGBSYH_2', 'end': 'ENDBSYH_2', 'offset': [0, 0], 'parent': 'BSYH'})
area.append({'name': 'LTUH', 'beg': 'BEGLTUH', 'end': 'ENDLTUH', 'offset': [0, 0], 'parent': 'LTUH'})
area.append({'name': 'UNDH', 'beg': 'BEGUNDH', 'end': 'ENDUNDH', 'offset': [0, 0], 'parent': 'UNDH'})
area.append({'name': 'DMPH_1', 'beg': 'BEGDMPH_1', 'end': 'ENDDMPH_1', 'offset': [0, 0], 'parent': 'DMPH'})
area.append({'name': 'DMPH_2', 'beg': 'BEGDMPH_2', 'end': 'ENDDMPH_2', 'offset': [0, 0], 'parent': 'DMPH'})
# cuHS
area.append({'name': 'SFTH_1', 'beg': 'BEGSFTH_1', 'end': 'ENDSFTH_1', 'offset': [0, 0], 'parent': 'SFTH'})
area.append({'name': 'SFTH_2', 'beg': 'BEGSFTH_2', 'end': 'ENDSFTH_2', 'offset': [0, 0], 'parent': 'SFTH'})
# cuHXTES/cuHTXI
area.append({'name': 'HXTES_1', 'beg': 'BEGHXTES_1', 'end': 'ENDHXTES_1', 'offset': [0, 0], 'parent': 'HXTES'})  # common line
area.append({'name': 'HXTES_2', 'beg': 'BEGHXTES_2', 'end': 'ENDHXTES_2', 'offset': [0, 0], 'parent': 'HXTES'})  # XTES line
area.append({'name': 'HXTES_3', 'beg': 'BEGHXTES_3', 'end': 'ENDHXTES_3', 'offset': [0, 0], 'parent': 'HXTES'})  # TXI line
# cuS
area.append({'name': 'CLTS', 'beg': 'BEGCLTS', 'end': 'ENDCLTS', 'offset': [0, 0], 'parent': 'CLTS'})
# cuGSPEC
area.append({'name': 'GSPEC', 'beg': 'BEGGSPEC', 'end': 'ENDGSPEC', 'offset': [0, 0], 'parent': 'GSPEC'})
# cuSPEC
area.append({'name': 'SPEC', 'beg': 'BEGSPEC', 'end': 'ENDSPEC', 'offset': [0, 0], 'parent': 'SPEC'})

# ------------------------------------------------------------------------------
# linac coordinate system
linac1 = []
linac1.append({"froot0":1})
linac1.append({"froot0":2})
linac1.append({"froot0":3})
linac1.append({"froot0":4})
linac1.append({"froot0":5})
linac1.append({"froot0":6})
linac1.append({"froot0":7})
linac1.append({"froot0":8})
linac1.append({"froot0":9})
linac1.append({"froot0":10})
linac1.append({"froot0":11})
linac1.append({"froot0":12})
linac1.append({"froot0":13})
linac1.append({"froot0":14})
linac1.append({"froot0":15})
linac1.append({"froot0":16})

# ------------------------------------------------------------------------------
# special coordinate system regions
other1_seqs = []
other1_seqs.append({"froot": 0,  "beg": "BEGSPD_1",   "end": "ENDDMPS_2",  "offset": np.array([0, 0])})
other1_seqs.append({"froot": 1,  "beg": "BEGSFTS_1",  "end": "ENDSFTS_2",  "offset": np.array([0, 0])})
other1_seqs.append({"froot": 2,  "beg": "BEGSXTES_1", "end": "ENDSXTES_2", "offset": np.array([0, 0])})
other1_seqs.append({"froot": 3,  "beg": "BEGSXTES_3", "end": "ENDSXTES_3", "offset": np.array([0, 0])})
other1_seqs.append({"froot": 4,  "beg": "BEGSXTES_4", "end": "ENDSXTES_4", "offset": np.array([0, 0])})
other1_seqs.append({"froot": 5,  "beg": "BEGSPH",     "end": "ENDSLTH",    "offset": np.array([0, 0])})
other1_seqs.append({"froot": 6,  "beg": "BEGSPD_2",   "end": "ENDSLTD",    "offset": np.array([0, 0])})
other1_seqs.append({"froot": 8,  "beg": "BEGDASEL",   "end": "ENDBSYA_2",  "offset": np.array([0, 0])})
other1_seqs.append({"froot": 9,  "beg": "BEGCLTH_0",  "end": "ENDDMPH_2",  "offset": np.array([0, 0])})
other1_seqs.append({"froot": 10, "beg": "BEGSFTH_1",  "end": "ENDSFTH_2",  "offset": np.array([0, 0])})
other1_seqs.append({"froot": 11, "beg": "BEGHXTES_1", "end": "ENDHXTES_2", "offset": np.array([0, 0])})
other1_seqs.append({"froot": 12, "beg": "BEGHXTES_3", "end": "ENDHXTES_3", "offset": np.array([0, 0])})
other1_seqs.append({"froot": 13, "beg": "BEGCLTS",    "end": "ENDCLTS",    "offset": np.array([0, 0])})

other2_seqs=[]

cBSY=len(other1_seqs)>0
cUND=len(other2_seq2)>0

from xtffs2mat import xtffs2mat
from xtffs2mat_obj import xtffs2mat_obj

# ------------------------------------------------------------------------------
# read the MAD output files
# ------------------------------------------------------------------------------

idf, ids, idd = [], [], []  # idf: which MAD output file an element came from
                            # ids: which XAL sequence an element belongs to
                            # idd: ordinal position in MAD output file

raw_file_data = []
for froot_ix,file_root in enumerate([x[0] for x in froot]):
    fname = f'{file_root}_survey.tape'
    print(f'Opening file {fname}')
    raw_file_data.append(xtffs2mat_obj(fname,froot_ix))

for ix,seq1 in enumerate(main_seq):
    raw_data = raw_file_data[seq1['froot']]

    names = [x.name for x in raw_data]
    id1 = names.index(seq1['beg']) + seq1['offset'][0]
    id2 = names.index(seq1['end']) + seq1['offset'][1]

    seq1['eles'] = raw_data[slice(id1,id2+1)]
    names = [x.name for x in seq1['eles']]

# get BSY lines
if cBSY:
    raw_file_data = []
    for froot_ix,file_root in enumerate([x[1] for x in froot]):
        if file_root != None:
            fname = f'{file_root}_survey.tape'
            print(f'Opening file {fname}')
            raw_file_data.append(xtffs2mat_obj(fname,froot_ix))
        else:
            raw_file_data.append(None)

    for ix,other1_seq in enumerate(other1_seqs):
        raw_data = raw_file_data[other1_seq['froot']]

        names = [x.name for x in raw_data]
        id1 = names.index(other1_seq['beg']) + other1_seq['offset'][0]
        id2 = names.index(other1_seq['end']) + other1_seq['offset'][1]

        other1_seq['eles'] = raw_data[slice(id1,id2+1)]
# get UND lines
if cUND:
    raw_file_data = []
    for froot_ix,file_root in enumerate([x[2] for x in froot]):
        if file_root != None:
            fname = f'{file_root}_survey.tape'
            print(f'Opening file {fname}')
            raw_file_data.append(xtffs2mat_obj(fname))
        else:
            raw_file_data.append(None)

    for n,other2_seq in enumerate(other2_seqs):
        raw_data = raw_file_data[seq1['froot']]

        id1 = raw_data.N.index(other2_seq['beg']) + other2_seq['offset'][0]
        id2 = raw_data.N.index(other2_seq['end']) + other2_seq['offset'][1]

        seq1['eles'] = raw_data[slice(id1,id2+1)]

def FixUpgradeNames(seq_data):
    # Device names in upgraded SXR cells have "_" appended ... remove it
    for seq1 in seq_data:
        for ele in seq1['eles']:
            if ele.name.endswith('_'):
                ele.name = ele.name[:-1]

# Fix device names in upgraded SXR cells
FixUpgradeNames(main_seq)
if cBSY:
  FixUpgradeNames(other1_seqs)
if cUND:
  FixUpgradeNames(other2_seq)

# initialize the suml key in the main_seq dictionary
for ix,seq1 in enumerate(main_seq):
    seq1['suml'] = seq1['eles'][0].suml

# assign machine areas

for area1 in area:
    for seq1 in main_seq:
        names = [x.name for x in seq1['eles']]
        id1 = safe_index(names, area1['beg'])
        if id1 is not None:
          id1 += area1['offset'][0]
        if id2 is not None:
          id2 += area1['offset'][1]
        id2 = safe_index(names, area1['end']) 
        if id1 is not None and id2 is not None:
          for ele_ix in range(id1,id2+1):
            seq1['eles'][ele_ix].area = area1
        elif id1 is not None and id2 is None:
          for ele_ix in range(id1,len(seq1['eles'])):
            seq1['eles'][ele_ix].area = area1
        elif id1 is None and id2 is not None:
          for ele_ix in range(0,id2+1):
            seq1['eles'][ele_ix].area = area1
    if cBSY:
      for other1_seq in other1_seqs:
          names = [x.name for x in other1_seq['eles']]
          id1 = safe_index(names, area1['beg'])
          if id1 is not None:
            id1 += area1['offset'][0]
          if id2 is not None:
            id2 += area1['offset'][1]
          id2 = safe_index(names, area1['end']) 
          if id1 is not None and id2 is not None:
            for ele_ix in range(id1,id2+1):
              other1_seq['eles'][ele_ix].area = area1
          elif id1 is not None and id2 is None:
            for ele_ix in range(id1,len(other1_seq['eles'])):
              other1_seq['eles'][ele_ix].area = area1
          elif id1 is None and id2 is not None:
            for ele_ix in range(0,id2+1):
              other1_seq['eles'][ele_ix].area = area1
    if cUND:
      for other2_seq in other2_seqs:
          names = [x.name for x in other2_seq['eles']]
          id1 = safe_index(names, area1['beg'])
          if id1 is not None:
            id1 += area1['offset'][0]
          if id2 is not None:
            id2 += area1['offset'][1]
          id2 = safe_index(names, area1['end']) 
          if id1 is not None and id2 is not None:
            for ele_ix in range(id1,id2+1):
              other2_seq['eles'][ele_ix].area = area1
          elif id1 is not None and id2 is None:
            for ele_ix in range(id1,len(other2_seq['eles'])):
              other2_seq['eles'][ele_ix].area = area1
          elif id1 is None and id2 is not None:
            for ele_ix in range(0,id2+1):
              other2_seq['eles'][ele_ix].area = area1

# special handling for rolled dump lines and A-line
def fix_dump_coords(seq):
    for seq1 in seq:
        names = [x.name for x in seq1['eles']]

        # set roll angle for SXR dump line components
        id1 = safe_index(names, 'RODMP1S')
        id2 = safe_index(names, 'RODMP2S')
        if id1 is not None and id2 is not None:
            ARODMP1S=seq1['eles'][id1].raw_params[4]
            for i in range(id1,id2-1+1):  #Want the ele just before RODMP2S
                seq1['eles'][i].coor[5]=ARODMP1S

        # set roll angle for SXR dump line components
        id1 = safe_index(names, 'RODMP2S')
        id2 = safe_index(names, 'ENDDMPS_2') 
        if id1 is not None and id2 is not None:
            for i in range(id1,id2+1):
                seq1['eles'][i].coor[5]=0.0

        # set roll angle for HXR dump line components
        id1 = safe_index(names, 'RODMP1H')
        id2 = safe_index(names, 'RODMP2H') 
        if id1 is not None and id2 is not None:
            ARODMP1H=seq1['eles'][id1].raw_params[4]
            for i in range(id1,id2-1+1):  #Want the ele just before RODMP2H
                seq1['eles'][i].coor[5]=ARODMP1H

        id1 = safe_index(names, 'RODMP2H')
        id2 = safe_index(names, 'ENDBSYA_2') 
        if id1 is not None and id2 is not None:
            ARODMP1H=seq1['eles'][id1].raw_params[4]
            for i in range(id1,id2+1):
                seq1['eles'][i].coor[5]=0.0

def fix_aline_coords(seq):
    # Implementation of FixAlineCoords function
    # set roll angle for A-line components
    for seq1 in seq:
        names = [x.name for x in seq1['eles']]

        # set roll angle for SXR dump line components
        id1 = safe_index(names, 'ROLL2')
        id2 = safe_index(names, 'ENDBSYA_2')
        if id1 is not None and id2 is not None:
            AROLL2=seq1['eles'][id1].raw_params[4]
            for i in range(id1,id2+1):
                seq1['eles'][i].coor[5]=AROLL2

def fix_sxtes_coords(seq):
    # Implementation of FixSXTESCoords function
    # fix BSY coordinates for selected SXTES system devices per P. Stephens
    fix_names = [
        'MR1K3_VGC_1', 'ND1S', 'SP1K1_MONO_VGC_1',  # 2.2 line
        'IM1K3_PPM', 'BT1K3_AIR',  # TXI line
        'BT2K0_PLEG_TMO', 'LUSI'  # TMO line
    ]
    coor_ids = [
        1, 1, 1,
        0, 0,
        -1, 0
    ]
    coor_vals = [
        -0.8826040, -2.0921000, -0.7249275,
        1.0694435, 1.0480923,
        1.2500000, -1.2194000
    ]
    for fix_name, coor_id, coor_val in zip(fix_names,coor_ids,coor_vals):
        if coor_id == -1:
            continue
        for seq1 in seq:
            names = [x.name for x in seq1['eles']]
            id_ = safe_index(names,fix_names)
            if id_ is not None:
                seq1['eles'][id_].coor[coor_id] = coor_val

fix_dump_coords(main_seq)
fix_aline_coords(main_seq)

if cBSY:
    fix_dump_coords(other1_seqs)
    fix_aline_coords(other1_seqs)
    fix_sxtes_coords(other1_seqs)

if cUND:
    fix_dump_coords(other2_seq)
    fix_aline_coords(other2_seq)

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

FINT = {}
UNDPARM_K = {}
UNDPARM_L = {}
for fname in vfile:
    with open(fname, 'r') as f:
        for line in f:
          if line.startswith("Value of expression"):
            data = line.split()
            if 'FINT' in data[3]:
                name = data[3].strip('"').replace('[',' ').replace(']','').split()[0]
                FINT[name] = float(data[5])
                if name[-1] == 'A':
                    FINT[name[:-1]+'B'] = float(data[5])
                elif name[-1] == '1':
                    FINT[name[:-1]+'2'] = float(data[5])
            else:
              name = data[3].strip('"')
              if name[-2:] == '_L':
                UNDPARM_L[name[:-2]] = float(data[5])
              elif name[-2:] == '_K':
                UNDPARM_K[name[:-2]] = float(data[5])

for seq1 in main_seq:
    keys = [x.key for x in seq1['eles']]
    ids = strmatch('SBEN',keys,True)
    for id_ in ids:
        name = seq1['eles'][id_].name
        seq1['eles'][id_].params['fint'] = FINT[name]
  
    ids = strmatch('MATR',keys,True)
    for id_ in ids:
        name = seq1['eles'][id_].name
        seq1['eles'][id_].params['undl'] = UNDPARM_L[name]
        seq1['eles'][id_].params['undk'] = UNDPARM_K[name]
  
# Shared devices (devices which see both kicked and unkicked beams)
area_name_all = ['DIAG0', 'SPH', 'SPS', 'SPA', 'CLTS']
ele_name_all = ['BPMDG000', 'BPMSPH', 'BPMSPS', 'BPMDAS', 'BPMCUS']

for ele_name, area_name in zip(ele_name_all,area_name_all):
    for seq1 in main_seq:
        names = [x.name for x in seq1['eles']]
        ids = strmatch(ele_name,names,True)

        for ele in [seq1['eles'][x] for x in ids]:
            if ele.area == area_name:
                ele.name = ele.name + '?'

    if cBSY:
      for other1_seq in other1_seqs:
          names = [x.name for x in other1_seq['eles']]
          ids = strmatch(ele_name,names,True)

          for ele in [other1_seq['eles'][x] for x in ids]:
              if ele.area == area_name:
                  ele.name = ele.name + '?'

    if cUND:
      for other2_seq in other2_seqs:
          names = [x.name for x in other2_seq['eles']]
          ids = strmatch(ele_name,names,True)

          for ele in [other2_seq['eles'][x] for x in ids]:
              if ele.area == area_name:
                  ele.name = ele.name + '?'

# copy T1 into TILT slot
ele_names = ['CQ01', 'SQ01', 'CQ01B', 'SQ01B', 'SQ02B']
for ele_name in ele_names:
    for eles in [x['eles'] for x in main_seq]:
        names = [x.name for x in eles]
        ids = strmatch(ele_name,names,True)
        for id_ in ids:
            eles[id_].raw_params[3] = eles[id_].raw_params[5]

#def assign_ucell(N, coor, idf):
def assign_ucell(seq):
    # NOTE: coordinates are assumed to be in MAD (not SYMBOLS) order
    filename = f'{script_dir}/sectors.xlsx'

    #UCELL = ['' for x in N]

    wb= pyxl.load_workbook(filename,data_only=True)

    # Read SXR sheet
    sxr_sht = wb.worksheets[2]
    sxr_data = sxr_sht['A2':'E36']
    ncell = len(sxr_data)
    ucell = []
    for row in sxr_data:
        ucell.append({'name':row[0].value,'froot':row[1].value,'Zbeg':row[3].value,'Zend':row[4].value})

    # Read HXR sheet
    hxr_sht = wb.worksheets[3]
    hxr_data = hxr_sht['A2':'E39']
    ncell = len(hxr_data)
    for row in hxr_data:
        ucell.append({'name':row[0].value,'froot':row[1].value,'Zbeg':row[3].value,'Zend':row[4].value})
    
    wb.close()
    # Combine data from both sheets
    
    for cell in ucell:
        for eles in [x['eles'] for x in seq]:
            froots = [x.froot_ix for x in eles]
            id1 = [i for i,x in enumerate(froots) if x == cell['froot']]
            id2 = [i for i,x in enumerate(eles) if x.coor[2] > cell['Zbeg']]
            inter1 = intersection(id1,id2)
            if inter1:
              inter1 = inter1[0]
            else:
              continue
            id3 = [i for i,x in enumerate(eles) if x.coor[2] < cell['Zend']]
            inter2 = intersection(id1,id3)
            if inter2:
              inter2 = inter2[-1]
            else:
              continue
            for jd in range(inter1,inter2+1):
                eles[jd].params['ucell'] = cell['name']

# Assign undulator cell names
assign_ucell(other1_seqs)

def read_sector():
    filename = f'{script_dir}/sectors.xlsx'
    wb= pyxl.load_workbook(filename,data_only=True)

    # read worksheet 1 (scS)
    sheet = wb.worksheets[0]
    data = sheet['A4':'J58']
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
    data = sheet['A4':'J37']
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

def set_sector(seq, sector):
    #froot and sector numbers from read_sector() are ordered starting with 1.
    if seq[0]['eles'][0].froot_ix+1 == sector['froot']:
        return
    for seq_eles in [x['eles'] for x in seq]:
        names = [x.name for x in seq_eles]
        Z = [x.coor[2] for x in seq_eles]

        if sector['Nbeg'] == '':
            jd1 = [i for i,x in enumerate(Z) if x > sector['Zbeg']]
            if jd1 == []:
                return
        else:
            jd1 = strmatch(sector['Nbeg'],names,True)
            if jd1 == []:
                return

        if sector['Nend'] == '':
            jd2 = [i for i,x in enumerate(Z) if x < sector['Zend']]
        else:
            jd2 = strmatch(sector['Nend'],names,True)

        inter = intersection(jd1,jd2)
        for ix in inter:
            seq_eles[ix].sector = sector['name']

def assign_sector(seq, other1):
    sect_SC, sect_Cu = read_sector()

    for sector in sect_SC:
        if sector['BSY'] == 0:
            set_sector(seq, sector)
        else:
            set_sector(other1, sector)
    for sector in sect_Cu:
        if sector['BSY'] == 0:
            set_sector(seq, sector)
        else:
            set_sector(other1, sector)

# Assign sector names
assign_sector(main_seq, other1_seqs)

# MAD SURVEY coordinates  [x,y,z,theta,phi   ,psi]
# correspond to SolidEdge [z,x,y,roll ,-pitch,yaw]
ic = [2, 0, 1, 5, 4, 3]
for seq1 in main_seq:
    for ele in seq1['eles']:
        ele.dbcoor = ele.coor[ic]
        ele.dbcoor[4] = -1*ele.coor[4]
if cBSY:
    for other1_seq in other1_seqs:
        for ele in other1_seq['eles']:
            ele.dbcoor = ele.coor[ic]
            ele.dbcoor[4] = -1*ele.coor[4]

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

with open('power_fractions.dat','r') as f:
    power_fraction_data = {
      key.strip(): float(value.strip())
      for line in f if line.strip()
      for key, value in [line.split(':', 1)]
    	}

# process by keyword

MADK = [
    'LCAV': [], 'SBEN': [], 'QUAD': [], 'SEXT': [], 'SOLE': [], 'MATR': [], 'RCOL': [], 'ECOL': [], 'SROT': [],
    'HKIC': [], 'VKIC': [], 'MONI': [], 'WIRE': [], 'PROF': [], 'IMON': [], 'BLMO': [], 'INST': [],
    'MARK': [], 'MULT': []
]
def get_attr_lst(eles,ix_lst,att):
    return [getattr(eles[ix],att) for ix in ix_lst]

for seq in main_seq:
    seq_eles = seq['eles']
    neles = len(seq_eles)
    for kwn in MADK.keys():
        kixs = strmatch(kwn,[x.key for x in seq_eles])
        knames = [seq_eles[x].name for x in kixs]
        # kixs:  all indexes in seq_eles that match kwn
        # knames:  all names in seq_eles that match kwn
        if kwn == 'LCAV':
            # create list of unique names that will allow unsplitting
            uniq_names = knames.copy()
            for i in range(len(uniq_names)):
                if uniq_names[i][:4] in ['CAVL', 'CAVC']:  # unique in 7 characters
                    uniq_names[i] = uniq_names[i][:7]
                else:  # unique in 6 characters
                    uniq_names[i] = uniq_names[i][:6]
            uniq_names = list(dict.fromkeys(uniq_names)) # de-dup while preserving order
    
            for uniq_name in uniq_names:
                #FOO Flag following conditional for removal
                if uniq_name.startswith('TCX'):
                    ids = strmatch(uniq_name,knames,True)
                else:
                    ids = strmatch(uniq_name,knames)
                #ids:  all elements with sane unique-ified name ... indicating they are 
                #      seqment of a split element
                id1 = ids[0]  # first segment
                ide = [id1-1, ids[-1]]  # [entrance, exit]
                ends = get_attr_lst(seq_eles, [id1-1,ids[-1]], '.Sd')

                # Sd is floor z of element end
                #   sdsp is element middle in floor z coords
                # S is running sum of element lengths
                #   suml is repurposed here to elment middle in running sum coords
                sdsp = np.mean(seq_eles,ide,'Sd')
                suml = np.mean(seq_eles,ide,'S')
                dist = suml - seq['suml']  # m (sequence start to beam center)
                energy = np.mean(seq_eles,ide,'energy')
                leng = np.sum(get_attr_lst(seq_eles,ids,L)

                freq = seq_eles[id1].raw_params[4]
                ampl = np.sum([x[5] for x in get_attr_lst(seq_eles,ids,'raw_params')])
                phase = seq_eles[id1].raw_params[6]
                grad = ampl / leng  # MeV/m
                if re.match(r'K\d\d_\d[ABCD]', uniq_name[:6]):  # i.e. K27_3D
                    id = strmatch(name[0:5],N)
                    ampls = [x[5] for x in get_attr_lst(seq_eles,ids,'raw_params')]
                    lengs = get_attr_lst(seq_eles,ids,'length')
                    grad0 = np.min(ampls / lengs)
                    if grad0 == 0:
                        power = power_fraction_data[name]
                    else:
                        power = 0.25 * round((grad / grad0) ** 2)  # KLYS power fraction (1)
                else:
                    power = 1
                coor_start = seq_eles[ide[0]].coor
                coor_end = seq_eles[ide[1]].coor
                coorc = [(a+b)/2 for a,b in zip(coor_start,coor_end)]
                MADK[kwn].append({
                    'idf': seq_eles[id1].froot_ix,
                    'id': seq_eleq[id1].file_ord,
                    'seq': seq.name,
                    'area': seq.area['name'],
                    'parent': seq.area['parent'],
                    'sector': seq_eles[id1].sector,
                    'ucell': [],
                    'prim': seq_eles[id1].fdn,
                    'name': uniq_name,
                    'type': seq_eles[id1].ele_type,
                    'dist': dist,
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
                    MADK[kwn][-1][f'c1{k+1}'] = []
                if cBSY:
                    for other1_seq in other1_seqs:
                        other1_eles = other1_seq['eles']
                        other1_kixs = strmatch(kwn,[x.key for x in other1_eles])
                        other1_knames = [other1_eles[x].name for x in other1_kixs]
                        if uniq_name.startswith('TCX'):
                            other1_ids = strmatch(uniq_name,other1_knames,True) # differentiate between TCX01/02 and TCX01B/02B
                        else:
                            other1_ids = strmatch(uniq_name,other1_knames)
                        if len(other1_ids) > 0:
                            id1 = other1_ids[0]  # first segment
                            ide = [id1 - 1, other1_ids[-1]]  # [entrance, exit]
                            suml1 = np.mean(other1_eles,ide,'S')
                            coor_start = other1_eles[ide[0]].coor
                            coor_end = other1_eles[ide[1]].coor
                            coorc1 = [(a+b)/2 for a,b in zip(coor_start,coor_end)]

                            MADK[kwn][-1]['suml1'] = suml1
                            for k in range(6):
                                MADK[kwn][-1][f'c1{k+1}'] = coorc1[k]
                            if not LCAV[-1]['sector']:
                                MADK[kwn]LCAV[-1]['sector'] = other1_eles[id1].sector
                            MADK[kwn]LCAV[-1]['ucell'] = other1_eles[id1].params['ucell']
    
                # UND coordinates
    
                MADK[kwn][-1]['suml2'] = []
                for k in range(6):
                    MADK[kwn][-1][f'c2{k+1}'] = []
                if cUND:
                    for other2_seq in other2_seqs:
                        other2_eles = other2_seq['eles']
                        other2_kixs = strmatch(kwn,[x.key for x in other2_eles])
                        other2_knames = [other2_eles[x].name for x in other2_kixs]
                        if uniq_name.startswith('TCX'):
                            other2_ids = strmatch(uniq_name,other2_knames,True) # differentiate between TCX01/02 and TCX01B/02B
                        else:
                            other2_ids = strmatch(uniq_name,other2_knames)
                        if len(other2_ids) > 0:
                            id1 = other2_ids[0]  # first segment
                            ide = [id1 - 1, other2_ids[-1]]  # [entrance, exit]
                            suml2 = np.mean(other2_eles,ide,'S')
                            coor_start = other2_eles[ide[0]].coor
                            coor_end = other2_eles[ide[1]].coor
                            coorc2 = [(a+b)/2 for a,b in zip(coor_start,coor_end)]
                            MADK[kwn][-1]['suml2'] = suml2
                            for k in range(6):
                                MADK[kwn][-1][f'c2{k+1}'] = coorc2[k]

        elif kwn == 'SBEN':
            # Assumed that all SBEN are split in 2.  Name differentiated by either an A/B or 1/2.
            # kixs: indexes in seq_eles that are SBEN
            # knames: names of those SBEN elements
            for m in range(0, len(kixs), 2):
                id1 = kixs[m]
                id2 = kixs[m+1]
                mname1 = knames[id1]
                mname2 = knames[id2]
                mname = mname1[:-1]
                ids = [id1,id2]
                sdsp = seq_eles[id1].Sd  # m
                suml = seq_eles[id1].S  # m
                dist = suml - seq['suml']  # m
                energy = seq_eles[id1].energy  # GeV
                leng = seq_eles[id1].length + seq_eles[id2].length  # m
                gap = 2 * seq_eles[id1].aper  # m
                fint = seq_eles[id1].params['fint']  # m
                tilt = seq_eles[id1].raw_params[3]  # rad
                ang = seq_eles[id1].raw_params[0] + seq_eles[id2].raw_params[1] #rad
                if abs(ang) < amin:
                    ang = 0
                    e1 = 0
                    e2 = 0
                else:
                    e1 = seq_eles[id1].raw_params[4]  # rad
                    e2 = seq_eles[id2].raw_params[5]  # rad
                EeV = 1e9 * energy  # eV
                brho = np.sqrt(EeV ** 2 - Er ** 2) / clight  # T-m
                BL = brho * ang  # T-m
                B = BL / leng  # T
                k1 = seq_eles[id1].raw_params[1]  # 1/m^2
                if abs(k1) < kmin:
                    k1 = 0
                G = brho * k1  # T/m
                GL = G * leng  # T
                polarity = -np.sign(ang + np.finfo(float).eps)  # add eps so that sign=1 when ang=0
                coori = seq_eles[id1-1].coor  # m,rad
                coorc = seq_eles[id1].coor  # m,rad
                cooro = seq_eles[id2].coor  # m,rad
                coorm = np.zeros(coorc.shape)  # m,rad (magnet steel center)
                if mname in KSnames:
                    counterpart_drift_name = f'D{mname}'
                    nfound = 0
                    zleng = 0
                    breakloop = False
                    for seq_ in main_seq:
                        for ele in seq_['eles']:
                            if ele['name'] == counterpart_drift_name:
                                #Two matches are expected.
                                nfound += 1
                                zleng += ele['length']
                                if nfound == 1:
                                    #Convention is to use the end of the first element.
                                    coorm = ele['coor']
                                if nfound == 2:
                                    breakloop = True 
                        if breakloop:
                            break
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
                pname = seq.area['parent']
                if pname in ['DMPS', 'DMPH']:
                    coorm[3] = coorc[3]  # dump line magnet coords set in FixDumpCoords
                elif pname == 'BSYA_2':
                    coorm[3] = coorc[3]  # dump line magnet coords set in FixAlineCoords
                else:
                    coorm[3] = tilt  # remove "creeping" rolls from non-rolled SBENs
                SBEN.append({
                    'idf': seq_eles[id1].froot_ix,
                    'id': seq_eles[id1].froot_ord,
                    'seq': seq.name,
                    'area': seq.area['name'],
                    'parent': seq.area['parent'],
                    'sector': seq_eles[id1].sector,
                    'ucell': [],
                    'prim': seq_eles[id1].fdn,
                    'name': mname,
                    'type': seq_eles[id1].ele_type,
                    'dist': dist,
                    'energy': energy,
                    'zleng': zleng,
                    'leng': leng,
                    'gap': seq_eles[id1]['aper'],  # m
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
                    'polarity': polarity,
                    'sdsp': sdsp,
                    'suml': suml,
                    **{f'c{k+1}': coorc[k] for k in range(6)},
                    **{f'm{k+1}': coorm[k] for k in range(6)}
                })
                # BSY coordinates
                #FOO main sequence SBEND done ... on to BSY SBEND
    
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
                        if mname in KSnames:
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
                        elif pname == 'BSYA_2':
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
                        if mname in KSnames:
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
                        elif pname == 'BSYA_2':
                            coorm2[3] = coorc2[3]  # dump line magnet coords set in FixAlineCoords
                        else:
                            coorm2[3] = tilt  # remove "creeping" rolls from non-rolled SBENs
                        SBEN[-1]['suml2'] = suml2
                        for k in range(6):
                            SBEN[-1][f'c2{k+1}'] = coorc2[k]
                            SBEN[-1][f'm2{k+1}'] = coorm2[k]
    
        elif kwn == 'QUAD':
            name = list(dict.fromkeys([N[i] for i in id]))
            QUAD = []
            for mname in name:
                id = strmatch(mname,N,True)
                id1 = id[0]  # first segment (beam center)
                sdsp = Sd[id1]  # m
                suml = S[id1]  # m
                dist = suml - seq[ids[id1]]['suml']  # m
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
                else:
                    G = brho * k1  # T/m
                    GL = G * leng  # T
                polarity = -np.sign(k1 + np.finfo(float).eps)  # add eps so that sign=1 when k1=0
                coorc = np.copy(coor[id1, :])  # m,rad
                QUAD.append({
                    'idf': idf[id1],
                    'id': idd[id1],
                    'seq': seq[ids[id1]]['name'],
                    'area': area[ida[id1]]['name'],
                    'parent': area[ida[id1]]['parent'],
                    'sector': SECTORS[id1].strip(),
                    'ucell': [],
                    'prim': FDN[id1],
                    'name': mname,
                    'type': T[id1].strip(),
                    'dist': dist,
                    'energy': energy,
                    'leng': leng,
                    'bore': bore,
                    'tilt': np.rad2deg(tilt),  # deg
                    'k1': k1,
                    'GL': T2kG * GL,  # kG
                    'G': charge * G,
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
            name = list(dict.fromkeys([N[i] for i in id]))
            SEXT = []
            for mname in name:
                id = strmatch(mname,N,True)
                id1 = id[0]  # first half (beam center)
                sdsp = Sd[id1]  # m
                suml = S[id1]  # m
                dist = suml - seq[ids[id1]]['suml']  # m
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
                polarity = -np.sign(k2 + np.finfo(float).eps)  # add eps so that sign=1 when k2=0
                coorc = np.copy(coor[id1, :])  # m,rad
                SEXT.append({
                    'idf': idf[id1],
                    'id': idd[id1],
                    'seq': seq[ids[id1]]['name'],
                    'area': area[ida[id1]]['name'],
                    'parent': area[ida[id1]]['parent'],
                    'sector': SECTORS[id1].strip(),
                    'ucell': [],
                    'prim': FDN[id1],
                    'name': mname,
                    'type': T[id1].strip(),
                    'dist': dist,
                    'energy': energy,
                    'leng': leng,
                    'bore': bore,
                    'tilt': np.rad2deg(tilt),  # deg
                    'k2': k2,
                    'GpL': T2kG * GpL,  # kG/m
                    'Gp': charge * Gp,
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
            name = list(dict.fromkeys([N[i] for i in id]))
            SOLE = []
            for mname in name:
                id = strmatch(mname,N,True)
                id1 = id[0]
                ide = [id1 - 1, id[-1]]  # [entrance, exit]
                sdsp = np.mean(Sd[ide])  # m
                suml = np.mean(S[ide])  # m
                dist = suml - seq[ids[id1]]['suml']  # m
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
                polarity = -np.sign(ks + np.finfo(float).eps)  # add eps so that sign=1 when ks=0
                coorc = np.mean(coor[ide], axis=0)  # m, rad
                SOLE.append({
                    'idf': idf[id1],
                    'id': idd[id1],
                    'seq': seq[ids[id1]]['name'],
                    'area': area[ida[id1]]['name'],
                    'parent': area[ida[id1]]['parent'],
                    'sector': SECTORS[id1].strip(),
                    'ucell': [],
                    'prim': FDN[id1],
                    'name': mname,
                    'type': T[id1].strip(),
                    'dist': dist,
                    'energy': energy,
                    'leng': leng,
                    'bore': bore,
                    'ks': ks,
                    'BL': T2kG * BL,  # kG-m
                    'B': charge * B,
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
            name = list(dict.fromkeys([N[i] for i in id]))
            MATR = []
            for mname in name:
                id = strmatch(mname,N,True)
                id1 = id[0]  # first half (beam center)
                sdsp = Sd[id1]  # m
                suml = S[id1]  # m
                dist = suml - seq[ids[id1]]['suml']  # m
                energy = E[id1]  # GeV
                leng = np.sum(L[id])  # m
                undl = P2[id1, 0]  # m
                undk = P2[id1, 1]  # 1
                coorc = np.copy(coor[id1])  # m, rad
                MATR.append({
                    'idf': idf[id1],
                    'id': idd[id1],
                    'seq': seq[ids[id1]]['name'],
                    'area': area[ida[id1]]['name'],
                    'parent': area[ida[id1]]['parent'],
                    'sector': SECTORS[id1].strip(),
                    'ucell': [],
                    'prim': FDN[id1],
                    'name': mname,
                    'type': T[id1].strip(),
                    'dist': dist,
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
            name = [N[i] for i in id] # RCOLs are not split
            RCOL = []
            for mname in name:
                id = strmatch(mname,N,True)[0]
                ide = [id - 1, id]  # [entrance, exit]
                sdsp = np.mean(Sd[ide])  # m (beam center)
                suml = np.mean(S[ide])  # m (beam center)
                dist = suml - seq[ids[id]]['suml']  # m (sequence start to beam center)
                energy = E[id]  # GeV
                leng = L[id]  # m
                xgap = 2 * P[id, 3]  # m
                ygap = 2 * P[id, 4]  # m
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                RCOL.append({
                    'idf': idf[id],
                    'id': idd[id],
                    'seq': seq[ids[id]]['name'],
                    'area': area[ida[id]]['name'],
                    'parent': area[ida[id]]['parent'],
                    'sector': SECTORS[id].strip(),
                    'ucell': [],
                    'prim': FDN[id],
                    'name': mname,
                    'type': T[id].strip(),
                    'dist': dist,
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
            name = [N[i] for i in id]  # ECOLs are not split
            ECOL = []
            for mname in name:
                id = strmatch(mname,N,True)[0]
                ide = [id - 1, id]  # [entrance, exit]
                sdsp = np.mean(Sd[ide])  # m (beam center)
                suml = np.mean(S[ide])  # m (beam center)
                dist = suml - seq[ids[id]]['suml']  # m (sequence start to beam center)
                energy = E[id]  # GeV
                leng = L[id]  # m
                xbore = 2 * P[id, 3]  # m
                ybore = 2 * P[id, 4]  # m
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                ECOL.append({
                    'idf': idf[id],
                    'id': idd[id],
                    'seq': seq[ids[id]]['name'],
                    'area': area[ida[id]]['name'],
                    'parent': area[ida[id]]['parent'],
                    'sector': SECTORS[id].strip(),
                    'ucell': [],
                    'prim': FDN[id],
                    'name': mname,
                    'type': T[id].strip(),
                    'dist': dist,
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
            name = [N[i] for i in id]  # SROTs are not split
            SROT = []
            for mname in name:
                id = strmatch(mname,N,True)[0]
                ide = [id - 1, id]  # [entrance, exit]
                sdsp = np.mean(Sd[ide])  # m (beam center)
                suml = np.mean(S[ide])  # m (beam center)
                dist = suml - seq[ids[id]]['suml']  # m (sequence start to beam center)
                energy = E[id]  # GeV
                leng = L[id]  # m
                ang = np.rad2deg(P[id, 4])  # deg
                if abs(ang) < amin:
                    ang = 0
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                SROT.append({
                    'idf': idf[id],
                    'id': idd[id],
                    'seq': seq[ids[id]]['name'],
                    'area': area[ida[id]]['name'],
                    'parent': area[ida[id]]['parent'],
                    'sector': SECTORS[id].strip(),
                    'ucell': [],
                    'prim': FDN[id],
                    'name': mname,
                    'type': T[id].strip(),
                    'dist': dist,
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
            name = list(dict.fromkeys([N[i] for i in id]))
            MULT = []
            for mname in name:
                id = strmatch(mname,N,True)
                if id[0] == 1:
                    idi = 1
                else:
                    idi = id[0] - 1  # beam in
                ide = [idi, id[-1]]  # [entrance, exit]
                sdsp = np.mean(Sd[ide])  # m (beam center)
                suml = np.mean(S[ide])  # m (beam center)
                dist = suml - seq[ids[id[0]]]['suml']  # m (sequence start to beam center)
                energy = E[id[0]]  # GeV
                leng = np.sum(L[id])  # m
                k1 = P[id[0], 1]  # 1/m^2
                if abs(k1) < kmin:
                    k1 = 0
                EeV = 1e9 * energy  # eV
                tilt = P[id[0], 3]  # rad
                brho = np.sqrt(EeV ** 2 - Er ** 2) / clight  # T-m
                if leng == 0:
                    G = 0  # T/m
                    GL = brho * k1  # T
                else:
                    G = brho * k1  # T/m
                    GL = G * leng  # T
                polarity = -np.sign(k1 + np.finfo(float).eps)  # add eps so that sign=1 when k1=0
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                t = T[id[0]].strip()
                aper = 2 * A[id[0]]  # m
                MULT.append({
                    'idf': idf[id[0]],
                    'id': idd[id[0]],
                    'seq': seq[ids[id[0]]]['name'],
                    'area': area[ida[id[0]]]['name'],
                    'parent': area[ida[id[0]]]['parent'],
                    'sector': SECTORS[id[0]].strip(),
                    'ucell': [],
                    'prim': FDN[id[0]],
                    'bore': aper,
                    'k1': k1,
                    'tilt': np.rad2deg(tilt),  # deg
                    'G': charge * G,
                    'GL': T2kG * GL,  # kG
                    'polarity': polarity,
                    'name': mname,
                    'type': T[id[0]].strip(),
                    'dist': dist,
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
                        ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                        suml1 = np.mean(S1[ide])  # m (beam center)
                        coorc1 = np.mean(coor1[ide], axis=0)  # m, rad (beam center)
                        MULT[-1]['suml1'] = suml1
                        for k in range(6):
                            MULT[-1][f'c1{k+1}'] = coorc1[k]
                        if not MULT[-1]['sector']:
                            MULT[-1]['sector'] = SECTORS1[id[0]].strip()
                        MULT[-1]['ucell'] = UCELL[id[0]].strip()
    
                # UND coordinates
    
                MULT[-1]['suml2'] = []
                for k in range(6):
                    MULT[-1][f'c2{k+1}'] = []
                    MULT[-1][f'm2{k+1}'] = []  # for MULT
                if cUND:
                    id = strmatch(mname,N2,True)
                    if len(id) > 0:
                        ide = [id[0] - 1, id[-1]]  # [entrance, exit]
                        suml2 = np.mean(S2[ide])  # m (beam center)
                        coorc2 = np.mean(coor2[ide], axis=0)  # m, rad (beam center)
                        MULT[-1]['suml2'] = suml2
                        for k in range(6):
                            MULT[-1][f'c2{k+1}'] = coorc2[k]
    
        elif kwn == 'INST':
            name = list(dict.fromkeys([N[i] for i in id]))
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
                dist = suml - seq[ids[id[0]]]['suml']  # m (sequence start to beam center)
                energy = E[id[0]]  # GeV
                leng = np.sum(L[id])  # m
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                t = T[id[0]].strip()
                INST.append({
                    'idf': idf[id[0]],
                    'id': idd[id[0]],
                    'seq': seq[ids[id[0]]]['name'],
                    'area': area[ida[id[0]]]['name'],
                    'parent': area[ida[id[0]]]['parent'],
                    'sector': SECTORS[id[0]].strip(),
                    'ucell': [],
                    'prim': FDN[id[0]],
                    'name': mname,
                    'type': T[id[0]].strip(),
                    'dist': dist,
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
            name = list(dict.fromkeys([N[i] for i in id]))
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
                dist = suml - seq[ids[id[0]]]['suml']  # m (sequence start to beam center)
                energy = E[id[0]]  # GeV
                leng = np.sum(L[id])  # m
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                t = T[id[0]].strip()
                HKIC.append({
                    'idf': idf[id[0]],
                    'id': idd[id[0]],
                    'seq': seq[ids[id[0]]]['name'],
                    'area': area[ida[id[0]]]['name'],
                    'parent': area[ida[id[0]]]['parent'],
                    'sector': SECTORS[id[0]].strip(),
                    'ucell': [],
                    'prim': FDN[id[0]],
                    'name': mname,
                    'type': T[id[0]].strip(),
                    'dist': dist,
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
            name = list(dict.fromkeys([N[i] for i in id]))
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
                dist = suml - seq[ids[id[0]]]['suml']  # m (sequence start to beam center)
                energy = E[id[0]]  # GeV
                leng = np.sum(L[id])  # m
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                t = T[id[0]].strip()
                VKIC.append({
                    'idf': idf[id[0]],
                    'id': idd[id[0]],
                    'seq': seq[ids[id[0]]]['name'],
                    'area': area[ida[id[0]]]['name'],
                    'parent': area[ida[id[0]]]['parent'],
                    'sector': SECTORS[id[0]].strip(),
                    'ucell': [],
                    'prim': FDN[id[0]],
                    'name': mname,
                    'type': T[id[0]].strip(),
                    'dist': dist,
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
            name = list(dict.fromkeys([N[i] for i in id]))
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
                dist = suml - seq[ids[id[0]]]['suml']  # m (sequence start to beam center)
                energy = E[id[0]]  # GeV
                leng = np.sum(L[id])  # m
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                t = T[id[0]].strip()
                MONI.append({
                    'idf': idf[id[0]],
                    'id': idd[id[0]],
                    'seq': seq[ids[id[0]]]['name'],
                    'area': area[ida[id[0]]]['name'],
                    'parent': area[ida[id[0]]]['parent'],
                    'sector': SECTORS[id[0]].strip(),
                    'ucell': [],
                    'prim': FDN[id[0]],
                    'name': mname,
                    'type': T[id[0]].strip(),
                    'dist': dist,
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
            name = list(dict.fromkeys([N[i] for i in id]))
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
                dist = suml - seq[ids[id[0]]]['suml']  # m (sequence start to beam center)
                energy = E[id[0]]  # GeV
                leng = np.sum(L[id])  # m
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                t = T[id[0]].strip()
                WIRE.append({
                    'idf': idf[id[0]],
                    'id': idd[id[0]],
                    'seq': seq[ids[id[0]]]['name'],
                    'area': area[ida[id[0]]]['name'],
                    'parent': area[ida[id[0]]]['parent'],
                    'sector': SECTORS[id[0]].strip(),
                    'ucell': [],
                    'prim': FDN[id[0]],
                    'name': mname,
                    'type': T[id[0]].strip(),
                    'dist': dist,
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
            name = list(dict.fromkeys([N[i] for i in id]))
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
                dist = suml - seq[ids[id[0]]]['suml']  # m (sequence start to beam center)
                energy = E[id[0]]  # GeV
                leng = np.sum(L[id])  # m
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                t = T[id[0]].strip()
                PROF.append({
                    'idf': idf[id[0]],
                    'id': idd[id[0]],
                    'seq': seq[ids[id[0]]]['name'],
                    'area': area[ida[id[0]]]['name'],
                    'parent': area[ida[id[0]]]['parent'],
                    'sector': SECTORS[id[0]].strip(),
                    'ucell': [],
                    'prim': FDN[id[0]],
                    'name': mname,
                    'type': T[id[0]].strip(),
                    'dist': dist,
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
            name = list(dict.fromkeys([N[i] for i in id]))
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
                dist = suml - seq[ids[id[0]]]['suml']  # m (sequence start to beam center)
                energy = E[id[0]]  # GeV
                leng = np.sum(L[id])  # m
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                t = T[id[0]].strip()
                IMON.append({
                    'idf': idf[id[0]],
                    'id': idd[id[0]],
                    'seq': seq[ids[id[0]]]['name'],
                    'area': area[ida[id[0]]]['name'],
                    'parent': area[ida[id[0]]]['parent'],
                    'sector': SECTORS[id[0]].strip(),
                    'ucell': [],
                    'prim': FDN[id[0]],
                    'name': mname,
                    'type': T[id[0]].strip(),
                    'dist': dist,
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
            name = list(dict.fromkeys([N[i] for i in id]))
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
                dist = suml - seq[ids[id[0]]]['suml']  # m (sequence start to beam center)
                energy = E[id[0]]  # GeV
                leng = np.sum(L[id])  # m
                coorc = np.mean(coor[ide], axis=0)  # m, rad (beam center)
                t = T[id[0]].strip()
                BLMO.append({
                    'idf': idf[id[0]],
                    'id': idd[id[0]],
                    'seq': seq[ids[id[0]]]['name'],
                    'area': area[ida[id[0]]]['name'],
                    'parent': area[ida[id[0]]]['parent'],
                    'sector': SECTORS[id[0]].strip(),
                    'ucell': [],
                    'prim': FDN[id[0]],
                    'name': mname,
                    'type': T[id[0]].strip(),
                    'dist': dist,
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
            name = [N[i] for i in id]
            MARK = []
            for mname in name:
                id = strmatch(mname,N,True)[0]
                sdsp = Sd[id]  # m
                suml = S[id]  # m
                dist = suml - seq[ids[id]]['suml']  # m (sequence start to beam center)
                energy = E[id]  # GeV
                coorc = np.copy(coor[id])
                MARK.append({
                    'idf': idf[id],
                    'id': idd[id],
                    'seq': seq[ids[id]]['name'],
                    'area': area[ida[id]]['name'],
                    'parent': area[ida[id]]['parent'],
                    'sector': SECTORS[id].strip(),
                    'ucell': [],
                    'leng': None,
                    'prim': FDN[id],
                    'name': mname,
                    'type': T[id].strip(),
                    'dist': dist,
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

def rotation_mat(yaw,pitch,roll):
    O1 = np.array([[np.cos(yaw), 0, np.sin(yaw)], [0, 1, 0], [-np.sin(yaw), 0, np.cos(yaw)]])
    O2 = np.array([[1, 0, 0], [0, np.cos(pitch), np.sin(pitch)], [0, -np.sin(pitch), np.cos(pitch)]])
    O3 = np.array([[np.cos(roll), -np.sin(roll), 0], [np.sin(roll), np.cos(roll), 0], [0, 0, 1]])
    O = O1 @ O2 @ O3
    return O

def FixMagnetCoords(seq, cflag):
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
        O = rotation_mat(yaw,pitch,roll)
        t = np.linalg.solve(O, np.array([X, Y, Z]))  # remove yaw, pitch, and roll
        Xr, Yr, Zr = t[0], t[1], t[2]
        dX = -off * np.sign(ang + np.finfo(float).eps)  # offset in chicane direction
        Xr = Xr[0] + dX * np.ones_like(Xr)
        t = O @ np.array([Xr, Yr, Zr])  # restore roll, pitch, and yaw
        Xm, Ym, Zm = t[0], t[1], t[2]
        for idb1 in idb:
            name = N[idb1].strip()[:-1] #remove last character
            jdb = strmatch(name,[N[i] for i in id])[0]
            jd = strmatch(name,Bname)[0]
            SBEN[jd][f'm{cflag or ""}2'] = Xm[jdb]
            SBEN[jd][f'm{cflag or ""}3'] = Ym[jdb]
            SBEN[jd][f'm{cflag or ""}1'] = Zm[jdb]

    # self-seeding chicane bends and Cavity-Based-XFEL bends

    names = ['BCXHS1', 'BCXHS2', 'BCXHS3', 'BCXHS4',  # HXRSS self-seeding chicane
            'BCXSS1', 'BCXSS2', 'BCXSS3', 'BCXSS4',  # SXRSS self-seeding chicane
            'BCXXL1', 'BCXXL2', 'BCXXL3', 'BCXXL4',  # XLEAP-II self-seeding chicane
            'BCXCBX11', 'BCXCBX12', 'BCXCBX13', 'BCXCBX14',  # CBXFEL chicane #1
            'BCXCBX21', 'BCXCBX22', 'BCXCBX23', 'BCXCBX24']  # CBXFEL chicane #2
    dX = 1e-3 * np.array([0, -2.39, -2.39, 0,  # HXRSS
                          +1, +9.7, +9.7, +1,  # SXRSS
                          -5, -12, -12, -5,  # XLEAP-II
                          +1, +9.7, +9.7, +1,  # CBXFEL #1
                          +1, +9.7, +9.7, +1])  # CBXFEL #2
    for name,dX1 in zip(names,dX):
        id = strmatch(name,Bname,True)[0]
        X0 = SBEN[id][f'm{cflag or ""}2']
        X = X0 + dX1
        SBEN[id][f'm{cflag or ""}2'] = X

    # safety dump bends (permanent magnet dipoles)

    names = ['BXPM1B', 'BXPM1', 'BXPM2']
    Xm = [1.25, -1.215, -1.215]
    for name,Xm1 in zip(names,Xm):
        id1 = strmatch(f"{name}1",N)[0] #center
        id0 = id1 - 1  # entrance
        # Flag for investigation
        if name != 'BXPM2':
          pitch = -coor[id0, 4]
          z0 = coor[id0, 0]
          y0 = coor[id0, 2]
        z1 = coor[id1, 0]
        Ym = y0 + np.tan(pitch) * (z1 - z0)
        yaw = 0
        id = strmatch(name,Bname,True)[0]
        SBEN[id][f'm{cflag or ""}2'] = Xm1
        SBEN[id][f'm{cflag or ""}3'] = Ym
        SBEN[id][f'm{cflag or ""}6'] = yaw
        SBEN[id][f'm{cflag or ""}5'] = -pitch

    # Lambertson septa
    # coor=[z,x,y,roll,-pitch,yaw] (SYMBOLS coordinates)

    names = ['BLRDG0', 'BLXSPS', 'BLXSPH', 'BLRDAS', 'BLRCUS']
    r = 0.010  # radius of field-free channel
    off = -0.004  # beam is 6 mm from top of field-free channel
    for n,name in enumerate(names):
        if n <= 1 and cflag is not None:
            continue  # no BSY or UND coords for BLRDG0 or BLRL3X
        id = strmatch(name,Bname,True)[0]
        Xm0 = SBEN[id][f'm{cflag or ""}2']
        Ym0 = SBEN[id][f'm{cflag or ""}3']
        Zm0 = SBEN[id][f'm{cflag or ""}1']
        yaw = SBEN[id][f'm{cflag or ""}6']
        pitch = -SBEN[id][f'm{cflag or ""}5']
        roll = (np.pi / 180) * SBEN[id]['tilt']
        O = rotation_mat(yaw,pitch,roll)
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
            O = rotation_mat(yaw,pitch,roll)
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
        O = rotation_mat(yaw,pitch,roll)
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

FixMagnetCoords(seq, None)
if cBSY:
    FixMagnetCoords(other1_seq,1)
if cUND:
    FixMagnetCoords(other2_seq,2)

# ------------------------------------------------------------------------------
# Write SYMBOLS txt-files ...

# SYMBOLS text-file headers and footers

head = ('Solid Edge,AREA,KeyW,ELEMENT,Eng_Name,L_EFF,APER,ANGLE,K1,K2,'
        'TILT,E1,E2,H1,H2,ENERGY,SUML,X Coor,Y Coor,Z Coor,'
        'X Angle,Y Angle,Z Angle,RF_Frequency,RF_Amplitude,RF_Phase,RF_Gradient,RF_Power_Fraction,Z_Length,Fringe_Field_Integral,'
        'Integrated_Field_BL,Field_B,Integrated_Field_Gradient_GL,Field_Gradient_G,XAL_Scale_Name,XAL_Scale_Value,XAL_Polarity,Magnet_X_Coor,Magnet_Y_Coor,Magnet_Z_Coor,'
        'Magnet_X_Angle,Magnet_Y_Angle,Magnet_Z_Angle,Solenoid_Strength_KS,Undulator_Period_Length,Undulator_Strength_K,X_Size,Y_Size,Section,Distance_From_Section_Start,'
        'XAL_Keyword,S_Display')

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
    for m,ele in enumerate(KEY):
        ip.append([ele['idf'], ele['id'], n, m])
ip = sorted(ip, key=lambda x: (x[0], x[1]))

def arrange_output(coord_system, system_name, filename):
    with open(outdir+'/'+fname, 'wt') as fid:
        fid.write(f'{head}\n')
        fid.write(f'{unit}\n')
        for entry in coord_system:
            id = [i for i,x in enumerate(ip) if x[0]==entry['froot0']]

            for n in id:
                idk = ip[n][2]
                idn = ip[n][3]
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
                s[48] = TEMP['seq']
                s[49] = TEMP['dist']
                s[51] = TEMP['sdsp']

                if system_name == 'LINAC':
                    s[16] = TEMP['suml']
                    s[17] = roundoff(TEMP['c1'], prec)
                    s[18] = roundoff(TEMP['c2'], prec)
                    s[19] = roundoff(TEMP['c3'], prec)
                    s[20] = roundoff(TEMP['c4'], prec)
                    s[21] = roundoff(TEMP['c5'], prec)
                    s[22] = roundoff(TEMP['c6'], prec)
                elif system_name == 'OTHER1':
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
                elif system_name == 'OTHER2':
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

                    if system_name == 'LINAC':
                        s[37] = roundoff(TEMP['m1'], prec)
                        s[38] = roundoff(TEMP['m2'], prec)
                        s[39] = roundoff(TEMP['m3'], prec)
                        s[40] = roundoff(TEMP['m4'], prec)
                        s[41] = roundoff(TEMP['m5'], prec)
                        s[42] = roundoff(TEMP['m6'], prec)
                    elif system_name == 'OTHER1':
                        s[37] = roundoff(TEMP['m11'], prec)
                        s[38] = roundoff(TEMP['m12'], prec)
                        s[39] = roundoff(TEMP['m13'], prec)
                        s[40] = roundoff(TEMP['m14'], prec)
                        s[41] = roundoff(TEMP['m15'], prec)
                        s[42] = roundoff(TEMP['m16'], prec)
                    elif system_name == 'OTHER2':
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

                    if system_name == 'LINAC':
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
                    if system_name == 'LINAC':
                        s[37] = roundoff(TEMP['m1'], prec)
                        s[38] = roundoff(TEMP['m2'], prec)
                        s[39] = roundoff(TEMP['m3'], prec)
                        s[40] = roundoff(TEMP['m4'], prec)
                        s[41] = roundoff(TEMP['m5'], prec)
                        s[42] = roundoff(TEMP['m6'], prec)
                    elif system_name == 'OTHER1':
                        s[37] = roundoff(TEMP['m11'], prec)
                        s[38] = roundoff(TEMP['m12'], prec)
                        s[39] = roundoff(TEMP['m13'], prec)
                        s[40] = roundoff(TEMP['m14'], prec)
                        s[41] = roundoff(TEMP['m15'], prec)
                        s[42] = roundoff(TEMP['m16'], prec)
                    elif system_name == 'OTHER2':
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
                        #s[8] = TEMP['k1']
                        s[10] = TEMP['tilt']
                        s[32] = TEMP['GL']
                        #s[33] = TEMP['G']

                fid.write(f"{s[0]+1},")
                for k in range(1, Ncol):
                    if s[k] is None:
                        fid.write(",")
                    elif isinstance(s[k], str):
                        fid.write(f"{s[k]},")
                    else:
                        fid.write(f"{madval(s[k])},")
                fid.write("\n")
        fid.write(f'{foot}\n')
        fid.write(f'{unit}\n')


fname = f'AD_ACCEL-{optics}.txt'
arrange_output(linac1,'LINAC',fname)
if cBSY:
    fname = f'BSY-AD_ACCEL-{optics}.txt'
    arrange_output(other1_seq,'OTHER1',fname)
if cUND:
    fname = f'UND-AD_ACCEL-{optics}.txt'
    arrange_output(other2_seq,'OTHER2',fname)

# ------------------------------------------------------------------------------
# Write extra SYMBOLS txt-file ...
# Element name, area name, undulator cell, sector

fname = f'AD_ACCEL-extra-{optics}.txt'
with open(outdir+'/'+fname, 'wt') as fid:
    fid.write('ELEMENT,Area2,Undulator Cell,Sector\n')
    for nf in range(1,len(froot)+1):
        id = [i for i,x in enumerate(ip) if x[0]==nf]
        for n in id:
            idk = ip[n][2]
            if keyw[idk] == 'MARK' or keyw[idk] == 'SROT':
                continue
            idn = ip[n][3]
            TEMP = KEYLIST[idk][idn]
            if TEMP['prim'] == 'MULT':
                continue
            TEMPucell = TEMP['ucell']
            TEMPucell = '' if isinstance(TEMPucell,list) else TEMPucell
            fid.write(f"{TEMP['name']},{TEMP['area']},{TEMPucell},{TEMP['sector']}\n")
    fid.write('ELEMENT,Area2,Undulator Cell,Sector\n')

# ------------------------------------------------------------------------------

print(f'Be sure to add FACET2 elements to {fname}!\n')
