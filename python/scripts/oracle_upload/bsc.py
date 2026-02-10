#!/bin/env python3

import os
import numpy as np
from dataclasses import dataclass, field

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
dE1 = 0.120    # full core energy width in BC1 ( )
dE2 = 0.036    # full core energy width in BC2 ( )
dE4 = 0.010    # full core energy width after undulator or BSY dump ( )
nsig = 16    # max. num. sigma (betatron size)
steer1 = 1e-3    # max. steering range in und. (+- this value)
steer2 = 2e-3    # max. steering range everywere else (+- this value)
dx0 = 5e-3    # hor. addition to FW stay-clear if we are in an R56-compensating-chicane (any of the 4 bends) (m)
betaf = 2.0    # worst case beta scalar
etaf = 1.25    # worst case dispersion scalar (was 1.3 on 20MAR15)
EFEL = 0.02    # FEL energy loss after und. (was 2% on 20MAR15)
xf = 18e-3    # x-offset of beam at OTRDMP with X-band TCAV on (m) - was 15 mm on 07JUL17
xw = 12e-3    # x-full width of streaked beam at OTRDMP with X-band TCAV on (m) - was 18 mm on 07JUL17
#For DASEL
A =65e-9  #  m (effective beam admittance)
dp =0.02  #  1 (beam maximum relative energy error in the S30XL)
D =0.002  #  m (maximum residual beam orbit in S30XL)

MODELS=['sc_sxr_beam0','sc_hxr_beam0','sc_bsyd_beam0','sc_diag0_beam0', 'cu_sxr', 'cu_hxr', 'sc_dasel_beam0']
froot_to_model = {1:0, 6:1, 7:2, 8:3, 14:4, 10:5, 9:6}

output_ordering = [0,6,10,7,8,14,9]

optics = '00TEST00'

ips = []
with open('ips.dump','r') as f:
  for line in f:
    if not line.startswith("#"):
      parts = line.split()
      ips.append([int(parts[0]), int(parts[1])])

bsc_data={}
for model in MODELS:
  print(f'model: {model}')
  bsc_data[model] = {}
  nele = 0
  lat = Lattice()
  with open(model+'_twiss.dat','r') as f:
    for line in f:
      if line.strip() and not line.startswith('#'):
        nele += 1
        lat.elements.append(Element(*line.split()))
  lat.names = [x.name for x in lat.elements]

  if model == 'cu_hxr':
    cu_hxr_marker = lat.names.index('BEGBSYH')

  if model == 'sc_hxr_beam0':
    sc_hxr_marker = lat.names.index('BEGBSYH')

  if model == 'sc_dasel_beam0':
    id_dasel_1 = strmatch('BEGSPA',lat.names,False)[0]
    id_dasel_2 = strmatch('MADUMP',lat.names,False)[-1] # ENDBSYA
    id_dasel_mark = strmatch('BLRDAS',lat.names)[-1] # downstream of BLRDAS

  if model.startswith('cu_'): # BSC parameters for Cu linac beam
    dE3 = 0.1e-2    # full core energy width in post-linac
    eN = 1e-6    # worst case emittance (~2-times nominal)
    Etrip = 0.235/2    # largest value @ 2.5 GeV (GeV)
    Ejit = 0.1e-2    # estimated FW rel. energy jitter
    vern = 0.01    # energy vernier after linac
    chirp = 0.01    # FWHM energy spread due to optional linear chirp after linac
  else:
    dE3 = 0.016    # full core energy width in post-linac ( )
    eN = 1e-6    # worst case emittance (~2-times nom.)
    Etrip = 0.016    # one SSA trip (GeV)
    Ejit = 0.1e-2    # estimated FW rel. energy jitter
    vern = 0.01    # energy vernier after linac (was 2% on 20MAR15 - set to 1% May 5, 2015 to get Dean's QDOG2 < 50 mm Diam.)
    chirp = 0.01    # FWHM energy spread due to optional linear chirp after linac (was 1% on 20MAR15)

  if model == 'sc_diag0_beam0':
    dE0 = 0.04    # full core energy width in DIAG0 - before adding jitter, chirp ( )
    idy = strmatch('TCYDG0',lat.names)[-1]
    idx = strmatch('TCXDG0',lat.names)[-1]
    S_TCYDG0 = lat.elements[idy].s    # S at exit Y-TCAV in DIAG0
    S_TCXDG0 = lat.elements[idx].s    # S at exit X-TCAV in DIAG0
  else:
    dE0 = 0.058    # full core energy width in heater area - before adding jitter, chirp ( )
    S_TCXDG0 = 1e10    # defualt to TcavX not in this beamline
    S_TCYDG0 = 1e10    # default to TcavY not in this beamline
  # some points of interest
  if model.startswith('cu_'):
    i_BSY = strmatch('BEGCLTH_0',lat.names)[0]    # entrance to BSY (Cu linac)
  S_XRstart=0   
  S_XRterm=0   
  S_TCX01=1e10   
  S_OTRDMP=0   
  for ix,ele in enumerate(lat.elements):
    if ele.name[1:8] == 'XRSTART':
      S_XRstart=ele.s    # S at undulator start
    elif ele.name[1:7] == 'XRTERM':
      S_XRterm=ele.s     # S at undulator exit (dumpline start)
    elif ele.name[0:5] == 'TCX01':
      S_TCX01=ele.s      # S at X-band TCAV exit (just after und's)
      i_TCX01=ix
    elif ele.name == 'MTCX' or ele.name[0:5] == 'MTCXB':
      mx0=ele.phi_a      # phase advance at center of X-band TCAV's
    elif ele.name[0:6] == 'OTRDMP':
      S_OTRDMP=ele.s   # S at dump (TCAV) screen
      bxf=ele.beta_a   # betaX at dump (TCAV) screen
      mxf=ele.phi_a    # phase advance to dump (TCAV) screen

  # R56 compensating chicanes (must add dx0 to horizontal stay-clear for each)
  R56names=['CCDLU','CCDLD','CC31B','CC32B','CC31','CC32','CC35','CC36']
  R56ids=[]
  for R56name in R56names:
    id1=strmatch(f'{R56name}BEG',lat.names) # chicane start
    id2=strmatch(f'{R56name}END',lat.names) # chicane end
    if id1 and id2:
      R56ids.extend(list(range(id1[0],id2[0]+1)))

  # BSC computation
  esprd=[0 for x in lat.elements]  # make array, initialized to zeros and same size as S
  xt=[0 for x in lat.elements]    # make array, intitiaized to zeros and same size as S (for XTCAV kick)
  XID=[0 for x in lat.elements]    # horizontal stay-clear full height (empty array initially)
  YID=[0 for x in lat.elements]    # vertical stay-clear full height (empty array initially)
  Dia=[0 for x in lat.elements]    # Stay-clear full diameter, if cylindrical chamber (empty array initially)
  fname = f'BSC_{model}.txt'
  fout = open(fname,'w')
  fout.write('ELEMENT              S (m)        BSCd (mm)    +BSCx (mm)     -BSCx (mm)    +BSCy (mm)     -BSCy (mm)\n')
  for ix,ele in enumerate(lat.elements):
    if model.startswith('cu_') and ix < i_BSY:
      continue

    if model == 'sc_dasel_beam0':
      if ix < id_dasel_1 or ix > id_dasel_2:
        continue
      if ix<id_dasel_mark:
        f=0.5
      else:
        f=1
      XID[ix] = 1e3/2*float((np.sqrt(A*ele.beta_a) + np.abs(ele.eta_x*dp) + f*D))
      YID[ix] = 1e3/2*float((np.sqrt(A*ele.beta_b) + np.abs(ele.eta_y*dp) + f*D))
      Dia[ix] = float(2*np.sqrt(XID[ix]**2 + YID[ix]**2))
      XID[ix] = 2*XID[ix]
      YID[ix] = 2*YID[ix]

    else:
      e=eN/(ele.e_tot/511e-6); # emitance along machine
      if ix in R56ids:
        dx=dx0; # horizontal stay-clear addition for R56-compensating chicanes
      else:
        dx=0;  # no additional horizontal stay-clear
      steer=steer2;  # default steering range
      min_XID=min_XID0;  # default minimum XID
      min_YID=min_YID0;  # default minimum YID
      if ele.e_tot>0.07 and ele.e_tot<0.12:  # ~heater or DIAG0
        if ele.s <= S_TCXDG0: # set minimum XID and YID (20 mm diam. after RF deflector in DIAG0)
          min_XID = min_XID0
          min_YID = min_YID0
        else:
          min_XID = 20.0e-3
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

    bsc_data[model][ix] = [ele.name, Dia[ix], XID[ix], YID[ix]]
    fout.write('{:<16s}  {:>10.6e}  {:>10.6e}  {:>10.6e}  {:>10.6e}  {:>10.6e}  {:>10.6e}\n'.format(ele.name.rstrip('_'), ele.s, Dia[ix], XID[ix], -XID[ix], YID[ix], -YID[ix]))
  fout.close()

hxr_offset = sc_hxr_marker - cu_hxr_marker

# write to AD_ACCEL collated output file
fname=f'BSC-AD_ACCEL-{optics}.txt'
with open(fname,'w') as f_all:
  f_all.write("ELEMENT, Stayclear Dia (mm), +Horz (mm), -Horz (mm), +Vert (mm), -Vert (mm)\n")
  for froot,ordinal in ips:
    if froot in froot_to_model.keys():
      model_name = MODELS[froot_to_model[froot]]
      if model_name == 'cu_hxr':
        if ordinal < cu_hxr_marker:
          continue
        model_name = 'sc_hxr_beam0'
        ordinal = ordinal + hxr_offset
      if ordinal in bsc_data[model_name]:
        x = bsc_data[model_name][ordinal]
        f_all.write(f'{x[0]}, {x[1]:>10.6e}, {x[2]:>10.6e}, {-x[2]:>10.6e}, {x[3]:>10.6e}, {-x[3]:>10.6e}\n')


    #for ix,ele in enumerate(lat.elements):
    #  name=ele.name.rstrip('_')
    #  #f_all.write('{:<16s}, {:>10.6e}, {:>10.6e}, {:>10.6e}, {:>10.6e}, {:>10.6e}\n'.format(ele.name, 1e3*Dia[ix], 1e3*XID[ix]/2, -1e3*XID[ix]/2, 1e3*YID[ix]/2, -1e3*YID[ix]/2))
    #  f_all.write('{:s}, {:.6e}, {:.6e}, {:.6e}, {:.6e}, {:.6e}\n'.format(ele.name, 1e3*Dia[ix], 1e3*XID[ix]/2, -1e3*XID[ix]/2, 1e3*YID[ix]/2, -1e3*YID[ix]/2))

    #   if (false) # plot
    #     figure(1)
    #     plot(S,-XID/2*1e3,'b-',S,XID/2*1e3,'b-', ...
    #          S,-YID/2*1e3,'r--',S,YID/2*1e3,'r--', ...
    #          S,-Dia/2*1e3,'g-.',S,Dia/2*1e3,'g-.')
    #     hor_line(0)
    #     xlabel('{\itS} (m)')
    #     ylabel('X and Y Beam Stay Clear (mm)')
    #     legend('+X','-X','+Y','-Y','-R','+R','Location','NorthWest');
  
    #     if (S_OTRDMP>0)
    #       figure(2)
    #       id=(i_TCX01:length(S));
    #       plot(S(id),xt(id)*1e3,'g--', ...
    #            S(id),xt(id)*1e3*xf/(xf+xw/2),'g-', ...
    #            S(id),xt(id)*1e3*(xf-xw/2)/(xf+xw/2),'g--')
    #       ver_line(S_TCX01)
    #       ver_line(S_OTRDMP)
    #       xlabel('{\itS} (m)')
    #       ylabel('{\itx} (mm)')















