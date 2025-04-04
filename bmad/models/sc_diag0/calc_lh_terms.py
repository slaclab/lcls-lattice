#!/bin/env python3

import numpy as np

lam = 0.054
lamr = 1030e-9
Ei = 75e6
m_electron = 0.511e6
c_light=3e8

gami = Ei/m_electron
k_und = np.sqrt(2*(lamr*2*gami**2/lam-1))

lhun = 9*lam
lhunh = lhun/2
kqlh = (k_und*2*np.pi/lam/np.sqrt(2)/gami)**2

# b_max = Kund * factor
factor = 2*np.pi*m_electron / (c_light * lam)

print(2.49357 *factor)
