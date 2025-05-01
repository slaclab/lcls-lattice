#!/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

lam = 0.054
lhun = 9*lam
lhunh = lhun/2
lamr = 1030e-9
lamr3rd = 3*lamr
Ei = 75e6
m_electron = 0.511e6
gami = Ei/m_electron
c_light=3e8
# b_max = Kund * factor
factor = 2*np.pi*m_electron / (c_light * lam)

gap = [24.6147, 32.0892, 34.0174, 36.5047, 39.5132, 41.1638, 43.0922, 
50.0023, 59.9537]

Keff = [2.49357, 1.5782, 1.40003, 1.19948, 0.997059, 0.900115, 0.800493, 
0.521708, 0.281317]

def K_gap_fit(gap):
  return 11.1781 * np.exp(-0.060596*gap - 0.0000140725*gap**2)

def K_to_B(K):
  return [x*factor for x in K]

# x_func = np.linspace(20,60,100)
# y_func = K_gap_fit(x_func)
# 
# plt.figure(figsize=(8,5))
# plt.scatter(gap,K_to_B(Keff),color='blue',label='Data')
# plt.plot(x_func,K_to_B(y_func),color='red',label='Fit')
# 
# plt.title('SC LHU Strength vs. Gap')
# plt.xlabel('Gap (mm)')
# #plt.ylabel('Keff')
# plt.ylabel('Bmax (T)')
# plt.legend()
# plt.grid(True)
# plt.show()

def matrix_terms(kqlh):
  argh = lhunh*np.sqrt(kqlh)
  sincargh = 1-argh**2/6+argh**4/120-argh**6/5040 #~sinc(ARGh)=sin(ARGh)/ARGh
  r34h = lhunh*sincargh

  tt12 = lhunh
  tt33 = np.cos(lhunh*np.sqrt(kqlh))
  tt34 = r34h
  tt43 = -np.sin(lhunh*np.sqrt(kqlh))*np.sqrt(kqlh)
  tt44 = np.cos(lhunh*np.sqrt(kqlh))

  print(f'tt12 = {tt12}')
  print(f'tt33 = {tt33}')
  print(f'tt34 = {tt34}')
  print(f'tt43 = {tt43}')
  print(f'tt44 = {tt44}')


#kqlh = (k_und*2*np.pi/lam/np.sqrt(2)/gami)**2
tt33 = 0.970748139159
#tt33 = cos(lhunh*sqrt(kqlh))
kqlh = (np.arccos(tt33)/lhunh)**2
print(f'{kqlh=}')
print(matrix_terms(kqlh))


#-------------------------------
k_und3rd = np.sqrt(2*(lamr3rd*2*gami**2/lam-1))
kqlh3rd = (k_und3rd*2*np.pi/lam/np.sqrt(2)/gami)**2
print(matrix_terms(kqlh3rd))
