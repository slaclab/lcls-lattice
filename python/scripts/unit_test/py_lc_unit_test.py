#!/bin/env python3

from pytao import Tao
import sys

#lattice_file = sys.argv[1]

def get_end_twiss(lattice_file):
  tao = Tao(lattice_file=lattice_file,noplot=True)
  end_twiss = tao.ele_twiss("end",verbose=True)
  return end_twiss

if __name__ == "__main__":
  lattice_file = "$LCLS_LATTICE/bmad/models/sc_sxr/sc_sxr.lat.bmad"
  end_twiss = get_end_twiss(lattice_file)
  for k,v in end_twiss.items(): 
    print(f'{k}: {v}')
