#!/bin/env python3

import numpy as np
import scipy

file = 'terms.out'
z0 = 0.0  # initial z0 for evaluating map
l = 4.48 # length over which to evaluate the map
nz = 20000 # number of points at which to evaluate the map.
           # needs to be large to get I1 and I2 right
E = 98e6 # beam energy for calcuating exit x and x'

n = 0
with open(file,'r') as f:
  for line in f:
    if line[0:4] == 'term':
      n = n + 1

A = np.zeros(n)
k = np.zeros(n)
i = 0
with open(file,'r') as f:
  for line in f:
    if line[0:4] == 'term':
      data = line[line.find("{")+1:line.find("}")].split(",")
      A[i], k[i] = data[0], data[2]
      i = i + 1

dz = l/(nz-1)
zlst = [z0+dz*i for i in range(nz)]
By=np.zeros(nz)
with open('field.out','w') as f:
  for j,z in enumerate(zlst):
    for Ai, ki in zip(A,k):
      By[j] = By[j] + Ai*np.cos(ki*z)
    f.write('{} {}\n'.format(z,By[j]))

I1y_cumulative = scipy.integrate.cumulative_simpson(By,x=zlst,initial=0)
I1y = I1y_cumulative[-1]
I2y = scipy.integrate.simpson(I1y_cumulative,x=zlst)

q = scipy.constants.value('electron volt')
me = scipy.constants.value('electron mass')
me_eV = scipy.constants.value('electron mass energy equivalent in MeV')*1e6
c = scipy.constants.value('speed of light in vacuum')
gamma = E / me_eV
x  =  q/gamma/me/c * I2y
xp = -q/gamma/me/c * I1y

print("I1y: {}".format(I1y))
print('I2y: {}'.format(I2y))
print("x  exit: {}".format(x))
print("x' exit: {}".format(xp))


