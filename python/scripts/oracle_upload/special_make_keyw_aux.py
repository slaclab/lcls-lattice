#!/bin/env python3

from parse_survey import parse_survey

file_roots = [
    {'root':'LCLS2scS',     'beg':'BEGGUNB',      'end':'ENDDMPS_2',   'ix':1,  'outn':'sc_sxr'},      #  1 SC Soft line
    {'root':'LCLS2scSS',    'beg':'BEGSFTS_1',    'end':'ENDSFTS_2',   'ix':2,  'outn':'sc_sfts'},      #  2 "SXR Safety Dump"
    {'root':'LCLS2scH',     'beg':'BEGSPH',       'end':'ENDSLTH',     'ix':6,  'outn':'sc_hxr'},      #  6 SC Hard line
    {'root':'LCLS2scD',     'beg':'BEGSPD_2',     'end':'ENDSLTD',     'ix':7,  'outn':'sc_bsyd'},      #  7 SC BSY Dump
    {'root':'DIAG0',        'beg':'BEGDIAG0',     'end':'ENDDIAG0',    'ix':8,  'outn':'sc_diag0'},      #  8 SC Diag0
    {'root':'LCLS2scDA',    'beg':'BEGSPA',       'end':'ENDESA',      'ix':9,  'outn':'sc_dasel'},      #  9 (DASEL)
    {'root':'LCLS2cuH',     'beg':'BEGGUN',       'end':'ENDDMPH_2',   'ix':10, 'outn':'cu_hxr'},     # 10 Cu Hard line
    {'root':'LCLS2cuHS',    'beg':'BEGSFTH_1',    'end':'ENDSFTH_2',   'ix':11, 'outn':'cu_sfts'},     # 11 Cu HXR Safety Dump
    {'root':'LCLS2cuS',     'beg':'BEGCLTS',      'end':'ENDCLTS',     'ix':14, 'outn':'cu_sxr'},     # 14 Cu Soft line
    {'root':'LCLS2cuGSPEC', 'beg':'BEGGSPEC',     'end':'ENDGSPEC',    'ix':15, 'outn':'cu_gspec'},     # 15 Cu 6 MeV Spectrometer
    {'root':'LCLS2cuSPEC',  'beg':'BEGSPEC',      'end':'ENDSPEC',     'ix':16, 'outn':'cu_spec'},     # 16 Cu 135 MeV Spectrometer
]

#file_roots = [
#    {'root':'LCLS2scH',     'beg':'BEGSPH',       'end':'ENDSLTH',     'ix':6,  'outn':'sc_hxr'},      #  6 SC Hard line
#]

# ------------------------------------------------------------------------------
# read the MAD output files
K, N, T, FDN = [], [], [], []
L, P, A, E, coor, S, Sd = [], [], [], [], [], [], []
idf, idd = [], []  # idf: which MAD survey file an element came from
                   # idd: ordinal position in MAD output file

outputs = {}

for file_root in file_roots:
    fname = f'{file_root["root"]}_survey.tape'
    print(f'Opening file {fname}')
    titl, tK, tN, tL, tP, tA, tT, tE, tFDN, tcoor, tS = parse_survey(fname)

    id1 = 0 #tN.index(file_root['beg'])
    id2 = len(tN) #tN.index(file_root['end']) 
    slc = slice(id1, id2)

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

    for N_,K_,FDN_ in zip(N,K,FDN):
      if FDN_ is None:
        print(f'{N_} is missing FDN')
      if K_ != 'DRIF':
        outputs[N_] = [K_,FDN_]
      else:
        outputs[N_] = [K_,None]

    #faux = f'{file_root["outn"]}_keys.dat'
    #with open(faux,'w') as f:
    #  f.write(f'{"# name":<19}{"madk":<10}{"dbkey"}\n')
    #  for N_,K_,FDN_ in zip(N,K,FDN):
    #    if FDN_ is None:
    #      print(f'{N_} is missing FDN')
    #    if K_ != 'DRIF':
    #      f.write(f'{N_:<19}{K_:<10}{FDN_}\n')
    #    else:
    #      f.write(f'{N_:<19}{K_:<10}\n')

with open('unified_keys.dat','w') as f:
  f.write(f'{"# name":<19}{"madk":<10}{"dbkey"}\n')
  for k,v in outputs.items():
      if v[1] is None:
        f.write(f'{k:<19}{v[0]:<10}\n')
      else:
        f.write(f'{k:<19}{v[0]:<10}{v[1]}\n')


