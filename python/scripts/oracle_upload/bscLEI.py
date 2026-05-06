#!/bin/env python3

import os
import numpy as np
from dataclasses import dataclass, field
from collections import defaultdict
from pathlib import Path
import sys

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

@dataclass
class Element:
  name: str
  key: str
  s: float
  beta_a: float
  beta_b: float
  phi_a: float
  phi_b: float
  eta_x: float
  eta_y: float
  e_tot: float

  def __post_init__(self):
    self.s = float(self.s)
    self.beta_a = float(self.beta_a)
    self.beta_b = float(self.beta_b)
    self.phi_a = float(self.phi_a)
    self.phi_b = float(self.phi_b)
    self.eta_x = float(self.eta_x)
    self.eta_y = float(self.eta_y)
    self.e_tot = float(self.e_tot)*1e-9  # [GeV]

@dataclass
class Lattice:
  elements: list[Element] = field(default_factory=list)
  names: list[str] = field(default_factory=list)

# Specifications
# BSC Parameters (starting from J. Welch, LCLSII-TN-14-15, 2014)
min_XID0 = 8e-3    # set minimum X-BSC diameter (m) (except undulator is 0.005 m)
min_YID0 = 8e-3    # set minimum Y-BSC diameter (m) (except undulator is 0.005 m)
eN = 1e-6    # worst case emittance (~2-times nominal)
nsig = 16    # max. num. sigma (betatron size)
steer = 2e-3    # max. steering range in und. (+- this value)
betaf = 2.0    # worst case beta scalar
etaf = 1.25    # worst case dispersion scalar (was 1.3 on 20MAR15)
vern = 0.01      # energy vernier after CM00
chirp = 0.01    # FWHM energy spread due to optional linear chirp after linac
dE0 = 0.04    # full core energy width in DIAG0 - before adding jitter, chirp ( )

MODELS=['diag02','diagis']
froot_to_model = {17:0, 18:1}

output_ordering = [17,18]

if len(sys.argv) > 1:
    optics = sys.argv[1]
else:
    optics = 'TEST'

ips_unsorted = []
with open('ips.dump','r') as f:
  for line in f:
    if not line.startswith("#"):
      parts = line.split()
      ips_unsorted.append([int(parts[0]), int(parts[1]), parts[4]])

ips = []
for froot in output_ordering:
  for entry in ips_unsorted:
    if entry[0] == froot:
      ips.append(entry)

#n_eles = {}

bsc_data={}
for model in MODELS:
  if model == 'diag02':
    name1 = 'BEAM0LEI'
    name2 = 'ENDDIAGI_2'
    Ejit = 0.01
  elif model == 'diagis':
    name1 = 'BEAM0LEI'
    name2 = 'ENDLEI_2'
    Ejit = 0.005
  else:
    print('error')
    quit()
  print(f'model: {model}')
  nele = 0
  lat = Lattice()
  with open(model+'_twiss.dat','r') as f:
    for line in f:
      if line.strip() and not line.startswith('#'):
        nele += 1
        lat.elements.append(Element(*line.split()))
  lat.names = [x.name for x in lat.elements]
  #n_eles[model] = nele

  if model == 'diag02':
    S_TCXDG0 = 1e10  # don't use minimum BSC downstream of TCXDGI in this beamline
  elif model == 'diagis':
    id_tcx = strmatch('TCXDGI',lat.names)[-1]
    S_TCXDGI = lat.elements[id_tcx].s  # S at exit X-TCAV in DIAGI ... 10 mm minimum BSC d/s
    dE0 = 0.038  # full core energy width in heater area - before adding jitter, chirp ( )
  else:
    print('error')
    quit()

  # BSC computation

  esprd=[0 for x in lat.elements]  # make array, initialized to zeros and same size as S
  xt=[0 for x in lat.elements]    # make array, intitiaized to zeros and same size as S (for XTCAV kick)
  XID=[0 for x in lat.elements]    # horizontal stay-clear full height (empty array initially)
  YID=[0 for x in lat.elements]    # vertical stay-clear full height (empty array initially)
  Dia=[0 for x in lat.elements]    # Stay-clear full diameter, if cylindrical chamber (empty array initially)
  Emax = 0.150 #maximum beam energy used to compute BSC

  fname = f'BSC_{model}.txt'
  fout = open(fname,'w')
  fout.write('#ELEMENT              S (m)        BSCd (mm)    +BSCx (mm)     -BSCx (mm)    +BSCy (mm)     -BSCy (mm)\n')
  bsc_data[model] = [['','',0,0,0] for _ in lat.elements]

  for ix,ele in enumerate(lat.elements):

    e=eN/(ele.e_tot/511e-6); # emitance along machine
    if ix in R56ids:
      dx=dx0; # horizontal stay-clear addition for R56-compensating chicanes
    else:
      dx=0;  # no additional horizontal stay-clear
    steer=steer2;  # default steering range
    min_XID=min_XID0;  # default minimum XID
    min_YID=min_YID0;  # default minimum YID
    if ele.e_tot>0.07 and ele.e_tot<0.12:  # ~heater or DIAG0
      if ele.s <= S_TCXDG0: # set minimum XID (20 mm diam. after RF deflector in DIAG0)
        min_XID = min_XID0
      else:
        min_XID = 20.0e-3
      if ele.s <= S_TCYDG0: # set minimum YID (20 mm diam. after RF deflector in DIAG0)
        min_YID = min_YID0
      else:
        min_YID = 20.0e-3
      esprd[ix] = dE0 + 2*chirp + 2*Ejit
    elif ele.e_tot > 0.22 and ele.e_tot < 0.28: 
      # ~BC1
      esprd[ix] = dE1 + 2*chirp + 2*Ejit
    elif ele.e_tot > 1.3 and ele.e_tot < 1.9: 
      # ~BC2
      esprd[ix] = dE2 + chirp + 2*Ejit+Etrip/ele.e_tot
    elif ele.e_tot > 3.7 and ele.e_tot < 8.2: 
      # ~post-linac (includes LCLS2cuS)
      # 3.8->3.7 & 4.2->8.2 for LCLSII-HE (July 17, 2017)
      if ele.s < S_XRstart:  # before undulator
        esprd[ix]=dE3 + chirp + vern + Ejit + Etrip/ele.e_tot  # includes LCLS2cuS
      elif ele.s >= S_XRstart and ele.s <= S_XRterm: 
        # in undulator
        steer=steer1
        min_XID=5e-3  # set minimum XID for undulator (m)
        min_YID=5e-3  # set minimum YID for und. (m)
      elif ele.s > S_XRterm:  
        # after undulator
        if ele.s > S_TCX01: 
          # after TCX01 Tcav
          xt[ix] = (xf+xw/2)*np.sqrt(ele.beta_a/bxf)*np.sin(ele.phi_a-mx0)/np.sin(mxf-mx0); # scale from "xf" offset at screen (m)
        if S_XRterm>0:
          esprd[ix] = dE4 + chirp + vern + EFEL + Ejit + Etrip/ele.e_tot # after undulator (HXR or SXR)
        else:
          esprd[ix] = dE4 + chirp + vern + Ejit + Etrip/ele.e_tot  # in BSY dumpline
    XID[ix] = 1e3/2*float(max(2*nsig*np.sqrt(e*ele.beta_a*betaf) + etaf*np.abs(ele.eta_x)*esprd[ix] + 2*steer + 2*xt[ix] + dx, min_XID))
    YID[ix] = 1e3/2*float(max(2*nsig*np.sqrt(e*ele.beta_b*betaf) + etaf*np.abs(ele.eta_y)*esprd[ix] + 2*steer, min_YID))
    Dia[ix] = 2*float(np.sqrt(XID[ix]**2+YID[ix]**2))

    # zero-out BSC data for kicked '?' elements
    if ele.name.endswith('?'):
      XID[ix] = 0.0
      YID[ix] = 0.0
      Dia[ix] = 0.0
    bsc_data[model][ix] = [ele.name, ele.key, Dia[ix], XID[ix], YID[ix]]
    fout.write('{:<16s}  {:>10.6e}  {:>10.6e}  {:>10.6e}  {:>10.6e}  {:>10.6e}  {:>10.6e}\n'.format(ele.name.rstrip('_'), ele.s, Dia[ix], XID[ix], -XID[ix], YID[ix], -YID[ix]))
  fout.close()

#For elements with the same name, find the one with the largest Dia and
# apply its values to all elements with that name.
for model in bsc_data:
  indices = {}
  for ix, (name,key) in enumerate([(x[0],x[1]) for x in bsc_data[model]]):
    if name == '' or key == 'Drift':
      continue
    if name in indices:
      indices[name] = (indices[name][0], ix)
    else:
      indices[name] = (ix, ix)
  spans = {name: idx_pair
           for name, idx_pair in indices.items()
           if idx_pair[0] != idx_pair[1]}
  for name, span in spans.items():
    items = bsc_data[model][span[0]-1:span[1]+1]
    #print("FOO A: ", name, span[0]-1,span[1], [[x[0],x[3]] for x in items])
    max_item = max(items, key=lambda x: x[2])
    #print("       ", name, max_item)
    for item in items:
      if item[0] == name:
        item[1:] = max_item[1:]  # these are references: modifies data in bsc_data

# write to AD_ACCEL collated output file
outdir='oracle_upload'
fname=f'BSC-AD_ACCEL-{optics}.txt'
filepath = Path(outdir+'/'+fname)
filepath.parent.mkdir(parents=True, exist_ok=True)
with filepath.open('w') as f_all:
  f_all.write("#ELEMENT, Stayclear Dia (mm), +Horz (mm), -Horz (mm), +Vert (mm), -Vert (mm)\n")
  for froot,ordinal,name in ips:
    if ordinal < 0:
      if not name.startswith('FIXER'):
        f_all.write(f'{name}, {0:>10.6e}, {0:>10.6e}, {0:>10.6e}, {0:>10.6e}, {0:>10.6e}\n')
    elif froot in froot_to_model.keys():
      model_name = MODELS[froot_to_model[froot]]
      if model_name == 'cu_hxr':
        if ordinal < cu_hxr_marker:
          continue
        model_name = 'sc_hxr_beam0'
        ordinal = ordinal #+ hxr_offset
      if bsc_data[model_name][ordinal][0] != '':
        x = bsc_data[model_name][ordinal]
        if not x[0].startswith('FIXER'):
          if x[0] != name:
            print(f'WARNING.  ips.dump name not match twiss.dat name: {model_name=} twiss.dat name=>{x[0]=}< ips.dump name>{name}<')
          f_all.write(f'{name}, {x[2]:>10.6e}, {x[3]:>10.6e},{-x[3]:>10.6e}, {x[4]:>10.6e},{-x[4]:>10.6e}\n')











