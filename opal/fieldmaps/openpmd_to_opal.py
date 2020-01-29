import numpy as np
#import openpmd_api as oapi
import h5py 

#Spacing
# gridSpacing:0.0003 0.0003 0.001

#Ereal_file ='/global/homes/n/nneveu/benchmarking/lcls2/opal/fields/APEX-GUN-Quarter-334K/E_Real.h5'
#Eimag_file ='/global/homes/n/nneveu/benchmarking/lcls2/opal/fields/APEX-GUN-Quarter-334K/E_Imag.h5' 

Ereal_file ='./APEX-GUN-Quarter-334K/E_Real.h5'
Eimag_file ='./APEX-GUN-Quarter-334K/E_Imag.h5' 

#Ereal = api.Series(Ereal_file,api.Access_Type.read_only)

Ereal = h5py.File(Ereal_file)
EImag = h5py.File(Eimag_file) 

Ez_real = Ereal['/data/200/fields/E_Real/z']
Ez_imag = EImag['/data/200/fields/E_Imag/z']

print(Ez_imag)

# Calculate real part of field
omega = 187*10**6 #187 MHz
phi   = 0 # Arb?
t     = 0 # In h5?


Ez1 = Ezr*np.exp(1j*phi) + Ezi*np.exp(-1j*phi)

Ez_total = np.real( Ez1 * np.exp(1j*omega*t) )



