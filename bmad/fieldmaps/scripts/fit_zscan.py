#!/bin/env python3

from mpi4py import MPI
import re
import numpy as np
#import matplotlib.pyplot as plt
import scipy
import pickle

n_keep=200

def read_data(file):
  nz = 0
  with open(file) as f:
    for line in f:
      if line.strip() and line[0:1] != '#':
        nz = nz + 1
        
  zdat = np.zeros(nz)
  Bydat = np.zeros(nz)

  i = 0
  with open(file) as f:
    for line in f:
      if line.strip() and line[0:1] != '#':
        data = line.split()
        zdat[i] = data[0]
        Bydat[i] = data[5]
        i = i + 1

  return zdat, Bydat

def write_terms(Xk):
  field_length = zdat[-1] - zdat[0]
  with open("terms.out",'w') as f:
    f.write("umhtr_map: wiggler, l={}, tracking_method=runge_kutta, num_step=500,\n".format(field_length))
    f.write("field_calc=fieldmap,\n")
    f.write("cartesian_map = { field_scale = 1.0,\n")
    n_written = 0
    for i,term in enumerate(Xk):
      if term != 0:
        #k = np.pi/(len(Xk)-1)*i/field_length
        k = np.pi*i/field_length
        term = term * np.sqrt(2) / np.sqrt(len(Xk)-1)
        f.write("term = {{{:.8e}, 0, {:10.8f}, {:10.8f}, 0, 0, 0, y}}".format(term,k,k))
        n_written += 1
        if n_written < n_keep:
          f.write(',\n')
        else:
          f.write('\n')
    f.write("}")

nd0 = np.array([0])
def idct_check(Xk,ix):
  Xk_masked = np.concatenate([Xk[:ix],nd0,Xk[ix+1:]])
  recovered_working = scipy.fft.idct(Xk_masked, type=1, norm='ortho')
  return recovered_working

def calc(Bydat,Xk,i):
  recovered_working = idct_check(Xk,i)
  #residuals = Bydat-recovered_working
  #rss = np.sum(residuals**2)
  rss = np.linalg.norm(Bydat-recovered_working)
  return rss

status = MPI.Status()
comm = MPI.COMM_WORLD
rank = comm.Get_rank()
nworkers = comm.Get_size()

zdat, Bydat = read_data('zscan.dat')

zi = 0.21
zf = 4.69
ixi = np.argmax(zdat>=zi)
ixf = np.argmax(zdat>=zf)
zdat = zdat[ixi:ixf+1]
Bydat = Bydat[ixi:ixf+1]
#print(zdat[0],zdat[-1])

Xk = scipy.fft.dct(Bydat, type=1, norm='ortho')
nt = len(Xk)
if rank == 0:
  pickled = bytearray(150)
  #nprune = 10
  nprune = nt-n_keep

  fprune = open("prune.log",'w') 
  rss_all = np.zeros(nt)

  for j in range(nprune):
    job_sent_counter = 0
    job_recv_counter = 0
    for i in range( 0,min(nt,nworkers-1) ):
      comm.send(i,dest=i+1,tag=10)
      job_sent_counter = job_sent_counter + 1
    while job_recv_counter < nt:
      comm.Recv(pickled,source=MPI.ANY_SOURCE,tag=11,status=status)
      source = status.Get_source()
      i,rss = pickle.loads(pickled)
      rss_all[i] = rss
      job_recv_counter = job_recv_counter + 1
      if job_sent_counter < nt:
        comm.send(job_sent_counter,dest=source,tag=10)
        job_sent_counter = job_sent_counter + 1

    ix_best = np.argmin(rss_all)
    rss_best = rss_all[ix_best]

    fprune.write("{}\n".format(rss_best))
    print("({} of {})best pruned rss:    {} (pruning {})".format(j,nprune,rss_best,ix_best))
    for i in range(nworkers-1):
      comm.send(ix_best,dest=i+1,tag=20)
    Xk[ix_best] = 0

  for i in range(1,nworkers):
    comm.send(-1,dest=i,tag=10)
  fprune.close()
  write_terms(Xk)

  #recovered_final = scipy.fft.idct(Xk, type=1, norm='ortho')
  #plt.plot(Bydat)
  #recovered_full = scipy.fft.idct(Xk, type=1, norm='ortho')
  #plt.plot(recovered_full)
  #plt.plot(recovered_final)
  #plt.show()
  #plt.plot(Xk)
  #plt.show()
elif rank > 0:
  while True:
    i = comm.recv(source=0, status=status)
    tag = status.Get_tag()
    if tag == 10:
      if i == -1:
        break
      if Xk[i] == 0:
        rss = 1.0e9
      else:
        rss = calc(Bydat,Xk,i)
      comm.Send(pickle.dumps((i,rss)), dest=0, tag=11)
    elif tag == 20:
      Xk[i] = 0

  



