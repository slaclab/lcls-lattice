#!/bin/env python3

import numpy as np
from dataclass import dataclass

@dataclass
class EleData:
    """
    froot_ix: integer.  index of file the element came from
    file_ord: integer.  ordinal position in MAD output file
    K (list): Element keyword
    N (list): Element name
    L (np.array): Element length
    P (np.array): Element parameter
    A (np.array): Aperture
    T (list): Engineering type
    E (np.array): Energy
    FDN (list): NLC Formal Device Name
    coor (np.array): Survey coordinates (X,Y,Z,yaw,pitch,roll)
    S (np.array): suml:  running sum of element lengths
    """
    fname: str = ""
    froot_ix: int = -1                  # idf
    file_ord: int = -1                  # idd
    key: str = ""                       # K
    name: str = ""                      # N
    length: float = 0.0                 # L
    raw_params: list = []               # P
    params: list = []
    aper: float = 0.0                   # A
    ele_type: str = ""                  # T
    energy: float = 0.0                 # E
    fdn: str = ""                       # FDN
    suml: float = 0.0                   # S: running sum of element legnths
    coor: float = [0,0,0,0,0,0]         # coor

    def __post_init__(self)
        self.Sd = self.coor[2]          # Sd (aka "Display S"): floor z from modeling code


def xtffs2mat_obj(fname,froot_ix):
    """
    Reads an XTFF SURVEY file and extracts various parameters.

    Parameters:
    fname (str): The filename of the XTFF SURVEY file.

    Returns:
    tuple: Contains the following elements:
        tt (str): Run title
    """

    with open(fname, 'r') as fid:
        # Read in the header ... check that XTFF file is a SURVEY file
        line = fid.readline()
        xtff = line[8:16]
        if xtff.strip() != "SURVEY":
            raise ValueError(f"Unexpected XTFF type ({xtff}) encountered ... abort")

        # Read in the run title
        tt = fid.readline().strip()

        elements = []

        file_ord = 0
        while True:
            line = fid.readline()
            if not line.strip():
                break

            file_ord += 1
            K = line[0:4].strip()
            N = line[4:20].strip()
            L = np.array(float(line[20:32].strip()))
            p = [line[32:48].strip(), line[48:64].strip(), line[64:80].strip()]
            A = np.array(float(line[80:96].strip()))
            T = line[97:113].strip()
            E = np.array(float(line[114:130].strip()))

            line = fid.readline().ljust(97)
            p.extend([line[0:16].strip(),  line[16:32].strip(), line[32:48].strip(),
                      line[48:64].strip(), line[64:80].strip()])
            FDN = line[81:97].strip()

            line = fid.readline()
            x, y, z = line[0:16].strip(), line[16:32].strip(), line[32:48].strip()
            S = np.array(float(line[48:64].strip()))

            line = fid.readline()
            yaw, pitch, roll = line[0:16].strip(), line[16:32].strip(), line[32:48].strip()

            coor = np.array([x, y, z, yaw, pitch, roll], dtype=float)

            P = np.array(p)

            elements.append(EleData(fname,froot_ix,file_ord,K,N,L,P,A,T,E,FDN,S,coor))

    return elements


